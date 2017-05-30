function PWBAuraBar:BuildGui()
	AuraFrame = PWBBarFrame.new("AuraBar", self.db)

	for i = 1, self.db.barcount do
		self.auraBars[i] = AuraFrame:StatusBar("AuraBar bar: " .. i)
	end

	PWBAuraBar:UpdateStyling()
	PWBAuraBar:UpdateVisiblity()
end

function PWBAuraBar:UpdateStyling()
	AuraFrame:UpdateFrame({heightScale = self.db.barcount})

	for i = 1, self.db.barcount do
		AuraFrame:UpdateStatusBar(self.auraBars[i], {yscaler = i - 1})
	end

	AuraFrame:UpdateBackdrop()
end

function PWBAuraBar:UpdateVisiblity()
	if self.db.enabled and Protwarbar:IsVisible() then
		AuraFrame:Show()
	else
		AuraFrame:Hide()
	end
end

function PWBAuraBar:UpdateSettings()
	AuraFrame:UpdateSettings(self.db)
end
