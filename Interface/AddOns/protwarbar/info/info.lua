local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

function PWBInfo:OnInitialize()
	self.db = Protwarbar.db.profile.PWBInfo
	self.resolve_name = GetSpellInfo(158298)
	self.barrier = 0
	self.versatility_bonus_factor = 0

	PWBInfo:BuildGui()

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_VISIBILITY")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")
end

function PWBInfo:OnEnable()
	PWBInfo:UpdateStats()
	PWBInfo:PWB_UPDATE_HANDLERS()
end

function PWBInfo:PWB_UPDATE_HANDLERS()
	self:CancelAllTimers()

	self:UnregisterEvent("UNIT_POWER_FREQUENT")
	self:UnregisterEvent("UNIT_ATTACK_POWER")
	self:UnregisterEvent("UNIT_STATS")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterEvent("UNIT_POWER_FREQUENT")
		self:RegisterEvent("UNIT_ATTACK_POWER")
		self:RegisterEvent("UNIT_STATS")
		self:ScheduleRepeatingTimer("SlowTimer", 0.5)
	end
end

function PWBInfo:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBInfo
	PWBInfo:UpdateSettings()
end

function PWBInfo:PWB_ABILITIES_LOADED()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBInfo", PWBInfo:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBInfo", L["Information"], "Protwarbar");
end

function PWBInfo:PWB_REFRESH_CONFIG()
	self:RefreshConfig()
end

function PWBInfo:PWB_UPDATE_VISIBILITY()
	self:UpdateVisiblity()
end

function PWBInfo:UNIT_POWER_FREQUENT(eventName, unit, powerType)
	if (unit == "player") then
		PWBInfo:Update(UnitPower("player"))
	end
end

function PWBInfo:UNIT_ATTACK_POWER(event, unit)
	if (unit == "player") then
		PWBInfo:UpdateStats()
	end
end

function PWBInfo:UNIT_STATS(event, unit)
	if (unit == "player") then
		PWBInfo:UpdateStats()
	end
end

function PWBInfo:SlowTimer()
	PWBInfo:Update(UnitPower("player"))
end

function PWBInfo:UpdateStats()
	local CR_VERSATILITY_DAMAGE_DONE = 29
	local CR_VERSATILITY_DAMAGE_TAKEN = 31

	local baseAP, posBuffAP, negBuffAP = UnitAttackPower("player")
	local attackPower = baseAP + posBuffAP + negBuffAP
	--local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
	local versatility_bonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
	--local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN)
	--Protwarbar:Print(versatility .. " " .. versatility_bonus .. " " .. versatilityDamageTakenReduction)

	self.barrier = max(attackPower, 0) * 1.125
	self.versatility_bonus_factor = 1 + versatility_bonus / 100
	PWBInfo:Update(UnitPower("player"))
end

function PWBInfo:RefreshConfig()
	self:UpdateStyling()
	self:UpdateVisiblity()
end

function PWBInfo:Update(power)
	local shieldBarrierText = ""
	local resolveHealingText = ""
	local resolveDamageText = ""

	local n,_,_,_,_,_,_,_,_,_,id,_,_, val1, healing_bonus, damage_taken = UnitAura("player", self.resolve_name, nil, "HELPFUL");

	if n == nil then
		healing_bonus = 0
		damage_taken = 0
	end

	if power > 19 and self.db.shieldBarrier.enabled then
		-- barrier = (AP * 1.125) * min(rage, 60) / 20 * healing_bonus_percentage * versatility
		shieldBarrierText = string.format("%.1fK", self.barrier * (min(power , 60) / 20) * (1 + (healing_bonus / 100)) * self.versatility_bonus_factor / 1000 )
		-- Protwarbar:Print("bar: " .. self.barrier .. " pf: " .. (min(power , 60) / 20) .. " rheal: " .. (1 + (healing_bonus / 100))  .. " vers: " .. self.versatility_bonus_factor)
	end

	if damage_taken > 0 and self.db.resolveDamage.enabled then
		resolveDamageText = string.format("%.1fK", damage_taken / 1000)
	end

	if healing_bonus > 0 and self.db.resolveHealing.enabled then
		resolveHealingText = healing_bonus .. "%"
	end
	
	ResolveHealingText:SetText(resolveHealingText)
	ResolveDamageText:SetText(resolveDamageText)
	ShieldText:SetText(shieldBarrierText)
end
