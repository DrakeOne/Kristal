-- Actor de Existential Bob
local actor, super = Class(Actor, "existential_bob")

function actor:init()
    super.init(self)
    
    self.name = "Existential Bob"
    
    -- Tamaño y hitbox
    self.width = 60
    self.height = 80
    self.hitbox = {0, 40, 60, 40}
    
    -- Ruta de sprites (por ahora usaremos un placeholder)
    self.path = "enemies/existential_bob"
    self.default = "idle"
    
    -- Animaciones
    self.animations = {
        ["idle"] = {"idle", 0.25, true},
        ["hurt"] = {"idle", 1/15, false, frames = {1, 2, 1, 2, 1}},
        ["defeat"] = {"defeat", 1/15, false},
        ["spare"] = {"spare", 1/15, false}
    }
    
    -- Offsets para las animaciones
    self.offsets = {
        ["idle"] = {0, 0},
        ["hurt"] = {0, 0},
        ["defeat"] = {0, 0},
        ["spare"] = {0, 0}
    }
end

return actor