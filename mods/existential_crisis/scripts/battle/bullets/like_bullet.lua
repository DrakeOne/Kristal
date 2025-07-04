local LikeBullet, super = Class(Bullet)

function LikeBullet:init(x, y, is_like, horizontal)
    super.init(self, x, y, "battle/bullets/like")
    
    -- Whether this is a like (true) or dislike (false)
    self.is_like = is_like ~= false
    self.is_trap = false
    self.horizontal = horizontal or false
    
    -- Movement
    if self.horizontal then
        self.physics.speed_x = 4 * 30
        self.physics.speed_y = 0
    else
        self.physics.speed_x = 0
        self.physics.speed_y = 3 * 30
    end
    
    -- Damage/heal
    self.damage = self.is_like and -1 or 5  -- Negative damage = heal
    
    -- Transform timer for trap likes
    self.transform_timer = 0
    
    self.remove_offscreen = true
end

function LikeBullet:update()
    super.update(self)
    
    -- If this is a trap like, transform after getting close to soul
    if self.is_trap and self.is_like and Game.battle.soul then
        local soul = Game.battle.soul
        local dist = math.sqrt((self.x - soul.x)^2 + (self.y - soul.y)^2)
        
        if dist < 60 then
            self.transform_timer = self.transform_timer + DT
            if self.transform_timer > 0.3 then
                -- Transform into dislike
                self.is_like = false
                self.damage = 5
                self.is_trap = false
            end
        end
    end
end

function LikeBullet:draw()
    -- Draw like or dislike
    if self.is_like then
        -- Draw heart (like)
        love.graphics.setColor(0, 0.5, 1)
        love.graphics.print("♥", -8, -8)
    else
        -- Draw thumbs down (dislike)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("👎", -8, -8)
    end
    
    -- Flash if about to transform
    if self.is_trap and self.transform_timer > 0 then
        love.graphics.setColor(1, 1, 1, math.sin(self.transform_timer * 20) * 0.5 + 0.5)
        love.graphics.circle("line", 0, 0, 12)
    end
    
    love.graphics.setColor(1, 1, 1)
end

return LikeBullet