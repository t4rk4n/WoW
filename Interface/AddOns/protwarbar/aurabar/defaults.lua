function PWBAuraBar:CreateDefaults()

	local auraPresets = {}

	auraPresets[871] = { -- Shield wall
		color = {0, 1, 0, 1},
		enabled = true
	}

	auraPresets[190456] = { -- Ignore pain
		color = {0, 0, 1, 1},
		enabled = true
	}

	auraPresets[2565] = { -- Shield block
		color = {1, 0, 0, 1},
		enabled = true
	}

	auraPresets[23920] = { -- Spell Reflection
		color = {0, 0.5, 0.5, 1},
		enabled = true
	}

	auraPresets[12975] = { -- Last stand
		color = {1, 1, 0, 1},
		enabled = true
	}

	auraPresets[97462] = { -- Rallying cry
		color = {0, 1, 1, 1},
		enabled = true
	}

	auraPresets[1160] = { -- Demo shout cry
		color = {0.5, 0.5, 1, 1},
		enabled = true
	}

	auraPresets[107574] = { -- Avatar
		color = {1, 0, 1, 1},
		enabled = true
	}

	auraPresets[12292] = { -- Bloodbath
		color = {1, 0, 1, 1},
		enabled = true
	}

	auraPresets[1719] = { -- Battle Cry
		color = {0.75, 0.75, 0.75, 1},
		enabled = true
	}

	auraPresets[203524] = { -- Neltharion's Fury
		color = {0.5, 1, 0.5, 1},
		enabled = true
	}

	auraPresets[13046] = { -- Enrage
		color = {0, 0, 0, 1},
		enabled = false
	}

	auraPresets[122509] = { -- Ultimatum
		color = {0.25, 0.25, 0.25, 1},
		enabled = false
	}

	auraPresets[46953] = { -- Sword and board
		color = {0.25, 0.9, 0, 1},
		enabled = false
	}

	auraPresets[152277] = { -- Ravager
		color = {0, 0.5, 0.25, 1},
		enabled = true
	}

	auraPresets[48792] = { -- Icebound Fortitude
		color = {0, 1, 0, 1},
		enabled = true
	}

	auraPresets[77535] = { -- Blood Shield
		color = {0, 0, 1, 1},
		enabled = true
	}

	auraPresets[48707] = { -- Anti-Magic Shell
		color = {1, 0, 0, 1},
		enabled = true
	}

	auraPresets[187617] = { -- Sanctus
		color = {1, 0.75, 0, 1},
		enabled = true
	}


	local defaults = {
		enabled = true,
		useDefaults = true,
		auras = auraPresets,
		barcount = 6,
		x = 600,
		y = 430,
		width = 250,
		height = 5,
		orientation = "HORIZONTAL",
		reverse = false,
		font = "Big Noodle",
		fontsize = 19,
		background = {0, 0, 0, 0.6},
		barTexture = "Solid",
	}

	return defaults
end
