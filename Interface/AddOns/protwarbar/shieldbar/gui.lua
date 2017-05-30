function PWBShieldbar:BuildGui()
	PWBShieldFrame = PWBBarFrame.new("Shield Frame", self.db, {static = true})
	PWBHealthFrame = PWBBarFrame.new("Healthbar", self.db, {strata = "MEDIUM"})

	ShieldBar = PWBShieldFrame:StatusBar("ShieldBar")
	PWBHealthBar = PWBShieldFrame:StatusBar("HealthBar", {strata = "LOW"})

	HealthBarText = PWBHealthFrame:CreateTextField({justify = "LEFT"})
	ShieldBarText = PWBHealthFrame:CreateTextField({justify = "RIGHT"})

	PWBShieldbar:UpdateStyling()
	PWBShieldbar:UpdateVisiblity()
end

function PWBShieldbar:UpdateStyling()
	PWBShieldFrame:UpdateFrame()
	PWBHealthFrame:UpdateFrame({widthScale = 0.5})

	PWBShieldFrame:UpdateStatusBar(ShieldBar, {color = self.db.shieldColor})
	PWBShieldFrame:UpdateStatusBar(PWBHealthBar, {color = self.db.healthColor4})

	PWBHealthFrame:UpdateTextField(ShieldBarText, {widthScale = 0.5})
	PWBHealthFrame:UpdateTextField(HealthBarText, {widthScale = 0.5})

	PWBHealthFrame:UpdateBackdrop({background = "barBackground"})
	PWBShieldFrame:UpdateBackdrop({hidden = true})
end

function PWBShieldbar:UpdateSettings()
	PWBShieldFrame:UpdateSettings(self.db)
	PWBHealthFrame:UpdateSettings(self.db)
end

function PWBShieldbar:UpdateVisiblity()
	if self.db.enabled == true and Protwarbar:IsVisible() then
		PWBShieldFrame:Show()
		PWBHealthFrame:Show()
	else
		PWBShieldFrame:Hide()
		PWBHealthFrame:Hide()
	end
end
