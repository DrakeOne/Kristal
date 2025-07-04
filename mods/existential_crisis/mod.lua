function Mod:init()
    print("Existential Crisis mod loaded!")
    print("Prepare to question everything...")
    
    -- Track some mod-specific variables
    self.bob_defeated = false
    self.times_died_to_bob = 0
    self.philosophical_level = 0
end

function Mod:load(data, new_file)
    -- Load saved data
    if data then
        self.bob_defeated = data.bob_defeated or false
        self.times_died_to_bob = data.times_died_to_bob or 0
        self.philosophical_level = data.philosophical_level or 0
    end
    
    -- Start with the intro cutscene
    if new_file and Game.world then
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