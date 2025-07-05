local ErrorBullet, super = Class(Bullet)

function ErrorBullet:init(x, y)
    super.init(self, x, y)
    
    self.text = "ERROR"
    self.damage = 5
    
    -- Tamaño basado en el texto
    self.font = Assets.getFont("main", 16)
    self.width = self.font:getWidth(self.text) + 10
    self.height = 24
    
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    
    -- Propiedades de movimiento
    self.velocity_x = 0
    self.velocity_y = 0
    self.gravity = 0.3
    
    -- Propiedades especiales
    self.bounce = false
    self.static = false
    self.flicker = false
    self.flicker_timer = 0
    self.remove_timer = nil
    self.bsod_mode = false
    
    -- Colores
    self.bg_color = {1, 0, 0} -- Rojo
    self.text_color = {1, 1, 1} -- Blanco
    self.border_color = {0.5, 0, 0} -- Rojo oscuro
    
    -- Efectos visuales
    self.scale = 1
    self.rotation = 0
    self.alpha = 1
end

function ErrorBullet:update()
    super.update(self)
    
    -- Movimiento con física
    if not self.static then
        self.x = self.x + self.velocity_x * DTMULT
        self.y = self.y + self.velocity_y * DTMULT
        
        -- Gravedad solo si está configurada para rebotar
        if self.bounce then
            self.velocity_y = self.velocity_y + self.gravity * DTMULT
        end
    end
    
    -- Rebote en los bordes de la arena
    if self.bounce then
        local arena = Game.battle.arena
        
        -- Rebote horizontal
        if self.x <= arena.left and self.velocity_x < 0 then
            self.velocity_x = -self.velocity_x * 0.8
            self.x = arena.left
            self:onBounce()
        elseif self.x + self.width >= arena.right and self.velocity_x > 0 then
            self.velocity_x = -self.velocity_x * 0.8
            self.x = arena.right - self.width
            self:onBounce()
        end
        
        -- Rebote vertical
        if self.y <= arena.top and self.velocity_y < 0 then
            self.velocity_y = -self.velocity_y * 0.8
            self.y = arena.top
            self:onBounce()
        elseif self.y + self.height >= arena.bottom and self.velocity_y > 0 then
            self.velocity_y = -self.velocity_y * 0.7
            self.y = arena.bottom - self.height
            self:onBounce()
            
            -- Reducir velocidad horizontal en el suelo
            self.velocity_x = self.velocity_x * 0.9
        end
    end
    
    -- Efecto de parpadeo
    if self.flicker then
        self.flicker_timer = self.flicker_timer + DT
        self.alpha = 0.5 + math.sin(self.flicker_timer * 20) * 0.5
    end
    
    -- Temporizador de eliminación
    if self.remove_timer then
        self.remove_timer = self.remove_timer - DT
        if self.remove_timer <= 0 then
            self:remove()
        end
    end
    
    -- Modo BSOD - rotación lenta
    if self.bsod_mode then
        self.rotation = self.rotation + DT * 0.5
        self.bg_color = {0, 0.3, 0.8} -- Azul BSOD
        self.border_color = {0, 0.2, 0.6}
    end
    
    -- Remover si sale mucho de la pantalla
    local margin = 100
    if self.x < -margin or self.x > SCREEN_WIDTH + margin or
       self.y < -margin or self.y > SCREEN_HEIGHT + margin then
        self:remove()
    end
end

function ErrorBullet:draw()
    super.draw(self)
    
    love.graphics.push()
    love.graphics.translate(self.width/2, self.height/2)
    love.graphics.rotate(self.rotation)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.width/2, -self.height/2)
    
    -- Sombra
    if not self.static then
        love.graphics.setColor(0, 0, 0, 0.3 * self.alpha)
        love.graphics.rectangle("fill", 2, 2, self.width, self.height)
    end
    
    -- Fondo
    love.graphics.setColor(self.bg_color[1], self.bg_color[2], self.bg_color[3], self.alpha)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    
    -- Borde
    love.graphics.setColor(self.border_color[1], self.border_color[2], self.border_color[3], self.alpha)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)
    
    -- Efecto de glitch en el texto
    if self.flicker and math.random() < 0.1 then
        -- Desplazar el texto aleatoriamente
        love.graphics.setColor(0, 1, 1, self.alpha * 0.5)
        love.graphics.setFont(self.font)
        love.graphics.print(self.text, 5 + math.random(-2, 2), 4 + math.random(-2, 2))
    end
    
    -- Texto
    love.graphics.setColor(self.text_color[1], self.text_color[2], self.text_color[3], self.alpha)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, 5, 4)
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

function ErrorBullet:onBounce()
    -- Efecto visual al rebotar
    self.scale = 1.2
    Game.battle.timer:tween(0.1, self, {scale = 1}, "out-bounce")
    
    -- Cambiar texto ocasionalmente
    if math.random() < 0.3 then
        local errors = {"ERROR", "FAIL", "CRASH", "OOPS", "404", "!!!"}
        self.text = errors[math.random(1, #errors)]
        self.width = self.font:getWidth(self.text) + 10
    end
    
    -- Crear partículas de error
    if math.random() < 0.5 then
        for i = 1, 3 do
            local particle = Text("!", self.x + self.width/2, self.y + self.height/2, {font = "main", size = 12})
            particle.color = self.bg_color
            particle.physics.speed_x = math.random(-2, 2)
            particle.physics.speed_y = math.random(-3, -1)
            particle.physics.gravity = 0.2
            particle.layer = self.layer - 1
            Game.battle:addChild(particle)
            
            Game.battle.timer:tween(0.5, particle, {alpha = 0}, "linear", function()
                particle:remove()
            end)
        end
    end
end

return ErrorBullet