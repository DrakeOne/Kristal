local AgeNumber, super = Class(Bullet)

function AgeNumber:init(x, y, age)
    super.init(self, x, y, "battle/bullets/age_number")
    
    self.age = age or 30
    self.speed = 2
    self.damage = 5
    
    -- Remove when offscreen
    self.remove_offscreen = true
    
    -- Track player
    self.tracking = true
    self.track_speed = 0.02
end

function AgeNumber:update()
    super.update(self)
    
    -- Track the soul
    if self.tracking and Game.battle.soul then
        local soul = Game.battle.soul
        local angle = math.atan2(soul.y - self.y, soul.x - self.x)
        
        -- Gradually adjust direction
        local target_vx = math.cos(angle) * self.speed * 30
        local target_vy = math.sin(angle) * self.speed * 30
        
        self.physics.speed_x = self.physics.speed_x + (target_vx - self.physics.speed_x) * self.track_speed
        self.physics.speed_y = self.physics.speed_y + (target_vy - self.physics.speed_y) * self.track_speed
    end
end

function AgeNumber:draw()
    -- Draw the age number
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(Assets.getFont("main", 24))
    love.graphics.print(tostring(self.age), -12, -12)
    love.graphics.setColor(1, 1, 1)
end

return AgeNumber