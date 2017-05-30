local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")
local media = LibStub("LibSharedMedia-3.0")

function PWBAuraBar:CreateOptions()

	local textures = media:List("statusbar")
	local fonts = media:List("font")
	local backgrounds = media:List("background")

	local abilities = PWBAuraBar:GenerateOptions()

	local options = {
		type = "group",
		name = "Aurabar",
		childGroups = "tab",
		args = {
			group1 = {
				name = L["General"],
				type = "group",
				order = 1,
				args = {
					enable = {
					  	order = 1,
					  	name = L["Enable"],
					  	desc = L["Enable this module"],
					  	type = "toggle",
					  	set = function(info,val) self.db.enabled = val PWBAuraBar:PWB_UPDATE_HANDLERS() PWBAuraBar:RefreshConfig() end,
					  	get = function(info) return self.db.enabled end
					},
				},
			},
			group2 = {
				name = L["Position"],
				type = "group",
				order = 2,
				args = {
					desc_pos = {
						type = 'header',
						name = L["Position"],
						order = 1,
					},
					x = {
						order = 3,
						name = L["X"],
						desc = L["X position"],
						type = "range",
						min = 1,
						max = 2560,
						step = 1,
						set = function(info,val) self.db.x = val PWBAuraBar:RefreshConfig() end,
						get = function(info) return self.db.x end
					},
					y = {
						order = 3,
						name = L["Y"],
						desc = L["Y position"],
						type = "range",
						min = 1,
						max = 2048,
						step = 1,
						set = function(info,val) self.db.y = val PWBAuraBar:RefreshConfig() end,
						get = function(info) return self.db.y end
					},
					desc_6 = {
						type = 'description',
						name = " ",
						order = 6,
					},
					width = {
						order = 7,
						name = L["Width"],
						desc = L["Width of bar"],
						type = "range",
						min = 5,
						max = 750,
						step = 1,
						set = function(info,val) self.db.width = val PWBAuraBar:RefreshConfig() end,
						get = function(info) return self.db.width end
					},
					height = {
						order = 8,
						name = L["Height"],
						desc = L["Height of bar"],
						type = "range",
						min = 5,
						max = 750,
						step = 1,
						set = function(info,val) self.db.height = val PWBAuraBar:RefreshConfig() end,
						get = function(info) return self.db.height end
					},
				}
			},
			group4 = {
				name = L["Appearance"],
				type = "group",
				order = 4,
				args = {
					enable = {
						order = 1,
						name = L["Use defaults"],
						desc = L["Use defaults"],
						type = "toggle",
						set = function(info,val) self.db.useDefaults = val PWBAuraBar:RefreshConfig() end,
						get = function(info) return self.db.useDefaults end
					},
					head_bar = {
						type = 'header',
						name = L["Bar options"],
						order = 9,
					},
					reverse = {
					  order = 10,
					  name = L["Reverse"],
					  desc = L["Reverse the direction the bars fill up"],
					  type = "toggle",
					  disabled = function() return self.db.useDefaults == true end,
					  set = function(info,val) self.db.reverse = val PWBAuraBar:RefreshConfig() end,
					  get = function(info) return self.db.reverse end
					},
					orient = {
						order = 13,
						name = L["Orientation"],
						desc = L["Orientation of the bar"],
						type = "select",
						disabled = function() return self.db.useDefaults == true end,
						values = function()
							orientations = {
								["HORIZONTAL"] = L["Horizontal"],
								["VERTICAL"] = L["Vertical"],
							}
							return orientations
						end,
						set = function(info, v)
								self.db.orientation = v
								PWBAuraBar:RefreshConfig()
							end,
						get = function(info) return self.db.orientation end
					},
					barTexture = {
						name = L["Texture"],
						desc = L["Texture"],
						type = "select",
						disabled = function() return self.db.useDefaults == true end,
						values = textures,
						order = 15,
						width = "normal",
						set = function(info, v)
								self.db.barTexture = media:List("statusbar")[v]
								PWBAuraBar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("statusbar", self.db.barTexture) end
					},
					head_bg = {
						type = 'header',
						name = L["Frame options"],
						order = 31,
					},
					bg = {
						name = L["Background color"],
						desc = L["Background color"],
						type = "color",
						disabled = function() return self.db.useDefaults == true end,
						order = 33,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.background[1] = r;
								self.db.background[2] = g;
								self.db.background[3] = b;
								self.db.background[4] = a;
								PWBAuraBar:RefreshConfig()
								end,
						get = function(info) return self.db.background[1], self.db.background[2],
													self.db.background[3], self.db.background[4]
							end
					},



				}
			},
			group3 = {
				name = L["Auras"],
				type = "group",
				order = 3,
				childGroups = "tree",
				args = abilities
			}
		}
	}
	return options
end


function PWBAuraBar:GenerateOptions()
	local options = {}

	for id, ability in pairs(self.auraList) do
		options[tostring(id)] = PWBAuraBar:GenerateAbiltyOptions(ability, id)
	end

	return options
end

function PWBAuraBar:GenerateAbiltyOptions(ability, id)

	local abillityName = GetSpellInfo(id)

	if ability.extraname ~= nil then
		abillityName = abillityName .. " (" .. ability.extraname .. ")"
	end

	local options = {
		name = abillityName,
		type = "group",
		order = 4,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				desc = L["Enables this aura"],
				type = "toggle",
				set = function(info,val) self.db.auras[id].enabled = val PWBAuraBar:RefreshConfig() end,
				get = function(info) return self.db.auras[id].enabled end
			},
			bg = {
				name = L["Background color"],
				desc = L["Background color"],
				type = "color",
				order = 33,
				width = "normal",
				hasAlpha = true,
				set = function(info, r, g, b, a)
						self.db.auras[id].color[1] = r;
						self.db.auras[id].color[2] = g;
						self.db.auras[id].color[3] = b;
						self.db.auras[id].color[4] = a;
						PWBAuraBar:RefreshConfig()
						end,
				get = function(info) return self.db.auras[id].color[1], self.db.auras[id].color[2],
											self.db.auras[id].color[3], self.db.auras[id].color[4]
					end
			},
		}
	}

	return options

end
