local spellList = {
	["DEATHKNIGHT"] = {
		47528 -- Mind Freeze
	},
	["DRUID"] = {
		80964, -- Skull Bash (Bear)
		80965  -- Skull Bash (Cat)
	},
	["MAGE"] = {
		2139 -- Counterspell
	},
	["PALADIN"] = {
		96231 -- Rebuke
	},
	["ROGUE"] = {
		1766 -- Kick
	},
	["SHAMAN"] = {
		57994 -- Wind Shear
	},
	["WARLOCK"] = {
		19647 -- Spell Lock
	},
	["WARRIOR"] = {
		6552, -- Pummel
		72 -- Shield Bash
	}
}

local classList = {
	[47528] =  "DEATHKNIGHT",
	[80964] =  "DRUID",
	[80965] =  "DRUID",
	[2139] =  "MAGE",
	[96231] =  "PALADIN",
	[1766] =  "ROGUE",
	[57994] =  "SHAMAN",
	[19647] =  "WARLOCK",
	[6552] =  "WARRIOR",
	[72] =  "WARRIOR"
}

local spellList40m = {
	["DRUID"] = 5176, -- Wrath
	["HUNTER"] = 3044, -- Arcane Shot
	["MAGE"] = 133, -- Fireball
	["WARLOCK"] = 686, -- Shadow Bolt
	["SHAMAN"] = 73680 -- Unleash Elements
}

local durList = {
	["DEATHKNIGHT"] = 10,
	["DRUID"] = 10,
	["MAGE"] = 24,
	["PALADIN"] = 10,
	["ROGUE"] = 10,
	["SHAMAN"] = 5,
	["WARLOCK"] = 24,
	["WARRIOR"] = 10
}

local RANGE10, RANGE28, RANGE40 = 1, 2, 3
--inRange = CheckInteractDistance("unit", distIndex);  -- from wowpedia
--distIndex: A value from 1 to 4:
--1 = Inspect, 28 yards
--2 = Trade, 11.11 yards
--3 = Duel, 9.9 yards
--4 = Follow, 28 yards

local rangeList = {
	["DEATHKNIGHT"] = RANGE10, -- melee
	["DRUID"] = RANGE28, -- 13yd
	["MAGE"] = RANGE40, -- 40yd
	["PALADIN"] = RANGE10, -- melee
	["ROGUE"] = RANGE10, -- melee
	["SHAMAN"] = RANGE28, -- 25yd
	["WARLOCK"] = RANGE40, -- 30yd
	["WARRIOR"] = RANGE10 -- melee
}


--                                 r    g    b    a
local fadedcolor              = {0.45,0.45,0.45,0.70};
local upcolor                 = {1.00,1.00,1.00,1.00};
local fadedrangecheckcolor    = {0.50,0.00,0.00,0.65};
local uprangecheckcolor       = {1.00,0.00,0.00,0.65};

local inArena = false
local frames = {}
local numframes = 0
local playerClass;

InterruptTrackerUnlock = false
InterruptTrackerScale = 1.0
InterruptTrackerEnableArena = true
InterruptTrackerEnableNonArena = true
InterruptTrackerRotate = false
InterruptTrackerEnableRangeCheck = false
InterruptTrackerRogueGlyph = false
InterruptTrackerRoguePrepGlyph = true
InterruptTrackerMaxFrames = 5

local function spellname(id)
	local name = GetSpellInfo(id)
	return name
end

local function InterruptTrackerFormatTime(time)
	if(time >= 1) then
		return floor(time);
	else
		return "."..floor(time*10);
	end
end

local function UnitIsPlayerByGUID(guid)
	-- enemy is player? taken from wowpedia
	local B = tonumber(guid:sub(5,5), 16);
	local maskedB = B % 8;
	if(maskedB == 0) then
		return true
	end

	return false
end

local function InterruptTrackerCreateFrame()
	numframes = numframes + 1

	frames[numframes] = CreateFrame("Frame", nil, UIParent)
	local frame = frames[numframes]

	frame:SetFrameStrata("LOW")
	frame:SetSize(36, 36)
	frame:SetScale(InterruptTrackerScale);
	
	frame:Hide()
	frame.fading = false
	frame.startTime = nil

	frame.icon = frame:CreateTexture(nil,"ARTWORK")
	frame.icon:SetAllPoints(frame)

	frame.overlay = CreateFrame("Frame", "InterruptTrackerActivationAlert" .. numframes, frame, "InterruptTrackerActivationAlert")
	frame.overlay:SetSize(36*1.4, 36*1.4)
	frame.overlay:SetPoint("TOPLEFT", frame, "TOPLEFT", -36*0.2, 36*0.2)
	frame.overlay:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 36*0.2, -36*0.2)

	frame.rangecheck = CreateFrame("Frame", nil, frame)
	frame.rangecheck:SetPoint("CENTER");
	frame.rangecheck:SetSize(33, 33)
	frame.rangecheck:SetScript("OnUpdate", InterruptTrackerRangeCheck)
	frame.rangecheck:Hide()
	frame.rangecheck.timeElapsed = 0

	frame.rangecheck.icon = frame.rangecheck:CreateTexture(nil,"ARTWORK")
	frame.rangecheck.icon:SetAllPoints(frame.rangecheck)
	frame.rangecheck.icon:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	frame.rangecheck.icon:SetAlpha(0.5)
	frame.rangecheck.icon:Hide()

	frame.ooccounter = CreateFrame("Frame", nil, frame)
	frame.ooccounter:SetScript("OnUpdate", InterruptTrackerOOCCounterFunc)
	frame.ooccounter:Hide()
	frame.ooccounter.startTime = nil

	frame.countframe = CreateFrame("Frame", nil, frame)
	frame.countframe:SetScript("OnUpdate", InterruptTrackerFrameCounter)
	frame.countframe:Hide()
	frame.countframe.endTime = nil

	frame.countframe.durtext = frame.countframe:CreateFontString(nil, "OVERLAY", "InterruptTrackerDurText")
	frame.countframe.durtext:SetPoint("CENTER", frame, "CENTER", 0, 0)

	if(numframes == 1) then
		frame:SetPoint("TOPLEFT", InterruptTrackerHeader, "TOPLEFT", 3, -3)
	else
		if(InterruptTrackerRotate) then
			frame:SetPoint("TOPLEFT", frames[numframes-1], "BOTTOMLEFT", 0, -5)
		else
			frame:SetPoint("TOPLEFT", frames[numframes-1], "TOPRIGHT", 5, 0)
		end
	end
end

--local function InterruptTrackerSetIconColor(frame)
--	if(frame.countframe:IsVisible()) then
--		frame.icon:SetVertexColor(upcolor[1], upcolor[2], upcolor[3], upcolor[4])
--		frame.rangecheck.icon:SetVertexColor(uprangecheckcolor[1], uprangecheckcolor[2], uprangecheckcolor[3], uprangecheckcolor[4])
--	else
--		frame.icon:SetVertexColor(fadedcolor[1], fadedcolor[2], fadedcolor[3], fadedcolor[4])
--		frame.rangecheck.icon:SetVertexColor(fadedrangecheckcolor[1], fadedrangecheckcolor[2], fadedrangecheckcolor[3], fadedrangecheckcolor[4])
--	end
--end

local function InterruptTrackerShowFrame(num, class)
	if(not frames[num]:IsVisible() or frames[num].fading) then
		frames[num]:SetScript("OnUpdate",InterruptTrackerFadeFunc)
		frames[num]:Show()
		frames[num].fading = false
		frames[num].startTime = GetTime()
	end

	local icon = select(3, GetSpellInfo(spellList[class][1]))
	frames[num].icon:SetTexture(icon)
	frames[num].class = class
	frames[num].dur = durList[class]

	frames[num].icon:SetVertexColor(fadedcolor[1], fadedcolor[2], fadedcolor[3], fadedcolor[4])
	frames[num].rangecheck.icon:SetVertexColor(fadedrangecheckcolor[1], fadedrangecheckcolor[2], fadedrangecheckcolor[3], fadedrangecheckcolor[4])
end

local function InterruptTrackerShowNonArenaFrame(num, class, guid)
	InterruptTrackerShowFrame(num, class)
	frames[num].guid = guid
	--frames[num].ownerguid = ownerguid
	frames[num].ooccounter:Show()
	frames[num].ooccounter.startTime = GetTime()
end

local function InterruptTrackerHideFrame(self)
	if(self:IsVisible() and not self.fading) then
		self:SetScript("OnUpdate",InterruptTrackerFadeFunc)
		self.fading = true
		self.startTime = GetTime()
	end

	self.class = nil
	self.dur = nil
	self.arenaid = nil
	self.guid = nil
	--self.ownerguid = nil
	self.countframe:Hide()
	self.ooccounter:Hide()
	self.rangecheck:Hide()
	self.rangecheck.icon:Hide()
end

local function InterruptTrackerInstaHideAll()

	for i=1, numframes do
		frames[i].class = nil
		frames[i].dur = nil
		frames[i].arenaid = nil
		frames[i].guid = nil
		--frames[i].ownerguid = nil
		frames[i]:Hide()
		frames[i].countframe:Hide()
		frames[i].ooccounter:Hide()
		frames[i].rangecheck:Hide()
		frames[i].rangecheck.icon:Hide()
	end

end

local function InterruptTrackerStartCounter(num)
	frames[num].countframe:Show()
	frames[num].countframe.endTime = GetTime() + frames[num].dur
	frames[num].overlay.animIn:Play()

	frames[num].icon:SetVertexColor(upcolor[1], upcolor[2], upcolor[3], upcolor[4])
	frames[num].rangecheck.icon:SetVertexColor(uprangecheckcolor[1], uprangecheckcolor[2], uprangecheckcolor[3], uprangecheckcolor[4])
end

local function InterruptTrackerStopCounter(frame)
	frame.countframe:Hide()

	frame.icon:SetVertexColor(fadedcolor[1], fadedcolor[2], fadedcolor[3], fadedcolor[4])
	frame.rangecheck.icon:SetVertexColor(fadedrangecheckcolor[1], fadedrangecheckcolor[2], fadedrangecheckcolor[3], fadedrangecheckcolor[4])
end

local function InterruptTrackerAddNewArenaOpponent(class, id)
	-- is unit already registered?
	for i=1, numframes do
		if(frames[i].arenaid == id) then
			return
		end
	end

	-- try to use an unused existing frame
	for i=1, numframes do
		if(frames[i].class == nil) then
			InterruptTrackerShowFrame(i, class)
			frames[i].arenaid = id

			if(InterruptTrackerEnableRangeCheck) then
				frames[i].rangecheck:Show()
			end
			return
		end
	end

	-- no unused existing frame found, create a new one
	InterruptTrackerCreateFrame()
	InterruptTrackerShowFrame(numframes, class)
	frames[numframes].arenaid = id

	if(InterruptTrackerEnableRangeCheck) then
		frames[numframes].rangecheck:Show()
	end
end

local function InterruptTrackerAddNewOpponent(class, guid)

	--local ownerguid = ...

	for i=1, numframes do
		if(frames[i].guid == guid) then
			-- maybe we can fill a missing ownerguid
			-- frames[i].ownerguid = ownerguid

			return
		end
	end

	-- first, try to use an unused existing frame
	local maxavailableframes

	if(InterruptTrackerMaxFrames < numframes) then
		maxavailableframes = InterruptTrackerMaxFrames
	else
		maxavailableframes = numframes
	end

	for i=1, maxavailableframes do
		if(frames[i].class == nil) then
			InterruptTrackerShowNonArenaFrame(i, class, guid)
			return
		end
	end


	if(InterruptTrackerMaxFrames >= numframes) then
		-- no unused existing frame found, create a new one
		InterruptTrackerCreateFrame()
		InterruptTrackerShowNonArenaFrame(maxavailableframes+1, class, guid)
	else
		-- maximum frame number reached. replace existing one
		local minooc = 0
		local minnum
		for i=1, numframes do
			if(not frames[i].countframe:IsVisible()) then
				local oocstart = frames[i].ooccounter.startTime
				if(minooc < oocstart) then
					minooc = oocstart
					minnum = i
				end
			end
		end

		if(minnum ~= nil) then
			InterruptTrackerShowNonArenaFrame(minnum, class, guid)
		end
	end
end

local function InterruptTrackerSetupArenaOpponents()
	if(not UnitIsDeadOrGhost("player")) then
		for i=1, 5 do
			if(UnitExists("arena" .. i) and not UnitIsDead("arena" .. i)) then
				local class = select(2, UnitClass("arena" .. i))

				if(spellList[class] ~= nil) then
					InterruptTrackerAddNewArenaOpponent(class, i)
				end

			end
		end
	end
end

function InterruptTrackerOnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("ARENA_OPPONENT_UPDATE")

	self:SetBackdropColor(0, 0, 0);
	self:RegisterForClicks("RightButtonUp")
	self:RegisterForDrag("LeftButton")
	self:SetClampedToScreen(true)

	playerClass = select(2, UnitClass("player"))
end

local function InterruptTrackerDruidSpecDetection(spellId, sourceGUID)
	if (spellId == 78674 or spellId == 24858 or spellId == 61391 or spellId == 33831 -- Starsurge, Moonkin Form, Typhoon, Force of Nature
		or spellId == 81261 or spellId == 48505 or spellId == 18562 -- Solar Beam, Starfall, Swiftmend
		or spellId == 17116 or spellId == 48438 or spellId == 33891 ) then -- Nature's Swiftness, Wild Growth, Tree of Life

		if(inArena) then
			for i=1, numframes do
				if(frames[i].arenaid ~= nil and UnitExists("arena" .. frames[i].arenaid)) then
					if(sourceGUID == UnitGUID("arena" .. frames[i].arenaid)) then
						frames[i].dur = 60
						return
					end
				end
			end
		elseif(InterruptTrackerEnableNonArena) then
			for i=1, numframes do
				if(sourceGUID == frames[i].guid) then
					frames[i].dur = 60
					return
				end
			end
		end
	end

end

function InterruptTrackerOnEvent(self, event, ...)

	if(InterruptTrackerUnlock) then
		return
	end

	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then


		if(UnitIsDeadOrGhost("player")) then
			return
		end

		local type = select(2, ...)
		local sourceGUID = select(4, ...)

		-- hide frame if unit died
		if (type == "UNIT_DIED") then
			local destGUID = select(8, ...)

			if(inArena) then

				for i=1, numframes do
					if(frames[i].arenaid ~= nil and UnitExists("arena" .. frames[i].arenaid)) then
						local class = select(2, UnitClass("arena" .. frames[i].arenaid))
						if(destGUID == UnitGUID("arena" .. frames[i].arenaid)) then
							InterruptTrackerHideFrame(frames[i])
							return
						end
						if(class == "WARLOCK" and destGUID == UnitGUID("arenapet" .. frames[i].arenaid)) then
							InterruptTrackerHideFrame(frames[i])
							return
						end
					end
				end

			else
				for i=1, numframes do
					if(destGUID == frames[i].guid) then
						InterruptTrackerHideFrame(frames[i])
						return
					end
				end
			end
		end

		local sourceFlags = select(6, ...)
		local isSrcEnemy = (bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
		local isSrcPlayerControlled = (bit.band(sourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER)

		if(not isSrcEnemy or not isSrcPlayerControlled) then
			return
		end

		-- update ooc timers
		if(not inArena and InterruptTrackerEnableNonArena) then
			for i=1, numframes do
				if(sourceGUID == frames[i].guid) then
					frames[i].ooccounter.startTime = GetTime()
					break
				end
			end
		end

		if (type == "SPELL_CAST_SUCCESS" or type == "SPELL_MISS") then

			local spellId = select(12, ...)

			InterruptTrackerDruidSpecDetection(spellId, sourceGUID)

			if(inArena) then

				-- check for interrupt
				for i=1, numframes do
					if(frames[i].arenaid ~= nil and (sourceGUID == UnitGUID("arena" .. frames[i].arenaid) or sourceGUID == UnitGUID("arenapet" .. frames[i].arenaid))) then
						for j=1, #spellList[frames[i].class] do
							if(spellId == spellList[frames[i].class][j]) then
								InterruptTrackerStartCounter(i)
							end
						end
					end
				end

				-- check for preparation
				if(InterruptTrackerRoguePrepGlyph and spellId == 14185) then
					for i=1, numframes do
						if(frames[i].arenaid ~= nil and sourceGUID == UnitGUID("arena" .. frames[i].arenaid) ) then
							InterruptTrackerStopCounter(frames[i])
							break
						end
					end
				end

			elseif(InterruptTrackerEnableNonArena) then

				-- first, search for new opponents
				-- add opponents that use interrupt spells
				local class = classList[spellId];
				local destGUID = select(8, ...)
				
				if(class ~= nil) then

					for i=1, 5 do
						if(destGUID == UnitGUID("party" .. i)) then
							if(UnitInRange("party" .. i)) then
								InterruptTrackerAddNewOpponent(class, sourceGUID)								
							end
						end
					end
					for i=1, 40 do
						if(destGUID == UnitGUID("raid" .. i)) then
							if(UnitInRange("party" .. i)) then
								InterruptTrackerAddNewOpponent(class, sourceGUID)								
							end
						end					
					end
					
				end

				-- add opponents that attack player
				if(destGUID == UnitGUID("player")) then

					local isSrcPlayer = (bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER)

					if(isSrcPlayer) then
						local sourceClass = select(2, GetPlayerInfoByGUID(sourceGUID))
						if(spellList[sourceClass] ~= nil and sourceClass ~= "WARLOCK") then -- dont add warlocks, have to track their pet instead
							InterruptTrackerAddNewOpponent(sourceClass, sourceGUID)
						end
					end

					if(spellId == 54049 or spellId == 19505) then -- Shadow Bite, Devour Magic (Fel Hunter)
						InterruptTrackerAddNewOpponent("WARLOCK", sourceGUID)
					end
				end

				-- check for interrupt
				for i=1, numframes do
					if(sourceGUID == frames[i].guid) then
						for j=1, #spellList[frames[i].class] do
							if(spellId == spellList[frames[i].class][j]) then
								InterruptTrackerStartCounter(i)
							end
						end
					end
				end

				-- check for preparation
				if(InterruptTrackerRoguePrepGlyph and spellId == 14185) then
					for i=1, numframes do
						if(sourceGUID == frames[i].guid) then
							InterruptTrackerStopCounter(frames[i])
						end
					end
				end

			end

		elseif (type=="SPELL_CAST_START") then

			local spellId = select(12, ...)

			InterruptTrackerDruidSpecDetection(spellId, sourceGUID)

		elseif (type == "SPELL_SUMMON") then
			-- check for new warlock pet
			local spellId = select(12, ...)
			local destGUID = select(8, ...)
			local sourceClass = select(2, GetPlayerInfoByGUID(sourceGUID))

			if(sourceClass == "WARLOCK") then

				if(inArena) then

					-- create new frame
					if(spellId == 691) then -- Summon Felhunter

						-- do nothing if frame already exists
						for i=1, numframes do
							if(frames[i].unit ~= nil and sourceGUID == UnitGUID("arena" .. frames[i].arenaid)) then
								return
							end
						end

						for i=1, 5 do
							if(sourceGUID == UnitGUID("arena" .. i)) then
								InterruptTrackerAddNewArenaOpponent("WARLOCK", i)
							end
						end

					else
						-- hide frame if no felhunter
						for i=1, numframes do
							if(frames[i].unit ~= nil and sourceGUID == UnitGUID("arena" .. frames[i].arenaid)) then
								InterruptTrackerHideFrame(frames[i])
								break
							end
						end
					end

				--else
					-- hide existing frame
					--local found = false
					--for i=1, numframes do
					--	if(frames[i].ownerguid == sourceGUID) then
					--		InterruptTrackerHideFrame(frames[i])
					--		found = true
					--		break
					--	end
					--end

					-- no ownerguid found, so search for a pet without owner and hope its the right one
					--if(not found) then
					--	for i=1, numframes do
					--		if(frames[i].class == "WARLOCK" and frames[i].ownerguid == nil) then
					--			InterruptTrackerHideFrame(frames[i])
					--			break
					--		end
					--	end
					--end

					-- create new frame
					--if(spellId == 691) then -- Summon Felhunter
					--	InterruptTrackerAddNewOpponent("WARLOCK", destGUID, sourceGUID)
					--end
				end
			end

		end

	elseif (event == "ARENA_OPPONENT_UPDATE") then

		InterruptTrackerSetupArenaOpponents()

	elseif(event == "PLAYER_ENTERING_WORLD") then

		InterruptTrackerInstaHideAll()

		if (select(2, IsInInstance()) == "arena") then
			if(InterruptTrackerEnableArena and not inArena) then
				inArena = true
			end
		else
			if(inArena) then
				inArena = false
			end
		end


	elseif(event == "PLAYER_DEAD") then

		for i=1, numframes do
			InterruptTrackerHideFrame(frames[i])
		end

	elseif(event == "PLAYER_TARGET_CHANGED" and not inArena and InterruptTrackerEnableNonArena) then

		if(UnitExists("target") and UnitCanAttack("player", "target") and UnitIsPlayer("target") and not UnitIsDead("target") and not UnitIsDeadOrGhost("player")) then

			local class = select(2, UnitClass("target"))

			if(spellList[class] ~= nil) then
				-- in case of warlocks, track their pet instead
				if(class == "WARLOCK") then
					--if(UnitExists("targetpet")) then
					--	InterruptTrackerAddNewOpponent("WARLOCK", UnitGUID("targetpet"), UnitGUID("target"))
					--end
				else
					InterruptTrackerAddNewOpponent(class, UnitGUID("target"))
				end
			end

		end

	elseif(event == "ADDON_LOADED" and arg1 == "InterruptTracker") then
		InterruptTrackerSetScale()
		InterruptTrackerSetLayout()
		InterruptTrackerUpdateRogueGlyph()
	end

end

------------------------
-- OnUpdate Functions --
------------------------

function InterruptTrackerFrameCounter(self)
	local time = self.endTime - GetTime()

	if(time <= 0) then
		InterruptTrackerStopCounter(self:GetParent())
	else
		self.durtext:SetText(InterruptTrackerFormatTime(time))
	end
end

function InterruptTrackerFadeFunc(self)
	local elapsed = GetTime() - self.startTime;

	if(elapsed > 0.4) then
		self:SetScript("OnUpdate", nil);

		if(self.fading) then
			self:Hide()
		end
	end

	if(self.fading) then
		self:SetAlpha(1-elapsed*2.5);
	else
		self:SetAlpha(elapsed*2.5);
	end
end

function InterruptTrackerRangeCheck(self, elapsed)
	self.timeElapsed = self.timeElapsed + elapsed
	if(self.timeElapsed <= 0.20) then return end
	self.timeElapsed = 0

	local frame = self:GetParent()
	local frameunit = "arena" .. frame.arenaid

	if(frame.arenaid ~= nil and UnitExists(frameunit)) then
		if (rangeList[frame.class] == RANGE10 and not CheckInteractDistance(frameunit, 2)) or
		   (rangeList[frame.class] == RANGE28 and not CheckInteractDistance(frameunit, 1)) or
		   (frame.class == "WARLOCK" and rangeList[frame.class] == RANGE40 and spellList40m[playerClass] ~= nil and not IsSpellInRange(spellname(spellList40m[playerClass]), "arenapet" .. frame.arenaid)) or
		   (rangeList[frame.class] == RANGE40 and spellList40m[playerClass] ~= nil and not IsSpellInRange(spellname(spellList40m[playerClass]), frameunit)) then
			frame.rangecheck.icon:Show()
			return
		end
	end

	frame.rangecheck.icon:Hide()
end

function InterruptTrackerOOCCounterFunc(self)
	if(GetTime() - self.startTime > 15) then
		InterruptTrackerHideFrame(self:GetParent())
	end
end



---------------------------
-- Config Menu Functions --
---------------------------

function InterruptTrackerUnlockFunc()
	InterruptTrackerHeader:Show();
	--HideUIPanel(InterfaceOptionsFrame)
	InterruptTrackerUnlock = true

	InterruptTrackerInstaHideAll()

	if(numframes < 5) then
		for i=numframes+1, 5 do
			InterruptTrackerCreateFrame()
		end
	end

	InterruptTrackerShowFrame(1, "MAGE")
	InterruptTrackerShowFrame(2, "WARLOCK")
	InterruptTrackerShowFrame(3, "ROGUE")
	InterruptTrackerShowFrame(4, "SHAMAN")
	InterruptTrackerShowFrame(5, "WARRIOR")
	InterruptTrackerStartCounter(2)
	InterruptTrackerStartCounter(3)
	InterruptTrackerStartCounter(5)
end

function InterruptTrackerLockFunc()
	InterruptTrackerHeader:Hide();
	InterruptTrackerUnlock = false

	InterruptTrackerInstaHideAll()

	if(inArena) then
		InterruptTrackerSetupArenaOpponents()
	end
end

function InterruptTrackerSetLayout()

	if(InterruptTrackerRotate) then
		InterruptTrackerHeader:SetHeight(InterruptTrackerMaxFrames*41+1)
		InterruptTrackerHeader:SetWidth(44)

		if(numframes > 1) then
			for i=2, numframes do
				frames[i]:ClearAllPoints()
				frames[i]:SetPoint("TOPLEFT", frames[i-1], "BOTTOMLEFT", 0, -5);
			end
		end
	else
		InterruptTrackerHeader:SetHeight(44)
		InterruptTrackerHeader:SetWidth(InterruptTrackerMaxFrames*41+1)

		if(numframes > 1) then
			for i=2, numframes do
				frames[i]:ClearAllPoints()
				frames[i]:SetPoint("TOPLEFT", frames[i-1], "TOPRIGHT", 5, 0);
			end
		end
	end

end

function InterruptTrackerSetScale()
	for i=1, numframes do
		frames[i]:SetScale(InterruptTrackerScale);
	end

	InterruptTrackerHeader:SetScale(InterruptTrackerScale);
end

function InterruptTrackerUpdateRogueGlyph()
	if(InterruptTrackerRogueGlyph) then
		durList["ROGUE"] = 8
	else
		durList["ROGUE"] = 10
	end
end

function InterruptTrackerDisableNonArena()
	if(inArena) then
		InterruptTrackerInstaHideAll()
	end
end

function InterruptTrackerUpdateMaxNum()
	if(not inArena and not InterruptTrackerUnlock and InterruptTrackerMaxFrames < numframes) then
		for i=InterruptTrackerMaxFrames+1, numframes do
			InterruptTrackerHideFrame(frames[i])
		end
	end
end
