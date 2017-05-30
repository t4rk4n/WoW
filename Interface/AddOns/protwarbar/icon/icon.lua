local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	return
end

function PWBIcon:OnInitialize()
	self.db = Protwarbar.db.profile.PWBIcon

	self.iconList = {}
	self.activeIcons = {}
	self.activeRageIcons = {}
	self.activeDebuffIcons = {}

	self.iconFrames = {}
	self.iconCooldown = {}
	self.cdTable = {}

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_VISIBILITY")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")
end

function PWBIcon:OnEnable()
	PWBIcon:PWB_UPDATE_HANDLERS()
end

function PWBIcon:PWB_UPDATE_HANDLERS()
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("ACTIONBAR_UPDATE_USABLE")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
	end
end

function PWBIcon:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBIcon
	self:RefreshConfig()
	PWBIcon:UpdateSettings()
end

function PWBIcon:PWB_UPDATE_VISIBILITY()
	self:UpdateVisiblity()
end

function PWBIcon:PWB_ABILITIES_LOADED(event, abilities)
	Protwarbar:GetActiveTalents()

	for id, ability in pairs(abilities) do
		if ability.icon == true then
			self:AddIcon(ability, id)
		end
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBIcon", PWBIcon:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBIcon", L["Icons"], "Protwarbar");
end

function PWBIcon:PWB_REFRESH_CONFIG()
	self:RefreshConfig()
end

function PWBIcon:SPELL_UPDATE_COOLDOWN()
	PWBIcon:Update()
end

function PWBIcon:ACTIONBAR_UPDATE_USABLE()
	PWBIcon:UpdateRage()
end

function PWBIcon:PLAYER_TARGET_CHANGED()
	PWBIcon:UpdateDebufIcons()
end

function PWBIcon:UNIT_AURA(eventName, unit)
	if (unit == "target") then
		PWBIcon:UpdateDebufIcons()
	end
end

function PWBIcon:RefreshConfig()
	Protwarbar:GetActiveTalents()

	-- reset active icons and cd's
	self.activeIcons = {}
	self.activeRageIcons = {}
	self.activeDebuffIcons = {}

	self.cdTable = {}

	for id, ability in pairs(self.iconList) do
		PWBIcon:AddOrCreate(id)

		self.iconList[id] = PWBIcon:UpdateMetaData(ability, id)
		PWBIcon:UpdateIconStyling(id)
		PWBIcon:UpdateIconVisiblity(id)
	end

	PWBIcon:UpdateRage(UnitPower("player"))
end

function PWBIcon:AddIcon(ability, id)
	ability = PWBIcon:UpdateMetaData(ability, id)

	table.insert(self.iconList, id, ability)

	PWBIcon:AddOrCreate(id)

	self.iconFrames[id] = PWBIcon:createIcon(ability, id)
	self.iconCooldown[id] = CreateFrame("Cooldown", nil ,self.iconFrames[id].frame, "CooldownFrameTemplate")
	self.iconCooldown[id]:SetAllPoints(self.iconFrames[id].frame)

	PWBIcon:UpdateIconStyling(id)
	PWBIcon:UpdateIconVisiblity(id)
end

-- Store meta info in the table, so we can directly lookit up later on
function PWBIcon:UpdateMetaData(ability, id)
	ability.name = GetSpellInfo(id)

	-- set default meta
	ability.hideOnCD = Protwarbar.db.profile.default.appearence.hideOnCD
	ability.lowRageAlpha = Protwarbar.db.profile.default.appearence.lowRageAlpha

	-- check if defaults need to be changed
	if self.db.icons[id] ~= nil then
		if self.db.icons[id].useDefaults ~= nil then
			if self.db.icons[id].useDefaults == false then
				ability.hideOnCD = self.db.icons[id].hideOnCD or Protwarbar.db.profile.default.appearence.hideOnCD
				ability.lowRageAlpha = self.db.icons[id].lowRageAlpha or Protwarbar.db.profile.default.appearence.lowRageAlpha
			end
		end
	end

	return ability
end


function PWBIcon:AddOrCreate(id)
	if self.db.icons[id] == nil then
		PWBIcon:InitNewIcon(id)
	end

	-- if icon is enabled
	if self.db.icons[id].enabled then
		-- if icon does not depend on a talent selection
		if self.iconList[id].talent == nil then
			PWBIcon:AddActiveIcon(id)
		else
			-- if icon does depend on talent selection
			if Protwarbar.talents[self.iconList[id].talent] then
				PWBIcon:AddActiveIcon(id)
			end
		end
	end
end

function PWBIcon:AddActiveIcon(id)
	if self.iconList[id].rage == true then
		table.insert(self.activeRageIcons, id)
	end

	if self.iconList[id].debuff == nil then
		table.insert(self.activeIcons, id)
		table.insert(self.cdTable, id, {0, 0})
	else
		table.insert(self.activeDebuffIcons, id)
	end

end

function PWBIcon:InitNewIcon(id)
	self.db.icons[id] = {}
	self.db.icons[id].x = self.db.startx
	self.db.icons[id].y = self.db.starty
	self.db.icons[id].useDefaults = true

	if self.iconList[id].enabled == true then
		self.db.icons[id].enabled = true
	else
		self.db.icons[id].enabled = false
	end
end

function PWBIcon:Update()
	for index, id in pairs(self.activeIcons) do
		PWBIcon:UpdateCooldown(id, self.iconFrames[id], self.iconCooldown[id], self.cdTable[id])
	end
end

function PWBIcon:UpdateCooldown(id, frame, cooldown, cdtable)
	local start, duration, enabled = GetSpellCooldown(id);

	if cdtable[1] ~= start or cdtable[2] ~= duration then
		cdtable[1] = start
		cdtable[2] = duration

		if self.iconList[id].hideOnCD then
			if duration > 1.5 then
				frame:TextureAlpha(0)
			else
				frame:TextureAlpha(1)
			end
		else
			CooldownFrame_Set(cooldown, start, duration, 1)
		end
	end
end

function PWBIcon:UpdateRage(rage)
	local isUsable, noRage
	for index, id in pairs(self.activeRageIcons) do
		isUsable, noRage = IsUsableSpell(id)

		if isUsable then
			self.iconFrames[id]:TextureAlpha(1)
		else
			self.iconFrames[id]:TextureAlpha(self.iconList[id].lowRageAlpha)
		end
	end
end

function PWBIcon:UpdateDebufIcons()
	for index, id in pairs(self.activeDebuffIcons) do
		local n,_,_,_,_,d,e,_,_,_,sid,_,_,val1,val2,val3 = UnitAura("target", self.iconList[id].name, false, "HARMFUL");

		if n then
			local duration = d or 0
			if d > 0 then
				CooldownFrame_Set(self.iconCooldown[id], e-d, d, 1)
			end
		else
			CooldownFrame_Set(self.iconCooldown[id], 1, 1, 1)
		end
	end
end
