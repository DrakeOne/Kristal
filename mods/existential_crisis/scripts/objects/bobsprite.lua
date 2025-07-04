-- Simple sprite class for Bob since we don't have actual image files
BobSprite = Class(Sprite)

function BobSprite:init(actor)
    super.init(self)
    
    self.actor = actor
    self.width = 64
    self.height = 64
    
    -- Animation state
    self.mood = "normal"
    self.wobble = 0
    self.eye_timer = 0
    self.blink_timer = 0
end

function BobSprite:update()
    super.update(self)
    
    -- Wobble effect
    self.wobble = self.wobble + DT * 2
    
    -- Blinking
    self.blink_timer = self.blink_timer + DT
    if self.blink_timer > 3 then
        self.eye_timer = 0.2
        self.blink_timer = 0
    end
    
    if self.eye_timer > 0 then
        self.eye_timer = self.eye_timer - DT
    end
end

function BobSprite:draw()
    super.draw(self)
    
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
        if self.mood == "sad" then
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
    if self.mood == "sad" then
        love.graphics.arc("line", "open", 0, 10, 10, 0, math.pi)
    elseif self.mood == "manic" then
        love.graphics.arc("line", "open", 0, 5, 15, math.pi, math.pi * 2)
    elseif self.mood == "attack" then
        love.graphics.ellipse("fill", 0, 10, 8, 6)
    end
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

return BobSprite