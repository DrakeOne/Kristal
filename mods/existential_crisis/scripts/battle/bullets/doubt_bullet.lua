-- Doubt Bullet - Pequeño proyectil de duda
local DoubtBullet, super = Class(Bullet)

function DoubtBullet:init(x, y)
    super.init(self, x, y)
    
    self.damage = 3
    self.tp = 0.2
    
    -- Tamaño pequeño
    self.width = 12
    self.height = 12
    self:setHitbox(2, 2, 8, 8)
    
    -- Visual
    self.rotation = 0
    self.pulse_timer = 0
    self:setScale(0.8)
end

function DoubtBullet:update()
    super.update(self)
    
    -- Rotación constante
    self.rotation = self.rotation + DT * 3
    
    -- Efecto de pulso
    self.pulse_timer = self.pulse_timer + DT
    local pulse = 0.8 + math.sin(self.pulse_timer * 5) * 0.1
    self:setScale(pulse)
end

function DoubtBullet:draw()
    super.draw(self)
    
    love.graphics.push()
    love.graphics.translate(self.width/2, self.height/2)
    love.graphics.rotate(self.rotation)
    
    -- Dibujar signo de interrogación giratorio
    love.graphics.setColor(0.6, 0.2, 0.6, 1)
    love.graphics.circle("fill", 0, 0, 6)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Assets.getFont("main", 8))
    love.graphics.print("?", -3, -6)
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

return DoubtBullet