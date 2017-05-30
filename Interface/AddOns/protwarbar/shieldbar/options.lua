local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")
local media = LibStub("LibSharedMedia-3.0")

function PWBShieldbar:CreateOptions()

	local textures = media:List("statusbar")
	local fonts = media:List("font")
	local backgrounds = media:List("background")

	local abilities = PWBShieldbar:GenerateOptions()

	local options = {
		type = "group",
		name = L["Shieldbar"],
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
						set = function(info,val) self.db.enabled = val PWBShieldbar:PWB_UPDATE_HANDLERS() PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.enabled end
					},
					desc_hp = {
						type = 'header',
						name = L["Healthbar"],
						order = 11,
					},
					enablehp = {
						order = 13,
						name = L["Combine healthbar and shieldbar"],
						desc = L["Combine healthbar and shieldbar"],
						type = "toggle",
						width = "full",
						set = function(info,val) self.db.healthbarEnabled = val PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.healthbarEnabled end
					},

				},
			},
			group4 = {
				name = L["Position"],
				type = "group",
				order = 3,
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
						set = function(info,val) self.db.x = val PWBShieldbar:RefreshConfig() end,
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
						set = function(info,val) self.db.y = val PWBShieldbar:RefreshConfig() end,
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
						set = function(info,val) self.db.width = val PWBShieldbar:RefreshConfig() end,
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
						set = function(info,val) self.db.height = val PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.height end
					},
					desc_9 = {
						type = 'description',
						name = " ",
						order = 9,
					},
				},
			},
			group5 = {
				name = L["Bar colors"],
				type = "group",
				order = 5,
				args = {
					desc_shields = {
						type = 'header',
						name = L["Shields"],
						order = 1,
					},
					shieldcolor = {
						order = 3,
						name = L["Shield Color"],
						desc = L["Shield Color"],
						type = "color",
						hasAlpha = true,
						set = function(info, r, g, b, a)
							self.db.shieldColor[1] = r;
							self.db.shieldColor[2] = g;
							self.db.shieldColor[3] = b;
							self.db.shieldColor[4] = a;
								PWBShieldbar:RefreshConfig()
								end,
						get = function(info) return self.db.shieldColor[1], self.db.shieldColor[2],
													self.db.shieldColor[3], self.db.shieldColor[4]
							end
					},
					header_health = {
						type = 'header',
						name = L["Health"],
						order = 11,
					},
					level1 = {
						order = 12,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 100,
						step = 1,
						set = function(info,val) self.db.healthlevel1 = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.healthlevel1 end
					},
					color1 = {
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						order = 15,
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.healthColor1[1] = r;
								self.db.healthColor1[2] = g;
								self.db.healthColor1[3] = b;
								self.db.healthColor1[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.healthColor1[1], self.db.healthColor1[2],
													self.db.healthColor1[3], self.db.healthColor1[4]
							end
					},
					desc_color1 = {
						type = 'description',
						name = " ",
						order = 19,
					},
					level2 = {
						order = 22,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 100,
						step = 1,
						set = function(info,val) self.db.healthlevel2 = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.healthlevel2 end
					},
					color2 = {
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						order = 25,
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.healthColor2[1] = r;
								self.db.healthColor2[2] = g;
								self.db.healthColor2[3] = b;
								self.db.healthColor2[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.healthColor2[1], self.db.healthColor2[2],
													self.db.healthColor2[3], self.db.healthColor2[4]
							end
					},
					desc_color2 = {
						type = 'description',
						name = " ",
						order = 29,
					},
					level3 = {
						order = 32,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 100,
						step = 1,
						set = function(info,val) self.db.healthlevel3 = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.healthlevel3 end
					},
					color3 = {
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						order = 35,
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.healthColor3[1] = r;
								self.db.healthColor3[2] = g;
								self.db.healthColor3[3] = b;
								self.db.healthColor3[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.healthColor3[1], self.db.healthColor3[2],
													self.db.healthColor3[3], self.db.healthColor3[4]
							end
					},
					desc_color3 = {
						type = 'description',
						name = " ",
						order = 39,
					},
					level4 = {
						order = 42,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 100,
						step = 1,
						set = function(info,val) self.db.healthlevel4 = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.healthlevel4 end
					},
					color4 = {
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						order = 45,
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.healthColor4[1] = r;
								self.db.healthColor4[2] = g;
								self.db.healthColor4[3] = b;
								self.db.healthColor4[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.healthColor4[1], self.db.healthColor4[2],
													self.db.healthColor4[3], self.db.healthColor4[4]
							end
					},
				},
			},

			group6 = {
				name = L["Appearance"],
				type = "group",
				order = 6,
				args = {
					desc_app_head = {
						type = 'header',
						name = L["Appearance"],
						order = 5,
					},
					enable = {
						order = 7,
						name = L["Use defaults"],
						desc = L["Use defaults"],
						type = "toggle",
						set = function(info,val) self.db.useDefaults = val PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.useDefaults end
					},
					desc_bg_head = {
						type = 'header',
						name = L["Bar options"],
						order = 11,
					},
					reverse = {
					  order = 13,
					  name = L["Reverse"],
					  desc = L["Reverse the direction the bars fill up"],
					  disabled = function() return self.db.useDefaults == true end,
					  type = "toggle",
					  set = function(info,val) self.db.reverse = val PWBShieldbar:RefreshConfig() end,
					  get = function(info) return self.db.reverse end
					},
					orient = {
						order = 15,
						name = L["Orientation"],
						desc = L["Orientation of the bar"],
						disabled = function() return self.db.useDefaults == true end,
						type = "select",
						values = function()
							orientations = {
								["HORIZONTAL"] = L["Horizontal"],
								["VERTICAL"] = L["Vertical"],
							}
							return orientations
						end,
						set = function(info, v)
								self.db.orientation = v
								PWBShieldbar:RefreshConfig()
							end,
						get = function(info) return self.db.orientation end
					},

					desc_12 = {
						type = 'description',
						name = " ",
						order = 17,
					},

					bg = {
						name = L["Background color"],
						desc = L["Color of bar Background"],
						disabled = function() return self.db.useDefaults == true end,
						type = "color",
						order = 31,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.barBackground[1] = r;
								self.db.barBackground[2] = g;
								self.db.barBackground[3] = b;
								self.db.barBackground[4] = a;
								PWBShieldbar:RefreshConfig()
								end,
						get = function(info) return self.db.barBackground[1], self.db.barBackground[2],
													self.db.barBackground[3], self.db.barBackground[4]
							end
					},
					barTexture = {
						name = L["Texture"],
						desc = L["Texture"],
						disabled = function() return self.db.useDefaults == true end,
						type = "select",
						values = textures,
						order = 34,
						width = "normal",
						set = function(info, v)
								self.db.barTexture = media:List("statusbar")[v]
								PWBShieldbar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("statusbar", self.db.barTexture) end
					},


					desc_bg = {
						type = 'header',
						name = L["Font options"],
						order = 50,
					},
					fontsize = {
						order = 51,
						name = L["Font Size"],
						desc = L["Font Size"],
						disabled = function() return self.db.useDefaults == true end,
						type = "range",
						min = 3,
						max = 50,
						step = 1,
						set = function(info,val) self.db.fontsize = val PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.fontsize end
					},
					barFont = {
						name = L["Font"],
						desc = L["Font"],
						disabled = function() return self.db.useDefaults == true end,
						type = "select",
						values = fonts,
						order = 52,
						set = function(info, v)
								self.db.font = media:List("font")[v]
								PWBShieldbar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.font) end
					},
					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						type = "toggle",
						disabled = function() return self.db.useDefaults == true end,
						order = 61,
						set = function(info, v)
								self.db.outline = v
								PWBShieldbar:RefreshConfig()
							end,
						get = function(info) return self.db.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.useDefaults == true or self.db.outline == true end,
						order = 63,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.shadowColor[1] = r;
								self.db.shadowColor[2] = g;
								self.db.shadowColor[3] = b;
								self.db.shadowColor[4] = a;
								PWBShieldbar:RefreshConfig()
								end,
						get = function(info) return self.db.shadowColor[1], self.db.shadowColor[2],
													self.db.shadowColor[3], self.db.shadowColor[4]
							end
					},
					shadowx = {
						order = 65,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.useDefaults == true or self.db.outline == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shadowX = val PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.shadowX end
					},
					shadowy = {
						order = 67,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.useDefaults == true or self.db.outline == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shadowY = val PWBShieldbar:RefreshConfig() end,
						get = function(info) return self.db.shadowY end
					},

				},

			},
			group3 = {
				name = L["Shields"],
				type = "group",
				order = 3,
				childGroups = "tree",
				args = abilities
			}
		}
	}

	return options
end

function PWBShieldbar:GenerateOptions()
	local options = {}

	for id, ability in pairs(self.shieldList) do
		options[tostring(id)] = PWBShieldbar:GenerateAbiltyOptions(ability, id)
	end

	return options
end

function PWBShieldbar:GenerateAbiltyOptions(ability, id)
	local options = {
		name = GetSpellInfo(id),
		type = "group",
		order = 4,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				desc = L["Enables this shield"],
				type = "toggle",
				set = function(info,val) self.db.shields[id].enabled = val PWBShieldbar:RefreshConfig() end,
				get = function(info) return self.db.shields[id].enabled end
			},
		}
	}

	return options
end
