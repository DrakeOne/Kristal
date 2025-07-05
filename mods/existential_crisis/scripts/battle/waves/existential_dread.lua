-- Existential Dread Wave - Preguntas existenciales y espiral de dudas
local ExistentialDread, super = Class(Wave)

function ExistentialDread:init()
    super.init(self)
    self.time = 10
    self.dread_level = 0
end

function ExistentialDread:onStart()
    local enemy = Game.battle:getEnemyBattler("existential_bob")
    if enemy then
        enemy.dialogue_override = "¿Qué sentido tiene todo esto?"
    end
    
    -- Fase 1: Preguntas existenciales
    local questions = {
        "¿POR QUÉ?",
        "¿QUIÉN SOY?",
        "¿IMPORTA?",
        "¿Y DESPUÉS?"
    }
    
    for i, question in ipairs(questions) do
        self.timer:after((i-1) * 2, function()
            -- Crear texto que flota y persigue levemente
            local text_bullet = self:spawnBullet("existential_text", 
                Game.battle.arena.center_x, 
                Game.battle.arena.top - 30
            )
            text_bullet.text = question
            text_bullet.target_y = Game.battle.arena.center_y + (i-2.5) * 30
        end)
    end
    
    -- Fase 2: Espiral de dudas
    self.timer:after(5, function()
        if enemy then
            enemy.dialogue_override = "¡Todo es un ciclo sin fin!"
        end
        
        -- Crear espiral de bullets
        local angle = 0
        self.timer:every(0.1, function()
            angle = angle + 0.3
            local radius = 100
            local x = Game.battle.arena.center_x + math.cos(angle) * radius
            local y = Game.battle.arena.center_y + math.sin(angle) * radius
            
            local bullet = self:spawnBullet("doubt_bullet", x, y)
            -- Bullets se mueven hacia el centro
            local dx = Game.battle.arena.center_x - x
            local dy = Game.battle.arena.center_y - y
            local dist = math.sqrt(dx*dx + dy*dy)
            bullet.physics.speed_x = (dx/dist) * 2
            bullet.physics.speed_y = (dy/dist) * 2
        end, 20) -- 20 bullets en total
    end)
end

return ExistentialDread