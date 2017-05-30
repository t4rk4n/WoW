function PWBTrinket:createIcon(index)
	local icon = PWBIconFrame.new("Trinket ".. index .. " Icon", self.db.position[index])
	icon:Texture(nil)

	return icon
end

function PWBTrinket:UpdateStyling()
	for index, id in pairs(self.activeTrinkets) do
		self.trinketFrames[index]:Update()
		self.trinketFrames[index]:UpdateTexture(GetItemIcon(id))
	end
end

function PWBTrinket:UpdateVisiblity()
	self.trinketFrames[1]:Hide()
	self.trinketFrames[2]:Hide()

	if self.db.enabled and Protwarbar:IsVisible() then
		for index, id in pairs(self.activeTrinkets) do
			if self.db.trinkets[id].enabled then
				self.trinketFrames[index]:Show()
			end
		end
	end
end

function PWBTrinket:UpdateSettings()
	self.trinketFrames[1]:UpdateSettings(self.db.position[1])
	self.trinketFrames[2]:UpdateSettings(self.db.position[2])
end
