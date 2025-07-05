local LoadingBar, super = Class(Bullet)

function LoadingBar:init(x, y)
    super.init(self, x, y)
    
    self.width = 120
    self.height = 20
    self.damage = 5
    
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    
    -- Progreso de carga (0 a 1)
    self.progress = 0
    self.speed = 2
    
    -- Estados especiales
    self.frozen = false
    self.freeze_timer = 0
    self.rotating = false
    self.angle = 0
    self.radius = 0
    self.center_x = 0
    self.center_y = 0
    self.rotation_speed = 0
    
    -- Efectos de lag/glitch
    self.lag_mode = false
    self.glitch_timer = 0
    self.corrupted = false
    self.teleport_timer = 0
    
    -- Colores
    self.bar_color = {0.2, 0.6, 1} -- Azul normal
    self.bg_color = {0.1, 0.1, 0.1}
    self.text_color = {1, 1, 1}
    
    -- Texto de porcentaje
    self.font = Assets.getFont("main", 12)
end

function LoadingBar:update()
    super.update(self)
    
    -- Actualizar progreso si no está congelado
    if not self.frozen and not self.corrupted then
        self.progress = math.min(self.progress + DT * 0.3, 1)
    end
    
    -- Movimiento rotatorio
    if self.rotating then
        self.angle = self.angle + self.rotation_speed * DT
        self.x = self.center_x + math.cos(self.angle) * self.radius
        self.y = self.center_y + math.sin(self.angle) * self.radius
        
        -- Orientar la barra hacia el centro
        self.rotation = self.angle + math.pi/2
    
    -- Movimiento normal
    elseif not self.frozen and not self.corrupted then
        self.x = self.x + self.speed * DTMULT
    end
    
    -- Efecto de congelamiento
    if self.frozen then
        self.freeze_timer = self.freeze_timer + DT
        -- Vibrar cuando está congelado
        if math.sin(self.freeze_timer * 20) > 0 then
            self.x = self.x + math.random(-1, 1)
        end
        
        -- Cambiar color cuando está congelado
        self.bar_color = {1, 0.5, 0} -- Naranja
    end
    
    -- Efecto de lag/glitch
    if self.lag_mode then
        self.glitch_timer = self.glitch_timer + DT
        
        -- Saltos aleatorios
        if self.glitch_timer > 0.2 then
            self.glitch_timer = 0
            self.x = self.x + math.random(-20, 20)
            self.y = self.y + math.random(-10, 10)
            
            -- A veces retroceder el progreso
            if math.random() < 0.3 then
                self.progress = math.max(0, self.progress - 0.1)
            end
        end
        
        -- Color glitcheado
        if math.random() < 0.1 then
            self.bar_color = {math.random(), math.random(), math.random()}
        end
    end
    
    -- Barras corruptas que se teletransportan
    if self.corrupted then
        self.teleport_timer = self.teleport_timer + DT
        
        -- Teletransportarse cada cierto tiempo
        if self.teleport_timer > 0.8 then
            self.teleport_timer = 0
            
            local arena = Game.battle.arena
            self.x = math.random(arena.left + 20, arena.right - self.width - 20)
            self.y = math.random(arena.top + 20, arena.bottom - self.height - 20)
            
            -- Efecto de teletransporte
            for i = 1, 5 do
                local particle = Sprite("battle/bullets/loading_bar", self.x, self.y)
                particle.width = self.width
                particle.height = self.height
                particle.alpha = 0.3
                particle.scale_x = 1
                particle.scale_y = 1
                particle.layer = self.layer - 1
                Game.battle:addChild(particle)
                
                Game.battle.timer:tween(0.5, particle, {
                    scale_x = 1.5,
                    scale_y = 0,
                    alpha = 0
                }, "out-quad", function()
                    particle:remove()
                end)
            end
        end
        
        -- Color corrupto
        self.bar_color = {1, 0, 0.5} -- Magenta
        
        -- Progreso aleatorio
        self.progress = self.progress + (math.random() - 0.5) * 0.1
        self.progress = math.max(0, math.min(1, self.progress))
    end
    
    -- Remover si sale de la arena
    local arena = Game.battle.arena
    if not self.rotating and not self.corrupted then
        if self.x > arena.right + 50 or self.x + self.width < arena.left - 50 then
            self:remove()
        end
    end
end

function LoadingBar:draw()
    super.draw(self)
    
    love.graphics.push()
    if self.rotating then
        love.graphics.translate(self.width/2, self.height/2)
        love.graphics.rotate(self.rotation)
        love.graphics.translate(-self.width/2, -self.height/2)
    end
    
    -- Fondo de la barra
    love.graphics.setColor(self.bg_color)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height, 3)
    
    -- Borde
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.width, self.height, 3)
    
    -- Barra de progreso
    if self.progress > 0 then
        love.graphics.setColor(self.bar_color)
        local bar_width = (self.width - 4) * self.progress
        love.graphics.rectangle("fill", 2, 2, bar_width, self.height - 4, 2)
        
        -- Efecto de brillo en barras congeladas
        if self.frozen and math.sin(self.freeze_timer * 10) > 0 then
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.rectangle("fill", 2, 2, bar_width, (self.height - 4) / 2, 2)
        end
    end
    
    -- Texto de porcentaje
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.text_color)
    
    local percent_text = string.format("%d%%", math.floor(self.progress * 100))
    if self.frozen and self.progress >= 0.99 then
        percent_text = "99%"
        -- Parpadear el texto
        if math.sin(self.freeze_timer * 5) > 0 then
            love.graphics.setColor(1, 0, 0)
        end
    elseif self.corrupted then
        -- Texto corrupto
        local chars = {"@", "#", "?", "!", "%", "&", "*"}
        percent_text = chars[math.random(1, #chars)] .. chars[math.random(1, #chars)] .. chars[math.random(1, #chars)]
    end
    
    love.graphics.printf(percent_text, 0, self.height/2 - 6, self.width, "center")
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

return LoadingBar