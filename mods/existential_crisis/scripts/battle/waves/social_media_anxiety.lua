-- Social Media Anxiety Wave - Mejorado y sin errores
local SocialMediaAnxiety, super = Class(Wave)

function SocialMediaAnxiety:init()
    super.init(self)
    self.time = 8
    self.notification_count = 0
end

function SocialMediaAnxiety:onStart()
    -- Diálogo del enemigo
    local enemy = Game.battle:getEnemyBattler("existential_bob")
    if enemy then
        enemy.dialogue_override = "¿Por qué nadie me valida?"
    end
    
    -- Patrón 1: Notificaciones cayendo
    self.timer:every(0.6, function()
        -- Advertencia visual antes de spawn
        local x = Utils.random(Game.battle.arena.left + 20, Game.battle.arena.right - 20)
        local warning = self:spawnBullet("warning_zone", x, Game.battle.arena.top - 10)
        
        self.timer:after(0.3, function()
            if warning and not warning.removed then
                warning:remove()
            end
            -- Spawn la notificación real
            local notif = self:spawnBullet("notification_bullet", x, Game.battle.arena.top - 20)
            notif.notification_type = Utils.pick({"like", "comment", "share"})
        end)
    end)
    
    -- Patrón 2: Ola de ansiedad (a mitad del wave)
    self.timer:after(4, function()
        if enemy then
            enemy.dialogue_override = "¡La presión social me consume!"
        end
        
        -- Crear ola de izquierda a derecha
        for i = 1, 8 do
            self.timer:after(i * 0.15, function()
                local y = Game.battle.arena.center_y + math.sin(i * 0.8) * 40
                self:spawnBullet("anxiety_wave", Game.battle.arena.left - 30, y)
            end)
        end
    end)
end

return SocialMediaAnxiety