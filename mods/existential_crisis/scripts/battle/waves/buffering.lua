local Buffering, super = Class(Wave)

function Buffering:init()
    super.init(self)
    self.time = 8
    
    -- Loading bar positions
    self.loading_bars = {}
end

function Buffering:onStart()
    -- Bob's dialogue
    local bob = Game.battle:getEnemyBattler("bob")
    bob.dialogue_override = "Sorry, my existential crisis\nis running on Windows Vista"
    
    -- Spawn fake loading bars
    self.timer:every(1, function()
        local y = math.random(Game.battle.arena.top + 30, Game.battle.arena.bottom - 30)
        local bar = self:spawnBullet("loading_bar", Game.battle.arena.left - 40, y)
        table.insert(self.loading_bars, bar)
    end)
    
    -- After 3 seconds, Bob "freezes"
    self.timer:after(3, function()
        bob.dialogue_override = "Buffering... 99%"
        
        -- Spawn a circle of loading bars around the soul
        local soul = Game.battle.soul
        local radius = 60
        
        for i = 1, 6 do
            local angle = (i - 1) * (math.pi * 2 / 6)
            local x = soul.x + math.cos(angle) * radius
            local y = soul.y + math.sin(angle) * radius
            
            local bar = self:spawnBullet("loading_bar", x, y)
            bar.rotating = true
            bar.center_x = soul.x
            bar.center_y = soul.y
            bar.angle = angle
            bar.radius = radius
        end
    end)
    
    -- Lag effect
    self.timer:after(5, function()
        bob.dialogue_override = "Connection lost...\nPlease try again later"
        
        -- Make all bullets stutter
        for _, bar in ipairs(self.loading_bars) do
            if bar and not bar.removed then
                bar.lag_mode = true
            end
        end
    end)
end

function Buffering:update()
    super.update(self)
    
    -- Clean up removed bullets
    for i = #self.loading_bars, 1, -1 do
        if self.loading_bars[i].removed then
            table.remove(self.loading_bars, i)
        end
    end
end

return Buffering