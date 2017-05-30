local media = LibStub("LibSharedMedia-3.0")

function PWBLog:BuildGui()
	PWBTopFrame = CreateFrame("Frame", "PWBTopFrame", UIParent)
	PWBTopFrame:SetPoint("BOTTOMLEFT", 0, 0)
	PWBTopFrame:SetBackdrop({bgFile = media:Fetch("background", "Blizzard Tooltip"), tile = false})

	PWBTopFrame:RegisterForDrag('LeftButton')
	PWBTopFrame:SetClampedToScreen(true)
	PWBTopFrame:SetScript("OnDragStart", function(self) Protwarbar:Dragstart(self) end )
	PWBTopFrame:SetScript('OnDragStop', function(self) PWBLog:Dragstop(self) end )
	PWBTopFrame:SetScript('OnEnter', function(self) PWBLog:onEnters(self) end )
	PWBTopFrame:SetScript('OnLeave', function(self) PWBLog:onLeaves(self) end )

	PWBLABELBlock = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "LEFT", text = "B:"})
	PWBLABELPysical = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "LEFT", text = "P:"})
	PWBLABELMagic = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "LEFT", text = "M:"})
	PWBLABELAB = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "LEFT", text = "A:"})

	PWBBlock = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})
	PWBPysical = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})
	PWBMagic = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})
	PWBAB = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})

	PWBTOPBlock = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})
	PWBTOPPysical = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})
	PWBTOPMagic = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})
	PWBTOPAB = Protwarbar:CreateTextField(PWBTopFrame, self.db, {justify = "RIGHT"})

	PWBLog:UpdateStyling()
	PWBLog:UpdateVisiblity()
end

function PWBLog:UpdateStyling()
	self.db.width = self.db.col1 + self.db.col2 + self.db.col3
	self.db.height = self.db.lineheight * 4

	Protwarbar:UpdateTextField(PWBLABELBlock, self.db, {height = self.db.fontsize, width = self.db.col1,  point = "TOPLEFT"})
	Protwarbar:UpdateTextField(PWBLABELPysical, self.db, {height = self.db.fontsize, width = self.db.col1, point = "TOPLEFT", pointY = -1 * self.db.lineheight})
	Protwarbar:UpdateTextField(PWBLABELMagic, self.db, {height = self.db.fontsize, width = self.db.col1, point = "TOPLEFT", pointY = -2 * self.db.lineheight})
	Protwarbar:UpdateTextField(PWBLABELAB, self.db, {height = self.db.fontsize, width = self.db.col1, point = "TOPLEFT", pointY = -3 * self.db.lineheight})

	local col2offset = (self.db.col3 + self.db.col2) * -1
	Protwarbar:UpdateTextField(PWBBlock, self.db, {height = self.db.fontsize, width = self.db.col2,  point = "TOPLEFT", pointX = col2offset})
	Protwarbar:UpdateTextField(PWBPysical, self.db, {height = self.db.fontsize, width = self.db.col2, point = "TOPLEFT", pointX = col2offset, pointY = -1 * self.db.lineheight})
	Protwarbar:UpdateTextField(PWBMagic, self.db, {height = self.db.fontsize, width = self.db.col2, point = "TOPLEFT", pointX = col2offset, pointY = -2 * self.db.lineheight})
	Protwarbar:UpdateTextField(PWBAB, self.db, {height = self.db.fontsize, width = self.db.col2, point = "TOPLEFT", pointX = col2offset, pointY = -3 * self.db.lineheight})

	local col3offset = self.db.col3 * - 1 --self.db.col1 + self.db.col2
	Protwarbar:UpdateTextField(PWBTOPBlock, self.db, {height = self.db.fontsize, width = self.db.col3,  point = "TOPLEFT", pointX = col3offset})
	Protwarbar:UpdateTextField(PWBTOPPysical, self.db, {height = self.db.fontsize, width = self.db.col3, point = "TOPLEFT", pointX = col3offset, pointY = -1 * self.db.lineheight})
	Protwarbar:UpdateTextField(PWBTOPMagic, self.db, {height = self.db.fontsize, width = self.db.col3, point = "TOPLEFT", pointX = col3offset, pointY = -2 * self.db.lineheight})
	Protwarbar:UpdateTextField(PWBTOPAB, self.db, {height = self.db.fontsize, width = self.db.col3, point = "TOPLEFT", pointX = col3offset, pointY = -3 * self.db.lineheight})

	Protwarbar:UpdateFrame(PWBTopFrame, self.db, {enableMouse = true})
	Protwarbar:UpdateBackdropColor(PWBTopFrame, self.db, "background")
end

function PWBLog:UpdateVisiblity()
	PWBTopFrame:Show()
	if self.db.enabled == true and Protwarbar:IsVisible() then
		PWBTopFrame:Show()
	else
		PWBTopFrame:Hide()
	end
end

function PWBLog:Dragstop(frame)
	frame:StopMovingOrSizing()

	self.db.x = PWBTopFrame:GetLeft()
	self.db.y = PWBTopFrame:GetBottom()
end

function PWBLog:onEnters(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_NONE")
    GameTooltip:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
    GameTooltip:ClearLines()

	GameTooltip:AddLine("Statistics", 1, 1, 0)
    GameTooltip:AddDoubleLine("Hit:", self.avoid["HIT"] , 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Mit Hit:", self.avoid["MHIT"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Parry:", self.avoid["PARRY"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Dodge:", self.avoid["DODGE"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Miss:", self.avoid["MISS"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Reflect:", self.avoid["REFLECT"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Deflect:", self.avoid["DEFLECT"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Block:", self.avoid["BLOCK"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Immune:", self.avoid["IMMUNE"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Resist:", self.avoid["RESIST"] , 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Evade:", self.avoid["EVADE"] , 1, 1, 1, 1, 1, 1)

    GameTooltip:Show()
end

function PWBLog:onLeaves(frame)
	GameTooltip:Hide()
end
