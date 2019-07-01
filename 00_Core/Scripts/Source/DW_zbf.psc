Scriptname DW_zbf extends Quest

Event OnInit()
	;StorageUtil.SetIntValue(none,"DW.PluginsCheck.zbf",2)
EndEvent

bool Function IsWearingZaZGag (Actor akActor)
	DW_CORE CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	if CORE.Plugin_ZaZ
		Keyword zbfWornGag = Keyword.GetKeyword("zbfWornGag")
		if ( zbfWornGag )
			if akActor.WornHasKeyword(zbfWornGag)
				return true
			endif
		endif
	endif
	return false
EndFunction

bool Function IsWearingZaZBlindfold (Actor akActor)
	DW_CORE CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	if CORE.Plugin_ZaZ
		Keyword zbfWornBlindfold = Keyword.GetKeyword("zbfWornBlindfold")
		if ( zbfWornBlindfold )
			if akActor.WornHasKeyword(zbfWornBlindfold)
				return true
			endif
		endif
	endif
	return false
EndFunction