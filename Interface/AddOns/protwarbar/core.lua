Protwarbar = LibStub("AceAddon-3.0"):NewAddon("Protwarbar", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0")

function Protwarbar:AllowedToLoadThisVerion()
	-- WoD = 6.2.4 - 21463 - 60200
	-- Leg = 7.0.3 - 21691 - 70000
	local version, internalVersion, date, uiVersion = GetBuildInfo()
	-- Protwarbar:Print(version .. " - " .. internalVersion .. " - " .. uiVersion)
	return tonumber(uiVersion) > 69999
end

PWBRagebar = Protwarbar:NewModule("Ragebar", "AceEvent-3.0")
-- PWBInfo = Protwarbar:NewModule("Info", "AceEvent-3.0", "AceTimer-3.0")
PWBIcon = Protwarbar:NewModule("PWBIcon", "AceEvent-3.0")
PWBAuraBar = Protwarbar:NewModule("PWBAuraBar", "AceEvent-3.0", "AceTimer-3.0")
PWBAnnounce = Protwarbar:NewModule("PWBAnnounce", "AceEvent-3.0")
PWBShieldbar = Protwarbar:NewModule("PWBShieldbar", "AceEvent-3.0", "AceTimer-3.0")
PWBTrinket = Protwarbar:NewModule("PWBTrinket", "AceEvent-3.0")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	Protwarbar:Print('This is the test version of Protwarbar for Legion and will not work for WoD. Use the stable version for WoD.')
	return
end

local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")
local NUMTALENTS = 21

function Protwarbar:OnInitialize()
	Protwarbar:SetDefaultMedia()
	Protwarbar:CreateOptionsTables()

	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	Protwarbar:RegisterChatCommand('protwarbar', 'OnCommand')
	Protwarbar:RegisterChatCommand('pwb', 'OnCommand')


	self.combat = false
	self.abilities = {}
end

function Protwarbar:COMBAT_LOG_EVENT_UNFILTERED(event, q, eventType, a, b, c, d, e, f, destName, ...)
	if (self.playerName == destName) then
		self:SendMessage("PWB_COMBAT_LOG_DEST_PLAYER", event, q, eventType, a, b, c, d, e, f, destName, ...)
	end
end

function Protwarbar:CreateOptionsTables()
	local defaults = self:CreateDefaults()
	defaults.profile.PWBAuraBar = PWBAuraBar:CreateDefaults()
	defaults.profile.PWBIcon = PWBIcon:CreateDefaults()
--	defaults.profile.PWBInfo = PWBInfo:CreateDefaults()
	defaults.profile.PWBRagebar = PWBRagebar:CreateDefaults()
	defaults.profile.PWBAnnounce = PWBAnnounce:CreateDefaults()
	defaults.profile.PWBShieldbar = PWBShieldbar:CreateDefaults()
	defaults.profile.PWBTrinket = PWBTrinket:CreateDefaults()

	self.db = LibStub('AceDB-3.0'):New('ProtwarbarDB', defaults, true)
	self.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);

	self.AceConfig = LibStub("AceConfigDialog-3.0")

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Protwarbar", self:CreateOptions())
	self.AceConfig:AddToBlizOptions("Protwarbar", "Protwarbar")

	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBProfiles", self.profileOptions);
	self.AceConfig:AddToBlizOptions("PWBProfiles", L["Profile"], "Protwarbar");
end

function Protwarbar:ProfileChanged()
	Protwarbar:GetActiveTalents()
	self:SendMessage("PWB_PROFILE_CHANGED")
	Protwarbar:RefreshConfig()
end

function Protwarbar:OnCommand(input)
	if not input or input:trim() == "" then
		if (not InterfaceOptionsFrame:IsShown()) then
			InterfaceOptionsFrame:Show();
		end
		InterfaceOptionsFrame_OpenToCategory("Protwarbar")
	else
		if input:trim() == "lock" then
			Protwarbar.db.profile.locked = true
		elseif input:trim() == "unlock" then
			Protwarbar.db.profile.locked = false
		elseif input:trim() == "toggle" then
			Protwarbar.db.profile.locked = not Protwarbar.db.profile.locked
		else
			Protwarbar:Print(L["Use /protwarbar lock | unlock | toggle"])
		end

		Protwarbar:RefreshConfig()
	end
end

function Protwarbar:OnEnable()
	self.playerName = UnitName("player")
	self.spec = GetSpecialization()
	Protwarbar:GetActiveTalents()

	Protwarbar:LoadClassAblilities()

	if self.abilities ~= nil then
		self:SendMessage("PWB_ABILITIES_LOADED", self.abilities)
	end

	Protwarbar:InitProtwarbar()
	Protwarbar:LoadSelectedProfile()
	self:SendMessage("PWB_MODULE_ENABLE")
	Protwarbar:RefreshConfig()
end

function Protwarbar:LoadClassAblilities()
	local _, playerClass = UnitClass("player")

	if playerClass == "WARRIOR" then
		self.abilities = Protwarbar:LoadWarriorAbilities()
	end

	-- if playerClass == "DEATHKNIGHT" then
	-- 	self.abilities = Protwarbar:LoadDeathKnightAbilities()
	-- end

	-- load and merge shared abilities
	local shared = Protwarbar:LoadSharedAbilities()
	for k,v in pairs(shared) do
		self.abilities[k] = v
	end

	if self.abilities ~= nil then
		-- 	Protwarbarc:Print(L["Protwarbar has been loaded but not enabled. Player class is not supported."])
	end
end

function Protwarbar:ClassSupported(classlist)
	local _, playerClass = UnitClass("player")

	for id, class in pairs(classlist) do
		if class == playerClass then
			return true
		end
	end

	return false
end

function Protwarbar:InitProtwarbar()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
end

function Protwarbar:RefreshConfig()
	self:SendMessage("PWB_REFRESH_CONFIG")
end

function Protwarbar:UpdateVisiblity()
	self:SendMessage("PWB_UPDATE_VISIBILITY")
end

function Protwarbar:OnDisable()
end

function Protwarbar:IsVisible()
	-- temp workaround
	-- local _, playerClass = UnitClass("player")
	-- if playerClass ~= "WARRIOR" then
	-- 	return false
	-- end

	if self.db.profile.enabled == false then
		return false
	end

	if self.db.profile.hideooc == true then
		if self.combat == true then
			return true
		else
			return false
		end
	end

	return true
end

function Protwarbar:LoadSelectedProfile()
	local profiles = self.db:GetProfiles()
	local spec = GetSpecialization()
	local preset = self.db.global.autoload[spec]

	if self.db.global.autoloadEnabled then
		if preset ~= nil then
			if Protwarbar:GetProfileId(profiles, preset) ~= nil then
				Protwarbar:Print(L["Loading Profile: "] .. preset)
				self.db:SetProfile(preset)
				self:SendMessage("PWB_PROFILE_CHANGED")
			else
				Protwarbar:Print(L["Can not auto load profile:"] .. " '" .. preset .. "'.")
			end
		end
	end
end

-- start combat
function Protwarbar:PLAYER_REGEN_DISABLED()
	self.combat = true
	Protwarbar:UpdateVisiblity()
end

-- end combat
function Protwarbar:PLAYER_REGEN_ENABLED()
	self.combat = false
	Protwarbar:UpdateVisiblity()
end

function Protwarbar:ACTIVE_TALENT_GROUP_CHANGED()
	self.spec = GetSpecialization()
	Protwarbar:GetActiveTalents()
	Protwarbar:LoadSelectedProfile()
	Protwarbar:RefreshConfig()
end

function Protwarbar:PLAYER_TALENT_UPDATE()
	Protwarbar:GetActiveTalents()
	Protwarbar:RefreshConfig()
end

function Protwarbar:GetActiveTalents()
	self.talents = {}
	local specGroup = GetActiveSpecGroup()

	-- TODO sort specialization
	-- local specID = GetSpecialization(), we might want to switch to GetTalentInfoByID()

	for i = 1, NUMTALENTS do
        local tier = math.floor((i - 1) / 3 + 1)
		local column = (i - 1) % 3 + 1
		local talentID, name, iconTexture, selected, available = GetTalentInfo(tier, column, specGroup)

		self.talents[i] = selected
	end
end

