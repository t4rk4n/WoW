local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	return
end

function PWBAuraBar:OnInitialize()
	self.db = Protwarbar.db.profile.PWBAuraBar

	self.auraBars = {}
	self.auraCount = 0
	self.auraList = {}
	self.enabledAuraList = {}
	self.cdTable = {}

	PWBAuraBar:BuildGui()

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_VISIBILITY")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")
end

function PWBAuraBar:OnEnable()
	PWBAuraBar:PWB_UPDATE_HANDLERS()
end

function PWBAuraBar:PWB_UPDATE_HANDLERS()
	self:CancelAllTimers()
	self:UnregisterEvent("UNIT_AURA")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterEvent("UNIT_AURA")
		self:ScheduleRepeatingTimer("QuickTimer", 0.1)
	end
end

function PWBAuraBar:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBAuraBar
	PWBAuraBar:UpdateSettings()
end

function PWBAuraBar:PWB_ABILITIES_LOADED(event, abilities)

	for id, ability in pairs(abilities) do
		if ability.aura == true then
			self:AddAura(ability, id)
		end
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBAuraBar", PWBAuraBar:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBAuraBar", L["Aurabar"], "Protwarbar");
end

function PWBAuraBar:PWB_REFRESH_CONFIG()
	self:RefreshConfig()
end

function PWBAuraBar:PWB_UPDATE_VISIBILITY()
	self:UpdateVisiblity()
end

function PWBAuraBar:UNIT_AURA(eventName, unit)
	if (unit == "player") then
		PWBAuraBar:UpdateAuraList()
		PWBAuraBar:Update()
	end
end

function PWBAuraBar:RefreshConfig()
	self.enabledAuraList = {}
	self.cdTable = {}

	for id, ability in pairs(self.auraList) do

		if self.db.auras[id] == nil then
			PWBAuraBar:InitNewAura(id)
		else
			if self.db.auras[id].enabled then
				PWBAuraBar:AddActiveAura(id)
			end
		end
	end

	PWBAuraBar:UpdateStyling()
	PWBAuraBar:UpdateVisiblity()
end

function PWBAuraBar:AddAura(ability, id)
	self.auraCount = self.auraCount + 1
	ability.name = GetSpellInfo(id)
	table.insert(self.auraList, id, ability)

	if self.db.auras[id] == nil then
		PWBAuraBar:InitNewAura(id)
	end

	if self.db.auras[id].enabled then
		PWBAuraBar:AddActiveAura(id)
	end
end

function PWBAuraBar:AddActiveAura(id)
	table.insert(self.enabledAuraList, id)
	table.insert(self.cdTable, id, {0, 0})
end

function PWBAuraBar:InitNewAura(id)
	self.db.auras[id] = {}
	self.db.auras[id].color = {1, 1, 1, 1}
	self.db.auras[id].enabled = false
end

function PWBAuraBar:QuickTimer()
	PWBAuraBar:Update()
end

-- TODO: only itterate over active auras
function PWBAuraBar:Update()
	local barVal = 0
	local barcount = 1
	local time = 0
	local now = GetTime()
	local color = {0, 0, 0 ,0}

	for id, abilityId in pairs(self.enabledAuraList) do
		if barcount <= self.db.barcount then
			if self.cdTable[abilityId][2] > now then
				time = self.cdTable[abilityId][2] - now
				self.auraBars[barcount]:SetValue(time / self.cdTable[abilityId][1] * 100)
				self.auraBars[barcount]:SetStatusBarColor(self.db.auras[abilityId].color[1], self.db.auras[abilityId].color[2], self.db.auras[abilityId].color[3], self.db.auras[abilityId].color[4])
				barcount = barcount + 1
			end
		end
	end

	-- set the remaining bars to 0
	for i = barcount, self.db.barcount do
		self.auraBars[i]:SetValue(0)
	end

end

function PWBAuraBar:UpdateAuraList()
	local e, d
	for id, abilityId in pairs(self.enabledAuraList) do
		e, d = PWBAuraBar:CheckShield(self.auraList[abilityId])

		self.cdTable[abilityId][1] = d
		self.cdTable[abilityId][2] = e
	end
end

function PWBAuraBar:CheckShield(ability)
	local n,_,_,_,_,d,e,_,_,_,id,_,_,val1,val2,val3 = UnitAura("player", ability.name, nil, "HELPFUL");

	if n then

		-- workaround, check if this is not the T19 2P Shield Block buff
		if id == 212236 then
			-- this is the wrong shield block, query all aruras to find the right one
			for i = 1, 40 do
				local n,_,_,_,_,d,e,_,_,_,id,_,_,val1,val2,val3 = UnitAura("player", i , "HELPFUL");
				-- Protwarbar:Print(GetSpellInfo(id))
				if id == 132404 then
					return  e, d
				end
			end

			-- we did not find it
			return 0, 0
		end


		if d > 0 then
			return  e, d
		end

	end

	return 0, 0
end
