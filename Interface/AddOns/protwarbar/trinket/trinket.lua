local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	return
end

function PWBTrinket:OnInitialize()
	self.db = Protwarbar.db.profile.PWBTrinket

	self.activeTrinkets = {}
	self.trinketFrames = {}
	self.trinketCooldown = {}
	self.cdTable = {}

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_VISIBILITY")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")

	self.trinketFrames[1] = self:createIcon(1)
	self.trinketFrames[2] = self:createIcon(2)

	self.trinketCooldown[1] = CreateFrame("Cooldown", nil ,self.trinketFrames[1].frame, "CooldownFrameTemplate")
	self.trinketCooldown[1]:SetAllPoints(self.trinketFrames[1].frame)

	self.trinketCooldown[2] = CreateFrame("Cooldown", nil ,self.trinketFrames[2].frame, "CooldownFrameTemplate")
	self.trinketCooldown[2]:SetAllPoints(self.trinketFrames[2].frame)
end

function PWBTrinket:OnEnable()
	self:UpdateActiveTrinkets()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBTrinket", PWBTrinket:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBTrinket", L["Trinkets"], "Protwarbar");

	PWBTrinket:PWB_UPDATE_HANDLERS()
end

function PWBTrinket:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBTrinket
	self:RefreshConfig()
	PWBTrinket:UpdateSettings()
end

function PWBTrinket:PWB_UPDATE_HANDLERS()
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	end
end

function PWBTrinket:PWB_UPDATE_VISIBILITY()
	self:UpdateVisiblity()
end

function PWBTrinket:PWB_ABILITIES_LOADED(event, abilities)
end

function PWBTrinket:PWB_REFRESH_CONFIG()
	self:RefreshConfig()
end

function PWBTrinket:SPELL_UPDATE_COOLDOWN()
	PWBTrinket:Update()
end

function PWBTrinket:UNIT_INVENTORY_CHANGED(eventName, unit)
	if (unit == "player") then
		self:UpdateActiveTrinkets()
		self:Update()
	end
end

function PWBTrinket:UpdateActiveTrinkets()
	local trinkets = {}
	trinkets[1] = GetInventoryItemID("player", GetInventorySlotInfo("Trinket0Slot"))
	trinkets[2] = GetInventoryItemID("player", GetInventorySlotInfo("Trinket1Slot"))

	-- reset current tracking
	self.activeTrinkets = {}
	self.cdTable = {}
	self.trinketCooldown[1]:SetCooldown(0,0)
	self.trinketCooldown[2]:SetCooldown(0,0)

	for index, trinketId in pairs(trinkets) do
		if trinketId ~= nil then
			if self.db.trinkets[trinketId] == nil then -- Add a new trinket if it's not yet in the list
				self.db.trinkets[trinketId] = {}
				self.db.trinkets[trinketId].enabled = true
			end

			if self.db.trinkets[trinketId].enabled then
				table.insert(self.activeTrinkets, index, trinketId)
				table.insert(self.cdTable, trinketId, {0, 0})
			end
		end
	end

	-- update the options to include the new trinkets
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBTrinket", PWBTrinket:CreateOptions());

	self:UpdateStyling()
	self:UpdateVisiblity()
	self:Update()
end

function PWBTrinket:RefreshConfig()
	self:UpdateActiveTrinkets()
end

function PWBTrinket:Update()
	for index, id in pairs(self.activeTrinkets) do
		self:UpdateCooldown(id, self.trinketFrames[index].frame, self.trinketCooldown[index], self.cdTable[id])
	end
end

function PWBTrinket:UpdateCooldown(id, frame, cooldown, cdtable)
	local start, duration, enabled = GetItemCooldown(id);

	if cdtable[1] ~= start or cdtable[2] ~= duration then
		cdtable[1] = start
		cdtable[2] = duration

		CooldownFrame_Set(cooldown, start, duration, 1)
	end
end
