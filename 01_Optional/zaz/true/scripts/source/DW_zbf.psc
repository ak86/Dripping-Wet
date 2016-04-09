Scriptname DW_zbf extends Quest

bool Function IsIntegraged ()
	Return True
EndFunction

bool Function IsWearingZaZGag (Actor akActor)
	Bool IsMilkingBlocked = false
	zbfBondageShell zbf = Quest.GetQuest("zbf") as zbfBondageShell
	if akActor.WornHasKeyword(zbf.zbfWornGag)
		IsMilkingBlocked = true
	endif
	Return IsMilkingBlocked
EndFunction
