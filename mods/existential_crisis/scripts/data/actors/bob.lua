local actor, super = Class(Actor, "bob")

function actor:init()
    super.init(self)

    -- Display name
    self.name = "Bob"

    -- Width and height for this actor, used to determine its center
    self.width = 64
    self.height = 64

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 32, 64, 32}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0.5, 0.5, 0.5}

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/bob"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Table of sprite animations
    self.animations = {
        ["idle"] = {"idle", 0.25, true},
        ["hurt"] = {"idle", 0.1, true}, -- Fast shake when hurt
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["idle"] = {0, 0},
        ["sad"] = {0, 0},
        ["manic"] = {0, 0},
        ["attack"] = {0, 0},
    }
end

return actor