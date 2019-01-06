Scriptname DW_DDi extends Quest

Event OnInit()
	;StorageUtil.SetIntValue(none,"DW.PluginsCheck.ddi",2)
EndEvent

bool Function IsWearingDDGag (Actor akActor)
	Keyword zad_DeviousGag = Keyword.GetKeyword("zad_DeviousGag")
	if ( zad_DeviousGag )
		if akActor.WornHasKeyword(zad_DeviousGag)
			return true
		endif
	endif
	return false
EndFunction

bool Function IsWearingDDBlindfold (Actor akActor)
	Keyword zad_DeviousBlindfold = Keyword.GetKeyword("zad_DeviousBlindfold")
	if ( zad_DeviousBlindfold )
		if akActor.WornHasKeyword(zad_DeviousBlindfold)
			return true
		endif
	endif
	return false
EndFunction