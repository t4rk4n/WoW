local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

if (Protwarbar:AllowedToLoadThisVerion() == false) then
	return
end

function PWBRagebar:OnInitialize()

	self.classesSupported = {"WARRIOR"}

	if Protwarbar:ClassSupported(self.classesSupported) then
		self.db = Protwarbar.db.profile.PWBRagebar
		PWBRagebar:BuildGui()
		self:RegisterMessage("PWB_ABILITIES_LOADED")
		self:RegisterMessage("PWB_PROFILE_CHANGED")
		self:RegisterMessage("PWB_REFRESH_CONFIG")
		self:RegisterMessage("PWB_UPDATE_VISIBILITY")
		self:RegisterMessage("PWB_UPDATE_HANDLERS")
	else
		-- Protwarbar:Print("Ragebar is not suported for your class.")
	end
end

function PWBRagebar:OnEnable()
	if Protwarbar:ClassSupported(self.classesSupported) then
		PWBRagebar:PWB_UPDATE_HANDLERS()
	end
end

function PWBRagebar:PWB_UPDATE_HANDLERS()
	self:UnregisterEvent("UNIT_POWER_FREQUENT")
	self:UnregisterEvent("UNIT_MAXPOWER")

	if self.db.enabled and Protwarbar.db.profile.enabled then
		self:RegisterEvent("UNIT_POWER_FREQUENT")
		self:RegisterEvent("UNIT_MAXPOWER")
	end
end

function PWBRagebar:PWB_PROFILE_CHANGED()
	self.db = Protwarbar.db.profile.PWBRagebar
	PWBRagebar:UpdateSettings()
end

function PWBRagebar:PWB_ABILITIES_LOADED()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PWBRagebar", PWBRagebar:CreateOptions());
	Protwarbar.AceConfig:AddToBlizOptions("PWBRagebar", L["Ragebar"], "Protwarbar");
end

function PWBRagebar:RefreshConfig()
	if RageFrame == nil then
		return
	end
	PWBRagebar:UpdateStyling()
	PWBRagebar:UpdateVisiblity()
end

function PWBRagebar:UNIT_POWER_FREQUENT(eventName, unit, powerType)
	if (unit == "player") then
		PWBRagebar:Update(UnitPower("player"))
	end
end

function PWBRagebar:UNIT_MAXPOWER()
	PWBRagebar:UpdateStyling()
end

function PWBRagebar:PWB_REFRESH_CONFIG()
	PWBRagebar:RefreshConfig()
end

function PWBRagebar:PWB_UPDATE_VISIBILITY()
	if RageFrame == nil then
		return
	end
	PWBRagebar:UpdateVisiblity()
end

function PWBRagebar:Update(power)
	RageBar:SetValue(power)
	RageBarText:SetText(power)

	if power < self.db.barlevel[1]  then
		RageBar:SetStatusBarColor(self.db.color1[1], self.db.color1[2],
			self.db.color1[3], self.db.color1[4])
	elseif power < self.db.barlevel[2] then
		RageBar:SetStatusBarColor(self.db.color2[1], self.db.color2[2],
			self.db.color2[3], self.db.color2[4])
	elseif power < self.db.barlevel[3] then
		RageBar:SetStatusBarColor(self.db.color3[1], self.db.color3[2],
			self.db.color3[3], self.db.color3[4])
	elseif power < self.db.barlevel[4] then
		RageBar:SetStatusBarColor(self.db.color4[1], self.db.color4[2],
			self.db.color4[3], self.db.color4[4])
	else
		RageBar:SetStatusBarColor(self.db.color5[1], self.db.color5[2],
			self.db.color5[3], self.db.color5[4])
	end
end
