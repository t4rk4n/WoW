function Protwarbar:LoadSharedAbilities()
	local abilities = {}

	-- Colossus
	abilities[116631] = {shield = true}

	-- Power word: Shield
	abilities[17] = {shield = true}

	-- Spirit Shell
	abilities[114908] = {shield = true}

	-- Clarity of Will
	abilities[152118] = {shield = true}

	-- Sanctus
	abilities[187617] = {aura = true}

	-- Shieldtronic Shield
	abilities[173260] = {aura = true}

	-- Stoneform
	abilities[20594] = {aura = true, announce = true, icon = true}

	-- Bulwark of Purity | Demons
	abilities[201414] = {aura = true, shield = true}

	-- Bulwark of Purity
	abilities[202052] = {aura = true, shield = true}

	return abilities

end


	-- Illuminated Healing
	-- abilities[86273] = {shield = true}
	-- Devine aegis
	-- abilities[47753] = {shield = true}
	-- Sacred shield
	-- abilities[65148] = {shield = true}
