Scriptname DW_DrippingScr extends ReferenceAlias

DW_CORE CORE

Event OnInit()
	CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	CORE.Startup()
	;debug.Notification("$DW_INITDONE")
Endevent

;rebuild json
;function DW_JsonRebuild()
;	JsonUtil.SetStringValue("/DW/Strings", "VirLost", "You have lost your virginity!")
;	JsonUtil.SetStringValue("/DW/Strings", "VirGain", "You have claimed virginity!")
;	JsonUtil.SetStringValue("/DW/Strings", "Vir1", "First Blood!")
;	JsonUtil.SetStringValue("/DW/Strings", "Vir2", "Power Play!")
;	JsonUtil.SetStringValue("/DW/Strings", "Vir3", "Brutality!")
;	JsonUtil.SetStringValue("/DW/Strings", "Vir4", "Domination!")
;	JsonUtil.SetStringValue("/DW/Strings", "Vir5", "Complete Annihilation!")
;	JsonUtil.SetStringValue("/DW/Strings", "ScriptInitFail", "Dripping when aroused was not installed correctly, scripts are not running. \n This can be false alarm when starting new game but if message keeps repeating, then something is wrong, reinstall with correct plugins.")
;EndFunction

Event OnPlayerLoadGame()
	CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	;DW_JsonRebuild()
	CORE.Startup()
EndEvent

Event OnObjectUnequipped( Form akBaseObject, ObjectReference akReference )
	Actor akActor = GetActorRef()
	if akActor
		if !(CORE.DDi.IsWearingDDGag(akActor)) && !(CORE.zbf.IsWearingZaZGag(akActor))
			akActor.RemoveSpell(CORE.DW_DrippingGag_Spell)
		endif
	endif
EndEvent