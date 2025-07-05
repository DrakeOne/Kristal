-- Notification Bullet - Notificaciones de redes sociales
local NotificationBullet, super = Class(Bullet)

function NotificationBullet:init(x, y)
    -- Usar un sprite simple por ahora
    super.init(self, x, y)
    
    self.notification_type = "like"
    self.physics.speed_y = 3
    self.physics.gravity = 0.1
    
    self.tp = 0.5 -- Da TP al hacer graze
    self.damage = 4
    
    -- Movimiento ondulatorio sutil
    self.sine_timer = 0
    self.base_x = x
    
    self:setScale(0.8)
    self.alpha = 0
    
    -- Crear visual simple
    self.width = 16
    self.height = 16
    self:setHitbox(0, 0, 16, 16)
end

function NotificationBullet:update()
    super.update(self)
    
    -- Fade in suave
    if self.alpha < 1 then
        self.alpha = math.min(1, self.alpha + 0.05)
    end
    
    -- Movimiento ondulatorio
    self.sine_timer = self.sine_timer + DT * 2
    self.x = self.base_x + math.sin(self.sine_timer) * 15
    
    -- Acelerar gradualmente
    self.physics.speed_y = math.min(6, self.physics.speed_y + self.physics.gravity)
end

function NotificationBullet:draw()
    super.draw(self)
    
    -- Dibujar un círculo simple como notificación
    love.graphics.setColor(1, 0.2, 0.2, self.alpha)
    love.graphics.circle("fill", 8, 8, 8)
    
    -- Punto blanco como indicador
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.circle("fill", 12, 4, 3)
    
    love.graphics.setColor(1, 1, 1, 1)
end

return NotificationBullet