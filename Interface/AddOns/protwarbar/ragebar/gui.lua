function PWBRagebar:BuildGui()
	RageFrame = PWBBarFrame.new("Rage Frame", self.db)
	RageBar = RageFrame:StatusBar("RageBar", {
			max = UnitPowerMax("player"), 
			val = UnitPower("player")
		})

	RageBarText = RageFrame:CreateTextField({frame = RageBar})
	RageBarText:SetText(UnitPower("player"))

	PWBRagebar:UpdateStyling()
	PWBRagebar:UpdateVisiblity()
end

function PWBRagebar:UpdateStyling()
	RageFrame:UpdateFrame()
	RageFrame:UpdateStatusBar(RageBar)
	RageFrame:SetMaxValue(RageBar, UnitPowerMax("player"))

	RageFrame:UpdateTextField(RageBarText)
	RageFrame:UpdateBackdrop({background = "barBackground"})
end

function PWBRagebar:UpdateVisiblity()
	if self.db.enabled == true and Protwarbar:IsVisible() then
		RageFrame:Show()
	else
		RageFrame:Hide()
	end
end

function PWBRagebar:UpdateSettings()
	RageFrame:UpdateSettings(self.db)
end
