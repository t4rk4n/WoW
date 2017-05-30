local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	return
end

function PWBShieldbar:OnInitialize()
	self.db = Protwarbar.db.profile.PWBShieldbar

	self.shieldList = {}
	self.enabledShieldList = {}
	self.shieldTable = {}

	PWBShieldbar:BuildGui()

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_VISIBILITY")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")
end

function PWBShieldbar:OnEnable()
	self.maxHp = UnitHealthMax("player") / 1000

	PWBShieldbar:PWB_UPDATE_HANDLERS()
end

function PWBShieldbar:PWB_UPDATE_HANDLERS()
	self:CancelAllTimers()
	self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	self:UnregisterEvent("UNIT_MAXHEALTH")
	self:UnregisterMessage("PWB_COMBAT_LOG_DEST_PLAYER")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterMessage("PWB_COMBAT_LOG_DEST_PLAYER")
		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
		self:RegisterEvent("UNIT_MAXHEALTH")
		self:ScheduleRepeatingTimer("QuickTimer", 0.1)
	end
end

function PWBShieldbar:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBShieldbar
	PWBShieldbar:UpdateSettings()
end

function PWBShieldbar:UNIT_MAXHEALTH()
	self.maxHp = UnitHealthMax("player") / 1000
end

function PWBShieldbar:UNIT_HEALTH_FREQUENT()
	if self.db.healthbarEnabled then
		PWBShieldbar:Update(UnitHealth("player") / 1000)
	end
end

function PWBShieldbar:PWB_ABILITIES_LOADED(event, abilities)

	for id, ability in pairs(abilities) do
		if ability.shield == true then

			ability.name = GetSpellInfo(id)
			table.insert(self.shieldList, id, ability)

			self:AddShield(ability, id)
		end
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBShieldbar", PWBShieldbar:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBShieldbar", L["Shieldbar"], "Protwarbar");
end

function PWBShieldbar:PWB_REFRESH_CONFIG()
	PWBShieldbar:RefreshConfig()
end

function PWBShieldbar:PWB_UPDATE_VISIBILITY()
	PWBShieldbar:UpdateVisiblity()
end

function PWBShieldbar:PWB_COMBAT_LOG_DEST_PLAYER(pwbevent, event, _, eventType, _, _, _, _, _, _, destName, _, _, spellId, _, _, _, amount)
	if (eventType == "SPELL_AURA_APPLIED") then
		-- TODO can filter amount != nil
		PWBShieldbar:UpdateShields(spellId, amount)
		return
	end

	if (eventType == "SPELL_AURA_REFRESH") then
		PWBShieldbar:UpdateShields(spellId, amount)
		return
	end

	if (eventType == "SPELL_AURA_REMOVED") then
		PWBShieldbar:UpdateShields(spellId, 0)
		return
	end
end

function PWBShieldbar:RefreshConfig()
	self.enabledShieldList = {}
	self.shieldTable = {}

	for id, ability in pairs(self.shieldList) do
		PWBShieldbar:AddShield(ability, id)
	end

	ShieldBar:SetValue(0)
	ShieldBarText:SetText("")
	PWBHealthBar:SetValue(0)
	HealthBarText:SetText("")

	PWBShieldbar:UpdateStyling()
	PWBShieldbar:UpdateVisiblity()
end

function PWBShieldbar:AddShield(ability, id)
	if self.db.shields[id] == nil then
		self.db.shields[id] = {}
		self.db.shields[id].enabled = false
	end

	if self.db.shields[id].enabled then
		table.insert(self.enabledShieldList, id, id)
		table.insert(self.shieldTable, id, {0, 0})
	end
end

function PWBShieldbar:UpdateShields(id, value)
	if (self.enabledShieldList[id] ~= nil) then
		self.shieldTable[id] = {value, value}
	end
end

function PWBShieldbar:QuickTimer()
	local shieldValue = 0
	local shieldTotal = 0
	local health = UnitHealth("player") / 1000
	local i = 1
	local buff,_,_,_,_,_,_,_,_,_,spellId,_,_,_,_,_,value,c  = UnitBuff("player", i);


	-- iterate over every buff to check if we are tracking them
	while buff do
		if self.shieldTable[spellId] then
			if self.shieldTable[spellId][1] > 0 then
				shieldTotal = shieldTotal + self.shieldTable[spellId][1]
				shieldValue = shieldValue + value or 0
			end
		end

		i = i + 1
		buff,_,_,_,_,_,_,_,_,_,spellId,_,_,_,_,_,value,c  = UnitBuff("player", i);
	end

	if (shieldTotal > 0) then
		if self.db.healthbarEnabled then
			ShieldBar:SetValue((shieldValue / 1000 + health) / self.maxHp * 50)
			ShieldBarText:SetText(string.format("%.1fk", shieldValue / 1000))
		else
			ShieldBar:SetValue(shieldValue / shieldTotal * 50)
			ShieldBarText:SetText(string.format("%.1fk", shieldValue / 1000))
		end
	else
		ShieldBar:SetValue(0)
		ShieldBarText:SetText("")
	end

	if self.db.healthbarEnabled then
		HealthBarText:SetText(string.format("%.0fk/%.0fk || %.1f%%", health, self.maxHp, health / self.maxHp * 100))
		PWBShieldbar:Update(health)
	end
end

function PWBShieldbar:Update(health)
	local ratio = health / self.maxHp
	PWBHealthBar:SetValue(ratio * 50)

	ratio = ratio * 100
	if ratio >= self.db.healthlevel4 then
		PWBHealthBar:SetStatusBarColor(self.db.healthColor4[1], self.db.healthColor4[2],
		self.db.healthColor4[3], self.db.healthColor4[4])
	elseif ratio >= self.db.healthlevel3 then
		PWBHealthBar:SetStatusBarColor(self.db.healthColor3[1], self.db.healthColor3[2],
		self.db.healthColor3[3], self.db.healthColor3[4])
	elseif ratio >= self.db.healthlevel2 then
		PWBHealthBar:SetStatusBarColor(self.db.healthColor2[1], self.db.healthColor2[2],
		self.db.healthColor2[3], self.db.healthColor2[4])
	else
		PWBHealthBar:SetStatusBarColor(self.db.healthColor1[1], self.db.healthColor1[2],
		self.db.healthColor1[3], self.db.healthColor1[4])
	end
end

