function PWBIcon:CreateDefaults()

	local iconsPresets = {}

	iconsPresets[203524] = { -- Neltharion's Fury
		x = 522,
		y = 400,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[6343] = { -- Thunder Clap
		x = 560,
		y = 400,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[6572] = { -- Revenge
		x = 560,
		y = 438,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[23922] = { -- Shield Slam
		x = 522,
		y = 438,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[1160] = { -- Demo shout
		x = 701,
		y = 362,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[871] = { -- Shield wall
		x = 739,
		y = 362,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[12975] = { -- Last stand
		x = 777,
		y = 362,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[190456] = { -- Ignore pain
		x = 522,
		y = 478,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[2565] = { -- Shield block
		x = 560,
		y = 478,
		enabled = true,
		useDefaults = true,
	}

	iconsPresets[23920] = { -- Spell Reflection
		x = 663,
		y = 362,
		enabled = true,
		useDefaults = true,
	}

	local defaults = {
		enabled = true,
		icons = iconsPresets,
		useDefaults = true,
		startx = 475,
		starty = 600,
	}

	return defaults
end
