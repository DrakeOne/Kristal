-- Encounter de Existential Bob
local Encounter, super = Class(Encounter)

function Encounter:init()
    super.init(self)
    
    -- Texto al iniciar el encuentro
    self.text = "* Existential Bob bloquea el camino,\ncuestionando todo."
    
    -- Música de batalla
    self.music = "battleut"
    
    -- Fondo de batalla
    self.background = true
    
    -- Añadir enemigo
    self:addEnemy("existential_bob", SCREEN_WIDTH/2, 220)
    
    -- Configuración
    self.can_flee = true
    
    -- Textos de victoria
    self.victory_text = "* Ganaste...\n* ¿Pero a qué costo?"
    self.victory_money = 120
    self.victory_xp = 150
end

function Encounter:beforeBattle()
    -- Diálogo inicial opcional
    local bob = self:getEnemyBattler("existential_bob")
    if bob then
        bob.dialogue_override = "¿Por qué existo...?"
    end
end

function Encounter:onBattleEnd()
    -- Establecer flag de que derrotamos a Bob
    Game:setFlag("defeated_existential_bob", true)
end

return Encounter