Scriptname DW_SLA extends Quest

bool Function IsIntegraged ()
	Return True
EndFunction

int Function GetActorArousal(Actor akActor)
	slaFrameWorkScr sla = Quest.GetQuest("sla_Framework") as slaFrameWorkScr
	return sla.GetActorArousal(akActor)
EndFunction
