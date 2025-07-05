-- Warning Zone - Zona de advertencia visual
local WarningZone, super = Class(Bullet)

function WarningZone:init(x, y)
    super.init(self, x, y)
    
    -- No hace daño, solo es visual
    self.damage = 0
    self.tp = 0
    self.collidable = false
    
    -- Tamaño de la zona
    self.width = 20
    self.height = 40
    
    -- Efecto de parpadeo
    self.flash_timer = 0
    self.alpha = 0.5
end

function WarningZone:update()
    super.update(self)
    
    -- Parpadeo de advertencia
    self.flash_timer = self.flash_timer + DT
    self.alpha = 0.3 + math.sin(self.flash_timer * 10) * 0.3
end

function WarningZone:draw()
    super.draw(self)
    
    -- Dibujar zona de advertencia
    love.graphics.setColor(1, 1, 0, self.alpha) -- Amarillo
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    
    -- Borde
    love.graphics.setColor(1, 0.8, 0, self.alpha * 1.5)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)
    
    -- Símbolo de advertencia
    love.graphics.setColor(1, 0, 0, self.alpha * 2)
    love.graphics.print("!", self.width/2 - 4, self.height/2 - 8)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
end

return WarningZone