Scriptname DW_Status_Player_Alias extends ReferenceAlias
{DW check script Player_Alias}
;Should (re)launch DW_Status script on every player load game


Event OnPlayerLoadGame()
	(Game.GetFormFromFile(0xD62, "DW.esp") as Quest).stop()
	;Quest.GetQuest("DW_Dripping_Status").stop()
	;Quest.GetQuest("DW_Dripping_Status").reset()	;reset interrupts script, so we don't use it here
	(Game.GetFormFromFile(0xD62, "DW.esp") as Quest).start()
	;Quest.GetQuest("DW_Dripping_Status").start()
EndEvent