function PWBInfo:BuildGui()
	-- Resolve Healing
	ResolveHealingFrame = PWBTextFrame.new("Resolve Healing", self.db.resolveHealing)
	ResolveHealingText = ResolveHealingFrame:CreateTextField()

	-- Resolve Damage
	ResolveDamageFrame = PWBTextFrame.new("Resolve Damage", self.db.resolveDamage)
	ResolveDamageText = ResolveDamageFrame:CreateTextField()

	-- Shield Barrier
	ShieldInfoFrame = PWBTextFrame.new("Shield Barrier Size", self.db.shieldBarrier)
	ShieldText = ShieldInfoFrame:CreateTextField()

	PWBInfo:UpdateStyling()
	PWBInfo:UpdateVisiblity()
end

function PWBInfo:UpdateStyling()
	ResolveHealingFrame:Update()
	ResolveHealingFrame:UpdateTextField(ResolveHealingText)
	ResolveHealingFrame:UpdateBackdrop()

	ResolveDamageFrame:Update()
	ResolveDamageFrame:UpdateTextField(ResolveDamageText)
	ResolveDamageFrame:UpdateBackdrop()

	ShieldInfoFrame:Update()
	ShieldInfoFrame:UpdateTextField(ShieldText)
	ShieldInfoFrame:UpdateBackdrop()
end

function PWBInfo:UpdateVisiblity()
	if self.db.resolveHealing.enabled == true and Protwarbar:IsVisible() and self.db.enabled == true then
		ResolveHealingFrame:Show()
	else
		ResolveHealingFrame:Hide()
	end

	if self.db.resolveDamage.enabled == true and Protwarbar:IsVisible() and self.db.enabled == true then
		ResolveDamageFrame:Show()
	else
		ResolveDamageFrame:Hide()
	end

	if self.db.shieldBarrier.enabled == true and Protwarbar:IsVisible() and self.db.enabled == true then
		ShieldInfoFrame:Show()
	else
		ShieldInfoFrame:Hide()
	end		
end

function PWBInfo:UpdateSettings()
	ResolveHealingFrame:UpdateSettings(self.db.resolveHealing)
	ResolveDamageFrame:UpdateSettings(self.db.resolveDamage)
	ShieldInfoFrame:UpdateSettings(self.db.shieldBarrier)
end
