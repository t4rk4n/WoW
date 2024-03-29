-- AskMrRobot
-- Does cool stuff associated with askmrrobot.com:
--   Import/Export gear and optimization solutions from/to the website
--   Improve the combat logging experience and augment it with extra data not available directly in the log file
--   Team Optimizer convenience functionality

AskMrRobot = LibStub("AceAddon-3.0"):NewAddon("AskMrRobot", "AceEvent-3.0", "AceComm-3.0", "AceConsole-3.0", "AceSerializer-3.0")
local Amr = AskMrRobot
Amr.Serializer = LibStub("AskMrRobot-Serializer")

Amr.ADDON_NAME = "AskMrRobot"

-- types of inter-addon messages that we receive, used to parcel them out to the proper handlers
Amr.MessageTypes = {
	Version = "_V",
	VersionRequest = "_VR",
	Team = "_T"
}

local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobot", true)
local AceGUI = LibStub("AceGUI-3.0")

-- minimap icon and LDB support
local _amrLDB = LibStub("LibDataBroker-1.1"):NewDataObject(Amr.ADDON_NAME, {
	type = "launcher",
	text = "Ask Mr. Robot",
	icon = "Interface\\AddOns\\" .. Amr.ADDON_NAME .. "\\Media\\icon",
	OnClick = function(self, button, down)
		if button == "LeftButton" then
			if IsControlKeyDown() then
				Amr:Wipe()
			else
				Amr:Toggle()
			end
		elseif button == "RightButton" then
			Amr:EquipGearSet()
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("Ask Mr. Robot", 1, 1, 1);
		tt:AddLine(" ");
		tt:AddLine(L.MinimapTooltip)
	end	
})
local _icon = LibStub("LibDBIcon-1.0")


-- initialize the database
local function initializeDb()

	local defaults = {
		char = {
			FirstUse = true,           -- true if this is first time use, gets cleared after seeing the export help splash window
			Talents = {},              -- for each spec, selected talents
			Artifacts = {},            -- for each spec, artifact info
			Equipped = {},             -- for each spec, slot id to item link
			BagItems = {},             -- list of item links for bag
			BankItems = {},            -- list of item links for bank
			VoidItems = {},            -- list of item links for void storage
			BagItemsAndCounts = {},    -- used mainly for the shopping list
			BankItemsAndCounts = {},   -- used mainly for the shopping list			
			GearSets = {},             -- imported gear sets, key by spec group (1 or 2), slot id to item object
			ExtraItemData = {},        -- for each spec group (1 or 2): mainly for legacy support, item id to object with socketColor and duplicateId information
			ExtraGemData = {},         -- for each spec group (1 or 2): gem enchant id to gem display information, and data used to detect identical gems (mainly for legacy support)
			ExtraEnchantData = {},     -- for each spec group (1 or 2): enchant id to enchant display information and material information
			Logging = {                -- character logging settings
				Enabled = false,       -- whether logging is currently on or not
				LastZone = nil,        -- last zone the player was in
				LastDiff = nil,        -- last difficulty for the last zone the player was in
				LastWipe = nil         -- last time a wipe was called by this player
			},
			TeamOpt = {
				AllItems = {},         -- all equippable items no matter where it is, list of item unique ids, used to determine when a player gains a new equippable item
				History = {},          -- history of drops since joining the current group
				Rolls = {},            -- current loot choices for a loot distribution in progress
				Role = nil,            -- Leader or Member, changes UI to the mode most appropriate for this user
				Loot = {},             -- the last loot seen by the master looter
				LootGuid = nil,        -- guid of the last unit looted by the master looter, will be "container" if there is no target
				LootInProgress = false -- true if looting is currently in progress
			}
		},
		profile = {
			minimap = {                -- minimap hide/show and position settings
				hide = false
			},
			window = {},               -- main window position settings
			lootWindow = {},           -- loot window position settings
			shopWindow = {},           -- shopping list window position settings
			options = {
				autoGear = false,      -- auto-equip saved gear sets when changing specs
				shopAh = false,        -- auto-show shopping list at AH
				disableEm = false,     -- disable auto-creation of equipment manager sets
				uiScale = 1            -- custom scale for AMR UI
			},
			Logging = {                -- global logging settings
				Auto = {}              -- for each instanceId, for each difficultyId, true if auto-logging enabled
			}
		},
		global = {
			Region = nil,              -- region that this user is in, all characters on the same account should be the same region
			Shopping = {},             -- shopping list data stored globally for access on any character
			Logging = {                -- a lot of log data is stored globally for simplicity, can only be raiding with one character at a time
				Wipes = {},            -- times that a wipe was called
				PlayerData = {},       -- player data gathered at fight start
				PlayerExtras = {}      -- player extra data like auras, gathered at fight start
			},
			TeamOpt = {                -- this stuff is stored globally in case a player e.g. switches to an alt in a raid group
				LootGear = {},         -- gear info that needs to be transmitted with the next loot
				Rankings = {},         -- last rankings imported by the loot ranker
				RankingString = nil    -- last ranking string imported, kept around for efficient serialization
			}
		}
	}
	
	-- set defaults for auto-logging
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		local byDiff = defaults.profile.Logging.Auto[instanceId]
		if not byDiff then
			byDiff = {}
			defaults.profile.Logging.Auto[instanceId] = byDiff
		end
		
		for k, difficultyId in pairs(Amr.Difficulties) do
			if byDiff[difficultyId] == nil then
				byDiff[difficultyId] = false
			end
		end
	end
	
	Amr.db = LibStub("AceDB-3.0"):New("AskMrRobotDb3", defaults)
	
	Amr.db.RegisterCallback(Amr, "OnProfileChanged", "RefreshConfig")
	Amr.db.RegisterCallback(Amr, "OnProfileCopied", "RefreshConfig")
	Amr.db.RegisterCallback(Amr, "OnProfileReset", "RefreshConfig")
end

function Amr:OnInitialize()
    
	initializeDb()

	Amr:RegisterChatCommand("amr", "SlashCommand")
	
	_icon:Register(Amr.ADDON_NAME, _amrLDB, self.db.profile.minimap)	

	-- listen for inter-addon communication
	self:RegisterComm(Amr.ChatPrefix, "OnCommReceived")	
end

local _enteredWorld = false
local _pendingInit = false

function finishInitialize()

	-- record region, the only thing that we still can't get from the log file
	Amr.db.global.Region = Amr.RegionNames[GetCurrentRegion()]
	
	-- make sure that some initialization is deferred until after PLAYER_ENTERING_WORLD event so that data we need is available;
	-- also delay this initialization for a few extra seconds to deal with some event spam that is otherwise hard to identify and ignore when a player logs in
	Amr.Wait(5, function()
		Amr:InitializeVersions()
		Amr:InitializeGear()
		Amr:InitializeExport()
		Amr:InitializeCombatLog()
		Amr:InitializeTeamOpt()
	end)
end

function onPlayerEnteringWorld()

	_enteredWorld = true
	
	if _pendingInit then
		finishInitialize()
		_pendingInit = false
	end
end

function Amr:OnEnable()
    
	--[[
	-- listen for changes to the snapshot enable state, and always make sure it is enabled if using the core AskMrRobot addon
	self:RegisterMessage("AMR_SNAPSHOT_STATE_CHANGED", function(eventName, isEnabled)
		if not isEnabled then
			-- immediately re-enable on any attempt to disable
			Amr.Serializer:EnableSnapshots()
		end	
	end)
	self.Serializer:EnableSnapshots()
	]]
	
	-- update based on current configuration whenever enabled
	self:RefreshConfig()
	
	-- if we have fully entered the world, do initialization; otherwise wait for PLAYER_ENTERING_WORLD to continue
	if not _enteredWorld then
		_pendingInit = true
	else
		_pendingInit = false
		finishInitialize()
	end
end

function Amr:OnDisable()
	-- disabling is not supported
end


----------------------------------------------------------------------------------------
-- Slash Commands
----------------------------------------------------------------------------------------
local _slashMethods = {
	hide      = "Hide",
	show      = "Show",
	toggle    = "Toggle",
	equip     = "EquipGearSet",     -- parameter is "primary" or "secondary", or no parameter to toggle
	version   = "PrintVersions",
	wipe      = "Wipe",
	undowipe  = "UndoWipe",
	reset     = "Reset",
	test      = "Test"
}

function Amr:SlashCommand(input)
	input = string.lower(input)
	local parts = {}
	for w in input:gmatch("%S+") do 
		table.insert(parts, w) 
	end
	
	if #parts == 0 then return end
	
	local func = _slashMethods[parts[1]]
	if not func then return end
	
	local funcArgs = {}
	for i = 2, #parts do
		table.insert(funcArgs, parts[i])
	end
	
	Amr[func](Amr, unpack(funcArgs))
end


----------------------------------------------------------------------------------------
-- Configuration
----------------------------------------------------------------------------------------

-- refresh all state based on the current values of configuration options
function Amr:RefreshConfig()
	
	self:UpdateMinimap()	
	self:RefreshOptionsUi()
	self:RefreshLogUi()
end

function Amr:UpdateMinimap()

	if self.db.profile.minimap.hide or not Amr:IsEnabled() then
		_icon:Hide(Amr.ADDON_NAME)
	else
		-- change icon color if logging
		if Amr:IsLogging() then
			_amrLDB.icon = 'Interface\\AddOns\\AskMrRobot\\Media\\icon_green'
		else
			_amrLDB.icon = 'Interface\\AddOns\\AskMrRobot\\Media\\icon'
		end
		
		_icon:Show(Amr.ADDON_NAME)
	end
end


----------------------------------------------------------------------------------------
-- Version Checking
----------------------------------------------------------------------------------------

-- version of addon being run by each person in the player's raid or group
Amr.GroupVersions = {}

local function toGroupVersionKey(realm, name)
	realm = string.gsub(realm, "%s+", "")
	return name .. "-" .. realm
end

-- prune out version information for players no longer in the current raid group
local function pruneVersionInfo()

	local newVersions = {}
	local units = Amr:GetGroupUnitIdentifiers()
	
    for i, unitId in ipairs(units) do
		local realm, name = Amr:GetRealmAndName(unitId)	
		if realm then
			local key = toGroupVersionKey(realm, name)
			newVersions[key] = Amr.GroupVersions[key]
		end
    end
	
	Amr.GroupVersions = newVersions	
end

-- send version information to other people in the same raid group
local function sendVersionInfo()
	
    local realm = GetRealmName()
    local name = UnitName("player")
	local ver = GetAddOnMetadata(Amr.ADDON_NAME, "Version")
	
	local msg = string.format("%s\n%s\n%s\n%s", Amr.MessageTypes.Version, realm, name, ver)
	Amr:SendAmrCommMessage(msg)
end

local function onVersionInfoReceived(message)
    
	-- message will be of format: realm\nname\nversion
    local parts = {}
	for part in string.gmatch(message, "([^\n]+)") do
		table.insert(parts, part)
	end
    
    local key = toGroupVersionKey(parts[2], parts[3])
    local ver = parts[4]
	
	Amr.GroupVersions[key] = tonumber(ver)
	
	-- make sure that versions are properly pruned in case this message arrived late and the player has since been removed from the group
	pruneVersionInfo()
end

-- get the addon version another person in the player's raid/group is running, or 0 if they are not running the addon
function Amr:GetAddonVersion(realm, name)
	local ver = Amr.GroupVersions[toGroupVersionKey(realm, name)]
	return ver or 0
end

function Amr:PrintVersions()

	if not IsInGroup() and not IsInRaid() then
		self:Print(L.VersionChatNotGrouped)
		return
	end
	
	local units = self:GetGroupUnitIdentifiers()
	
	local msg = {}
	table.insert(msg, L.VersionChatTitle)
	
	for i, unitId in ipairs(units) do
		local realm, name = self:GetRealmAndName(unitId)
		if realm then
			local key = toGroupVersionKey(realm, name)
			local ver = Amr.GroupVersions[key]
			if not ver then
				table.insert(msg, key .. " |cFFFF0000" .. L.VersionChatNotInstalled .. "|r")
			else
				table.insert(msg, key .. " v" .. ver)
			end
		end
	end
	
	msg = table.concat(msg, "\n")
	print(msg)
end

function Amr:InitializeVersions()
	Amr:AddEventHandler("GROUP_ROSTER_UPDATE", pruneVersionInfo)
	Amr:AddEventHandler("GROUP_ROSTER_UPDATE", sendVersionInfo)

	-- request version information from anyone in my group upon initialization
	if IsInGroup() or IsInRaid() then
		Amr:SendAmrCommMessage(Amr.MessageTypes.VersionRequest)
	end
end


----------------------------------------------------------------------------------------
-- Generic Helpers
----------------------------------------------------------------------------------------

local _waitTable = {}
local _waitFrame = nil

-- execute the specified function after the specified delay (in seconds)
function Amr.Wait(delay, func, ...)
	if not _waitFrame then
		_waitFrame = CreateFrame("Frame", "AmrWaitFrame", UIParent)
		_waitFrame:SetScript("OnUpdate", function (self, elapse)
			local count = #_waitTable
			local i = 1
			while(i <= count) do
				local waitRecord = table.remove(_waitTable, i)
				local d = table.remove(waitRecord, 1)
				local f = table.remove(waitRecord, 1)
				local p = table.remove(waitRecord, 1)
				if d > elapse then
					table.insert(_waitTable, i, { d-elapse, f, p })
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)
	end
	table.insert(_waitTable, { delay, func, {...} })
	return true
end

-- helper to iterate over a table in order by its keys
function Amr.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function Amr.StartsWith(str, prefix)
	if string.len(str) < string.len(prefix) then return false end
	return string.sub(str, 1, string.len(prefix)) == prefix
end

-- helper to get the unit identifiers (e.g. to pass to GetUnitName) for all members of the player's current group/raid
function Amr:GetGroupUnitIdentifiers()

	local units = {}    
    if IsInRaid() then
        for i = 1,40 do
            table.insert(units, "raid" .. i)
        end
    elseif IsInGroup() then
        table.insert(units, "player")
        for i = 1,4 do
            table.insert(units, "party" .. i)
        end
	else
		table.insert(units, "player")
    end
	
	return units
end

-- helper to get the realm and name from a unitId (e.g. "player" or "raid1")
function Amr:GetRealmAndName(unitId)

	local name = GetUnitName(unitId, true)
	if not name then return end
	
	local realm = GetRealmName()
	local splitPos = string.find(name, "-")
	if splitPos ~= nil then
		realm = string.sub(name, splitPos + 1)
		name = string.sub(name, 1, splitPos - 1)
	end
	
	return realm, name
end

-- find the unitid of a player given the name and realm... this comes from the server so the realm will be in english...
-- TODO: more robust handling of players with same name but different realms in the same group on non-english clients
function Amr:GetUnitId(unitRealm, unitName)

	local nameMatches = {}
	
	local units = Amr:GetGroupUnitIdentifiers()
	for i, unitId in ipairs(units) do
		local realm, name = Amr:GetRealmAndName(unitId)	
		if realm then
			-- remove spaces to ensure proper matches
			realm = string.gsub(realm, "%s+", "")
			unitRealm = string.gsub(unitRealm, "%s+", "")
			
			if unitRealm == realm and unitName == name then return unitId end
			if unitName == name then
				table.insert(nameMatches, unitId)
			end
		end
	end
	
	-- only one player with same name, must be the player of interest
	if #nameMatches == 1 then return nameMatches[1] end

	-- could not find or ambiguous
	return nil
end


-- search the tooltip for txt, returns true if it is encountered on any line
function Amr:IsTextInTooltip(tt, txt)
	local regions = { tt:GetRegions() }
	for i, region in ipairs(regions) do
		if region and region:GetObjectType() == "FontString" then
            if region:GetText() == txt then
				return true
			end
        end	
	end
	return false
end

-- helper to determine if we can equip an item (it is already soulbound or account bound)
function Amr:CanEquip(bagId, slotId)
	local tt = Amr.GetItemTooltip(bagId, slotId)
	if self:IsTextInTooltip(tt, ITEM_SOULBOUND) then return true end
	if self:IsTextInTooltip(tt, ITEM_BNETACCOUNTBOUND) then return true end
	if self:IsTextInTooltip(tt, ITEM_ACCOUNTBOUND) then return true end
end

-- helper to determine if an item has a unique constraint
function Amr:IsUnique(bagId, slotId)
	local tt = Amr.GetItemTooltip(bagId, slotId)
	if self:IsTextInTooltip(tt, ITEM_UNIQUE_EQUIPPABLE)	then return true end
	if self:IsTextInTooltip(tt, ITEM_UNIQUE) then return true end
	return false
end


----------------------------------------------------------------------------------------
-- Inter-Addon Communication
----------------------------------------------------------------------------------------
function Amr:SendAmrCommMessage(message, channel)
	-- prepend version to all messages
	local v = GetAddOnMetadata(Amr.ADDON_NAME, "Version")
	message = v .. "\r" .. message
	
	Amr:SendCommMessage(Amr.ChatPrefix, message, channel or (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID"))
end

function Amr:OnCommReceived(prefix, message, distribution, sender)

	local parts = {}
	for part in string.gmatch(message, "([^\r]+)") do
		table.insert(parts, part)
	end
	
	local ver = parts[1]	
	if ver then ver = tonumber(ver) end
	if ver then
		-- newest versions of the addon start all messages with a version number
		message = parts[2]
	end
		
	-- we always allow version checks, even from old versions of the addon that aren't otherwise compatible
	if Amr.StartsWith(message, Amr.MessageTypes.Version) then
		-- version checking between group members
		if Amr.StartsWith(message, Amr.MessageTypes.VersionRequest) then
			sendVersionInfo()
		else
			onVersionInfoReceived(message)
		end
		
		return
	end

	-- any other kind of message is ignored if the version is too old
	if not ver or ver < Amr.MIN_ADDON_VERSION then return end
	
	if Amr.StartsWith(message, Amr.MessageTypes.Team) then	
		-- if fully initialized, process team optimizer messages
		if Amr["ProcessTeamMessage"] then
			Amr:ProcessTeamMessage(message)
		end
	else
		-- if we are fully loaded, process a player snapshot when it is received (combat logging)
		if Amr["ProcessPlayerSnapshot"] then
			self:ProcessPlayerSnapshot(message)
		end
	end
end


----------------------------------------------------------------------------------------
-- Events
----------------------------------------------------------------------------------------
local _eventHandlers = {}

local function handleEvent(eventName, ...)
	local list = _eventHandlers[eventName]
	if list then
		--print(eventName .. " handled")
		for i, handler in ipairs(list) do
			if type(handler) == "function" then
				handler(select(1, ...))
			else
				Amr[handler](Amr, select(1, ...))
			end
		end
	end
end

-- WoW and Ace seem to work on a "one handler" kind of approach to events (as far as I can tell from the sparse documentation of both).
-- This is a simple wrapper to allow adding multiple handlers to the same event, thus allowing better encapsulation of code from file to file.
function Amr:AddEventHandler(eventName, methodOrName)
	local list = _eventHandlers[eventName]
	if not list then
		list = {}
		_eventHandlers[eventName] = list
		Amr:RegisterEvent(eventName, handleEvent)
	end
	table.insert(list, methodOrName)
end

Amr:AddEventHandler("PLAYER_ENTERING_WORLD", onPlayerEnteringWorld)


----------------------------------------------------------------------------------------
-- Debugging
----------------------------------------------------------------------------------------
function Amr:Test()

	local s = "|cff0070dd|Hitem:127224:5337:0:0:0:0:0:0:100:105:512:22:2:615:656:100|h[Staff of Polarities]|h|r"
	Amr.GetItemInfo(s, function(obj, name, link, quality, iLevel)
		print(iLevel)
	end)
end

--[[
function Amr:Test(val1, val2, val3)

	local link = GetLootSlotLink(tonumber(val1))
	local index = Amr:TestLootIndex(link)
	print("loot index: " .. index)
	
	if val2 then
		local candidate = Amr:TestLootCandidate(link, val2, val3)
		print("loot candidate: " .. candidate)
		
		GiveMasterLoot(index, candidate)
	end
end
]]
