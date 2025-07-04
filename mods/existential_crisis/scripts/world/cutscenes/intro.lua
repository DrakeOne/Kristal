return {
    intro = function(cutscene)
        -- Fade in from black
        Game.world.music:stop()
        cutscene:fadeIn(0.5)
        
        -- Show text on black screen
        cutscene:text("* You boot up a suspicious mod...", nil, nil, {auto = true})
        cutscene:wait(1)
        cutscene:text("* Something feels... wrong.", nil, nil, {auto = true})
        cutscene:wait(1)
        
        -- More ominous text
        cutscene:text("* The void calls out to you.", nil, nil, {auto = true})
        cutscene:wait(1)
        cutscene:text("* You have no choice but to answer.", nil, nil, {auto = true})
        cutscene:wait(1)
        
        -- Start the encounter directly
        cutscene:text("* ...", nil, nil, {auto = true})
        cutscene:wait(0.5)
        
        -- Glitch effect (simple screen shake)
        Game.world:shakeCamera(4, 0.5)
        cutscene:wait(0.5)
        
        -- Start battle
        cutscene:encounter("bob_encounter", false)
    end
}