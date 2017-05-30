local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")
local media = LibStub("LibSharedMedia-3.0")

function PWBRagebar:CreateOptions()

	local textures = media:List("statusbar")
	local fonts = media:List("font")
	local backgrounds = media:List("background")

	local options = {
		type = "group",
		name = L["Ragebar"],
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
					  	set = function(info,val) self.db.enabled = val PWBRagebar:PWB_UPDATE_HANDLERS() PWBRagebar:RefreshConfig() end,
					  	get = function(info) return self.db.enabled end
					},
				},
			},
			group3 = {
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
						set = function(info,val) self.db.x = val PWBRagebar:RefreshConfig() end,
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
						set = function(info,val) self.db.y = val PWBRagebar:RefreshConfig() end,
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
						set = function(info,val) self.db.width = val PWBRagebar:RefreshConfig() end,
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
						set = function(info,val) self.db.height = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.height end
					},
					desc_9 = {
						type = 'description',
						name = " ",
						order = 9,
					},
				},
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
						set = function(info,val) self.db.useDefaults = val PWBRagebar:RefreshConfig() end,
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
					  set = function(info,val) self.db.reverse = val PWBRagebar:RefreshConfig() end,
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
								PWBRagebar:RefreshConfig()
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
								PWBRagebar:RefreshConfig()
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
								PWBRagebar:RefreshConfig()
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
						set = function(info,val) self.db.fontsize = val PWBRagebar:RefreshConfig() end,
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
								PWBRagebar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.font) end
					},
					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						disabled = function() return self.db.useDefaults == true end,
						type = "toggle",
						order = 55,
						set = function(info, v)
								self.db.outline = v
								PWBRagebar:RefreshConfig()
							end,
						get = function(info) return self.db.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.outline == true or self.db.useDefaults == true end,
						order = 57,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.shadowColor[1] = r;
								self.db.shadowColor[2] = g;
								self.db.shadowColor[3] = b;
								self.db.shadowColor[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.shadowColor[1], self.db.shadowColor[2],
													self.db.shadowColor[3], self.db.shadowColor[4]
							end
					},
					shadowx = {
						order = 59,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.outline == true or self.db.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shadowX = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.shadowX end
					},
					shadowy = {
						order = 61,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.outline == true or self.db.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shadowY = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.shadowY end
					},
				},
			},
			group2 = {
				name = L["Bar colors"],
				type = "group",
				order = 2,
				args = {
					desc_colour = {
						type = 'header',
						name = L["Bar colors"],
						order = 1,
					},
					level1 = {
						order = 10,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 120,
						step = 1,
						set = function(info,val) self.db.barlevel[1] = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.barlevel[1] end
					},
					color1 = {
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						order = 15,
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.color1[1] = r;
								self.db.color1[2] = g;
								self.db.color1[3] = b;
								self.db.color1[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.color1[1], self.db.color1[2],
													self.db.color1[3], self.db.color1[4]
							end
					},
					desc_color1 = {
						type = 'description',
						name = " ",
						order = 19,
					},
					level2 = {
						order = 20,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 120,
						step = 1,
						set = function(info,val) self.db.barlevel[2] = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.barlevel[2] end
					},
					color2 = {
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						order = 25,
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.color2[1] = r;
								self.db.color2[2] = g;
								self.db.color2[3] = b;
								self.db.color2[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.color2[1], self.db.color2[2],
													self.db.color2[3], self.db.color2[4]
							end
					},
					desc_color2 = {
						type = 'description',
						name = " ",
						order = 29,
					},
					level3 = {
						order = 30,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 120,
						step = 1,
						set = function(info,val) self.db.barlevel[3] = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.barlevel[3] end
					},
					color3 = {
						order = 35,
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.color3[1] = r;
								self.db.color3[2] = g;
								self.db.color3[3] = b;
								self.db.color3[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.color3[1], self.db.color3[2],
													self.db.color3[3], self.db.color3[4]
							end
					},
					desc_color3 = {
						type = 'description',
						name = " ",
						order = 39,
					},
					level4 = {
						order = 40,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 0,
						max = 120,
						step = 1,
						set = function(info,val) self.db.barlevel[4] = val PWBRagebar:RefreshConfig() end,
						get = function(info) return self.db.barlevel[4] end
					},
					color4 = {
						order = 45,
						name = L["Threshold color"],
						desc = L["Threshold color"],
						type = "color",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.color4[1] = r;
								self.db.color4[2] = g;
								self.db.color4[3] = b;
								self.db.color4[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.color4[1], self.db.color4[2],
													self.db.color4[3], self.db.color4[4]
							end
					},
					desc_color4 = {
						type = 'description',
						name = " ",
						order = 49,
					},
					level5 = {
						order = 50,
						name = L["Threshold"],
						desc = L["Threshold"],
						type = "range",
						min = 120,
						max = 120,
						step = 1,
						set = function(info,val)  end,
						get = function(info) return 120 end
					},
					color5 = {
						order = 55,
						name = L["Color full bar"],
						desc = L["Color full bar"],
						type = "color",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.color5[1] = r;
								self.db.color5[2] = g;
								self.db.color5[3] = b;
								self.db.color5[4] = a;
								PWBRagebar:RefreshConfig()
								end,
						get = function(info) return self.db.color5[1], self.db.color5[2],
													self.db.color5[3], self.db.color5[4]
							end
					},
				},
			},
		}
	}

	return options
end
