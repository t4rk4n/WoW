function PWBIcon:createIcon(ability, id)
	local icon = PWBIconFrame.new(ability.name .. " Icon", self.db.icons[id])
	icon:Texture(GetSpellTexture(id))
	return icon
end

function PWBIcon:UpdateIconStyling(id)
	self.iconFrames[id]:Update()
end

function PWBIcon:UpdateIconVisiblity(id)
	local visible = self.db.icons[id].enabled and self.db.enabled and Protwarbar:IsVisible()
	local active = true

	if self.iconList[id].talent ~= nil then
		active = Protwarbar.talents[self.iconList[id].talent]
	end

	if visible and active then
		self.iconFrames[id]:Show()
	else
		self.iconFrames[id]:Hide()
	end
end

function PWBIcon:UpdateStyling()
	for id, ability in pairs(self.iconList) do
		PWBIcon:UpdateIconStyling(id)
	end
end

function PWBIcon:UpdateVisiblity()
	for id, ability in pairs(self.iconList) do
		PWBIcon:UpdateIconVisiblity(id)
	end
end

function PWBIcon:UpdateSettings()
	for id, ability in pairs(self.iconList) do
		self.iconFrames[id]:UpdateSettings(self.db.icons[id])
	end	
end
