-- Existential Bob - El enemigo que sufre crisis existencial
local ExistentialBob, super = Class(EnemyBattler)

function ExistentialBob:init()
    super.init(self)
    
    -- Nombre del enemigo
    self.name = "Existential Bob"
    -- Actor (sprites) - necesitarás crear este actor
    self:setActor("existential_bob")
    
    -- Stats
    self.max_health = 500
    self.health = 500
    self.attack = 6
    self.defense = 2
    self.money = 120
    
    -- Mercy
    self.spare_points = 20
    
    -- Lista de waves mejorados
    self.waves = {
        "social_media_anxiety",
        "existential_dread",
        "quarter_life_crisis",
        "impostor_syndrome",
        "infinite_scroll",
        "burnout_cycle",
        "memory_leak"
    }
    
    -- Diálogos durante la batalla
    self.dialogue = {
        "...",
        "¿Qué sentido tiene todo?",
        "Nadie me entiende...",
        "¿Soy real?",
        "Todo es tan... vacío."
    }
    
    -- Check text
    self.check = "AT 6 DF 2\n* Sufre de crisis existencial.\n* Solo quiere ser comprendido."
    
    -- Texto en la parte inferior
    self.text = {
        "* Bob mira al vacío con\nojos perdidos.",
        "* Bob cuestiona su propia\nexistencia.",
        "* El aura de Bob irradia\nansiedad existencial.",
        "* Bob se pregunta si algo\nimporta realmente."
    }
    
    self.low_health_text = "* Bob parece estar al borde\nde un colapso mental."
    
    -- Registrar actos
    self:registerAct("Escuchar")
    self:registerAct("Consolar")
    self:registerAct("Filosofar", "", {"ralsei"})
    self:registerAct("Validar", "", {"susie"})
end

function ExistentialBob:onAct(battler, name)
    if name == "Escuchar" then
        self:addMercy(30)
        self.dialogue_override = "Gracias por... escuchar..."
        return {
            "* Escuchas pacientemente las\npreocupaciones de Bob.",
            "* Bob parece un poco más calmado."
        }
        
    elseif name == "Consolar" then
        self:addMercy(40)
        self.dialogue_override = "¿De verdad... importo?"
        return "* Le dices a Bob que su vida\ntiene significado.\n* Bob quiere creerlo."
        
    elseif name == "Filosofar" then
        self:addMercy(50)
        self.dialogue_override = "Tal vez... tal vez tienes razón..."
        return {
            "* Ralsei y tú discuten filosofía\nexistencial con Bob.",
            "* Bob encuentra consuelo en\nlas palabras sabias."
        }
        
    elseif name == "Validar" then
        self:addMercy(60)
        self.dialogue_override = "¡Sí! ¡Existo! ¡SOY REAL!"
        return "* Susie le grita a Bob que\ndeje de lloriquear.\n* Extrañamente, funciona."
        
    elseif name == "Standard" then
        if battler.chara.id == "kris" then
            self:addMercy(25)
            return "* Kris asiente en silencio.\n* Bob aprecia el gesto."
        elseif battler.chara.id == "ralsei" then
            self:addMercy(30)
            return "* Ralsei ofrece palabras de aliento.\n* Bob sonríe débilmente."
        elseif battler.chara.id == "susie" then
            self:addMercy(20)
            return "* Susie se encoge de hombros.\n* Bob no está seguro de cómo\ninterpretar eso."
        end
    end
    
    return super.onAct(self, battler, name)
end

function ExistentialBob:onHurt(damage, battler)
    super.onHurt(self, damage, battler)
    
    if self.health <= 0 then
        self.dialogue_override = "Al final... nada importaba..."
    elseif self.health <= self.max_health * 0.5 then
        self.dialogue_override = "¿Por qué me haces esto?"
    end
end

function ExistentialBob:onDefeat()
    self.dialogue_override = "Tal vez... la muerte sea la respuesta..."
end

function ExistentialBob:onSpare()
    self.dialogue_override = "Gracias... por darle sentido a mi vida."
end

return ExistentialBob