-- Existential Text - Texto flotante con preguntas existenciales
local ExistentialText, super = Class(Bullet)

function ExistentialText:init(x, y)
    -- No usa sprite, dibuja texto directamente
    super.init(self, x, y)
    
    self.text = "¿?"
    self.target_y = y
    self.float_timer = 0
    self.damage = 3
    
    -- Hitbox basada en texto
    self:setHitbox(0, 0, 60, 20)
    
    -- Efecto de desvanecimiento
    self.lifetime = 5
    self.age = 0
end

function ExistentialText:update()
    super.update(self)
    
    self.age = self.age + DT
    self.float_timer = self.float_timer + DT
    
    -- Movimiento flotante hacia posición objetivo
    local dy = self.target_y - self.y
    self.y = self.y + dy * 0.05
    
    -- Ligero bamboleo
    self.x = self.x + math.sin(self.float_timer * 3) * 0.5
    
    -- Desvanecer al final
    if self.age > self.lifetime - 1 then
        self.alpha = self.alpha - 0.02
        if self.alpha <= 0 then
            self:remove()
        end
    end
end

function ExistentialText:draw()
    super.draw(self)
    
    -- Dibujar texto con sombra
    love.graphics.setFont(Assets.getFont("main", 16))
    
    -- Sombra
    love.graphics.setColor(0, 0, 0, self.alpha * 0.5)
    love.graphics.print(self.text, -30 + 2, -10 + 2)
    
    -- Texto principal
    love.graphics.setColor(0.8, 0.2, 0.2, self.alpha)
    love.graphics.print(self.text, -30, -10)
    
    love.graphics.setColor(1, 1, 1, 1)
end

return ExistentialText