Scriptname DW_DDi extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.ddi",2)
EndEvent

bool Function IsIntegraged ()
	Return True
EndFunction

bool Function IsWearingDDGag (Actor akActor)
	Bool IsMilkingBlocked = false
	zadLibs Libs = Quest.GetQuest("zadQuest") as zadLibs
	if akActor.WornHasKeyword(Libs.zad_DeviousGag)
		IsMilkingBlocked = true
	endif
	Return IsMilkingBlocked
EndFunction

bool Function IsWearingDDBlindfold (Actor akActor)
	Bool IsMilkingBlocked = false
	zadLibs Libs = Quest.GetQuest("zadQuest") as zadLibs
	if akActor.WornHasKeyword(Libs.zad_DeviousBlindfold)
		IsMilkingBlocked = true
	endif
	Return IsMilkingBlocked
EndFunction
