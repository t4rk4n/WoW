-- License: Public Domain

C_Timer.After(.1, function() -- need to wait a bit
	if not InCombatLockdown() then
		-- set distance back to 40 (down from 60)
		SetCVar("nameplateMaxDistance", 40)

		-- in patch 7.1 only the targeted nameplate clamps to the top of the screen,
		-- change back to default behavior
		SetCVar("nameplateOtherTopInset", GetCVarDefault("nameplateOtherTopInset"))
		SetCVar("nameplateOtherBottomInset", GetCVarDefault("nameplateOtherBottomInset"))
	end
end)
