local LoadingBar, super = Class(Bullet)

function LoadingBar:init(x, y)
    super.init(self, x, y, "battle/bullets/loading")
    
    self.damage = 5
    self.progress = math.random(0, 99)
    
    -- Movement
    self.physics.speed_x = 3 * 30
    
    -- Rotating mode
    self.rotating = false
    self.center_x = x
    self.center_y = y
    self.angle = 0
    self.radius = 60
    
    -- Lag mode
    self.lag_mode = false
    self.lag_timer = 0
    
    self.remove_offscreen = true
end

function LoadingBar:update()
    super.update(self)
    
    -- Update progress
    self.progress = self.progress + DT * 20
    if self.progress >= 99 then
        self.progress = 99
    end
    
    -- Rotating around soul
    if self.rotating then
        self.angle = self.angle + DT * 2
        self.x = self.center_x + math.cos(self.angle) * self.radius
        self.y = self.center_y + math.sin(self.angle) * self.radius
    end
    
    -- Lag effect
    if self.lag_mode then
        self.lag_timer = self.lag_timer + DT
        if self.lag_timer > 0.2 then
            -- Stutter movement
            self.physics.speed_x = math.random(-1, 1) * 30
            self.physics.speed_y = math.random(-1, 1) * 30
            self.lag_timer = 0
        end
    end
end

function LoadingBar:draw()
    -- Draw loading bar background
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", -30, -10, 60, 20)
    
    -- Draw loading bar progress
    love.graphics.setColor(0, 0.7, 0)
    love.graphics.rectangle("fill", -30, -10, 60 * (self.progress / 100), 20)
    
    -- Draw border
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", -30, -10, 60, 20)
    
    -- Draw percentage
    love.graphics.setFont(Assets.getFont("main", 12))
    love.graphics.print(math.floor(self.progress) .. "%", -15, -6)
    
    -- Glitch at 99%
    if self.progress >= 99 and math.random() < 0.3 then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.print("STUCK", -15, -6)
    end
    
    love.graphics.setColor(1, 1, 1)
end

return LoadingBar