function PWBInfo:CreateOptions()
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
					  set = function(info, val) self.db.enabled = val PWBInfo:PWB_UPDATE_HANDLERS() PWBInfo:RefreshConfig() end,
					  get = function(info) return self.db.enabled end
					},
					desc_420 = {
						type = 'header',
						name = L["Information elements"],
						order = 20,
					},
					enableresheal = {
					  order = 21,
					  name = L["Display Resolve Healing"],
					  desc = L["Display Resolve Healing"],
					  type = "toggle",
					  set = function(info, val) self.db.resolveHealing.enabled = val PWBInfo:RefreshConfig() end,
					  get = function(info) return self.db.resolveHealing.enabled end
					},
					desc_30 = {
						type = 'description',
						name = " ",
						order = 30,
					},					
					enableresdam = {
					  order = 31,
					  name = L["Display Resolve Damage"],
					  desc = L["Display Resolve Damage"],
					  type = "toggle",
					  set = function(info, val) self.db.resolveDamage.enabled = val PWBInfo:RefreshConfig() end,
					  get = function(info) return self.db.resolveDamage.enabled end
					},
					desc_40 = {
						type = 'description',
						name = " ",
						order = 40,
					},
					enablesb = {
					  order = 42,
					  name = L["Display Shield Barrier"],
					  desc = L["Display Shield Barrier"],
					  type = "toggle",
					  set = function(info, val) self.db.shieldBarrier.enabled = val PWBInfo:RefreshConfig() end,
					  get = function(info) return self.db.shieldBarrier.enabled end
					},
				},
			},
			group3 = {
				name = L["Resolve Healing"],
				type = "group",
				order = 3,
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
						set = function(info,val) self.db.resolveHealing.x = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.x end
					},
					you = {
						order = 5,
						name = L["Y"],
						desc = L["Y position"],
						type = "range",
						min = 1,
						max = 2048,
						step = 1,
						set = function(info,val) self.db.resolveHealing.y = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.y end
					},
					desc_6 = {
						type = 'description',
						name = " ",
						order = 6,
					},					
					venwidth = {
						order = 7,
						name = L["Width"],
						desc = L["Width"],
						type = "range",
						min = 5,
						max = 200,
						step = 1,
						set = function(info,val) self.db.resolveHealing.width = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.width end
					},
					venheight = {
						order = 8,
						name = L["Height"],
						desc = L["Height"],
						type = "range",
						min = 5,
						max = 200,
						step = 1,
						set = function(info,val) self.db.resolveHealing.height = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.height end
					},					
					desc_app = {
						type = 'header',
						name = L["Appearance"],
						order = 9,
					},				
					enable = {
						order = 10,
						name = L["Use defaults"],
						desc = L["Use defaults"],
						type = "toggle",
						set = function(info,val) self.db.resolveHealing.useDefaults = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.useDefaults end
					},
					desc_bg = {
						type = 'header',
						name = L["Frame options"],
						order = 11,
					},
					bg = {
						name = L["Background color"],
						desc = L["Background color"],
						type = "color",
						disabled = function() return self.db.resolveHealing.useDefaults == true end,
						order = 12,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.resolveHealing.background[1] = r;
								self.db.resolveHealing.background[2] = g;
								self.db.resolveHealing.background[3] = b;
								self.db.resolveHealing.background[4] = a;
								PWBInfo:RefreshConfig()
								end,
						get = function(info) return self.db.resolveHealing.background[1], self.db.resolveHealing.background[2],
													self.db.resolveHealing.background[3], self.db.resolveHealing.background[4]
							end
					},
					desc_ven_head = {
						type = 'header',
						name = L["Font options"],
						order = 21,
					},
					venfontsize = {
						order = 22,
						name = L["Font Size"],
						desc = L["Font Size"],
						type = "range",
						disabled = function() return self.db.resolveHealing.useDefaults == true end,
						min = 3,
						max = 50,
						step = 1,
						set = function(info,val) self.db.resolveHealing.fontsize = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.fontsize end
					},
					venFont = {
						name = L["Font"],
						desc = L["Font"],
						type = "select",
						disabled = function() return self.db.resolveHealing.useDefaults == true end,
						values = fonts,
						order = 23,
						set = function(info, v)
								self.db.resolveHealing.font = media:List("font")[v]
								PWBInfo:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.resolveHealing.font) end
					},
					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						disabled = function() return self.db.resolveHealing.useDefaults == true end,
						type = "toggle",
						order = 55,
						set = function(info, v)
								self.db.resolveHealing.outline = v
								PWBInfo:RefreshConfig()
							end,
						get = function(info) return self.db.resolveHealing.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.resolveHealing.outline == true or self.db.resolveHealing.useDefaults == true end,
						order = 57,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.resolveHealing.shadowColor[1] = r;
								self.db.resolveHealing.shadowColor[2] = g;
								self.db.resolveHealing.shadowColor[3] = b;
								self.db.resolveHealing.shadowColor[4] = a;
								PWBInfo:RefreshConfig()
								end,
						get = function(info) return self.db.resolveHealing.shadowColor[1], self.db.resolveHealing.shadowColor[2],
													self.db.resolveHealing.shadowColor[3], self.db.resolveHealing.shadowColor[4]
							end
					},
					shadowx = {
						order = 59,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.resolveHealing.outline == true or self.db.resolveHealing.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.resolveHealing.shadowX = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.shadowX end
					},
					shadowy = {
						order = 61,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.resolveHealing.outline == true or self.db.resolveHealing.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.resolveHealing.shadowY = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveHealing.shadowY end
					},
				},
			},
			group4 = {
				name = L["Resolve Damage"],
				type = "group",
				order = 4,
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
						set = function(info,val) self.db.resolveDamage.x = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.x end
					},
					you = {
						order = 5,
						name = L["Y"],
						desc = L["Y position"],
						type = "range",
						min = 1,
						max = 2048,
						step = 1,
						set = function(info,val) self.db.resolveDamage.y = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.y end
					},
					desc_6 = {
						type = 'description',
						name = " ",
						order = 6,
					},					
					venwidth = {
						order = 7,
						name = L["Width"],
						desc = L["Width"],
						type = "range",
						min = 5,
						max = 200,
						step = 1,
						set = function(info,val) self.db.resolveDamage.width = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.width end
					},
					venheight = {
						order = 8,
						name = L["Height"],
						desc = L["Height"],
						type = "range",
						min = 5,
						max = 200,
						step = 1,
						set = function(info,val) self.db.resolveDamage.height = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.height end
					},					
					desc_app = {
						type = 'header',
						name = L["Appearance"],
						order = 9,
					},				
					enable = {
						order = 10,
						name = L["Use defaults"],
						desc = L["Use defaults"],
						type = "toggle",
						set = function(info,val) self.db.resolveDamage.useDefaults = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.useDefaults end
					},
					desc_bg = {
						type = 'header',
						name = L["Frame options"],
						order = 11,
					},
					bg = {
						name = L["Background color"],
						desc = L["Background color"],
						type = "color",
						disabled = function() return self.db.resolveDamage.useDefaults == true end,
						order = 12,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.resolveDamage.background[1] = r;
								self.db.resolveDamage.background[2] = g;
								self.db.resolveDamage.background[3] = b;
								self.db.resolveDamage.background[4] = a;
								PWBInfo:RefreshConfig()
								end,
						get = function(info) return self.db.resolveDamage.background[1], self.db.resolveDamage.background[2],
													self.db.resolveDamage.background[3], self.db.resolveDamage.background[4]
							end
					},
					desc_ven_head = {
						type = 'header',
						name = L["Font options"],
						order = 21,
					},
					venfontsize = {
						order = 22,
						name = L["Font Size"],
						desc = L["Font Size"],
						type = "range",
						disabled = function() return self.db.resolveDamage.useDefaults == true end,
						min = 3,
						max = 50,
						step = 1,
						set = function(info,val) self.db.resolveDamage.fontsize = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.fontsize end
					},
					venFont = {
						name = L["Font"],
						desc = L["Font"],
						type = "select",
						disabled = function() return self.db.resolveDamage.useDefaults == true end,
						values = fonts,
						order = 23,
						set = function(info, v)
								self.db.resolveDamage.font = media:List("font")[v]
								PWBInfo:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.resolveDamage.font) end
					},
					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						disabled = function() return self.db.resolveDamage.useDefaults == true end,
						type = "toggle",
						order = 55,
						set = function(info, v)
								self.db.resolveDamage.outline = v
								PWBInfo:RefreshConfig()
							end,
						get = function(info) return self.db.resolveDamage.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.resolveDamage.outline == true or self.db.resolveDamage.useDefaults == true end,
						order = 57,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.resolveDamage.shadowColor[1] = r;
								self.db.resolveDamage.shadowColor[2] = g;
								self.db.resolveDamage.shadowColor[3] = b;
								self.db.resolveDamage.shadowColor[4] = a;
								PWBInfo:RefreshConfig()
								end,
						get = function(info) return self.db.resolveDamage.shadowColor[1], self.db.resolveDamage.shadowColor[2],
													self.db.resolveDamage.shadowColor[3], self.db.resolveDamage.shadowColor[4]
							end
					},
					shadowx = {
						order = 59,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.resolveDamage.outline == true or self.db.resolveDamage.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.resolveDamage.shadowX = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.shadowX end
					},
					shadowy = {
						order = 61,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.resolveDamage.outline == true or self.db.resolveDamage.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.resolveDamage.shadowY = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.resolveDamage.shadowY end
					},
				},
			},
						group5 = {
				name = L["Shield Barrier"],
				type = "group",
				order = 5,
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
						set = function(info,val) self.db.shieldBarrier.x = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.x end
					},
					you = {
						order = 5,
						name = L["Y"],
						desc = L["Y position"],
						type = "range",
						min = 1,
						max = 2048,
						step = 1,
						set = function(info,val) self.db.shieldBarrier.y = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.y end
					},
					desc_6 = {
						type = 'description',
						name = " ",
						order = 6,
					},					
					venwidth = {
						order = 7,
						name = L["Width"],
						desc = L["Width"],
						type = "range",
						min = 5,
						max = 200,
						step = 1,
						set = function(info,val) self.db.shieldBarrier.width = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.width end
					},
					venheight = {
						order = 8,
						name = L["Height"],
						desc = L["Height"],
						type = "range",
						min = 5,
						max = 200,
						step = 1,
						set = function(info,val) self.db.shieldBarrier.height = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.height end
					},					
					desc_app = {
						type = 'header',
						name = L["Appearance"],
						order = 9,
					},				
					enable = {
						order = 10,
						name = L["Use defaults"],
						desc = L["Use defaults"],
						type = "toggle",
						set = function(info,val) self.db.shieldBarrier.useDefaults = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.useDefaults end
					},
					desc_bg = {
						type = 'header',
						name = L["Frame options"],
						order = 11,
					},
					bg = {
						name = L["Background color"],
						desc = L["Background color"],
						type = "color",
						disabled = function() return self.db.shieldBarrier.useDefaults == true end,
						order = 12,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.shieldBarrier.background[1] = r;
								self.db.shieldBarrier.background[2] = g;
								self.db.shieldBarrier.background[3] = b;
								self.db.shieldBarrier.background[4] = a;
								PWBInfo:RefreshConfig()
								end,
						get = function(info) return self.db.shieldBarrier.background[1], self.db.shieldBarrier.background[2],
													self.db.shieldBarrier.background[3], self.db.shieldBarrier.background[4]
							end
					},
					desc_ven_head = {
						type = 'header',
						name = L["Font options"],
						order = 21,
					},
					venfontsize = {
						order = 22,
						name = L["Font Size"],
						desc = L["Font Size"],
						type = "range",
						disabled = function() return self.db.shieldBarrier.useDefaults == true end,
						min = 3,
						max = 50,
						step = 1,
						set = function(info,val) self.db.shieldBarrier.fontsize = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.fontsize end
					},
					venFont = {
						name = L["Font"],
						desc = L["Font"],
						type = "select",
						disabled = function() return self.db.shieldBarrier.useDefaults == true end,
						values = fonts,
						order = 23,
						set = function(info, v)
								self.db.shieldBarrier.font = media:List("font")[v]
								PWBInfo:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.shieldBarrier.font) end
					},
					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						disabled = function() return self.db.shieldBarrier.useDefaults == true end,
						type = "toggle",
						order = 55,
						set = function(info, v)
								self.db.shieldBarrier.outline = v
								PWBInfo:RefreshConfig()
							end,
						get = function(info) return self.db.shieldBarrier.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.shieldBarrier.outline == true or self.db.shieldBarrier.useDefaults == true end,
						order = 57,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.shieldBarrier.shadowColor[1] = r;
								self.db.shieldBarrier.shadowColor[2] = g;
								self.db.shieldBarrier.shadowColor[3] = b;
								self.db.shieldBarrier.shadowColor[4] = a;
								PWBInfo:RefreshConfig()
								end,
						get = function(info) return self.db.shieldBarrier.shadowColor[1], self.db.shieldBarrier.shadowColor[2],
													self.db.shieldBarrier.shadowColor[3], self.db.shieldBarrier.shadowColor[4]
							end
					},
					shadowx = {
						order = 59,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.shieldBarrier.outline == true or self.db.shieldBarrier.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shieldBarrier.shadowX = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.shadowX end
					},
					shadowy = {
						order = 61,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.shieldBarrier.outline == true or self.db.shieldBarrier.useDefaults == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.shieldBarrier.shadowY = val PWBInfo:RefreshConfig() end,
						get = function(info) return self.db.shieldBarrier.shadowY end
					},
				},
			},

		}
	}

	return options

end
