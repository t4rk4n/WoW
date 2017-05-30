local media = LibStub("LibSharedMedia-3.0")

PWBTextFrame = {}
PWBTextFrame.__index = PWBTextFrame

function PWBTextFrame.new(name, db)
	local self = setmetatable({}, PWBTextFrame)
	self.db = db
	self.name = name
	self.scale = Protwarbar.db.profile.default.appearence.scale

	self.frame = CreateFrame("Frame", "PWB:" .. name, UIParent)
	self.frame:SetFrameStrata("BACKGROUND")
	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)
	self.frame:SetBackdrop({bgFile = media:Fetch("background", "Blizzard Tooltip"), tile = false})
	self.frame:RegisterForDrag('LeftButton')
	self.frame:SetClampedToScreen(true)

	self.frame:SetScript("OnDragStart", function(s) PWBTextFrame.Dragstart(self) end )
	self.frame:SetScript('OnDragStop', function(s) PWBTextFrame.Dragstop(self) end )

	return self
end

function PWBTextFrame:UpdateSettings(db)
	self.db = db
end

function PWBTextFrame:Update(options)
	if options == nil then
		options = {}
	end

	local scale = Protwarbar.db.profile.default.appearence.scale

	local wscale = options.widthScale or 1
	self.frame:SetWidth(self.db.width * wscale * scale )

	local hscale = options.heightScale or 1
	self.frame:SetHeight(self.db.height * hscale * scale)

	self.frame:SetMovable(not Protwarbar.db.profile.locked)
	self.frame:EnableMouse(options.enableMouse or (not Protwarbar.db.profile.locked))
	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)
end

function PWBTextFrame:CreateTextField()
	local style = Protwarbar:GetStyle(self.db)

	local textField = self.frame:CreateFontString(nil, "OVERLAY")
	textField:SetPoint("CENTER", 0, 0);
	textField:SetFont(media:Fetch("font", style.font), style.fontsize, "OUTLINE")
	textField:SetJustifyH("CENTER")
	textField:SetText("")

	return textField
end

function PWBTextFrame:UpdateTextField(textField)
	local style = Protwarbar:GetStyle(self.db)

	textField:SetPoint("CENTER", 0, 0);
	textField:SetSize(self.db.width - style.textOffset, self.db.height)

	if style.outline then
		textField:SetFont(media:Fetch("font", style.font), style.fontsize, "OUTLINE")
		textField:SetShadowOffset(0, 0)
	else
		textField:SetFont(media:Fetch("font", style.font), style.fontsize)
		textField:SetShadowColor(style.shadowColor[1], style.shadowColor[2], style.shadowColor[3], style.shadowColor[4])
		textField:SetShadowOffset(style.shadowX, style.shadowY)
	end
end

function PWBTextFrame:UpdateBackdrop()
	local style = Protwarbar:GetStyle(self.db)
	local color = style["background"]

	if Protwarbar.db.profile.locked then
		self.frame:SetBackdropColor(color[1], color[2],color[3], color[4])
	else
		self.frame:SetBackdropColor(Protwarbar.db.profile.default.appearence.unlockbg[1],
			Protwarbar.db.profile.default.appearence.unlockbg[2],
			Protwarbar.db.profile.default.appearence.unlockbg[3],
			Protwarbar.db.profile.default.appearence.unlockbg[4])
	end
end

function PWBTextFrame:Show()
	self.frame:Show()
end

function PWBTextFrame:Hide()
	self.frame:Hide()
end

function PWBTextFrame:Dragstart()
	if not Protwarbar.db.profile.locked then
		self.frame:StartMoving()
	end
end

function PWBTextFrame:Dragstop()
	self.frame:StopMovingOrSizing()
 	self.db.x = self.frame:GetLeft()
 	self.db.y = self.frame:GetBottom()
end
-------------------------------------

PWBIconFrame = {}
PWBIconFrame.__index = PWBIconFrame

function PWBIconFrame.new(name, db)
	local self = setmetatable({}, PWBIconFrame)
	self.db = db

	self.frame = CreateFrame("Frame", "PWB:" .. name, UIParent)
	self.frame:SetFrameStrata("BACKGROUND")
	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)
	self.frame:SetBackdrop({bgFile = media:Fetch("background", "Blizzard Tooltip"), tile = false})
	self.frame:RegisterForDrag('LeftButton')
	self.frame:SetClampedToScreen(true)

	self.frame:SetScript("OnDragStart", function(s) PWBIconFrame.Dragstart(self) end )
	self.frame:SetScript('OnDragStop', function(s) PWBIconFrame.Dragstop(self) end )

	return self
end

function PWBIconFrame:UpdateSettings(db)
	self.db = db
end

function PWBIconFrame:Texture(texture)
	self.frame.texture = self.frame:CreateTexture(nil, "BACKGROUND")
	self.frame.texture:SetPoint("CENTER")
	self.frame.texture:SetTexture(texture)
end	

function PWBIconFrame:UpdateTexture(texture)
	self.frame.texture:SetTexture(texture)
	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)
end

function PWBIconFrame:TextureAlpha(alpha)
	self.frame.texture:SetAlpha(alpha)
end

function PWBIconFrame:Update()
	local style = Protwarbar:GetStyle(self.db)
	local scale = Protwarbar.db.profile.default.appearence.scale

	self.frame:SetWidth(style.iconsize * scale)
	self.frame:SetHeight(style.iconsize * scale)
	self.frame:SetMovable(not Protwarbar.db.profile.locked)
	self.frame:EnableMouse(not Protwarbar.db.profile.locked)

	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)

	self.frame:SetBackdrop({bgFile = media:Fetch("background", "None"),
												edgeFile = media:Fetch("border", style.border),
			                                    tile = false, edgeSize = style.edgeSize})
	self.frame.texture:SetWidth(style.textureSize * scale)
	self.frame.texture:SetHeight(style.textureSize * scale)
end

function PWBIconFrame:Show()
	self.frame:Show()
end

function PWBIconFrame:Hide()
	self.frame:Hide()
end

function PWBIconFrame:Dragstart()
	if not Protwarbar.db.profile.locked then
		self.frame:StartMoving()
	end
end

function PWBIconFrame:Dragstop()
	self.frame:StopMovingOrSizing()
 	self.db.x = self.frame:GetLeft()
 	self.db.y = self.frame:GetBottom()
end

---------------------------------------------------------------------------

PWBBarFrame = {}
PWBBarFrame.__index = PWBBarFrame

function PWBBarFrame.new(name, db, options)
	local self = setmetatable({}, PWBBarFrame)
	self.db = db

	if options == nil then
		options = {}
	end

	self.frame = CreateFrame("Frame", "PWB:" .. name, UIParent)
	self.frame:SetFrameStrata(options.strata or "BACKGROUND")
	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)
	self.frame:SetBackdrop({bgFile = media:Fetch("background", "Blizzard Tooltip"), tile = false})

	if options.static == nil then 
		self.frame:RegisterForDrag('LeftButton')
		self.frame:SetClampedToScreen(true)
		self.frame:SetScript("OnDragStart", function(s) PWBBarFrame.Dragstart(self) end )
		self.frame:SetScript('OnDragStop', function(s) PWBBarFrame.Dragstop(self) end )
	end

	return self
end

function PWBBarFrame:UpdateSettings(db)
	self.db = db
end

function PWBBarFrame:UpdateFrame(options)
	if options == nil then
		options = {}
	end

	local scale = Protwarbar.db.profile.default.appearence.scale
	local wscale = options.widthScale or 1
	local hscale = options.heightScale or 1

	self.frame:SetWidth(self.db.width * wscale * scale )
	self.frame:SetHeight(self.db.height * hscale * scale)	
	
	self.frame:SetMovable(not Protwarbar.db.profile.locked)
	self.frame:EnableMouse(not Protwarbar.db.profile.locked)
	self.frame:SetPoint("BOTTOMLEFT", self.db.x, self.db.y)
end


function PWBBarFrame:CreateTextField(options)
	if options == nil then
		options = {}
	end

	local style = Protwarbar:GetStyle(self.db)
	local textField = nil

	if options.frame == nil then 
		textField = self.frame:CreateFontString(nil, "OVERLAY")
	else
		textField = options.frame:CreateFontString(nil, "OVERLAY")
	end

	textField:SetPoint((options.point or "CENTER"), (options.pointX or 0), (options.pointY or 0));
	textField:SetFont(media:Fetch("font", style.font), style.fontsize, "OUTLINE")
	textField:SetJustifyH(options.justify or "CENTER")
	textField:SetText(options.text or "")

	return textField
end

function PWBBarFrame:UpdateTextField(textfield, options)
	if options == nil then
		options = {}
	end

	local style = Protwarbar:GetStyle(self.db)

	textfield:SetPoint((options.point or "CENTER"), (options.pointX or 0), (options.pointY or 0));

	local wscale = options.widthScale or 1
	textfield:SetSize(self.db.width * wscale - style.textOffset, options.height or self.db.height)

	if style.outline then
		textfield:SetFont(media:Fetch("font", style.font), style.fontsize, "OUTLINE")
		textfield:SetShadowOffset(0, 0)
	else
		textfield:SetFont(media:Fetch("font", style.font), style.fontsize)
		textfield:SetShadowColor(style.shadowColor[1], style.shadowColor[2], style.shadowColor[3], style.shadowColor[4])
		textfield:SetShadowOffset(style.shadowX, style.shadowY)
	end
end

function PWBBarFrame:StatusBar(name, options)
	if options == nil then
		options = {}
	end

	local bar = CreateFrame("StatusBar", "PWB:" .. name, self.frame)
	bar:SetFrameStrata(options.strata or "BACKGROUND")
	bar:SetOrientation(self.db.orientation)
	bar:SetMinMaxValues(0, options.max or 100)
	bar:SetValue(options.val or 0)
	bar:SetPoint("BOTTOMLEFT", 0, 0)

	return bar
end

function PWBBarFrame:SetMaxValue(bar, max)
	bar:SetMinMaxValues(0, max)
end

function PWBBarFrame:UpdateStatusBar(bar, options)
	if options == nil then
		options = {}
	end

	local style = Protwarbar:GetStyle(self.db)
	local scale = Protwarbar.db.profile.default.appearence.scale

	bar:SetStatusBarTexture(media:Fetch("statusbar", style.barTexture))
	bar:SetOrientation(style.orientation)
	bar:SetReverseFill(style.reverse)

	if options.color ~= nil then
		bar:SetStatusBarColor(options.color[1], options.color[2], options.color[3], options.color[4])
	end

	bar:SetWidth(self.db.width * scale)
	bar:SetHeight(self.db.height * scale)
	
	local y = 0
	if options.yscaler ~= nil then
		y = options.yscaler * self.db.height * scale
	end
	bar:SetPoint("BOTTOMLEFT", 0, y)
end


function PWBBarFrame:UpdateBackdrop(options)
	local style = Protwarbar:GetStyle(self.db)

	if options == nil then
		options = {}
	end	

	local color = {0,0,0,0}
	local key = options.background or "background"

	if not options.hidden then
		color = style[key]
	end

	if Protwarbar.db.profile.locked or options.hidden then
		self.frame:SetBackdropColor(color[1], color[2],color[3], color[4])
	else
		self.frame:SetBackdropColor(Protwarbar.db.profile.default.appearence.unlockbg[1],
			Protwarbar.db.profile.default.appearence.unlockbg[2],
			Protwarbar.db.profile.default.appearence.unlockbg[3],
			Protwarbar.db.profile.default.appearence.unlockbg[4])
	end
end

function PWBBarFrame:Show()
	self.frame:Show()
end

function PWBBarFrame:Hide()
	self.frame:Hide()
end

function PWBBarFrame:Dragstart()
	if not Protwarbar.db.profile.locked then
		self.frame:StartMoving()
	end
end

function PWBBarFrame:Dragstop()
	self.frame:StopMovingOrSizing()
 	self.db.x = self.frame:GetLeft()
 	self.db.y = self.frame:GetBottom()
end


function Protwarbar:GetStyle(localStyle)

	local style = nil

	if localStyle.useDefaults then
		style = Protwarbar.db.profile.default.appearence
	else
		style = localStyle

		if style.shadowColor == nil then
			style.shadowColor = Protwarbar.db.profile.default.appearence.shadowColor
		end

		if style.shadowX == nil then
			style.shadowX = Protwarbar.db.profile.default.appearence.shadowX
		end

		if style.shadowY == nil then
			style.shadowY = Protwarbar.db.profile.default.appearence.shadowY
		end

		if style.textOffset == nil then
			style.textOffset = 0
		end

		if style.iconsize == nil then
			style.iconsize = Protwarbar.db.profile.default.appearence.iconsize
		end

		if style.textureSize == nil then
			style.textureSize = Protwarbar.db.profile.default.appearence.textureSize
		end

		if style.edgeSize == nil then
			style.edgeSize = Protwarbar.db.profile.default.appearence.edgeSize
		end

		if style.border == nil then
			style.border = Protwarbar.db.profile.default.appearence.border
		end
	end

	return style
end

-- function Protwarbar:UpdateFrame(frame, settings, options)
-- 	if options == nil then
-- 		options = {}
-- 	end

-- 	local scale = Protwarbar.db.profile.default.appearence.scale

-- 	local wscale = options.widthScale or 1
-- 	frame:SetWidth(settings.width * wscale * scale )

-- 	local hscale = options.heightScale or 1
-- 	frame:SetHeight(settings.height * hscale * scale)

-- 	frame:SetMovable(not Protwarbar.db.profile.locked)
-- 	frame:EnableMouse(options.enableMouse or (not Protwarbar.db.profile.locked))
-- 	frame:SetPoint("BOTTOMLEFT", settings.x, settings.y)
-- end


-- function Protwarbar:CreateTextField(frame, settings, options)
-- 	if options == nil then
-- 		options = {}
-- 	end

-- 	local style = Protwarbar:GetStyle(settings)

-- 	local textField = frame:CreateFontString()
-- 	textField:SetPoint((options.point or "CENTER"), (options.pointX or 0), (options.pointY or 0));
-- 	textField:SetFont(media:Fetch("font", style.font), style.fontsize, "OUTLINE")
-- 	textField:SetJustifyH(options.justify or "CENTER")
-- 	textField:SetText(options.text or "")

-- 	return textField
-- end

-- function Protwarbar:UpdateTextField(frame, settings, options)
-- 	if options == nil then
-- 		options = {}
-- 	end

-- 	local style = Protwarbar:GetStyle(settings)

-- 	frame:SetPoint((options.point or "CENTER"), (options.pointX or 0), (options.pointY or 0));

-- 	local wscale = options.widthScale or 1

-- 	frame:SetSize(settings.width * wscale - style.textOffset, options.height or settings.height)

-- 	if style.outline then
-- 		frame:SetFont(media:Fetch("font", style.font), style.fontsize, "OUTLINE")
-- 		frame:SetShadowOffset(0, 0)
-- 	else
-- 		frame:SetFont(media:Fetch("font", style.font), style.fontsize)
-- 		frame:SetShadowColor(style.shadowColor[1], style.shadowColor[2], style.shadowColor[3], style.shadowColor[4])
-- 		frame:SetShadowOffset(style.shadowX, style.shadowY)
-- 	end

-- end

-- function Protwarbar:UpdateStatusBar(frame, color, settings)
-- 	local style = Protwarbar:GetStyle(settings)
-- 	local scale = Protwarbar.db.profile.default.appearence.scale

-- 	frame:SetStatusBarTexture(media:Fetch("statusbar", style.barTexture))
-- 	frame:SetOrientation(style.orientation)
-- 	frame:SetReverseFill(style.reverse)

-- 	if color ~= nil then
-- 		frame:SetStatusBarColor(color[1], color[2], color[3], color[4])
-- 	end

-- 	frame:SetWidth(settings.width * scale)
-- 	frame:SetHeight(settings.height * scale)
-- 	frame:SetPoint("BOTTOMLEFT", 0, 0)
-- end

-- function Protwarbar:UpdateBackdropColor(frame, settings, key, options)
-- 	if options == nil then
-- 		options = {}
-- 	end

-- 	local style = Protwarbar:GetStyle(settings)

-- 	local color = {0,0,0,0}

-- 	if not options.hidden then
-- 		color = style[key]
-- 	end

-- 	if Protwarbar.db.profile.locked or options.hidden then
-- 		frame:SetBackdropColor(color[1], color[2],color[3], color[4])
-- 	else
-- 		frame:SetBackdropColor(Protwarbar.db.profile.default.appearence.unlockbg[1],
-- 			Protwarbar.db.profile.default.appearence.unlockbg[2],
-- 			Protwarbar.db.profile.default.appearence.unlockbg[3],
-- 			Protwarbar.db.profile.default.appearence.unlockbg[4])
-- 	end
-- end

function Protwarbar:Dragstart(frame)
	if not Protwarbar.db.profile.locked then
		frame:StartMoving()
	end
end
