Scriptname DW_DDi extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.ddi",1)
EndEvent

bool Function IsIntegraged ()
	Return False
EndFunction

bool Function IsWearingDDGag (Actor akActor)
	Bool IsMilkingBlocked = false
	Return IsMilkingBlocked
EndFunction

bool Function IsWearingDDBlindfold (Actor akActor)
	Bool IsMilkingBlocked = false
	Return IsMilkingBlocked
EndFunction
