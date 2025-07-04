return function(cutscene, event)
    -- Check if we haven't played the intro yet
    if not Mod.intro_played then
        Mod.intro_played = true
        
        -- Wait a moment for the world to settle
        cutscene:wait(0.5)
        
        -- Start the intro cutscene
        cutscene:after(function()
            Game.world:startCutscene("intro")
        end)
    end
end