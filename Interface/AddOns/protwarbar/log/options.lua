function PWBLog:CreateOptions()
	local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")
	local media = LibStub("LibSharedMedia-3.0")
	local fonts = media:List("font")

	local options = {
		type = "group",
		name = L["Information"],
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
					  set = function(info,val) self.db.enabled = val PWBLog:PWB_UPDATE_HANDLERS() PWBLog:RefreshConfig() end,
					  get = function(info) return self.db.enabled end
					},
					exp = {
						type = 'description',
						name = L["|cFFFF0000This module is still in an expirimental state, and might not work as expected."],
						fontSize = "large",
						order = 2,
					},
				}

			},
			group2 = {
				name = L["Position"],
				type = "group",
				order = 2,
				args = {
					desc_pos = {
						type = 'header',
						name = L["Position"],
						order = 2,
					},
					x = {
						order = 4,
						name = L["X"],
						desc = L["X position"],
						type = "range",
						min = 1,
						max = 2560,
						step = 1,
						set = function(info,val) self.db.x = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.x end
					},
					you = {
						order = 5,
						name = L["Y"],
						desc = L["Y position"],
						type = "range",
						min = 1,
						max = 2048,
						step = 1,
						set = function(info,val) self.db.y = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.y end
					},
					desc_6 = {
						type = 'description',
						name = " ",
						order = 6,
					},
					col1width = {
						order = 21,
						name = L["Label width"],
						desc = L["Label width"],
						type = "range",
						min = 5,
						max = 100,
						step = 1,
						set = function(info,val) self.db.col1 = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.col1 end
					},
					col2width = {
						order = 23,
						name = L["Totals width"],
						desc = L["Totals width"],
						type = "range",
						min = 5,
						max = 100,
						step = 1,
						set = function(info,val) self.db.col2 = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.col2 end
					},
					col3width = {
						order = 25,
						name = L["Recent width"],
						desc = L["Recent width"],
						type = "range",
						min = 5,
						max = 100,
						step = 1,
						set = function(info,val) self.db.col3 = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.col3 end
					},
					linemarginwidth = {
						order = 27,
						name = L["Line height"],
						desc = L["Line height"],
						type = "range",
						min = 0,
						max = 50,
						step = 1,
						set = function(info,val) self.db.lineheight = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.lineheight end
					},
				},
			},
			group3 = {
				name = L["Appearance"],
				type = "group",
				order = 3,
				args = {
					enable = {
						order = 1,
						name = L["Use defaults"],
						desc = L["Use defaults"],
						type = "toggle",
						set = function(info,val) self.db.useDefaults = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.useDefaults end
					},
					desc_ven_head = {
						type = 'header',
						name = L["Font options"],
						order = 10,
					},
					venfontsize = {
						order = 11,
						name = L["Font Size"],
						desc = L["Font Size"],
						type = "range",
						disabled = function() return self.db.useDefaults == true end,
						min = 3,
						max = 50,
						step = 1,
						set = function(info,val) self.db.fontsize = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.fontsize end
					},
					venFont = {
						name = L["Font"],
						desc = L["Font"],
						type = "select",
						disabled = function() return self.db.useDefaults == true end,
						values = fonts,
						order = 13,
						set = function(info, v)
								self.db.font = media:List("font")[v]
								PWBLog:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.font) end
					},

					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						type = "toggle",
						disabled = function() return self.db.useDefaults == true end,
						order = 15,
						set = function(info, v)
								self.db.outline = v
								PWBLog:RefreshConfig()
							end,
						get = function(info) return self.db.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.useDefaults == true or self.db.outline == true end,
						order = 17,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.shadowColor[1] = r;
								self.db.shadowColor[2] = g;
								self.db.shadowColor[3] = b;
								self.db.shadowColor[4] = a;
								PWBLog:RefreshConfig()
								end,
						get = function(info) return self.db.shadowColor[1], self.db.shadowColor[2],
													self.db.shadowColor[3], self.db.shadowColor[4]
							end
					},
					shadowx = {
						order = 19,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.useDefaults == true or self.db.outline == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shadowX = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.shadowX end
					},
					shadowy = {
						order = 21,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.useDefaults == true or self.db.outline == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shadowY = val PWBLog:RefreshConfig() end,
						get = function(info) return self.db.shadowY end
					},


					desc_bg = {
						type = 'header',
						name = L["Frame options"],
						order = 31,
					},
					bg = {
						name = L["Background color"],
						desc = L["Background color"],
						type = "color",
						disabled = function() return self.db.useDefaults == true end,
						order = 32,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.background[1] = r;
								self.db.background[2] = g;
								self.db.background[3] = b;
								self.db.background[4] = a;
								PWBLog:RefreshConfig()
								end,
						get = function(info) return self.db.background[1], self.db.background[2],
													self.db.background[3], self.db.background[4]
							end
					},
				},
			},


		}
	}

	return options
end
