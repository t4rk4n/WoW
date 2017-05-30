local media = LibStub("LibSharedMedia-3.0")
local borders = media:List("border")
local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

function PWBIcon:CreateOptions()

	local textures = media:List("statusbar")
	local fonts = media:List("font")
	local backgrounds = media:List("background")

	local abilities = PWBIcon:GenerateOptions()

	local options = {
		type = "group",
		name = L["Icons"],
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
					  	set = function(info,val) self.db.enabled = val PWBIcon:PWB_UPDATE_HANDLERS() PWBIcon:RefreshConfig() end,
					  	get = function(info) return self.db.enabled end
					},
				},
			},
			group2 = {
				name = L["Icons"],
				type = "group",
				order = 1,
				childGroups = "tree",
				args = abilities
			},
		}
	}

	return options
end

function PWBIcon:GenerateOptions()
	local options = {}

	for id, ability in pairs(self.iconList) do
		options[tostring(id)] = PWBIcon:GenerateAbiltyOptions(ability, id)
	end

	return options
end

function PWBIcon:GenerateAbiltyOptions(ability, id)

	local iconalphaOptions = nil
	local abillityName = GetSpellInfo(id)
	if ability.debuff ~= nil then
		abillityName = abillityName .. " (" .. L["debuff"] .. ")"
	end
	if ability.extraname ~= nil then
		abillityName = abillityName .. " (" .. ability.extraname .. ")"
	end

	if ability.rage ~= nil then
		iconalphaOptions = {
			order = 32,
			name = L["Icon lack rage of alpha"],
			desc = L["Alpha for a spell that you don't have enough rage for at that moment"],
			type = "range",
			disabled = function() return self.db.icons[id].useDefaults == true end,
			min = 0,
			max = 1,
			step = 0.01,
			set = function(info,val) self.db.icons[id].lowRageAlpha = val PWBIcon:RefreshConfig() end,
			get = function(info)
				if self.db.icons[id].lowRageAlpha == nil then
					return Protwarbar.db.profile.default.appearence.lowRageAlpha
				else
					return self.db.icons[id].lowRageAlpha
				end
			end
		}
	end

	local options = {
		name = abillityName,
		type = "group",
		order = 4,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				desc = L["Enables this icon"],
				type = "toggle",
				set = function(info,val) self.db.icons[id].enabled = val PWBIcon:RefreshConfig() end,
				get = function(info) return self.db.icons[id].enabled end
			},
			desc_pos = {
				type = 'header',
				name = L["Position"],
				order = 4,
			},
			x = {
				order = 5,
				name = L["X"],
				desc = L["X position"],
				type = "range",
				min = 1,
				max = 2560,
				step = 1,
				set = function(info,val) self.db.icons[id].x = val PWBIcon:RefreshConfig() end,
				get = function(info) return self.db.icons[id].x end
			},
			y = {
				order = 6,
				name = L["Y"],
				desc = L["Y position"],
				type = "range",
				min = 1,
				max = 2048,
				step = 1,
				set = function(info,val) self.db.icons[id].y = val PWBIcon:RefreshConfig() end,
				get = function(info) return self.db.icons[id].y end
			},
			desc_app = {
				type = 'header',
				name = L["Appearance"],
				order = 11,
			},
			defaults = {
				order = 12,
				name = L["Use defaults"],
				desc = L["Use defaults"],
				type = "toggle",
				set = function(info,val) self.db.icons[id].useDefaults = val PWBIcon:RefreshConfig() end,
				get = function(info)
						if self.db.icons[id].useDefaults == nil then
							return true
						else
							return self.db.icons[id].useDefaults
						end
					end
			},
			desc_13 = {
				type = 'description',
				name = " ",
				order = 13,
			},
			size = {
				order = 21,
				name = L["Size"],
				desc = L["Size of the icons"],
				type = "range",
				disabled = function() return self.db.icons[id].useDefaults == true end,
				min = 5,
				max = 100,
				step = 1,
				set = function(info,val) self.db.icons[id].iconsize = val PWBIcon:RefreshConfig() end,
				get = function(info)
						if self.db.icons[id].iconsize == nil then
							return Protwarbar.db.profile.default.appearence.iconsize
						else
							return self.db.icons[id].iconsize
						end
					end
			},
			tsize = {
				order = 22,
				name = L["Texture Size"],
				desc = L["Texture Size"],
				type = "range",
				disabled = function() return self.db.icons[id].useDefaults == true end,
				min = 1,
				max = 100,
				step = 1,
				set = function(info,val) self.db.icons[id].textureSize = val PWBIcon:RefreshConfig() end,
				get = function(info)
						if self.db.icons[id].textureSize == nil then
							return Protwarbar.db.profile.default.appearence.textureSize
						else
							return self.db.icons[id].textureSize
						end
					end
			},
			border = {
				name = L["Border"],
				desc = L["Border"],
				type = "select",
				disabled = function() return self.db.icons[id].useDefaults == true end,
				values = borders,
				order = 26,
				width = "normal",
				set = function(info, v)
						self.db.icons[id].border = media:List("border")[v]
						PWBIcon:RefreshConfig()
					end,
				get = function(info)
						if self.db.icons[id].border == nil then
							return Protwarbar:GetLSMIndex("border", Protwarbar.db.profile.default.appearence.border)
						else
							return Protwarbar:GetLSMIndex("border", self.db.icons[id].border)
						end
					end
			},
			edge = {
				order = 27,
				name = L["Edge size"],
				desc = L["Edge size"],
				type = "range",
				disabled = function() return self.db.icons[id].useDefaults == true end,
				min = 1,
				max = 50,
				step = 1,
				set = function(info,val) self.db.icons[id].edgeSize = val PWBIcon:RefreshConfig() end,
				get = function(info)
						if self.db.icons[id].edgeSize == nil then
							return Protwarbar.db.profile.default.appearence.edgeSize
						else
							return self.db.icons[id].edgeSize
						end
					end
			},
			iconalpha = iconalphaOptions,
			desc_31 = {
				type = 'description',
				name = " ",
				order = 41,
			},
			hideoncd = {
				order = 52,
				name = L["Hide on cooldown"],
				desc = L["Hide on cooldown"],
				type = "toggle",
				disabled = function() return self.db.icons[id].useDefaults == true end,
				set = function(info,val) self.db.icons[id].hideOnCD = val PWBIcon:RefreshConfig() end,
				get = function(info) return self.db.icons[id].hideOnCD end
			},
		}
	}

	return options
end
