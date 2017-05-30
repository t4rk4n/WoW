function Protwarbar:LoadWarriorAbilities()
	local abilities = {}

	-- Berserker rage
	abilities[18499] = {icon = true}

	-- Shield Slam
	abilities[23922] = {icon = true}

	-- Revenge
	abilities[6572] = {icon = true, rage = true}

	-- Shield wall
	abilities[871] = {icon = true, aura = true, announce = true}

	-- Shield block
	abilities[2565] = {icon = true, aura = true, rage = true}

	-- Last stand
	abilities[12975] = {icon = true, aura = true, announce = true}

	-- Rallying cry
	abilities[97462] = {icon = true, aura = true, announce = true}

	-- Demo shout
	abilities[1160] = {icon = true, aura = true, announce = true}

	-- Thunder clap
	abilities[6343] = {icon = true}

	-- Bladestorm
	abilities[46924] = {talent = 18, icon = true}

	-- Shockwave
	abilities[46968] = {talent = 1, icon = true}

	-- Dragon roar
	abilities[118000] = {talent = 12, icon = true}

	-- Battle cry
	abilities[1719] = {icon = true, aura = true}

	-- Avatar
	abilities[107574] = {talent = 9, icon = true, aura = true}

	-- Bloodbath
	abilities[12292] = {talent = 17, icon = true, aura = true}

	-- Storm Bolt
	abilities[107570] = {talent = 2, icon = true}

	-- Staggering Shout
	abilities[107566] = {talent = 7, icon = true}

	-- Piercing Howl
	abilities[12323] = {talent = 8, icon = true, rage = true}

	-- Mass Spell Reflection
	abilities[114028] = {talent = 13, icon = true, announce = true}

	-- Vigilance
	--? abilities[114030] = {talent = 15, icon = true, announce = true}

	-- Pummel
	abilities[6552] = {icon = true, announce = true}

	-- Charge
	abilities[100] = {icon = true}

	-- Die by the sword
  --? abilities[118038] = {icon = true, aura = true, announce = true}

	-- Heroic Throw
	abilities[57755] = {icon = true}

	-- Intimidating Shout
	abilities[5246] = {icon = true}

	-- Mortal strike
	abilities[12294] = {icon = true}

	-- Hamstring
	abilities[1715] = {icon = true, rage = true}

	-- Heoroic leap
	abilities[6544] = {icon = true}

	-- Spell Reflection
	abilities[23920] = {icon = true, aura = true, announce = true}

	-- Taunt
	abilities[355] = {icon = true, announce = true}

	-- Slam
	abilities[1464] = {talent = 9, spec = 1, icon = true, rage = true}

	-- Bloodthirst
	abilities[23881] = {icon = true}

	-- Raging Blow
	abilities[96103] = {icon = true, rage = true}

	-- Whirlwind
	abilities[1680] = {icon = true, rage = true}

	-- Wild Strike
	abilities[100130] = {icon = true, rage = true}

	-- Execute
	abilities[5308] = {icon = true, rage = true}

	-- Victory rush
	abilities[34428] = {icon = true, rage = true}

	-- Ultimatum (depricated)
	abilities[122509] = {aura = true}

	-- Sword and board
	abilities[46953] = {aura = true}

	-- Devastate
	abilities[20243] = {icon = true}

	-- Ravager
	abilities[152277] = {talent = 21, icon = true, aura = true, announce = true}

	-- Siegebreaker
	abilities[176289] = {talent = 21, spec = 1, icon = true}

	-- Hamstrnig
	abilities[162350] = {debuff = true, icon = true}

	-- Impending victory
	abilities[202168] = {talent = 4, icon = true, rage = true}

	-- Ignore pain
	abilities[190456] = {icon = true, aura = true, rage = true, announce = true, shield = true}

	-- Safeguard
  abilities[223657] = {talent = 6, icon = true, announce = true}

	-- Vengeance: Revenge
	abilities[202573] = {aura = true}

	-- Vengeance: Ignore Pain
	abilities[202574] = {aura = true}

	-- Neltharion's Fury
  abilities[203524] = {icon = true, aura = true, announce = true}

  -- Overpower
  abilities[7384] = {talent = 2, icon = true, spec = 1, rage = true}

  -- Warbreaker
  abilities[209577] = {icon = true, spec = 1}

  -- Colossus Smash
  abilities[167105] = {icon = true}

  -- Colossus Smash debuff
  abilities[208086] = {icon = true, debuff = true}

  return abilities
end


