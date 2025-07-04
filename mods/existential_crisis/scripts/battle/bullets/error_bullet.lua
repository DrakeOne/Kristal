local ErrorBullet, super = Class(Bullet)

function ErrorBullet:init(x, y, text)
    super.init(self, x, y, "battle/bullets/error")
    
    self.text = text or "ERROR"
    self.damage = 6
    
    -- Bouncing properties
    self.bounce_x = 0
    self.bounce_y = 0
    
    -- Static mode (for walls)
    self.static = false
    self.remove_timer = nil
    
    self.remove_offscreen = false
end

function ErrorBullet:update()
    super.update(self)
    
    -- Remove after timer
    if self.remove_timer then
        self.remove_timer = self.remove_timer - DT
        if self.remove_timer <= 0 then
            self:remove()
        end
    end
    
    -- Bounce off arena walls
    if not self.static then
        if self.x <= Game.battle.arena.left + 10 or self.x >= Game.battle.arena.right - 10 then
            self.bounce_x = -self.bounce_x
            self.physics.speed_x = self.bounce_x * 30
        end
        
        if self.y <= Game.battle.arena.top + 10 or self.y >= Game.battle.arena.bottom - 10 then
            self.bounce_y = -self.bounce_y
            self.physics.speed_y = self.bounce_y * 30
        end
    end
end

function ErrorBullet:draw()
    -- Draw error box
    love.graphics.setColor(1, 0, 0, 0.8)
    love.graphics.rectangle("fill", -15, -10, 30, 20)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", -15, -10, 30, 20)
    
    -- Draw error text
    love.graphics.setFont(Assets.getFont("main", 12))
    local w = Assets.getFont("main", 12):getWidth(self.text)
    love.graphics.print(self.text, -w/2, -6)
    
    -- Glitch effect
    if math.random() < 0.1 then
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.rectangle("fill", -15 + math.random(-2, 2), -10 + math.random(-2, 2), 30, 20)
    end
    
    love.graphics.setColor(1, 1, 1)
end

return ErrorBullet