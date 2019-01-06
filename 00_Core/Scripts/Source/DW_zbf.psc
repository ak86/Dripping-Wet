Scriptname DW_zbf extends Quest

Event OnInit()
	;StorageUtil.SetIntValue(none,"DW.PluginsCheck.zbf",2)
EndEvent

bool Function IsWearingZaZGag (Actor akActor)
	Keyword zbfWornGag = Keyword.GetKeyword("zbfWornGag")
	if ( zbfWornGag )
		if akActor.WornHasKeyword(zbfWornGag)
			Return true
		endif
	endif
	Return false
EndFunction

bool Function IsWearingZaZBlindfold (Actor akActor)
	Keyword zbfWornBlindfold = Keyword.GetKeyword("zbfWornBlindfold")
	if ( zbfWornBlindfold )
		if akActor.WornHasKeyword(zbfWornBlindfold)
			return true
		endif
	endif
	return false
EndFunction