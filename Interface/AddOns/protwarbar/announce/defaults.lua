function PWBAnnounce:CreateDefaults()
	local announcePresets = {}

	-- Last stand
	announcePresets[12975] = {
		enabled = true,
		auto = true
	}

	-- Shield wall
	announcePresets[871] = {
		enabled = true,
		auto = true
	}

	-- Taunt
	announcePresets[355] = {
		startmsg = "Used LINK on TARGET."
	}

	-- Pummel
	announcePresets[6552] = {
		startmsg = "Used LINK on TARGET."
	}

	-- Safeguard
	announcePresets[114029] = {
		startmsg = "Used LINK on TARGET."
	}

	-- Vigilance
	announcePresets[114030] = {
		startmsg = "Used LINK on TARGET."
	}

	-- Icebound Fortitude
	announcePresets[48792] = {
		enabled = true,
		auto = true
	}

	local defaults = {
		enabled = false,
		enableCombat = false,
		party = true,
		raid = true,
		arena = false,
		pvp = false,
		scenario = false,
		world = true,
		announce = announcePresets,
		defaultStart = "Used LINK.",
		defaultEnd = "LINK ended.",
	}

	return defaults
end

