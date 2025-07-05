-- Anxiety Wave - Onda de ansiedad
local AnxietyWave, super = Class(Bullet)

function AnxietyWave:init(x, y)
    super.init(self, x, y)
    
    self.damage = 4
    self.tp = 0.3
    
    -- Movimiento horizontal
    self.physics.speed_x = 5
    self.physics.speed_y = 0
    
    -- Tamaño de la onda
    self.width = 32
    self.height = 32
    self:setHitbox(4, 4, 24, 24)
    
    -- Efecto visual
    self.wave_timer = 0
    self.alpha = 0.8
    self:setScale(0.5)
end

function AnxietyWave:update()
    super.update(self)
    
    self.wave_timer = self.wave_timer + DT
    
    -- Crecer gradualmente
    if self.scale_x < 1.2 then
        self.scale_x = self.scale_x + 0.02
        self.scale_y = self.scale_x
    end
    
    -- Movimiento ondulatorio vertical
    self.y = self.y + math.sin(self.wave_timer * 5) * 0.8
    
    -- Desvanecer al salir de la arena
    if self.x > Game.battle.arena.right + 50 then
        self:remove()
    end
end

function AnxietyWave:draw()
    super.draw(self)
    
    -- Dibujar onda de energía
    love.graphics.push()
    love.graphics.translate(self.width/2, self.height/2)
    
    -- Múltiples círculos para efecto de onda
    for i = 1, 3 do
        local size = (i * 8) + math.sin(self.wave_timer * 8 + i) * 2
        local alpha = self.alpha * (1 - (i-1) * 0.3)
        
        love.graphics.setColor(0.8, 0.2, 0.8, alpha)
        love.graphics.circle("line", 0, 0, size)
    end
    
    -- Centro brillante
    love.graphics.setColor(1, 0.5, 1, self.alpha)
    love.graphics.circle("fill", 0, 0, 4)
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

return AnxietyWave