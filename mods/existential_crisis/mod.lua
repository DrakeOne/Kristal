function Mod:init()
    print("Existential Crisis mod loaded!")
    print("Prepare to question everything...")
    
    -- Track some mod-specific variables
    self.bob_defeated = false
    self.times_died_to_bob = 0
    self.philosophical_level = 0
    self.intro_played = false
end

function Mod:load(data, new_file)
    -- Load saved data
    if data then
        self.bob_defeated = data.bob_defeated or false
        self.times_died_to_bob = data.times_died_to_bob or 0
        self.philosophical_level = data.philosophical_level or 0
        self.intro_played = data.intro_played or false
    end
    
    -- If it's a new file and we haven't played the intro yet
    if new_file and not self.intro_played then
        self.should_play_intro = true
    end
end

function Mod:save(data)
    -- Save mod-specific data
    data.bob_defeated = self.bob_defeated
    data.times_died_to_bob = self.times_died_to_bob
    data.philosophical_level = self.philosophical_level
    data.intro_played = self.intro_played
    return data
end

function Mod:postInit(new_file)
    -- Easter egg: if player name is Bob
    if Game.save_name and Game.save_name:upper() == "BOB" then
        Game:setFlag("identity_crisis", true)
    end
    
    -- Start intro cutscene when entering the world
    if self.should_play_intro and Game.world then
        self.should_play_intro = false
        self.intro_played = true
        
        -- Start the cutscene immediately
        Game.world:startCutscene("intro")
    end
end

return Mod