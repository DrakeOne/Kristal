local Philosophy, super = Class(Wave)

function Philosophy:init()
    super.init(self)
    self.time = 8
    
    -- Philosophical questions that slow you down
    self.questions = {
        "Why?",
        "What's the point?",
        "Is this canon?",
        "Are we real?",
        "Does it matter?",
        "Who am I?",
        "What is love?",
        "Why exist?"
    }
end

function Philosophy:onStart()
    -- Bob's dialogue
    local bob = Game.battle:getEnemyBattler("bob")
    if bob then
        bob.dialogue_override = "Let's get philosophical!"
    end
    
    -- Spawn text bubbles with questions
    self.timer:every(1.2, function()
        local question = self.questions[math.random(1, #self.questions)]
        local arena = Game.battle.arena
        local x = math.random(arena.left + 30, arena.right - 30)
        local y = arena.top - 20
        
        self:spawnBullet("text_bubble", x, y, question)
    end)
    
    -- After 4 seconds, spam existential questions
    self.timer:after(4, function()
        if bob then
            bob.dialogue_override = "THINK ABOUT YOUR EXISTENCE!"
        end
        
        -- Spawn a circle of questions
        local arena = Game.battle.arena
        -- Calculate center manually since arena doesn't have center_x/center_y
        local center_x = arena.x + arena.width / 2
        local center_y = arena.y + arena.height / 2
        local radius = 100
        
        for i = 1, 8 do
            local angle = (i - 1) * (math.pi * 2 / 8)
            local x = center_x + math.cos(angle) * radius
            local y = center_y + math.sin(angle) * radius
            
            local bullet = self:spawnBullet("text_bubble", x, y, "?")
            bullet.target_x = center_x
            bullet.target_y = center_y
            bullet.converge = true
        end
    end)
end

return Philosophy