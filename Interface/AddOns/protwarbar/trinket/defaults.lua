function PWBTrinket:CreateDefaults()
	local trinketspot = {}

	trinketspot[1] = {
		x = 701,
		y = 324,
		useDefaults = true,
		iconsize = 35,
		textureSize = 35,
		border = "None",
		edgeSize = 16,
	}

	trinketspot[2] = {
		x = 739,
		y = 324,
		useDefaults = true,
		iconsize = 35,
		textureSize = 35,
		border = "None",
		edgeSize = 16,
	}

	local defaults = {
		enabled = true,
		trinkets = {},
		position = trinketspot,
	}

	return defaults
end
