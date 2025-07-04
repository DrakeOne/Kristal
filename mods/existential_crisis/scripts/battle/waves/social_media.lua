local SocialMedia, super = Class(Wave)

function SocialMedia:init()
    super.init(self)
    self.time = 7
    
    -- Track likes for the trap mechanic
    self.like_bullets = {}
end

function SocialMedia:onStart()
    -- Bob's dialogue
    local bob = Game.battle:getEnemyBattler("bob")
    bob.dialogue_override = "Please validate my existence!\nPLEASE!"
    
    -- Spawn likes and dislikes
    self.timer:every(0.8, function()
        local type = math.random(1, 3)
        
        if type <= 2 then
            -- Spawn a "like" that turns into dislike
            local x = math.random(Game.battle.arena.left + 20, Game.battle.arena.right - 20)
            local bullet = self:spawnBullet("like_bullet", x, Game.battle.arena.top - 20)
            bullet.is_trap = true
            table.insert(self.like_bullets, bullet)
        else
            -- Spawn a regular dislike
            local x = math.random(Game.battle.arena.left + 20, Game.battle.arena.right - 20)
            self:spawnBullet("like_bullet", x, Game.battle.arena.top - 20, false)
        end
    end)
    
    -- Occasionally spawn a wave of social media icons
    self.timer:after(3, function()
        bob.dialogue_override = "Why won't anyone like my posts?!"
        
        -- Spawn a horizontal wave
        for i = 1, 5 do
            self.timer:after(i * 0.2, function()
                local y = Game.battle.arena.center_y + (i - 3) * 30
                self:spawnBullet("like_bullet", Game.battle.arena.left - 20, y, false, true)
            end)
        end
    end)
end

function SocialMedia:update()
    super.update(self)
    
    -- Clean up removed bullets
    for i = #self.like_bullets, 1, -1 do
        if self.like_bullets[i].removed then
            table.remove(self.like_bullets, i)
        end
    end
end

return SocialMedia