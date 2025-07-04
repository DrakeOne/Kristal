local BobEncounter, super = Class(Encounter)

function BobEncounter:init()
    super.init(self)
    
    -- Basic encounter text
    self.text = "* Bob blocks the way!"
    
    -- Use default battle music
    self.music = "battle"
    
    -- Add the actual Bob enemy (not virovirokun)
    self:addEnemy("bob", 320, 200)
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