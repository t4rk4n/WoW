function Protwarbar:SetDefaultMedia()

	local media = LibStub("LibSharedMedia-3.0")

	local defaultTextures = {
		{ text = "Blank", 				value = "Interface\\AddOns\\protwarbar\\media\\textures\\blank.tga", texture = "Interface\\AddOns\\protwarbar\\media\\textures\\blank.tga" },
		{ text = "Blizzard",			value = "Interface\\TargetingFrame\\UI-StatusBar", texture = "Interface\\TargetingFrame\\UI-StatusBar" },
		{ text = "Solid", 				value = "Interface\\AddOns\\protwarbar\\media\\textures\\solid.tga", texture = "Interface\\AddOns\\protwarbar\\media\\textures\\solid.tga"},
	}

	local defaultFonts = {
		{ text = "Arial Narrow", 		value = "Fonts\\ARIALN.TTF", font = "Fonts\\ARIALN.TTF" },
		{ text = "Big Noodle", 			value = "Interface\\AddOns\\protwarbar\\media\\fonts\\BigNoodle.ttf", font = "Interface\\AddOns\\protwarbar\\media\\fonts\\BigNoodle.ttf" },
		{ text = "Friz Quadrata TT", 	value = "Fonts\\FRIZQT__.TTF", font = "Fonts\\FRIZQT__.TTF" },
		{ text = "Morpheus", 			value = "Fonts\\MORPHEUS.ttf", font = "Fonts\\MORPHEUS.ttf" },
		{ text = "Skurri", 				value = "Fonts\\skurri.ttf", font = "Fonts\\skurri.ttf" },
	}

	for i = 1, #defaultTextures do
		media:Register("statusbar", defaultTextures[i].text, defaultTextures[i].texture)
	end

	for i = 1, #defaultFonts do
		media:Register("font", defaultFonts[i].text, defaultFonts[i].font)
	end
end
