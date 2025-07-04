local Error404, super = Class(Wave)

function Error404:init()
    super.init(self)
    self.time = 7
    
    -- Error messages
    self.errors = {
        "404",
        "ERROR",
        "NULL",
        "FATAL",
        "CRASH",
        "BSOD",
        "!!!"
    }
end

function Error404:onStart()
    -- Bob's dialogue
    local bob = Game.battle:getEnemyBattler("bob")
    bob.dialogue_override = "ERROR: REASON_TO_LIVE.exe\nhas stopped working"
    
    -- Spawn bouncing error bullets
    self.timer:every(0.6, function()
        local error_text = self.errors[math.random(1, #self.errors)]
        local x = math.random(Game.battle.arena.left + 20, Game.battle.arena.right - 20)
        
        local bullet = self:spawnBullet("error_bullet", x, Game.battle.arena.top, error_text)
        
        -- Random bounce direction
        bullet.bounce_x = math.random(-2, 2)
        bullet.bounce_y = math.random(3, 5)
    end)
    
    -- After 3 seconds, glitch the arena
    self.timer:after(3, function()
        bob.dialogue_override = "SYSTEM FAILURE IMMINENT"
        
        -- Create glitch walls
        for i = 1, 3 do
            self.timer:after(i * 0.5, function()
                -- Vertical error wall
                for y = Game.battle.arena.top, Game.battle.arena.bottom, 30 do
                    local x = Game.battle.arena.left + (Game.battle.arena.width / 4) * i
                    local bullet = self:spawnBullet("error_bullet", x, y, "!")
                    bullet.static = true
                    bullet.remove_timer = 1.5
                end
            end)
        end
    end)
end

return Error404