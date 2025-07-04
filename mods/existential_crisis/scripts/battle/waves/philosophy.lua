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
    bob.dialogue_override = "Let's get philosophical!"
    
    -- Spawn text bubbles with questions
    self.timer:every(1.2, function()
        local question = self.questions[math.random(1, #self.questions)]
        local x = math.random(Game.battle.arena.left + 30, Game.battle.arena.right - 30)
        local y = Game.battle.arena.top - 20
        
        self:spawnBullet("text_bubble", x, y, question)
    end)
    
    -- After 4 seconds, spam existential questions
    self.timer:after(4, function()
        bob.dialogue_override = "THINK ABOUT YOUR EXISTENCE!"
        
        -- Spawn a circle of questions
        local center_x = Game.battle.arena.center_x
        local center_y = Game.battle.arena.center_y
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