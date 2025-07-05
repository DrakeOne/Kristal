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
    
    -- Convergencia (para el ataque circular)
    self.converge = false
    self.target_x = nil
    self.target_y = nil
end

function TextBubble:update()
    super.update(self)
    
    -- Movimiento flotante
    self.float_timer = self.float_timer + DT * 2
    
    if self.converge and self.target_x and self.target_y then
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
    else
        -- Movimiento normal
        self.y = self.base_y + math.sin(self.float_timer) * 10
        self.base_y = self.base_y + self.physics.speed_y * DTMULT
        
        -- Mover hacia la izquierda por defecto
        if self.physics.speed_x == 0 and self.physics.speed_y == 0 then
            self.x = self.x - self.speed * DTMULT
        end
    end
    
    -- Remover si sale de la arena
    local arena = Game.battle.arena
    if self.x + self.width < arena.left - 20 or 
       self.x > arena.right + 20 or
       self.y + self.height < arena.top - 20 or
       self.y > arena.bottom + 20 then
        self:remove()
    end
end

function TextBubble:draw()
    super.draw(self)
    
    -- Burbuja de diálogo
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height, 5)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, self.width, self.height, 5)
    
    -- Cola de la burbuja
    love.graphics.setColor(0.2, 0.2, 0.2)
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
    
    -- Texto
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, 5, 7, self.width - 10, "center")
    
    love.graphics.setColor(1, 1, 1)
end

return TextBubble