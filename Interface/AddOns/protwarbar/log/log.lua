local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

function PWBLog:OnInitialize()
	self.db = Protwarbar.db.profile.PWBLog

	PWBLog:CreateBuffers()
	PWBLog:SetupLog()
	PWBLog:BuildGui()

	self:RegisterMessage("PWB_ABILITIES_LOADED")
	self:RegisterMessage("PWB_PROFILE_CHANGED")
	self:RegisterMessage("PWB_REFRESH_CONFIG")
	self:RegisterMessage("PWB_UPDATE_VISIBILITY")
	self:RegisterMessage("PWB_UPDATE_HANDLERS")
end

function PWBLog:OnEnable()
	PWBLog:PWB_UPDATE_HANDLERS()
end

function PWBLog:PWB_UPDATE_HANDLERS()
	self:CancelAllTimers()
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterMessage("PWB_COMBAT_LOG_DEST_PLAYER")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterMessage("PWB_COMBAT_LOG_DEST_PLAYER")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:ScheduleRepeatingTimer("QuickTimer", 1)
	end
end

function PWBLog:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBLog
end

function PWBLog:PWB_ABILITIES_LOADED()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBLog", PWBLog:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBLog", L["Log"], "Protwarbar");
end

function PWBLog:PWB_REFRESH_CONFIG()
	self:RefreshConfig()
end

function PWBLog:PWB_UPDATE_VISIBILITY()
	self:UpdateVisiblity()
end

function PWBLog:RefreshConfig()
	self:UpdateStyling()
	self:UpdateVisiblity()
end

function PWBLog:PLAYER_REGEN_DISABLED()
	PWBLog:SetupLog()
end
function PWBLog:PWB_COMBAT_LOG_DEST_PLAYER(pwbevent, event, _, eventType, _, _, _, _, _, _, destName, _, _, val1, c, a, b, d, e, f, g, h)
	if (eventType == "SWING_DAMAGE") then
		PWBLog:LogDamage(eventType, val1, a, b, d, e)
	elseif (eventType == "SPELL_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE") then
		PWBLog:LogDamage(eventType, b, e, f, g, h)
	elseif (eventType == "SWING_MISSED") then
		PWBLog:LogMiss(eventType, val1, a)
	elseif (eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED") then
		PWBLog:LogMiss(eventType, b, e)
	end
end

function PWBLog:LogDamage(eventType, amount, school, resisted, blocked, absorbed)
	if school == 1 then --school is physical
		if eventType == "SWING_DAMAGE" then
			self.blockable = self.blockable + amount
			self.dpslogb[self.dpslog_count] = self.dpslogb[self.dpslog_count] + amount
		else
			self.physical = self.physical + amount
			self.dpslogp[self.dpslog_count] = self.dpslogp[self.dpslog_count] + amount
		end
	else
		self.magic = self.magic + amount
		self.dpslogm[self.dpslog_count] = self.dpslogm[self.dpslog_count] + amount
	end

	if blocked ~= nil then
		self.blockabsorb = self.blockabsorb + blocked
		self.dpsloga[self.dpslog_count] = self.dpsloga[self.dpslog_count] + amount
	end
	if absorbed ~= nil then
		self.blockabsorb = self.blockabsorb + absorbed
		self.dpsloga[self.dpslog_count] = self.dpsloga[self.dpslog_count] + amount
	end
end

function PWBLog:LogMiss(eventType, type, amount)
	if (type == "ABSORB" ) then
		self.blockabsorb = self.blockabsorb + amount
		self.dpsloga[self.dpslog_count] = self.dpsloga[self.dpslog_count] + amount
	else
		self.avoid[type] = self.avoid[type] + 1
	end
end

function PWBLog:SetupLog()
	self.blockable = 1
	self.physical = 1
	self.magic = 1
	self.blockabsorb = 1

	self.avoid = {}
	self.avoid["HIT"] = 0
	self.avoid["MHIT"] = 0
	self.avoid["BLOCK"] = 0
	self.avoid["DEFLECT"] = 0
	self.avoid["DODGE"] = 0
	self.avoid["EVADE"] = 0
	self.avoid["IMMUNE"] = 0
	self.avoid["MISS"] = 0
	self.avoid["PARRY"] = 0
	self.avoid["REFLECT"] = 0
	self.avoid["RESIST"] = 0
end


function PWBLog:CreateBuffers()
	self.DPSLOGCOUNT = self.db.averageTime
	self.dpslogb = {}
	self.dpslogp = {}
	self.dpslogm = {}
	self.dpsloga = {}

	for i = 1, self.DPSLOGCOUNT do
		self.dpslogb[i] = 0
		self.dpslogp[i] = 0
		self.dpslogm[i] = 0
		self.dpsloga[i] = 0
	end

	self.dpslog_count = 1
end

function PWBLog:QuickTimer()
	PWBLog:UpdateLog()
end

function PWBLog:UpdateLog()
	local dpslogb = 1
	local dpslogp = 1
	local dpslogm = 1
	local dpsloga = 1

	for i = 1, self.DPSLOGCOUNT do
		dpslogb = dpslogb + self.dpslogb[i]
		dpslogp = dpslogp + self.dpslogp[i]
		dpslogm = dpslogm + self.dpslogm[i]
		dpsloga = dpsloga + self.dpsloga[i]
	end

	self.dpslog_count = self.dpslog_count + 1

	if self.dpslog_count > self.DPSLOGCOUNT then
		self.dpslog_count = 1
	end

	self.dpslogb[self.dpslog_count] = 1
	self.dpslogp[self.dpslog_count] = 1
	self.dpslogm[self.dpslog_count] = 1
	self.dpsloga[self.dpslog_count] = 1

	--dpslogb = dpslogb / self.DPSLOGCOUNT / 1000

	PWBBlock:SetText(string.format("%.0fK", self.blockable / 1000))
	PWBPysical:SetText(string.format("%.0fK", self.physical / 1000))
	PWBMagic:SetText(string.format("%.0fK", self.magic / 1000))
	PWBAB:SetText(string.format("%.0fK", self.blockabsorb / 1000))

	PWBTOPBlock:SetText(string.format("%.0fK", dpslogb / 1000))
	PWBTOPPysical:SetText(string.format("%.0fK", dpslogp / 1000))
	PWBTOPMagic:SetText(string.format("%.0fK", dpslogm / 1000))
	PWBTOPAB:SetText(string.format("%.0fK", dpsloga / 1000))
end
