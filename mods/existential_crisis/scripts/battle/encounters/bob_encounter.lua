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

function BobEncounter:onBattleInit()
    super.onBattleInit(self)
    -- Asegurarse de que la batalla esté configurada correctamente
end

function BobEncounter:onBattleStart()
    -- Remover la cutscene que podría estar causando el problema
    -- En su lugar, solo mostrar el texto inicial
    super.onBattleStart(self)
end

function BobEncounter:onTurnStart()
    super.onTurnStart(self)
    -- Asegurarse de que el UI esté visible
    if Game.battle.state == "INTRO" then
        Game.battle:setState("ACTIONSELECT")
    end
end

function BobEncounter:onBattleEnd()
    -- Mark that Bob was defeated
    if Mod then
        Mod.bob_defeated = true
    end
    Game:setFlag("bob_defeated", true)
end

return BobEncounter