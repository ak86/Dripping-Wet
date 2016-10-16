Scriptname DW_Status_Player_Alias extends ReferenceAlias
{DW check script Player_Alias}
;Should (re)launch DW_Status script on every player load game

Event OnPlayerLoadGame()
	Quest.GetQuest("DW_Dripping_Status").stop()
	;Quest.GetQuest("DW_Dripping_Status").reset()	;reset interrupts script, so we don't use it here
	Quest.GetQuest("DW_Dripping_Status").start()
EndEvent