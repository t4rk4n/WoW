function PWBShieldbar:CreateDefaults()

	local shieldPresets = {}

	shieldPresets[190456] = { -- Ignore pain
		enabled = true
	}

	shieldPresets[174926] = { -- Shield Barrier (Arms, Fury)
		enabled = true
	}

	shieldPresets[77535] = { -- Blood Shield
		enabled = true
	}

	local defaults = {
		enabled = true,
		useDefaults = true,
		shields = shieldPresets,
		x = 600,
		y = 465,
		width = 250,
		height = 25,
		orientation = "HORIZONTAL",
		reverse = false,
		font = "Big Noodle",
		fontsize = 19,
		barBackground = {0, 0, 0, 0.6},
		barTexture = "Solid",
		shieldColor = {0.17, 0.25, 1, 1},
		healthColor1 = {0.5, 0, 0, 1},
		healthColor2 = {0.5, 0.25, 0, 1},
		healthColor3 = {0.25, 0.5, 0, 1},
		healthColor4 = {0, 0.5, 0, 1},
		healthlevel1 = 0,
		healthlevel2 = 30,
		healthlevel3 = 60,
		healthlevel4 = 90,
		textOffset = 10,
		healthbarEnabled = false,
		outline = true,
		shadowColor = {0, 0, 0, 1},
		shadowX = 0.8,
		shadowY = -0.8,
	}

	return defaults
end
