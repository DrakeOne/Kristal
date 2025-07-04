local BobEncounter, super = Class(Encounter)

function BobEncounter:init()
    super.init(self)
    
    -- Basic encounter text
    self.text = "* Bob blocks the way!"
    
    -- Use default battle music
    self.music = "battle"
    
    -- Add a simple enemy (using virovirokun as placeholder since Bob doesn't have sprites)
    -- Position it in the center of the battle arena
    self:addEnemy("virovirokun", 320, 200)
    
    -- Custom dialogue for this encounter
    self.dialogue_override = {
        "Bob?",
        "I am Bob.",
        "You are not Bob.",
        "This is... problematic."
    }
end

function BobEncounter:onBattleStart()
    -- Show some flavor text when battle starts
    Game.battle:startCutscene(function(cutscene)
        cutscene:text("* A strange presence fills the room...")
        cutscene:text("* You feel like you're being judged.")
    end)
end

function BobEncounter:onBattleEnd()
    -- Mark that Bob was defeated
    Mod.bob_defeated = true
    Game:setFlag("bob_defeated", true)
end

return BobEncounter