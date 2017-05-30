local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	return
end

function PWBAnnounce:OnInitialize()
	self.db = Protwarbar.db.profile.PWBAnnounce

	self.announceList = {}
	self.enabledAnnounceList = {}
	self.auraGainList = {}
	self.auraLostList = {}

	self.combat = false
	self.zoneType = nil
	self.groupType = "SOLO"
	self.autoChannel = "PARTY"
	self.enabled = true

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")
end

function PWBAnnounce:OnEnable()
	PWBAnnounce:PWB_UPDATE_HANDLERS()

	PWBAnnounce:CheckZone()
	PWBAnnounce:CheckGroup()
end

function PWBAnnounce:PWB_UPDATE_HANDLERS()
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
	self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	self:UnregisterEvent("RAID_ROSTER_UPDATE")
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
		self:RegisterEvent("PARTY_MEMBERS_CHANGED")
		self:RegisterEvent("RAID_ROSTER_UPDATE")
		self:RegisterEvent("UNIT_SPELLCAST_SENT")
	end
end

function PWBAnnounce:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBAnnounce
end

function PWBAnnounce:PWB_ABILITIES_LOADED(event, abilities)
	for id, ability in pairs(abilities) do
		if ability.announce == true then
			self:AddAnnounce(ability, id)
		end
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBAnnounce", PWBAnnounce:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBAnnounce", L["Announce"], "Protwarbar");
end

function PWBAnnounce:PWB_REFRESH_CONFIG()
	PWBAnnounce:RefreshConfig()
end

function PWBAnnounce:UNIT_SPELLCAST_SENT(eventName, unit, spell, rank, target, lineId)
	if not self.enabled then
		return
	end

	if unit == "player" then
		if self.enabledAnnounceList[spell] ~= nil then
			PWBAnnounce:Start(spell, target)
			if self.enabledAnnounceList[spell].aura then
				table.insert(self.auraGainList, spell)
			end
		end
	end
end

function PWBAnnounce:UNIT_AURA(eventName, unit)
	if unit == "player" then
		-- Check if we lost an aura that where tracking
		for id, spell in pairs(self.auraLostList) do
			local n,_,_,_,_,d,e,_,_,_,spellid,_,_,val1,val2,val3 = UnitAura("player", spell, nil, "HELPFUL");
			if n then
			else
				PWBAnnounce:End(spell)
				self.auraLostList[id] = nil
			end
		end

		-- Check if we gained an aura that where tracking
		for id, spell in pairs(self.auraGainList) do
			local n,_,_,_,_,d,e,_,_,_,spellid,_,_,val1,val2,val3 = UnitAura("player", spell, nil, "HELPFUL");
			if n then
				table.insert(self.auraLostList, spell)
				self.auraGainList[id] = nil
			end
		end

	end
end

-- start combat
function PWBAnnounce:PLAYER_REGEN_DISABLED()
	self.combat = true
	PWBAnnounce:CheckEnabled()
end

-- end combat
function PWBAnnounce:PLAYER_REGEN_ENABLED()
	self.combat = false
	PWBAnnounce:CheckEnabled()
end

function PWBAnnounce:ZONE_CHANGED_NEW_AREA()
	PWBAnnounce:CheckZone()
end

function PWBAnnounce:GROUP_ROSTER_UPDATE()
	PWBAnnounce:CheckGroup()
end

function PWBAnnounce:PARTY_MEMBERS_CHANGED()
	PWBAnnounce:CheckGroup()
end

function PWBAnnounce:RAID_ROSTER_UPDATE()
	PWBAnnounce:CheckGroup()
end

function PWBAnnounce:RefreshConfig()
	self.enabledAnnounceList = {}
	self.auraGainList = {}
	self.auraLostList = {}

	for id, ability in pairs(self.announceList) do
		PWBAnnounce:AddOrCreate(PWBAnnounce:SetMetaData(ability, id), id)
	end
	PWBAnnounce:CheckZone()
end

function PWBAnnounce:AddAnnounce(ability, id)
	ability = PWBAnnounce:SetMetaData(ability, id)
	table.insert(self.announceList, id, ability)

	PWBAnnounce:AddOrCreate(ability, id)
end

function PWBAnnounce:SetMetaData(ability, id)
	ability.name = GetSpellInfo(id)
	ability.id = id
	ability.startmsg = PWBAnnounce:GenerateMessage(ability, id, "start")
	ability.endmsg = PWBAnnounce:GenerateMessage(ability, id, "end")

	return ability
end

function PWBAnnounce:GenerateMessage(ability, id, msgtype)
	local message = ""

	if msgtype == "start" then
		message = self.db.defaultStart
		if self.db.announce[id] ~= nil then
			if self.db.announce[id].startmsg ~= nil then
				message = self.db.announce[id].startmsg
			end
		end
	end

	if msgtype == "end" then
		message = self.db.defaultEnd
		if self.db.announce[id] ~= nil then
			if self.db.announce[id].endmsg ~= nil then
				message = self.db.announce[id].endmsg
			end
		end
	end

	return string.gsub(message, "LINK", GetSpellLink(id))
end

function PWBAnnounce:AddOrCreate(ability, id)
	if self.db.announce[id] == nil then
		self.db.announce[id] = {}
	end

	if self.db.announce[id].enabled then
		self.enabledAnnounceList[ability.name] = ability
	end
end

function PWBAnnounce:Start(spell, target)
	PWBAnnounce:Send(self.db.announce[self.enabledAnnounceList[spell].id], self.enabledAnnounceList[spell].startmsg, target)
end

function PWBAnnounce:End(spell)
	PWBAnnounce:Send(self.db.announce[self.enabledAnnounceList[spell].id], self.enabledAnnounceList[spell].endmsg, nil)
end

function PWBAnnounce:Send(options, msg, target)
	if target ~= nil then
		msg = string.gsub(msg, "TARGET", target)
	end

	if options.say then
		SendChatMessage(msg, "SAY", nil, nil)
	end

	if self.groupType ~= "SOLO" then
		if options.auto then
			SendChatMessage(msg, self.autoChannel, nil, nil)
		end

		if options.party then
			SendChatMessage(msg, "PARTY", nil, nil)
		end

		if options.raid then
			SendChatMessage(msg, "RAID", nil, nil)
		end

		if options.instance then
			SendChatMessage(msg, "INSTANCE_CHAT", nil, nil)
		end
	end

	if options.custom then
		local id, name = GetChannelName(options.channelName)
		if (id > 0 and name ~= nil) then
			SendChatMessage(msg, "CHANNEL", nil, id)
		end
	end

end

function PWBAnnounce:CheckEnabled()
	self.enabled = true

	-- protwarbar disabled
	if self.enabled then
		self.enabled = Protwarbar.db.profile.enabled
	end

	-- module disabled
	if self.enabled then
		self.enabled = self.db.enabled
	end

	-- if combat is required
	if self.enabled then
		if self.db.enableCombat then
			self.enabled = self.combat
		end
	end

	-- zone type
	if self.enabled then
		self.enabled = self.db[self.zoneType]
	end

	-- Protwarbar:Print("Zone type: " .. self.zoneType)
	-- Protwarbar:Print("Group type: " .. self.groupType)
	-- Protwarbar:Print(self.db[self.zoneType])
end

function PWBAnnounce:CheckZone()
	local isInstance, instanceType = IsInInstance()

	-- party, raid, arena, pvp, none
	if isInstance == 1 then
		self.zoneType = instanceType
	else
		self.zoneType = "world"
	end

	if IsInScenarioGroup("player") then
		self.zoneType = "scenario"
	end

	PWBAnnounce:CheckEnabled()
end

function PWBAnnounce:CheckGroup()
	self.groupType = "SOLO"

	if IsInGroup() then
		self.groupType = "PARTY"
		self.autoChannel = "PARTY"
	end

	if IsInRaid() then
		self.groupType = "RAID"
		self.autoChannel = "RAID"
	end

	if IsInLFGDungeon() then
		self.groupType = "LFR"
		self.autoChannel = "INSTANCE_CHAT"
	end

	if IsInScenarioGroup() then
		self.groupType = "LFR_SCENARIO"
		self.autoChannel = "INSTANCE_CHAT"
	end

	PWBAnnounce:CheckEnabled()
end
