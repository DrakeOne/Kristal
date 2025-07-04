local Bob, super = Class(EnemyBattler)

-- Definir BobCustomSprite ANTES de usarla
local BobCustomSprite = Class(Sprite)

function BobCustomSprite:init()
    Sprite.init(self)
    self.width = 64
    self.height = 64
    self.mood = "normal"
    self.wobble = 0
    self.eye_timer = 0
    
    -- Inicializar propiedades necesarias de Sprite
    self.crossfade_speed = 0
    self.crossfade_to = nil
    self.crossfade_alpha = 0
    self.anim_speed = 1
    self.anim_frames = {}
    self.anim_routine = nil
end

function BobCustomSprite:draw()
    Sprite.draw(self)
    
    -- Draw Bob as a simple blob
    love.graphics.push()
    love.graphics.translate(self.width/2, self.height/2)
    
    -- Body (black blob)
    love.graphics.setColor(0.1, 0.1, 0.1)
    local scale = 1 + math.sin(self.wobble) * 0.05
    love.graphics.ellipse("fill", 0, 0, 30 * scale, 35 * scale)
    
    -- Eyes (white)
    if self.eye_timer <= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", -10, -5, 5)
        love.graphics.circle("fill", 10, -5, 5)
        
        -- Pupils
        love.graphics.setColor(0, 0, 0)
        local pupil_offset = 0
        if self.mood == "depressed" then
            pupil_offset = 2
        elseif self.mood == "manic" then
            pupil_offset = -2
        end
        love.graphics.circle("fill", -10, -5 + pupil_offset, 2)
        love.graphics.circle("fill", 10, -5 + pupil_offset, 2)
    else
        -- Blinking
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", -15, -5, 10, 2)
        love.graphics.rectangle("fill", 5, -5, 10, 2)
    end
    
    -- Mouth (based on mood)
    love.graphics.setColor(1, 1, 1)
    if self.mood == "depressed" then
        love.graphics.arc("line", "open", 0, 10, 10, 0, math.pi)
    elseif self.mood == "manic" then
        love.graphics.arc("line", "open", 0, 5, 15, math.pi, math.pi * 2)
    elseif self.mood == "apathetic" then
        love.graphics.line(-10, 10, 10, 10)
    end
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

-- Ahora sí definir Bob
function Bob:init()
    super.init(self)

    -- Enemy name
    self.name = "Bob"
    
    -- NO llamar a setActor porque no tenemos sprites
    -- self:setActor("bob")

    -- Enemy health
    self.max_health = 999
    self.health = 999
    -- Enemy attack (determines bullet damage)
    self.attack = 6
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "quarter_life",
        "social_media",
        "philosophy",
        "error_404",
        "buffering"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "...",
        "Why?",
        "Does any of this matter?",
        "I'm tired.",
        "Leave me alone.",
        "Error 404: Will to live not found.",
        "Buffering...",
        "This is fine.",
        "Are we having fun yet?",
        "Existence is pain."
    }

    -- Check text
    self.check = "AT ??? DF ???\n* Having a rough eternity.\n* Smells like expired philosophy books\nand regret."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Bob stares into the void.\n* The void stares back.",
        "* Bob questions the nature of reality.",
        "* Smells like existential dread.",
        "* Bob is having a crisis.",
        "* You feel uncomfortable.",
        "* Bob's HP display is glitching out.",
        "* The battle feels meaningless.\n* But you continue anyway."
    }
    
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Bob seems... relieved?"

    -- Register acts
    self:registerAct("Therapy")
    self:registerAct("Relate")
    self:registerAct("Joke")
    self:registerAct("Philosophy", "", {"ralsei"})
    
    -- Initialize mood system
    self.mood = "normal" -- normal, depressed, manic, apathetic
    self.mood_timer = 0
    self.turn_count = 0
    
    -- Track player actions
    self.times_spared = 0
    self.times_attacked = 0
    self.last_act = nil
    self.act_count = {}
    
    -- HP display shenanigans
    self.hp_displays = {
        "999/???",
        "NaN/NaN",
        "404/404",
        "Yes/No",
        "∞/-∞",
        "Help/Me",
        "Why/Tho",
        "LOL/LMAO"
    }
    self.current_hp_display = 1
    
    -- Create custom sprite
    self.sprite = BobCustomSprite()
    self:addChild(self.sprite)
    
    -- Animation variables
    self.wobble = 0
    self.eye_timer = 0
    self.blink_timer = 0
end

function Bob:getHPText()
    -- Return random HP display
    return self.hp_displays[self.current_hp_display]
end

function Bob:onAct(battler, name)
    -- Track act usage
    self.act_count[name] = (self.act_count[name] or 0) + 1
    
    if name == "Therapy" then
        self:addMercy(30)
        if self.act_count[name] > 1 then
            self.dialogue_override = "Oh great, more therapy.\nJust what I needed."
            return "* You try the therapy approach again.\n* Bob seems annoyed."
        else
            self.dialogue_override = "Therapy? Really?\nDo I look like I can afford that?"
            return "* You suggest Bob should seek\nprofessional help.\n* He laughs bitterly."
        end
        
    elseif name == "Relate" then
        self:addMercy(25)
        self.mood = "depressed"
        self.dialogue_override = "Oh, you too?\n...That's actually worse somehow."
        return "* You share your own existential dread.\n* Bob feels less alone but more\ndepressed."
        
    elseif name == "Joke" then
        if self.mood == "depressed" then
            self:addMercy(40)
            self.dialogue_override = "Heh... that's actually funny.\nI hate that it's funny."
            return "* You tell Bob a joke about existence.\n* He laughs despite himself!"
        else
            self:addMercy(20)
            self.dialogue_override = "Ha. Ha. Very funny.\nComedy is dead, just like my soul."
            return "* You tell Bob a joke.\n* He's not very amused."
        end
        
    elseif name == "Philosophy" then
        self:setMercy(100)
        self.dialogue_override = "The meaning of life is...\nwait, that's... huh.\nI need to think about this."
        Game.battle:startActCutscene("bob", "philosophy_ending")
        return
        
    elseif name == "Standard" then
        self:addMercy(50)
        if battler.chara.id == "susie" then
            self.dialogue_override = "OW! Physical pain!\nAt least it's not emotional!"
            return "* Susie punched Bob!\n* He seems... grateful?"
        else
            return "* "..battler.chara:getName().." tried to help Bob.\n* It's not very effective..."
        end
    end

    return super.onAct(self, battler, name)
end

function Bob:onHurt(damage, battler)
    super.onHurt(self, damage, battler)
    
    self.times_attacked = self.times_attacked + 1
    
    -- Change HP display when hurt
    self.current_hp_display = math.random(1, #self.hp_displays)
    
    -- Dialogue based on damage
    if damage > 50 then
        self.dialogue_override = "Wow, that actually hurt.\nGood for you, I guess."
    elseif self.times_attacked > 3 then
        self.dialogue_override = "Violence won't solve\nyour problems, you know."
    end
end

function Bob:onDefeat(damage, battler)
    self.dialogue_override = "Finally... wait, why do I\nhear boss music in the afterlife?"
    
    -- Easter egg: Bob respawns
    Game.battle:startActCutscene("bob", "fake_death")
end

function Bob:onSpare(battler)
    self.dialogue_override = "You... you think I deserve to exist?\nThat's... something."
    
    if Game:getFlag("identity_crisis") then
        Game.battle:startActCutscene("bob", "identity_crisis_spare")
    end
end

function Bob:update()
    super.update(self)
    
    -- Update mood timer
    self.mood_timer = self.mood_timer + DT
    
    -- Change mood every 3 turns
    if self.mood_timer > 15 then
        self.mood_timer = 0
        local moods = {"normal", "depressed", "manic", "apathetic"}
        self.mood = moods[math.random(1, #moods)]
        
        -- Announce mood change
        if self.mood == "depressed" then
            self.dialogue_override = "Everything is pointless..."
        elseif self.mood == "manic" then
            self.dialogue_override = "EVERYTHING IS FINE!\nEVERYTHING IS GREAT!"
        elseif self.mood == "apathetic" then
            self.dialogue_override = "Whatever. Nothing matters."
        end
    end
    
    -- Update animation
    self.wobble = self.wobble + DT * 2
    self.blink_timer = self.blink_timer + DT
    if self.blink_timer > 3 then
        self.eye_timer = 0.2
        self.blink_timer = 0
    end
    if self.eye_timer > 0 then
        self.eye_timer = self.eye_timer - DT
    end
    
    -- Update sprite mood
    if self.sprite and self.sprite.mood then
        self.sprite.mood = self.mood
        self.sprite.wobble = self.wobble
        self.sprite.eye_timer = self.eye_timer
    end
    
    -- Glitch effect - reducido para móviles
    local glitch_chance = Mod and Mod.mobile_mode and 0.005 or 0.02
    if math.random() < glitch_chance then
        local glitch_amount = Mod and Mod.mobile_mode and 1 or 2
        self.sprite.x = self.sprite.x + math.random(-glitch_amount, glitch_amount)
        self.sprite.y = self.sprite.y + math.random(-glitch_amount, glitch_amount)
    end
end

function Bob:getNextWaves()
    -- Modify wave selection based on mood
    if self.mood == "depressed" then
        return {"philosophy", "error_404"}
    elseif self.mood == "manic" then
        return {"social_media", "buffering", "quarter_life"}
    elseif self.mood == "apathetic" then
        return {"error_404"}
    else
        return self.waves
    end
end

return Bob