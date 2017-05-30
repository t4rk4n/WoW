local media = LibStub("LibSharedMedia-3.0")
local borders = media:List("border")
local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

function Protwarbar:CreateOptions()
	local fonts = media:List("font")
	local textures = media:List("statusbar")
	local fonts = media:List("font")
	local backgrounds = media:List("background")

	local options = {
		type = "group",
		name = "Protwarbar",
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
					  desc = L["Enables / disables the addon"],
					  type = "toggle",
					  set = function(info,val) self.db.profile.enabled = val self:SendMessage("PWB_UPDATE_HANDLERS") Protwarbar:RefreshConfig() end,
					  get = function(info) return self.db.profile.enabled end
					},
					hideooc = {
					  order = 2,
					  name = L["Hide out of combat"],
					  desc = L["Hide the frames when you are out of combat."],
					  type = "toggle",
					  set = function(info,val) self.db.profile.hideooc = val Protwarbar:RefreshConfig() end,
					  get = function(info) return self.db.profile.hideooc end
					},
					header_9 = {
						type = 'header',
						name = L["Movement"],
						order = 9,
					},
					locked = {
					  order = 11,
					  name = L["Lock frames"],
					  desc = L["Unlock to move frames"],
					  type = "toggle",
					  set = function(info,val) self.db.profile.locked = val Protwarbar:RefreshConfig() end,
					  get = function(info) return self.db.profile.locked end
					},
					header_19 = {
						type = 'header',
						name = L["Auto Load"],
						order = 19,
					},
					enableal = {
					  	order = 31,
					  	name = L["Auto Load enabled"],
					  	desc = L["Auto Load enabled"],
					  	type = "toggle",
					  	set = function(info,val) self.db.global.autoloadEnabled = val Protwarbar:RefreshConfig() end,
					  	get = function(info) return self.db.global.autoloadEnabled end
					},
					desc32 = {
						order = 32,
						name = L["Protwarbar will auto load the selected profile when you change spec."],
						type = "description",
					},
					header_39 = {
						type = 'header',
						name = L["Specializations"],
						order = 39,
					},
					spec1 = {
						type = "select",
						name = L["Arms"],
						order = 41,
						values = function() return self.db:GetProfiles() end,
						get = function(info) return Protwarbar:GetProfileId(self.db:GetProfiles(), self.db.global.autoload[1]) end,
						set = function(info, v) self.db.global.autoload[1] = self.db:GetProfiles()[v] end
					},
					spec2 = {
						type = "select",
						name = L["Fury"],
						order = 43,
						values = function() return self.db:GetProfiles() end,
						get = function(info) return Protwarbar:GetProfileId(self.db:GetProfiles(), self.db.global.autoload[2]) end,
						set = function(info, v) self.db.global.autoload[2] = self.db:GetProfiles()[v] end
					},
					spec3 = {
						type = "select",
						name = L["Protection"],
						order = 45,
						values = function() return self.db:GetProfiles() end,
						get = function(info) return Protwarbar:GetProfileId(self.db:GetProfiles(), self.db.global.autoload[3]) end,
						set = function(info, v) self.db.global.autoload[3] = self.db:GetProfiles()[v] end
					}
				}
			},
			group4 = {
				name = L["Appearance"],
				type = "group",
				order = 4,
				args = {
					scale = {
						order = 3,
						name = L["Scale"],
						desc = L["Scale all elements in the interface"],
						type = "range",
						min = 0.1,
						max = 4,
						step = 0.05,
						set = function(info,val) self.db.profile.default.appearence.scale = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.scale end
					},
					desc_4 = {
						type = 'description',
						name = L["\n\nThese are the default options used in Protwarbar. You can override the options at the Appearance tab of a module."],
						fontSize = 'medium',
						order = 4,
					},
					header_6 = {
						type = 'header',
						name = L["Bar options"],
						order = 9,
					},
					reverse = {
					  order = 10,
					  name = L["Reverse"],
					  desc = L["Reverse the direction the bars fill up"],
					  type = "toggle",
					  set = function(info,val) self.db.profile.default.appearence.reverse = val Protwarbar:RefreshConfig() end,
					  get = function(info) return self.db.profile.default.appearence.reverse end
					},
					orient = {
						order = 11,
						name = L["Orientation"],
						desc = L["Orientation"],
						type = "select",
						values = function()
							orientations = {
								["HORIZONTAL"] = L["Horizontal"],
								["VERTICAL"] = L["Vertical"],
							}
							return orientations
						end,
						set = function(info, v)
								self.db.profile.default.appearence.orientation = v
								Protwarbar:RefreshConfig()
							end,
						get = function(info) return self.db.profile.default.appearence.orientation end
					},
					desc_12 = {
						type = 'description',
						name = "",
						order = 13,
					},
					barbg = {
						name = L["Background color"],
						desc = L["Color of bar Background"],
						type = "color",
						order = 15,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.profile.default.appearence.barBackground[1] = r;
								self.db.profile.default.appearence.barBackground[2] = g;
								self.db.profile.default.appearence.barBackground[3] = b;
								self.db.profile.default.appearence.barBackground[4] = a;
								Protwarbar:RefreshConfig()
								end,
						get = function(info) return self.db.profile.default.appearence.barBackground[1], self.db.profile.default.appearence.barBackground[2],
													self.db.profile.default.appearence.barBackground[3], self.db.profile.default.appearence.barBackground[4]
							end
					},
					barTexture = {
						name = L["Texture"],
						desc = L["Texture"],
						type = "select",
						values = textures,
						order = 17,
						width = "normal",
						set = function(info, v)
								self.db.profile.default.appearence.barTexture = media:List("statusbar")[v]
								Protwarbar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("statusbar", self.db.profile.default.appearence.barTexture) end
					},
					desc_font = {
						type = 'header',
						name = L["Font options"],
						order = 21,
					},
					fontsize = {
						order = 23,
						name = L["Font Size"],
						desc = L["Font Size"],
						type = "range",
						min = 3,
						max = 50,
						step = 1,
						set = function(info,val) self.db.profile.default.appearence.fontsize = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.fontsize end
					},
					font = {
						name = L["Font"],
						desc = L["Font"],
						type = "select",
						values = fonts,
						order = 25,
						set = function(info, v)
								self.db.profile.default.appearence.font = media:List("font")[v]
								Protwarbar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("font", self.db.profile.default.appearence.font) end
					},

					outline = {
						name = L["Outline"],
						desc = L["Outline"],
						type = "toggle",
						order = 26,
						set = function(info, v)
								self.db.profile.default.appearence.outline = v
								Protwarbar:RefreshConfig()
							end,
						get = function(info) return self.db.profile.default.appearence.outline end
					},
					shadowcolor = {
						name = L["Shadow color"],
						desc = L["Shadow color"],
						type = "color",
						disabled = function() return self.db.profile.default.appearence.outline == true end,
						order = 27,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.profile.default.appearence.shadowColor[1] = r;
								self.db.profile.default.appearence.shadowColor[2] = g;
								self.db.profile.default.appearence.shadowColor[3] = b;
								self.db.profile.default.appearence.shadowColor[4] = a;
								Protwarbar:RefreshConfig()
								end,
						get = function(info) return self.db.profile.default.appearence.shadowColor[1], self.db.profile.default.appearence.shadowColor[2],
													self.db.profile.default.appearence.shadowColor[3], self.db.profile.default.appearence.shadowColor[4]
							end
					},
					shadowx = {
						order = 28,
						name = L["Shadow X offset"],
						desc = L["Shadow X offset"],
						type = "range",
						disabled = function() return self.db.profile.default.appearence.outline == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.profile.default.appearence.shadowX = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.shadowX end
					},
					shadowy = {
						order = 29,
						name = L["Shadow Y offset"],
						desc = L["Shadow Y offset"],
						type = "range",
						disabled = function() return self.db.profile.default.appearence.outline == true end,
						min = -10,
						max = 10,
						step = 0.1,
						set = function(info,val) self.db.profile.default.appearence.shadowY = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.shadowY end
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
						order = 32,
						width = "normal",
						hasAlpha = true,
						set = function(info, r, g, b, a)
								self.db.profile.default.appearence.background[1] = r;
								self.db.profile.default.appearence.background[2] = g;
								self.db.profile.default.appearence.background[3] = b;
								self.db.profile.default.appearence.background[4] = a;
								Protwarbar:RefreshConfig()
								end,
						get = function(info) return self.db.profile.default.appearence.background[1], self.db.profile.default.appearence.background[2],
													self.db.profile.default.appearence.background[3], self.db.profile.default.appearence.background[4]
							end
					},
					desc_icon = {
						type = 'header',
						name = L["Icon options"],
						order = 41,
					},
					size = {
						order = 42,
						name = L["Size"],
						desc = L["Size of the icons"],
						type = "range",
						min = 5,
						max = 100,
						step = 1,
						set = function(info,val) self.db.profile.default.appearence.iconsize = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.iconsize end
					},
					tsize = {
						order = 43,
						name = L["Texture Size"],
						desc = L["Texture Size"],
						type = "range",
						min = 1,
						max = 100,
						step = 1,
						set = function(info,val) self.db.profile.default.appearence.textureSize = val Protwarbar:RefreshConfig() end,
						get = function(info) return Protwarbar.db.profile.default.appearence.textureSize end
					},
					desc_44 = {
						type = 'description',
						name = " ",
						order = 44,
					},
					edge = {
						order = 45,
						name = L["Edge size"],
						desc = L["Edge size"],
						type = "range",
						min = 1,
						max = 50,
						step = 1,
						set = function(info,val) self.db.profile.default.appearence.edgeSize = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.edgeSize	end
					},
					iconalphaOptions = {
						order = 56,
						name = L["Icon lack rage of alpha"],
						desc = L["Alpha for a spell that you don't have enough rage for at that moment"],
						type = "range",
						min = 0,
						max = 1,
						step = 0.01,
						set = function(info,val) self.db.profile.default.appearence.lowRageAlpha = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.lowRageAlpha end
					},
					desc_57 = {
						type = 'description',
						name = " ",
						order = 57,
					},
					hideoncd = {
						order = 58,
						name = L["Hide on cooldown"],
						desc = L["Hide on cooldown"],
						type = "toggle",
						set = function(info,val) self.db.profile.default.appearence.hideOnCD = val Protwarbar:RefreshConfig() end,
						get = function(info) return self.db.profile.default.appearence.hideOnCD end
					},
					border = {
						name = L["Border"],
						desc = L["Border"],
						type = "select",
						values = borders,
						order = 59,
						width = "normal",
						set = function(info, v)
								self.db.profile.default.appearence.border = media:List("border")[v]
								Protwarbar:RefreshConfig()
							end,
						get = function(info) return Protwarbar:GetLSMIndex("border", self.db.profile.default.appearence.border) end
					},
				}
			}

		}
	}

	return options
end

function Protwarbar:GetLSMIndex(t, value)
	local media = LibStub("LibSharedMedia-3.0")

	for k, v in pairs(media:List(t)) do
		if v == value then
			return k
		end
	end
	return nil
end

function Protwarbar:GetProfileId(profiles, value)
	for id, v in pairs(profiles) do
		if value == v then
			return id
		end
	end

	return nil
end

