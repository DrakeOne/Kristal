return {
    philosophy_ending = function(cutscene, battler, enemy)
        -- Ralsei's philosophical speech
        cutscene:text("* Ralsei explained the meaning of life!", "smile", "ralsei")
        cutscene:wait(1)
        
        -- Bob's reaction
        cutscene:text("[voice:none]* ...", nil, "bob")
        cutscene:wait(1)
        cutscene:text("[voice:none]* That's... actually profound.", nil, "bob")
        cutscene:wait(1)
        cutscene:text("[voice:none]* Maybe existence isn't meaningless after all...", nil, "bob")
        cutscene:wait(1)
        
        -- Bob becomes spareable
        enemy:spare()
        
        cutscene:text("* Bob is having an existential breakthrough!")
        cutscene:wait(1)
        cutscene:text("* Bob can now be SPARED!")
    end,
    
    fake_death = function(cutscene, battler, enemy)
        -- Bob "dies"
        cutscene:wait(1)
        cutscene:text("[voice:none]* Finally... sweet release...", nil, "bob")
        cutscene:wait(1)
        
        -- Fake death animation
        enemy:fadeOut(1)
        cutscene:wait(1.5)
        
        -- Respawn
        cutscene:text("* ...But nobody died.")
        enemy:fadeIn(0.5)
        cutscene:wait(0.5)
        
        cutscene:text("[voice:none]* WHAT?! I CAN'T EVEN DIE PROPERLY?!", nil, "bob")
        cutscene:wait(1)
        cutscene:text("[voice:none]* This is worse than existence!", nil, "bob")
        
        -- Restore Bob's HP
        enemy.health = enemy.max_health / 2
        enemy:statusMessage("HP RESTORED?!")
    end,
    
    identity_crisis_spare = function(cutscene, battler, enemy)
        -- Special ending if player is named Bob
        cutscene:text("[voice:none]* Wait... if you're Bob...", nil, "bob")
        cutscene:wait(1)
        cutscene:text("[voice:none]* And I'm Bob...", nil, "bob")
        cutscene:wait(1)
        cutscene:text("[voice:none]* Then who's driving the car?!", nil, "bob")
        cutscene:wait(2)
        
        -- Both Bobs have an existential crisis
        Game.world:shakeCamera(4, 1)
        cutscene:wait(1)
        
        cutscene:text("* The universe couldn't handle two Bobs!")
        cutscene:text("* Reality is collapsing!")
        
        -- End battle with special flag
        Game:setFlag("double_bob_paradox", true)
    end
}