function PWBLog:CreateDefaults()
	local defaults = {
		enabled = false,
		useDefaults = true,
		x = 950,
		y = 400,
		font = "Big Noodle",
		background = {0, 0, 0, 0.6},
		fontsize = 19,
		averageTime = 5,
		outline = true,
		shadowColor = {0, 0, 0, 1},
		shadowX = 0.8,
		shadowY = -0.8,
		col1 = 60,
		col2 = 50,
		col3 = 10,
		lineheight = 20,
	}

	return defaults
end
