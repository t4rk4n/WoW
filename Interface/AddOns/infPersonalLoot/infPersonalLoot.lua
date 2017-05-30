----------------------------------------------
-- infPersonalLoot
----------------------------------------------

local infPersonalLoot = CreateFrame("Frame", "infPersonalLoot")
infPersonalLoot:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
infPersonalLoot:RegisterEvent("PLAYER_LOGIN")

local SetLootMethod = SetLootMethod
local GetLootMethod = GetLootMethod
local UnitIsGroupLeader = UnitIsGroupLeader

function infPersonalLoot:PLAYER_LOGIN()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local function IsInParty()
	local _, _, diff = GetInstanceInfo()
	return diff == 2
end

function infPersonalLoot:PLAYER_ENTERING_WORLD()
	if IsInParty() then
		self:RegisterEvent("PARTY_LEADER_CHANGED")
		self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
		self:Update()
	else
		self:UnregisterEvent("PARTY_LEADER_CHANGED")
		self:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED")
	end
end

function infPersonalLoot:PARTY_LEADER_CHANGED()
	self:Update()
end

function infPersonalLoot:PARTY_LOOT_METHOD_CHANGED()
	self:Update()
end

function infPersonalLoot:Update()
	local lootMethod = GetLootMethod()
	if lootMethod and lootMethod ~= "personalloot" then
		if UnitIsGroupLeader("player") then
			SetLootMethod("personalloot")
			print("|cff3399FFinf|rPersonalLoot: Loot method set to Personal.")
		else
			print("|cff3399FFinf|rPersonalLoot: Loot method is >NOT< Personal and you are >NOT< the group leader.")
		end
	end
end

