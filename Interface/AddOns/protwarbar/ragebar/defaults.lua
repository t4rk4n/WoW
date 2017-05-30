function PWBRagebar:CreateDefaults()
	local defaults = {
		enabled = true,
		useDefaults = true,
		x = 600,
		y = 400,
		width = 250,
		height = 25,
		orientation = "HORIZONTAL",
		reverse = false,
		font = "Big Noodle",
		fontsize = 19,
		outline = true,
		shadowColor = {0, 0, 0, 1},
		shadowX = 0.8,
		shadowY = -0.8,
		barBackground = {0, 0, 0, 0.6},
		barTexture = "Solid",
		barlevel = {10, 40, 60, 100},
		color1 = {0.7, 0.5, 1, 1},
		color2 = {0, 1, 1, 1},
		color3 = {0, 1, 0, 1},
		color4 = {1, 1, 1, 1},
		color5 = {1, 0, 0, 1},
	}

	return defaults
end
