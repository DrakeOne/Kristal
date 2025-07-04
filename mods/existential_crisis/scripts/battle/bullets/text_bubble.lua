local TextBubble, super = Class(Bullet)

function TextBubble:init(x, y, text)
    super.init(self, x, y, "battle/bullets/text_bubble")
    
    self.text = text or "?"
    self.damage = 0  -- No damage, just slows you down
    
    -- Movement
    self.physics.speed_y = 2 * 30
    
    -- Slow effect
    self.slow_duration = 3
    self.touched_soul = false
    
    -- For converging bullets
    self.converge = false
    self.target_x = x
    self.target_y = y
    
    self.remove_offscreen = true
end

function TextBubble:update()
    super.update(self)
    
    -- Converge to target if needed
    if self.converge then
        local dx = self.target_x - self.x
        local dy = self.target_y - self.y
        
        self.physics.speed_x = dx * 2
        self.physics.speed_y = dy * 2
        
        -- Stop when close enough
        if math.abs(dx) < 5 and math.abs(dy) < 5 then
            self.physics.speed_x = 0
            self.physics.speed_y = 0
            self.converge = false
        end
    end
end

function TextBubble:onCollide(soul)
    if not self.touched_soul then
        self.touched_soul = true
        
        -- Apply slow effect to soul
        soul.slow_timer = self.slow_duration
        
        -- Show philosophical thought
        local thought_text = Text(self.text, soul.x, soul.y - 30)
        thought_text.alpha = 0.8
        thought_text.scale_x = 0.5
        thought_text.scale_y = 0.5
        Game.battle:addChild(thought_text)
        
        -- Fade out thought
        thought_text:fadeOutAndRemove(2)
    end
    
    -- Don't deal damage, just remove
    self:remove()
end

function TextBubble:draw()
    -- Draw bubble
    love.graphics.setColor(0.5, 0.5, 1, 0.7)
    love.graphics.circle("fill", 0, 0, 20)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", 0, 0, 20)
    
    -- Draw text
    love.graphics.setFont(Assets.getFont("main", 16))
    local w = Assets.getFont("main", 16):getWidth(self.text)
    love.graphics.print(self.text, -w/2, -8)
end

return TextBubble