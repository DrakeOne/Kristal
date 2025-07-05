local TextBubble, super = Class(Bullet)

function TextBubble:init(x, y, text)
    super.init(self, x, y)
    
    self.text = text or "???"
    self.damage = 4
    
    -- Tamaño basado en texto
    self.font = Assets.getFont("main", 16)
    self.width = self.font:getWidth(self.text) + 20
    self.height = 30
    
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    
    -- Movimiento flotante
    self.float_timer = math.random() * math.pi * 2
    self.base_y = y
    
    -- Velocidad de movimiento
    self.speed = 2
    
    -- Propiedades especiales
    self.converge = false
    self.target_x = nil
    self.target_y = nil
    
    -- Para philosophy wave
    self.slowdown = false
    self.spiral = false
    self.angle = 0
    self.radius = 0
    self.center_x = 0
    self.center_y = 0
    self.rotation_speed = 0
    self.heavy = false
    
    -- Color de la burbuja
    self.bubble_color = {0.2, 0.2, 0.2}
    self.text_color = {1, 1, 1}
    
    -- Efectos visuales
    self.scale = 1
    self.rotation = 0
end

function TextBubble:update()
    super.update(self)
    
    -- Movimiento flotante
    self.float_timer = self.float_timer + DT * 2
    
    if self.spiral then
        -- Movimiento en espiral
        self.angle = self.angle + self.rotation_speed * DT
        self.radius = self.radius + DT * 20 -- Expandir lentamente
        
        self.x = self.center_x + math.cos(self.angle) * self.radius
        self.y = self.center_y + math.sin(self.angle) * self.radius
        
        -- Rotar el texto también
        self.rotation = self.angle
        
    elseif self.converge and self.target_x and self.target_y then
        -- Mover hacia el objetivo
        local dx = self.target_x - self.x
        local dy = self.target_y - self.y
        local dist = math.sqrt(dx*dx + dy*dy)
        
        if dist > 5 then
            self.x = self.x + (dx / dist) * self.speed * DTMULT
            self.y = self.y + (dy / dist) * self.speed * DTMULT
        else
            -- Cuando llega al centro, explotar en direcciones aleatorias
            self.converge = false
            local angle = math.random() * math.pi * 2
            self.physics.speed_x = math.cos(angle) * 3
            self.physics.speed_y = math.sin(angle) * 3
        end
        
    elseif self.heavy then
        -- Caída pesada con efecto de escala
        self.scale = 1 + math.sin(self.float_timer * 4) * 0.1
        self.bubble_color = {0.4, 0.1, 0.1} -- Rojo oscuro para "pesado"
        
    else
        -- Movimiento normal flotante
        if not self.heavy then
            self.y = self.base_y + math.sin(self.float_timer) * 10
        end
        self.base_y = self.base_y + self.physics.speed_y * DTMULT
        
        -- Mover hacia la izquierda por defecto
        if self.physics.speed_x == 0 and self.physics.speed_y == 0 then
            self.x = self.x - self.speed * DTMULT
        end
    end
    
    -- Remover si sale de la arena
    local arena = Game.battle.arena
    local margin = 50
    if self.x + self.width < arena.left - margin or 
       self.x > arena.right + margin or
       self.y + self.height < arena.top - margin or
       self.y > arena.bottom + margin then
        self:remove()
    end
end

function TextBubble:draw()
    super.draw(self)
    
    love.graphics.push()
    love.graphics.translate(self.width/2, self.height/2)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-self.width/2, -self.height/2)
    
    -- Sombra
    if self.heavy then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 2, 2, self.width, self.height, 5)
    end
    
    -- Burbuja de diálogo
    love.graphics.setColor(self.bubble_color)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height, 5)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.width, self.height, 5)
    
    -- Cola de la burbuja (solo si no está rotando)
    if not self.spiral then
        love.graphics.setColor(self.bubble_color)
        love.graphics.polygon("fill", 
            self.width - 15, self.height - 5,
            self.width - 5, self.height + 5,
            self.width - 20, self.height
        )
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon("line", 
            self.width - 15, self.height - 5,
            self.width - 5, self.height + 5,
            self.width - 20, self.height
        )
    end
    
    -- Texto
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.text_color)
    love.graphics.printf(self.text, 5, 7, self.width - 10, "center")
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

function TextBubble:onCollide(soul)
    if self.slowdown and soul == Game.battle.soul then
        -- Ralentizar temporalmente el alma
        soul.speed = soul.speed * 0.8
        
        -- Efecto visual
        local effect = Text("Slow!", soul.x, soul.y - 20, {font = "main", size = 12})
        effect.color = {0.5, 0.5, 1}
        effect.layer = soul.layer + 1
        Game.battle:addChild(effect)
        
        Game.battle.timer:tween(0.5, effect, {y = soul.y - 40, alpha = 0}, "out-quad", function()
            effect:remove()
        end)
        
        -- Restaurar velocidad después de un momento
        Game.battle.timer:after(0.5, function()
            if soul and not soul.removed then
                soul.speed = soul.speed / 0.8
            end
        end)
    end
    
    return super.onCollide(self, soul)
end

return TextBubble