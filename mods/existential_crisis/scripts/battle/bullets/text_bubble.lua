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
end

function TextBubble:update()
    super.update(self)
    
    -- Movimiento flotante
    self.float_timer = self.float_timer + DT * 2
    self.y = self.base_y + math.sin(self.float_timer) * 10
    
    -- Mover hacia la izquierda
    self.x = self.x - self.speed * DTMULT
    
    -- Remover si sale de la arena
    if self.x + self.width < Game.battle.arena.left - 20 then
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