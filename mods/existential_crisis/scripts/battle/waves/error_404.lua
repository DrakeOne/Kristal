local Error404, super = Class(Wave)

function Error404:init()
    super.init(self)
    self.time = 8
    
    -- Mensajes de error
    self.errors = {
        "404",
        "ERROR",
        "NULL",
        "FATAL",
        "CRASH",
        "BSOD",
        "!!!",
        "0x0",
        "FAIL"
    }
    
    -- Variables para efectos de glitch
    self.glitch_timer = 0
    self.arena_glitched = false
    self.original_arena_color = nil
end

function Error404:onStart()
    -- Diálogo de Bob
    local bob = Game.battle:getEnemyBattler("bob")
    if bob then
        bob.dialogue_override = "ERROR: REASON_TO_LIVE.exe\nhas stopped working"
    end
    
    -- Guardar color original de la arena
    local arena = Game.battle.arena
    self.original_arena_color = arena.color
    
    -- FASE 1: Errores rebotando (0-3 segundos)
    self.timer:every(0.5, function()
        local error_text = self.errors[math.random(1, #self.errors)]
        local x = math.random(arena.left + 20, arena.right - 20)
        
        local bullet = self:spawnBullet("error_bullet", x, arena.top - 20)
        bullet.text = error_text
        bullet.bounce = true
        bullet.velocity_x = math.random(-3, 3)
        bullet.velocity_y = math.random(2, 4)
    end, 6) -- Por 3 segundos
    
    -- FASE 2: Glitch de la arena (3-5 segundos)
    self.timer:after(3, function()
        if bob then
            bob.dialogue_override = "SYSTEM FAILURE IMMINENT"
        end
        
        self.arena_glitched = true
        
        -- Crear paredes de error que aparecen y desaparecen
        for i = 1, 3 do
            self.timer:after(i * 0.3, function()
                -- Pared vertical de errores
                local x = arena.left + (arena.width / 4) * i
                
                for y = arena.top, arena.bottom, 25 do
                    local bullet = self:spawnBullet("error_bullet", x, y)
                    bullet.text = "!"
                    bullet.static = true
                    bullet.flicker = true
                    bullet.remove_timer = 2
                end
                
                -- Efecto de sonido y vibración
                if love.system.getOS() == "Android" and love.system.vibrate then
                    love.system.vibrate(0.1)
                end
            end)
        end
    end)
    
    -- FASE 3: Blue Screen of Death (5-8 segundos)
    self.timer:after(5, function()
        if bob then
            bob.dialogue_override = ":( Your reality ran into a problem"
        end
        
        -- Crear efecto BSOD
        self:createBSOD()
        
        -- Lluvia de errores desde todas las direcciones
        self.timer:every(0.2, function()
            for i = 1, 2 do
                local side = math.random(1, 4)
                local x, y, vx, vy
                
                if side == 1 then -- Arriba
                    x = math.random(arena.left, arena.right)
                    y = arena.top - 20
                    vx = 0
                    vy = 3
                elseif side == 2 then -- Derecha
                    x = arena.right + 20
                    y = math.random(arena.top, arena.bottom)
                    vx = -3
                    vy = 0
                elseif side == 3 then -- Abajo
                    x = math.random(arena.left, arena.right)
                    y = arena.bottom + 20
                    vx = 0
                    vy = -3
                else -- Izquierda
                    x = arena.left - 20
                    y = math.random(arena.top, arena.bottom)
                    vx = 3
                    vy = 0
                end
                
                local bullet = self:spawnBullet("error_bullet", x, y)
                bullet.text = self.errors[math.random(1, #self.errors)]
                bullet.velocity_x = vx
                bullet.velocity_y = vy
                bullet.bsod_mode = true
            end
        end, 15) -- Por 3 segundos
    end)
end

function Error404:createBSOD()
    local arena = Game.battle.arena
    
    -- Crear fondo azul semitransparente
    local bsod = Rectangle(arena.x, arena.y, arena.width, arena.height)
    bsod.color = {0, 0.3, 0.8}
    bsod.alpha = 0
    bsod.layer = arena.layer + 1
    Game.battle:addChild(bsod)
    
    -- Fade in del BSOD
    Game.battle.timer:tween(0.5, bsod, {alpha = 0.7}, "out-quad")
    
    -- Texto de error
    local error_text = Text(":(", arena.x + arena.width/2 - 20, arena.y + 20, {font = "main", size = 32})
    error_text.color = {1, 1, 1}
    error_text.layer = bsod.layer + 1
    error_text.alpha = 0
    Game.battle:addChild(error_text)
    
    Game.battle.timer:tween(0.5, error_text, {alpha = 1}, "out-quad")
    
    -- Mensaje de error
    local message = Text("Your reality ran into a problem\nand needs to restart.", 
                        arena.x + 10, arena.y + 60, {font = "main", size = 12})
    message.color = {1, 1, 1}
    message.layer = bsod.layer + 1
    message.alpha = 0
    Game.battle:addChild(message)
    
    Game.battle.timer:tween(0.5, message, {alpha = 1}, "out-quad")
    
    -- Remover después de 2 segundos
    Game.battle.timer:after(2, function()
        Game.battle.timer:tween(0.3, bsod, {alpha = 0}, "in-quad", function()
            bsod:remove()
        end)
        Game.battle.timer:tween(0.3, error_text, {alpha = 0}, "in-quad", function()
            error_text:remove()
        end)
        Game.battle.timer:tween(0.3, message, {alpha = 0}, "in-quad", function()
            message:remove()
        end)
    end)
end

function Error404:update()
    super.update(self)
    
    -- Efecto de glitch en la arena
    if self.arena_glitched then
        self.glitch_timer = self.glitch_timer + DT
        
        local arena = Game.battle.arena
        
        -- Cambiar color de la arena aleatoriamente
        if math.random() < 0.1 then
            arena.color = {math.random(), math.random(), math.random()}
        end
        
        -- A veces restaurar el color original
        if math.random() < 0.05 then
            arena.color = self.original_arena_color
        end
        
        -- Hacer temblar la arena
        if math.random() < 0.2 then
            arena.x = arena.x + math.random(-2, 2)
            arena.y = arena.y + math.random(-2, 2)
        end
    end
end

function Error404:onEnd()
    -- Restaurar la arena
    local arena = Game.battle.arena
    if self.original_arena_color then
        arena.color = self.original_arena_color
    end
    arena.x = (SCREEN_WIDTH - arena.width) / 2
    arena.y = (SCREEN_HEIGHT - arena.height) / 2 + 10
end

return Error404