Scriptname DW_SLA extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.sla",1)
EndEvent

bool Function IsIntegraged ()
	Return False
EndFunction

int Function GetActorArousal(Actor akActor)
	return 0
EndFunction
