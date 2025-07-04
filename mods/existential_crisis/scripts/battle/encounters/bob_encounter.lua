local BobEncounter, super = Class(Encounter)

function BobEncounter:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Bob blocks the way!\n* ...Not that there's anywhere to go."

    -- Battle music ("battle" is rude buster)
    self.music = "battle"
    
    -- Add the enemy to the encounter
    self:addEnemy("bob")

    -- Uncomment this line to add another!
    --self:addEnemy("bob")

    -- Background (optional)
    self.background = true
    
    -- Hide party status
    self.hide_world = true
    
    -- Death counter
    self.death_count = Mod.times_died_to_bob or 0
end

function BobEncounter:onBattleStart()
    -- Special dialogue if you've died before
    if self.death_count > 0 then
        local bob = Game.battle:getEnemyBattler("bob")
        if self.death_count == 1 then
            bob.dialogue_override = "Oh, you're back.\nGlutton for punishment?"
        elseif self.death_count < 5 then
            bob.dialogue_override = "Death #" .. self.death_count .. ".\nWe really doing this again?"
        else
            bob.dialogue_override = "You've died " .. self.death_count .. " times.\nThat's... concerning."
        end
    end
    
    -- Easter egg for player named Bob
    if Game:getFlag("identity_crisis") then
        local bob = Game.battle:getEnemyBattler("bob")
        bob.dialogue_override = "Wait... BOB?!\nIDENTITY THEFT IS NOT A JOKE!"
        bob.attack = bob.attack + 1 -- Extra damage for the confusion
    end
end

function BobEncounter:onTurnStart()
    local bob = Game.battle:getEnemyBattler("bob")
    
    -- Change HP display each turn
    bob.current_hp_display = (bob.current_hp_display % #bob.hp_displays) + 1
    
    -- Special dialogue based on turn count
    if Game.battle.turn_count == 10 then
        bob.dialogue_override = "Still here?\nDon't you have better things to do?"
    elseif Game.battle.turn_count == 20 then
        bob.dialogue_override = "This is taking forever.\nJust like existence."
    end
end

function BobEncounter:beforeStateChange(old_state, new_state)
    -- Track deaths
    if new_state == "GAMEOVER" then
        Mod.times_died_to_bob = (Mod.times_died_to_bob or 0) + 1
    end
end

function BobEncounter:createBackground()
    -- Create a custom glitchy background
    local bg = {}
    
    -- Black base
    table.insert(bg, Object(0, 0))
    bg[1].draw = function(self)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    end
    
    -- Glitch lines
    table.insert(bg, Object(0, 0))
    bg[2].draw = function(self)
        love.graphics.setColor(0, 1, 0, 0.5)
        for i = 1, 5 do
            local y = math.random(0, SCREEN_HEIGHT)
            love.graphics.rectangle("fill", 0, y, SCREEN_WIDTH, 2)
        end
        
        -- Random "code" text
        love.graphics.setColor(0, 1, 0, 0.3)
        love.graphics.setFont(Assets.getFont("main", 16))
        for i = 1, 10 do
            local x = math.random(0, SCREEN_WIDTH - 100)
            local y = math.random(0, SCREEN_HEIGHT - 20)
            local texts = {"404", "ERROR", "NULL", "VOID", "WHY", "HELP"}
            love.graphics.print(texts[math.random(1, #texts)], x, y)
        end
    end
    
    return bg
end

return BobEncounter