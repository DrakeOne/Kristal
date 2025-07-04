local ErrorBullet, super = Class(Bullet)

function ErrorBullet:init(x, y, text)
    super.init(self, x, y)
    
    self.text = text or "ERROR"
    self.damage = 5
    
    -- Física
    self.bounce_x = 0
    self.bounce_y = 0
    self.static = false
    self.remove_timer = nil
    
    -- Visual
    self.width = 40
    self.height = 20
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    
    -- Glitch effect
    self.glitch_timer = 0
end

function ErrorBullet:update()
    super.update(self)
    
    -- Bouncing physics
    if not self.static then
        self.x = self.x + self.bounce_x * DTMULT
        self.y = self.y + self.bounce_y * DTMULT
        
        -- Bounce off arena walls
        if self.x <= Game.battle.arena.left or self.x + self.width >= Game.battle.arena.right then
            self.bounce_x = -self.bounce_x
        end
        if self.y <= Game.battle.arena.top or self.y + self.height >= Game.battle.arena.bottom then
            self.bounce_y = -self.bounce_y
        end
    end
    
    -- Remove timer
    if self.remove_timer then
        self.remove_timer = self.remove_timer - DT
        if self.remove_timer <= 0 then
            self:remove()
        end
    end
    
    -- Glitch effect
    self.glitch_timer = self.glitch_timer + DT
end

function ErrorBullet:draw()
    super.draw(self)
    
    -- Glitch offset
    local offset_x = 0
    local offset_y = 0
    if math.sin(self.glitch_timer * 20) > 0.8 then
        offset_x = math.random(-2, 2)
        offset_y = math.random(-2, 2)
    end
    
    -- Draw error box
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", offset_x, offset_y, self.width, self.height)
    
    -- Draw text
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(Assets.getFont("main", 16))
    love.graphics.printf(self.text, offset_x, offset_y + 2, self.width, "center")
    
    love.graphics.setColor(1, 1, 1)
end

return ErrorBullet