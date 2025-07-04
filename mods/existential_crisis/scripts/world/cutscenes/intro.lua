return function(cutscene)
    -- Stop any music that might be playing
    if Game.world.music then
        Game.world.music:stop()
    end
    
    -- Fade to black first
    cutscene:fadeOut(0)
    cutscene:wait(0.5)
    
    -- Show text on black screen
    cutscene:text("* You boot up a suspicious mod...")
    cutscene:wait(1)
    
    cutscene:text("* Something feels... wrong.")
    cutscene:wait(1)
    
    cutscene:text("* The void calls out to you.")
    cutscene:wait(1)
    
    cutscene:text("* You have no choice but to answer.")
    cutscene:wait(1)
    
    cutscene:text("* ...")
    cutscene:wait(1.5)
    
    -- Simple screen shake effect
    if Game.world then
        Game.world:shakeCamera(4, 4, 0.5)
        cutscene:wait(0.5)
    end
    
    -- Fade back in
    cutscene:fadeIn(0.5)
    cutscene:wait(0.5)
    
    -- Start the encounter
    cutscene:encounter("bob_encounter", true)
end