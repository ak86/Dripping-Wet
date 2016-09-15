Scriptname DW_DrippingScr extends ReferenceAlias

DW_CORE property CORE auto

Event OnInit()
	CORE.RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	CORE.RegisterForModEvent("DeviceActorOrgasm", "OnDDOrgasm")
	CORE.RegisterForModEvent("AnimationStart", "OnAnimationStart")
	CORE.RegisterForModEvent("AnimationEnd", "OnAnimationEnd")
	CORE.RegisterForModEvent("StageStart", "OnSexLabStageChange")
	CORE.RegisterForModEvent("RestoreVirginity", "RV")
	CORE.MCM.Maintenance()
	StorageUtil.SetIntValue(game.getplayer(),"DW.PluginsCheck.scripts", 1)
	Utility.wait(1)
	debug.Notification("$DW_INITDONE")
	RegisterForSingleUpdate(1)
	;DW_JsonRebuild()
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
	;debug.Notification("$DW_VIRGINS{" + game.getplayer().GetLeveledActorBase().GetName() + "}CLAIMED")
	CORE.RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	CORE.RegisterForModEvent("DeviceActorOrgasm", "OnDDOrgasm")
	CORE.RegisterForModEvent("AnimationStart", "OnAnimationStart")
	CORE.RegisterForModEvent("AnimationEnd", "OnAnimationEnd")
	CORE.RegisterForModEvent("StageStart", "OnSexLabStageChange")
	CORE.RegisterForModEvent("RestoreVirginity", "RV")
	StorageUtil.SetIntValue(none,"DW.bAnimating", 0)
	;check optionals
	CORE.MCM.Maintenance()
	StorageUtil.SetIntValue(game.getplayer(),"DW.PluginsCheck.scripts", 1)
	CORE.RegisterForSingleUpdate(1)
	CORE.DW_VirginsClaimedTG.Revert()
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	Actor akActor = GetActorRef()
	Int DW_Arousal_threshold = StorageUtil.GetIntValue(none,"DW.Arousal_threshold", 50)
	;cast - spell using onHit to trigger effects
	;addspell - abilities that run constantly

	;if StorageUtil.GetIntValue(none,"DW.bUseSpells") != 1
		if CORE.SLA.GetActorArousal(akActor) > StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33)
			;visuals
			if !(StorageUtil.GetIntValue(none,"DW.bAnimating", 1) && CORE.DW_ModState09.GetValue() == 1)
				if (CORE.DW_ModState05.GetValue() == 1 || CORE.DW_ModState07.GetValue() == 1) && !akActor.HasSpell( CORE.DW_Visuals_Spell )
					akActor.AddSpell( CORE.DW_Visuals_Spell, false )
				endif
			endif
			;sound
			if !(StorageUtil.GetIntValue(none,"DW.bAnimating", 1) && CORE.DW_ModState10.GetValue() == 1) 
				;hearth beat
				if CORE.DW_ModState06.GetValue() == 1 && !akActor.HasSpell( CORE.DW_Heart_Spell )
					akActor.AddSpell( CORE.DW_Heart_Spell, false )
				endif
				;breath
				if CORE.DW_ModState08.GetValue() == 1 && !akActor.HasSpell( CORE.DW_Breath_Spell )
					akActor.AddSpell( CORE.DW_Breath_Spell, false )
				endif
			endif
		endif

		;dripping wet pc
		if CORE.SLA.GetActorArousal(akActor) >= DW_Arousal_threshold
			akActor.AddSpell( CORE.DW_Dripping_Spell, false )
		endif
		
		;dripping gag pc
		if CORE.DDi.IsWearingDDGag(akActor) || CORE.zbf.IsWearingZaZGag(akActor)
			CORE.DW_DrippingGag_Spell.cast( akActor )
		endif
	;endif
	
	;npc cloak
	if StorageUtil.GetIntValue(none,"DW.DW_Cloak", 1) == 1
		Cell akTargetCell = akActor.GetParentCell()
		int iRef = 0
		
		while iRef <= akTargetCell.getNumRefs(43) ;GetType() 62-char,44-lvchar,43-npc
			Actor aNPC = akTargetCell.getNthRef(iRef, 43) as Actor
			
			if aNPC != none
				;dripping wet npc
				If CORE.SLA.GetActorArousal(aNPC) >= DW_Arousal_threshold
					CORE.DW_Dripping_Spell.cast( aNPC )
				EndIf
				
				;dripping gag npc
				if CORE.DDi.IsWearingDDGag(aNPC) || CORE.zbf.IsWearingZaZGag(aNPC)
					CORE.DW_DrippingGag_Spell.cast( aNPC )
				endif
				
				;breath npc
				if CORE.DW_ModState00.GetValue() == 1 && !aNPC.HasSpell( CORE.DW_Breath_Spell ) && aNPC != akActor
					aNPC.AddSpell( CORE.DW_Breath_Spell, false )
				endif
			endif
			
			iRef = iRef + 1
		endWhile
	endif

	RegisterForSingleUpdate(StorageUtil.GetIntValue(none,"DW.DW_Timer", 10))
EndEvent

Event OnObjectUnequipped( Form akBaseObject, ObjectReference akReference )
	Actor akActor = GetActorRef()
	if !(CORE.DDi.IsWearingDDGag(akActor) || CORE.zbf.IsWearingZaZGag(akActor))
		akActor.RemoveSpell(CORE.DW_DrippingGag_Spell)
	endif
EndEvent