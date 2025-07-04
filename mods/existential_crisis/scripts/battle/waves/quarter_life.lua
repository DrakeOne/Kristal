local QuarterLife, super = Class(Wave)

function QuarterLife:init()
    super.init(self)
    self.time = 8
    
    -- Age numbers that will chase the player
    self.ages = {25, 30, 35, 40}
    self.age_bullets = {}
end

function QuarterLife:onStart()
    -- Bob's dialogue
    local bob = Game.battle:getEnemyBattler("bob")
    bob.dialogue_override = "Time is running out!\nYou're getting OLDER!"
    
    -- Spawn age numbers that chase the player
    self.timer:every(1.5, function()
        local age = self.ages[math.random(1, #self.ages)]
        local side = math.random(1, 4)
        local x, y
        
        if side == 1 then -- Top
            x = math.random(Game.battle.arena.left, Game.battle.arena.right)
            y = Game.battle.arena.top - 20
        elseif side == 2 then -- Right
            x = Game.battle.arena.right + 20
            y = math.random(Game.battle.arena.top, Game.battle.arena.bottom)
        elseif side == 3 then -- Bottom
            x = math.random(Game.battle.arena.left, Game.battle.arena.right)
            y = Game.battle.arena.bottom + 20
        else -- Left
            x = Game.battle.arena.left - 20
            y = math.random(Game.battle.arena.top, Game.battle.arena.bottom)
        end
        
        local bullet = self:spawnBullet("age_number", x, y, age)
        table.insert(self.age_bullets, bullet)
    end)
    
    -- Make numbers move faster over time
    self.timer:every(0.1, function()
        for _, bullet in ipairs(self.age_bullets) do
            if bullet and not bullet.removed then
                bullet.speed = bullet.speed + 0.5
            end
        end
    end)
end

function QuarterLife:update()
    super.update(self)
    
    -- Clean up removed bullets
    for i = #self.age_bullets, 1, -1 do
        if self.age_bullets[i].removed then
            table.remove(self.age_bullets, i)
        end
    end
end

return QuarterLife