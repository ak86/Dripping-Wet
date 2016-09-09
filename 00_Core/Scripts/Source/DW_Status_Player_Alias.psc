Scriptname DW_Status_Player_Alias extends ReferenceAlias
{DW check script Player_Alias}
;Should (re)launch DW_Status script on every player load game

Event OnPlayerLoadGame()
	Quest.GetQuest("DW_StatusCheck").stop()
	Quest.GetQuest("DW_StatusCheck").start()
EndEvent