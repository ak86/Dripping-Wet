Scriptname DW_zbf extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.zbf",1)
EndEvent

bool Function IsIntegraged ()
	Return False
EndFunction

bool Function IsWearingZaZGag (Actor akActor)
	Bool IsMilkingBlocked = false
	Return IsMilkingBlocked
EndFunction
