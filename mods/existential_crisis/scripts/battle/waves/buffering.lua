local Buffering, super = Class(Wave)

function Buffering:init()
    super.init(self)
    self.time = 9
    
    -- Variables para el efecto de lag
    self.lag_active = false
    self.lag_timer = 0
    self.soul_positions = {} -- Historial de posiciones del alma
    self.max_positions = 10
    
    -- Barras de carga
    self.loading_bars = {}
end

function Buffering:onStart()
    -- Diálogo de Bob
    local bob = Game.battle:getEnemyBattler("bob")
    if bob then
        bob.dialogue_override = "Sorry, my existential crisis\nis buffering..."
    end
    
    -- FASE 1: Barras de carga normales (0-3 segundos)
    self.timer:every(0.8, function()
        local arena = Game.battle.arena
        local y = math.random(arena.top + 30, arena.bottom - 30)
        
        local bar = self:spawnBullet("loading_bar", arena.left - 100, y)
        bar.speed = 2
        bar.progress = 0
        table.insert(self.loading_bars, bar)
    end, 4) -- Solo por 3 segundos
    
    -- FASE 2: Congelamiento al 99% (3-6 segundos)
    self.timer:after(3, function()
        if bob then
            bob.dialogue_override = "Loading... 99%\n(This may take forever)"
        end
        
        -- Congelar todas las barras existentes al 99%
        for _, bar in ipairs(self.loading_bars) do
            if bar and not bar.removed then
                bar.frozen = true
                bar.progress = 0.99
                bar.freeze_timer = 0
            end
        end
        
        -- Crear círculo de barras de carga alrededor del alma
        local soul = Game.battle.soul
        local radius = 80
        
        for i = 1, 8 do
            local angle = (i - 1) * (math.pi * 2 / 8)
            local x = soul.x + math.cos(angle) * radius
            local y = soul.y + math.sin(angle) * radius
            
            local bar = self:spawnBullet("loading_bar", x, y)
            bar.rotating = true
            bar.center_x = soul.x
            bar.center_y = soul.y
            bar.angle = angle
            bar.radius = radius
            bar.progress = 0.99
            bar.frozen = true
            bar.rotation_speed = 1
            table.insert(self.loading_bars, bar)
        end
    end)
    
    -- FASE 3: Efecto de lag (6-9 segundos)
    self.timer:after(6, function()
        if bob then
            bob.dialogue_override = "Connection lost...\nExperiencing existential lag"
        end
        
        -- Activar efecto de lag
        self.lag_active = true
        
        -- Hacer que las barras se muevan erráticamente
        for _, bar in ipairs(self.loading_bars) do
            if bar and not bar.removed then
                bar.lag_mode = true
                bar.glitch_timer = 0
            end
        end
        
        -- Spawn de barras "corruptas" que se teletransportan
        self.timer:every(0.5, function()
            local arena = Game.battle.arena
            local x = math.random(arena.left + 20, arena.right - 20)
            local y = math.random(arena.top + 20, arena.bottom - 20)
            
            local bar = self:spawnBullet("loading_bar", x, y)
            bar.corrupted = true
            bar.teleport_timer = 0
            bar.progress = math.random()
            table.insert(self.loading_bars, bar)
        end, 6) -- Por 3 segundos
    end)
end

function Buffering:update()
    super.update(self)
    
    -- Efecto de lag en el alma
    if self.lag_active then
        local soul = Game.battle.soul
        
        -- Guardar posiciones del alma
        table.insert(self.soul_positions, {x = soul.x, y = soul.y})
        if #self.soul_positions > self.max_positions then
            table.remove(self.soul_positions, 1)
        end
        
        -- Cada cierto tiempo, "lagear" el alma
        self.lag_timer = self.lag_timer + DT
        if self.lag_timer > 0.5 then
            self.lag_timer = 0
            
            -- Teletransportar el alma a una posición anterior
            if #self.soul_positions > 5 then
                local old_pos = self.soul_positions[#self.soul_positions - 5]
                
                -- Efecto visual de lag
                local afterimage = Sprite(soul.texture, soul.x, soul.y)
                afterimage:setOrigin(0.5, 0.5)
                afterimage.alpha = 0.5
                afterimage.color = {0.5, 0.5, 1}
                afterimage.layer = soul.layer - 1
                Game.battle:addChild(afterimage)
                
                -- Desvanecer la imagen residual
                Game.battle.timer:tween(0.3, afterimage, {alpha = 0}, "linear", function()
                    afterimage:remove()
                end)
                
                -- Mover el alma
                soul.x = old_pos.x
                soul.y = old_pos.y
            end
        end
    end
    
    -- Limpiar barras removidas
    for i = #self.loading_bars, 1, -1 do
        if self.loading_bars[i].removed then
            table.remove(self.loading_bars, i)
        end
    end
end

function Buffering:onEnd()
    -- Limpiar efectos de lag
    self.lag_active = false
    self.soul_positions = {}
end

return Buffering