function Protwarbar:CreateDefaults()

	local autoloadOptions = {}
	autoloadOptions[1] = "Default"
	autoloadOptions[2] = "Default"
	autoloadOptions[3] = "Default"

	local defaults = {
		profile = {
			enabled = true,
			locked = true,
			hideooc = false,
			default = {
				appearence = {
					scale = 1,
					font = "Big Noodle",
					fontsize = 19,
					orientation = "HORIZONTAL",
					reverse = false,
					iconsize = 35,
					textureSize = 35,
					border = "None",
					edgeSize = 16,
					barTexture = "Solid",
					background = {0, 0, 0, 0.0},
					barBackground = {0, 0, 0, 0.6},
					unlockbg = {0, 0.6, 0, 1},
					lowRageAlpha = 0.5,
					hideOnCD = false,
					outline = true,
					shadowColor = {0, 0, 0, 1},
					shadowX = 0.8,
					shadowY = -0.8,
					textOffset = 10,
				}
			}
		},
		global = {
			autoloadEnabled = false,
			autoload = autoloadOptions,
		}

	}

	return defaults

end
