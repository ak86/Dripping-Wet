Scriptname DW_DDi extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.ddi",2)
EndEvent

bool Function IsWearingDDGag (Actor akActor)
	Keyword zad_DeviousGag = Keyword.GetKeyword("zad_DeviousGag")
	if zad_DeviousGag != none
		if akActor.WornHasKeyword(zad_DeviousGag)
			Return true
		else
			Return false
		endif
	endif
EndFunction

bool Function IsWearingDDBlindfold (Actor akActor)
	Keyword zad_DeviousBlindfold = Keyword.GetKeyword("zad_DeviousBlindfold")
	if zad_DeviousBlindfold != none
		if akActor.WornHasKeyword(zad_DeviousBlindfold)
			Return true
		else
			Return false
		endif
	endif
EndFunction