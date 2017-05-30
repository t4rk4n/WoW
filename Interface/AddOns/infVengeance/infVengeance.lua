----------------------------------------------
-- infVengeance
----------------------------------------------

infVengeance = LibStub("AceAddon-3.0"):NewAddon("infVengeance", "AceEvent-3.0", "AceBucket-3.0")

local vengeance = nil

function infVengeance:OnInitialize()	
	infven_frame = CreateFrame("MessageFrame", "infVengeance_Frame", UIParent)
	infven_icon = infven_frame:CreateTexture("Icon", "OVERLAY")
	infven_text = infven_frame:CreateFontString("Text")

	CreateFrame("GameTooltip", "TextTooltip", nil, "GameTooltipTemplate")
	TextTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	TextTooltip:AddFontStrings(
	TextTooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
	TextTooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"))

	if infVengeanceDB == nil then
		self:defaultParameters()
	end

	self:FrameCreation()

	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

	if infVengeanceDB.moveable == true then
		infven_frame:SetMovable(true)
		infven_frame:EnableMouse(true)	
		infven_frame:RegisterForDrag("LeftButton")
		infven_frame:SetScript("OnDragStart", function(self, button) self:StartMoving() end)
		infven_frame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			_, _, _, infVengeanceDB.x, infVengeanceDB.y = infven_frame:GetPoint() 
		end)
	end
end

function infVengeance:FrameCreation()
	infven_frame:SetSize(infVengeanceDB.width, infVengeanceDB.height)
	infven_frame:SetPoint("CENTER", UIParent, "CENTER", infVengeanceDB.x, infVengeanceDB.y)
	infven_frame:SetScale(infVengeanceDB.scale)	
    infven_frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8", 
		edgeFile = "Interface\\AddOns\\infVengeance\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 12,
		tile = false,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	infven_frame:SetBackdropColor(0, 0, 0, 0.6)

	if infVengeanceDB.icon == true then
		infven_icon:SetSize(infVengeanceDB.height, infVengeanceDB.height)
		infven_icon:SetTexture("Interface\\Icons\\Spell_Shadow_Charm")
		infven_icon:SetPoint("RIGHT", infven_frame, "LEFT", 0, 0)
		infven_icon.cdtexture = CreateFrame("Cooldown", nil, infven_frame)
		infven_icon.cdtexture:SetReverse(true)
		infven_icon.cdtexture:SetAllPoints(infven_icon)
	end

	infven_text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	infven_text:SetAllPoints(true)
	infven_text:SetSize(120, 24)
	infven_text:SetText("0")

	if infVengeanceDB.fade == true then
		infven_frame:Hide()
	end
end

local function IsTank()
	local _, playerclass = UnitClass("player")
	local masteryIndex 
	local tank = false
	if playerclass == "DEATHKNIGHT" then
		masteryIndex = GetSpecialization()
		if masteryIndex and masteryIndex == 1 then
			tank = true
		end
	elseif playerclass == "DRUID" then
		masteryIndex = GetSpecialization()
		if masteryIndex and masteryIndex == 3 then
			tank = true
		end
	elseif playerclass == "MONK" then
		masteryIndex = GetSpecialization()
		if masteryIndex and masteryIndex == 1 then
			tank = true
		end
	elseif playerclass == "PALADIN" then
		masteryIndex = GetSpecialization()
		if masteryIndex and masteryIndex == 2 then
			tank = true
		end
	elseif playerclass == "WARRIOR" then
		masteryIndex = GetSpecialization()
		if masteryIndex and masteryIndex == 3 then
			tank = true
		end
	end
	return tank
end

function infVengeance:Toggle(flag)
	if flag then
		self:RegisterBucketEvent("UNIT_AURA", 0.25, "UNIT_AURA")
		infven_frame:Show()
		print("|cff3399FFinf|rVengeance: ON")
	else
		self:UnregisterBucket("UNIT_AURA")
		infven_frame:Hide()
		print("|cff3399FFinf|rVengeance: OFF")
	end
end

function infVengeance:PLAYER_LOGIN()
	self:Toggle(IsTank())
	self:UnregisterEvent("PLAYER_LOGIN")
end

function infVengeance:ACTIVE_TALENT_GROUP_CHANGED()
	self:Toggle(IsTank())
end

function infVengeance:UNIT_AURA(units)
	for unitId in pairs(units) do
		self:BucketUpdate(unitId)
	end
end

function infVengeance:BucketUpdate(unitId)
	if unitId ~= "player" then return end
	local name, _, _, _, _, duration, expirationTime, _, _, _, _ = UnitBuff(unitId, (GetSpellInfo(76691)))
	if name then
		if not vengeance then vengeance = true end
		TextTooltip:ClearLines()
		TextTooltip:SetUnitBuff(unitId, name)
		local txt = TextTooltipTextLeft2:GetText()
		local val = tonumber(string.match(txt,"%d+"))
		if not infven_frame:IsShown() then
			infven_frame:Show()
		end
		if infVengeanceDB.icon == true then
			if expirationTime > 0 then
				local startTime = expirationTime - duration
				infven_icon.cdtexture:SetCooldown(startTime, duration)
				infven_icon.cdtexture:Show()
			end
		end
		infven_text:SetText(val)
	else
		if vengeance then
			vengeance = nil
			infven_text:SetText("0")
			infven_icon.cdtexture:Hide()
			if infVengeanceDB.fade == true then
				infven_frame:Hide()
			end
		end
	end
end

function infVengeance:defaultParameters()
	infVengeanceDB = {}
	infVengeanceDB.moveable = false
	infVengeanceDB.x = "-440"
	infVengeanceDB.y = "-174"
	infVengeanceDB.height = "24"
	infVengeanceDB.width = "120"
	infVengeanceDB.scale = "1"
	infVengeanceDB.icon = true
	infVengeanceDB.fade = false
end

SLASH_INF_VEN1 = "/infven"
SlashCmdList["INF_VEN"] = function(msg, editBox)

	local cmd, arg = string.split(" ", msg, 2)
	cmd = string.lower(cmd or "")
	arg = string.lower(arg or "")

	if cmd == "" then 
		print("|cff3399FFinf|rVengeance: /inf lock to unlock/lock.")
		print("|cff3399FFinf|rVengeance: /inf icon to enable/disable the icon.")
		print("|cff3399FFinf|rVengeance: /inf fade to enabled/disable fading when you have no vengeance.")
		print("|cff3399FFinf|rVengeance: /inf height <height> to change the height.")		
		print("|cff3399FFinf|rVengeance: /inf width <width> to change the width.")
		print("|cff3399FFinf|rVengeance: /inf scale <scale> to change the scale.")
	elseif cmd == "lock" then
		if infVengeanceDB.moveable == true then
			infven_frame:SetMovable(false)
			infven_frame:EnableMouse(false)
			infVengeanceDB.moveable = false	
			print("|cff3399FFinf|rVengeance: locked.")
		elseif infVengeanceDB.moveable == false then
			infven_frame:SetMovable(true)
			infven_frame:EnableMouse(true)	
			infven_frame:RegisterForDrag("LeftButton")
			infven_frame:SetScript("OnDragStart", function(self, button) self:StartMoving() end)
			infven_frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing()
				_, _, _, infVengeanceDB.x, infVengeanceDB.y = infven_frame:GetPoint()
			end)
			infVengeanceDB.moveable = true
			print("|cff3399FFinf|rVengeance: unlocked.")
		end
	elseif cmd == "icon" then
		if infVengeanceDB.icon == true then
			infVengeanceDB.icon = false
			print("|cff3399FFinf|rVengeance: Icon disabled.")
			print("|cff3399FFinf|rVengeance: Requires reload/relog to update.")
		else
			infVengeanceDB.icon = true
			print("|cff3399FFinf|rVengeance: Icon enabled.")	
			print("|cff3399FFinf|rVengeance: Requires reload/relog to update.")
		end
	elseif cmd == "height" then
		if arg:match("^[0-9]+$") then 
			infVengeanceDB.height = arg     
			infven_frame:SetHeight(arg)
			infven_icon:SetSize(infVengeanceDB.height, infVengeanceDB.height)
			print("|cff3399FFinf|rVengeance: Height set to ".. arg ..".")
		elseif arg == "" then
			print("|cff3399FFinf|rVengeance: Missing the height.")
			print("|cff3399FFinf|rVengeance: Example: /inf height 50")
		else
			print("|cff3399FFinf|rVengeance: Invalid height.")
		end
	elseif cmd == "width" then
		if arg:match("^[0-9]+$") then 
			infVengeanceDB.width = arg
			infven_frame:SetWidth(arg)
			print("|cff3399FFinf|rVengeance: Width set to ".. arg ..".")
		elseif arg == "" then
			print("|cff3399FFinf|rVengeance: Missing the width.")
			print("|cff3399FFinf|rVengeance: Example: /inf width 175")
		else
			print("|cff3399FFinf|rVengeance: Invalid width.")
		end
	elseif cmd == "scale" then
		if arg:match("^[0-9].+$") or arg:match("^[0-9]+$") then 
			infVengeanceDB.scale = arg
			infven_frame:SetScale(arg)
			print("|cff3399FFinf|rVengeance: Scale set to ".. arg ..".")
		elseif arg == "" then
			print("|cff3399FFinf|rVengeance: Missing the scale.")
			print("|cff3399FFinf|rVengeance: Example: /inf scale 1.1")
		else
			print("|cff3399FFinf|rVengeance: Invalid scale.")
		end		
	elseif cmd == "fade" then
		if infVengeanceDB.fade == true then
			infVengeanceDB.fade = false
			print("|cff3399FFinf|rVengeance: Fading disabled.")
			infven_frame:Show()
		else
			infVengeanceDB.fade = true
			print("|cff3399FFinf|rVengeance: Fading enabled.")
			infven_frame:Hide()
		end
	end	
end

