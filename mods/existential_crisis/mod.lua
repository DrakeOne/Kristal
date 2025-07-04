function Mod:init()
    print("Existential Crisis mod loaded!")
    print("Prepare to question everything...")
    
    -- Register the encounter
    self:registerEncounter("bob_encounter")
    
    -- Track some mod-specific variables
    self.bob_defeated = false
    self.times_died_to_bob = 0
    self.philosophical_level = 0
end

function Mod:load(data, new_file)
    -- Start with the intro cutscene
    if new_file then
        Game.world:startCutscene("intro")
    end
end

function Mod:save(data)
    -- Save mod-specific data
    data.bob_defeated = self.bob_defeated
    data.times_died_to_bob = self.times_died_to_bob
    data.philosophical_level = self.philosophical_level
    return data
end

function Mod:postInit()
    -- Easter egg: if player name is Bob
    if Game.save_name and Game.save_name:upper() == "BOB" then
        Game:setFlag("identity_crisis", true)
    end
end

return Mod