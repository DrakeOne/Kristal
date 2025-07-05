local Philosophy, super = Class(Wave)

function Philosophy:init()
    super.init(self)
    self.time = 10 -- Un poco más largo para más diversión
    
    -- Preguntas existenciales que ralentizan al jugador
    self.questions = {
        "Why?",
        "What's the point?",
        "Is this real?",
        "Who am I?",
        "Does it matter?",
        "Am I happy?",
        "What is love?",
        "Why exist?",
        "Is this canon?",
        "Are we NPCs?"
    }
    
    -- Efectos de ralentización
    self.slowdown_active = false
    self.original_soul_speed = nil
end

function Philosophy:onStart()
    -- Diálogo de Bob
    local bob = Game.battle:getEnemyBattler("bob")
    if bob then
        bob.dialogue_override = "Let's get philosophical!"
    end
    
    -- Guardar velocidad original del alma
    self.original_soul_speed = Game.battle.soul.speed
    
    -- FASE 1: Preguntas flotantes (0-4 segundos)
    self.timer:every(0.8, function()
        local question = self.questions[math.random(1, #self.questions)]
        local arena = Game.battle.arena
        
        -- Spawn desde diferentes lados
        local side = math.random(1, 4)
        local x, y
        
        if side == 1 then -- Arriba
            x = math.random(arena.left + 30, arena.right - 30)
            y = arena.top - 20
        elseif side == 2 then -- Derecha
            x = arena.right + 20
            y = math.random(arena.top + 30, arena.bottom - 30)
        elseif side == 3 then -- Abajo
            x = math.random(arena.left + 30, arena.right - 30)
            y = arena.bottom + 20
        else -- Izquierda
            x = arena.left - 20
            y = math.random(arena.top + 30, arena.bottom - 30)
        end
        
        local bullet = self:spawnBullet("text_bubble", x, y)
        bullet.text = question
        bullet.slowdown = true -- Nueva propiedad para ralentizar
        
        -- Hacer que se mueva hacia el centro con algo de aleatoriedad
        local center_x = arena.x + arena.width / 2
        local center_y = arena.y + arena.height / 2
        local angle = math.atan2(center_y - y, center_x - x)
        angle = angle + (math.random() - 0.5) * 0.5 -- Añadir variación
        
        bullet.physics.speed_x = math.cos(angle) * 2
        bullet.physics.speed_y = math.sin(angle) * 2
    end, 5) -- Solo por 4 segundos
    
    -- FASE 2: Espiral de dudas (4-7 segundos)
    self.timer:after(4, function()
        if bob then
            bob.dialogue_override = "THINK ABOUT YOUR EXISTENCE!"
        end
        
        -- Crear espiral de preguntas
        local arena = Game.battle.arena
        local center_x = arena.x + arena.width / 2
        local center_y = arena.y + arena.height / 2
        local radius = 120
        local num_bullets = 16
        
        for i = 1, num_bullets do
            self.timer:after(i * 0.1, function()
                local angle = (i / num_bullets) * math.pi * 4 -- 2 vueltas completas
                local r = radius * (1 - i / num_bullets) -- Radio decreciente
                
                local x = center_x + math.cos(angle) * r
                local y = center_y + math.sin(angle) * r
                
                local bullet = self:spawnBullet("text_bubble", x, y)
                bullet.text = "?"
                bullet.spiral = true
                bullet.angle = angle
                bullet.radius = r
                bullet.center_x = center_x
                bullet.center_y = center_y
                bullet.rotation_speed = 2
            end)
        end
    end)
    
    -- FASE 3: Lluvia de pensamientos pesados (7-10 segundos)
    self.timer:after(7, function()
        if bob then
            bob.dialogue_override = "The weight of existence!"
        end
        
        -- Activar ralentización global
        self.slowdown_active = true
        Game.battle.soul.speed = self.original_soul_speed * 0.6
        
        -- Lluvia de pensamientos pesados
        self.timer:every(0.3, function()
            local arena = Game.battle.arena
            local x = math.random(arena.left + 20, arena.right - 20)
            
            local bullet = self:spawnBullet("text_bubble", x, arena.top - 20)
            bullet.text = "HEAVY"
            bullet.physics.speed_y = 4
            bullet.physics.gravity = 0.2 -- Caen con gravedad
            bullet.heavy = true
        end, 10) -- Por 3 segundos
    end)
end

function Philosophy:onEnd()
    -- Restaurar velocidad del alma
    if self.original_soul_speed then
        Game.battle.soul.speed = self.original_soul_speed
    end
end

function Philosophy:update()
    super.update(self)
    
    -- Efecto de ralentización cuando las burbujas tocan el alma
    if self.slowdown_active then
        -- Efecto visual de "pensamiento pesado"
        if math.random() < 0.1 then
            local soul = Game.battle.soul
            local x = soul.x + math.random(-10, 10)
            local y = soul.y - 10
            
            -- Crear efecto de "peso"
            local effect = Text("...", x, y, {font = "main", size = 12})
            effect.alpha = 0.5
            effect.layer = soul.layer + 1
            Game.battle:addChild(effect)
            
            -- Animar el efecto
            Game.battle.timer:tween(1, effect, {y = y - 20, alpha = 0}, "out-quad", function()
                effect:remove()
            end)
        end
    end
end

return Philosophy