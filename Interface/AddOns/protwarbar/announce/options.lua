local L = LibStub("AceLocale-3.0"):GetLocale("Protwarbar")

function PWBAnnounce:CreateOptions()

	local abilities = PWBAnnounce:GenerateOptions()

	local options = {
		type = "group",
		name = L["Announce"],
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
						set = function(info,val) self.db.enabled = val PWBAnnounce:PWB_UPDATE_HANDLERS() PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.enabled end
					},
					enableCombat = {
					  	order = 2,
					  	name = L["Only enable in combat"],
					  	desc = L["Only enable in combat"],
					  	type = "toggle",
					  	set = function(info,val) self.db.enableCombat = val PWBAnnounce:RefreshConfig() end,
					  	get = function(info) return self.db.enableCombat end
					},
					header_enable = {
						type = 'header',
						name = L["Enable Announcements in"],
						order = 10,
					},
					dungeons = {
						order = 11,
						name = L["Dungeons"],
						desc = L["Dungeons"],
						type = "toggle",
						set = function(info,val) self.db.party = val PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.party end
					},
					raids = {
						order = 13,
						name = L["Raids"],
						desc = L["Raids"],
						type = "toggle",
						set = function(info,val) self.db.raid = val PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.raid end
					},
					arenas = {
						order = 15,
						name = L["Arenas"],
						desc = L["Arenas"],
						type = "toggle",
						set = function(info,val) self.db.arena = val PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.arena end
					},
					battlegrounds = {
						order = 17,
						name = L["Battlegrounds"],
						desc = L["Battlegrounds"],
						type = "toggle",
						set = function(info,val) self.db.pvp = val PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.pvp end
					},
					scenarios = {
						order = 19,
						name = L["Scenarios"],
						desc = L["Scenarios"],
						type = "toggle",
						set = function(info,val) self.db.scenario = val PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.scenario end
					},
					world = {
						order = 21,
						name = L["World"],
						desc = L["World"],
						type = "toggle",
						set = function(info,val) self.db.world = val PWBAnnounce:RefreshConfig() end,
						get = function(info) return self.db.world end
					},
				},
			},
			group3 = {
				name = L["Announce"],
				type = "group",
				order = 3,
				childGroups = "tree",
				args = abilities
			}
		}
	}

	return options
end

function PWBAnnounce:GenerateOptions()
	local options = {}

	for id, ability in pairs(self.announceList) do
		options[tostring(id)] = PWBAnnounce:GenerateAbiltyOptions(ability, id)
	end

	return options
end

function PWBAnnounce:GenerateAbiltyOptions(ability, id)
	local options = {
		name = GetSpellInfo(id),
		type = "group",
		order = 4,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				desc = L["Enables this announcement"],
				type = "toggle",
				set = function(info, val) self.db.announce[id].enabled = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].enabled end
			},
			header_channel = {
				type = 'header',
				name = L["Channels"],
				order = 10,
			},
			auto = {
				order = 11,
				name = L["Automatic"],
				desc = L["Automatic"],
				type = "toggle",
				disabled = function() return self.db.announce[id].enabled ~= true end,
				set = function(info, val) self.db.announce[id].auto = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].auto end
			},
			raid = {
				order = 13,
				name = L["Raid"],
				desc = L["Raid"],
				type = "toggle",
				disabled = function() return self.db.announce[id].enabled ~= true end,
				set = function(info, val) self.db.announce[id].raid = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].raid end
			},
			party = {
				order = 15,
				name = L["Party"],
				desc = L["Party"],
				type = "toggle",
				disabled = function() return self.db.announce[id].enabled ~= true end,
				set = function(info, val) self.db.announce[id].party = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].party end
			},
			instance = {
				order = 17,
				name = L["Instance"],
				desc = L["Instance"],
				type = "toggle",
				disabled = function() return self.db.announce[id].enabled ~= true end,
				set = function(info, val) self.db.announce[id].instance = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].instance end
			},
			say = {
				order = 19,
				name = L["Say"],
				desc = L["Say"],
				type = "toggle",
				disabled = function() return self.db.announce[id].enabled ~= true end,
				set = function(info, val) self.db.announce[id].say = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].say end
			},
			desc_20 = {
				type = 'description',
				name = " ",
				order = 20,
			},
			custom = {
				order = 21,
				name = L["Custom channel"],
				desc = L["Custom channel"],
				type = "toggle",
				disabled = function() return self.db.announce[id].enabled ~= true end,
				set = function(info, val) self.db.announce[id].custom = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].custom end
			},
			channelname = {
				order = 24,
				name = L["Channel name"],
				desc = L["Channel name"],
				type = "input",
				disabled = function() return self.db.announce[id].custom ~= true end,
				set = function(info, val) self.db.announce[id].channelName = val PWBAnnounce:RefreshConfig() end,
				get = function(info) return self.db.announce[id].channelName end
			},
			header_msg = {
				type = 'header',
				name = L["Message"],
				order = 30,
			},
			starmsg = {
				order = 31,
				name = L["Start"],
				desc = L["Start"],
				type = "input",
				width = "full",
				set = function(info, val) self.db.announce[id].startmsg = val PWBAnnounce:RefreshConfig() end,
				get = function(info)
						if self.db.announce[id].startmsg == nil then
							return self.db.defaultStart
						else
							return self.db.announce[id].startmsg
						end
					end
			},
			endmsg = {
				order = 32,
				name = L["End"],
				desc = L["End"],
				type = "input",
				hidden = function() return ability.aura ~= true end,
				width = "full",
				set = function(info, val) self.db.announce[id].endmsg = val PWBAnnounce:RefreshConfig() end,
				get = function(info)
						if self.db.announce[id].endmsg == nil then
							return self.db.defaultEnd
						else
							return self.db.announce[id].endmsg
						end
					end
			}
		}
	}

	return options
end
