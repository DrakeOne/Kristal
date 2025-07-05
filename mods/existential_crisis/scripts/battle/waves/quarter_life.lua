local QuarterLife, super = Class(Wave)

function QuarterLife:init()
    super.init(self)
    self.time = 10
    
    -- Edades y responsabilidades
    self.ages = {25, 30, 35, 40}
    self.responsibilities = {
        "BILLS",
        "TAXES",
        "RENT",
        "DEBT",
        "WORK",
        "ADULT",
        "TIRED",
        "STRESS"
    }
    
    -- Variables para el reloj
    self.clock_active = false
    self.time_acceleration = 1
    self.age_bullets = {}
end

function QuarterLife:onStart()
    -- Diálogo de Bob
    local bob = Game.battle:getEnemyBattler("bob")
    if bob then
        bob.dialogue_override = "Time is running out!\nYou're getting OLDER!"
    end
    
    local arena = Game.battle.arena
    
    -- FASE 1: Números de edad persiguiendo (0-4 segundos)
    self.timer:every(1, function()
        local age = self.ages[math.random(1, #self.ages)]
        local side = math.random(1, 4)
        local x, y
        
        if side == 1 then -- Arriba
            x = math.random(arena.left, arena.right)
            y = arena.top - 20
        elseif side == 2 then -- Derecha
            x = arena.right + 20
            y = math.random(arena.top, arena.bottom)
        elseif side == 3 then -- Abajo
            x = math.random(arena.left, arena.right)
            y = arena.bottom + 20
        else -- Izquierda
            x = arena.left - 20
            y = math.random(arena.top, arena.bottom)
        end
        
        local bullet = self:spawnBullet("age_number", x, y)
        bullet.number = age
        bullet.speed = 1.5
        bullet.homing = true
        table.insert(self.age_bullets, bullet)
    end, 4) -- Por 4 segundos
    
    -- FASE 2: Lluvia de responsabilidades (4-7 segundos)
    self.timer:after(4, function()
        if bob then
            bob.dialogue_override = "Welcome to adulthood!\nEnjoy your responsibilities!"
        end
        
        -- Crear reloj visual
        self:createClock()
        self.clock_active = true
        
        -- Lluvia de responsabilidades
        self.timer:every(0.4, function()
            local x = math.random(arena.left + 20, arena.right - 20)
            local responsibility = self.responsibilities[math.random(1, #self.responsibilities)]
            
            local bullet = self:spawnBullet("text_bubble", x, arena.top - 20)
            bullet.text = responsibility
            bullet.physics.speed_y = 3
            bullet.physics.gravity = 0.1
            bullet.heavy = true
            bullet.bubble_color = {0.3, 0.3, 0.3} -- Gris oscuro
            
            -- Efecto de peso
            if math.random() < 0.3 then
                bullet.scale = 1.2
                bullet.damage = 6
            end
        end, 8) -- Por 3 segundos
    end)
    
    -- FASE 3: Aceleración del tiempo (7-10 segundos)
    self.timer:after(7, function()
        if bob then
            bob.dialogue_override = "TIME ACCELERATING!\nLIFE IS PASSING YOU BY!"
        end
        
        -- Acelerar el tiempo
        self.time_acceleration = 3
        
        -- Números de edad más agresivos
        self.timer:every(0.3, function()
            -- Spawn desde el centro en espiral
            local center_x = arena.x + arena.width / 2
            local center_y = arena.y + arena.height / 2
            local angle = math.random() * math.pi * 2
            local radius = 100
            
            local x = center_x + math.cos(angle) * radius
            local y = center_y + math.sin(angle) * radius
            
            local bullet = self:spawnBullet("age_number", x, y)
            bullet.number = math.random(25, 65) -- Rango más amplio
            bullet.speed = 3
            bullet.spiral = true
            bullet.center_x = center_x
            bullet.center_y = center_y
            bullet.angle = angle
            table.insert(self.age_bullets, bullet)
        end, 10) -- Por 3 segundos
    end)
end

function QuarterLife:createClock()
    local arena = Game.battle.arena
    local clock_x = arena.x + arena.width - 60
    local clock_y = arena.y + 20
    
    -- Fondo del reloj
    self.clock_bg = Ellipse(clock_x, clock_y, 50, 50)
    self.clock_bg.color = {0.2, 0.2, 0.2}
    self.clock_bg.layer = arena.layer + 1
    Game.battle:addChild(self.clock_bg)
    
    -- Manecillas del reloj
    self.hour_hand = Rectangle(clock_x + 25, clock_y + 25, 2, 15)
    self.hour_hand.color = {1, 1, 1}
    self.hour_hand.origin_y = 1
    self.hour_hand.layer = self.clock_bg.layer + 1
    Game.battle:addChild(self.hour_hand)
    
    self.minute_hand = Rectangle(clock_x + 25, clock_y + 25, 2, 20)
    self.minute_hand.color = {1, 1, 1}
    self.minute_hand.origin_y = 1
    self.minute_hand.layer = self.clock_bg.layer + 1
    Game.battle:addChild(self.minute_hand)
end

function QuarterLife:update()
    super.update(self)
    
    -- Actualizar reloj
    if self.clock_active and self.hour_hand and self.minute_hand then
        -- Rotar manecillas basado en la aceleración del tiempo
        self.minute_hand.rotation = self.minute_hand.rotation + DT * self.time_acceleration * 2
        self.hour_hand.rotation = self.hour_hand.rotation + DT * self.time_acceleration * 0.2
        
        -- Efectos visuales cuando el tiempo se acelera
        if self.time_acceleration > 1 then
            if math.random() < 0.1 then
                -- Crear números de edad alrededor del reloj
                local angle = math.random() * math.pi * 2
                local dist = 30
                local x = self.clock_bg.x + 25 + math.cos(angle) * dist
                local y = self.clock_bg.y + 25 + math.sin(angle) * dist
                
                local age_text = Text(tostring(math.random(25, 65)), x, y, {font = "main", size = 12})
                age_text.color = {1, 0.5, 0.5}
                age_text.physics.speed_x = math.cos(angle) * 2
                age_text.physics.speed_y = math.sin(angle) * 2
                age_text.layer = self.clock_bg.layer
                Game.battle:addChild(age_text)
                
                Game.battle.timer:tween(1, age_text, {alpha = 0}, "linear", function()
                    age_text:remove()
                end)
            end
        end
    end
    
    -- Actualizar velocidad de las balas basado en la aceleración del tiempo
    for _, bullet in ipairs(self.age_bullets) do
        if bullet and not bullet.removed then
            bullet.time_mult = self.time_acceleration
        end
    end
    
    -- Limpiar balas removidas
    for i = #self.age_bullets, 1, -1 do
        if self.age_bullets[i].removed then
            table.remove(self.age_bullets, i)
        end
    end
end

function QuarterLife:onEnd()
    -- Limpiar el reloj
    if self.clock_bg then self.clock_bg:remove() end
    if self.hour_hand then self.hour_hand:remove() end
    if self.minute_hand then self.minute_hand:remove() end
end

return QuarterLife