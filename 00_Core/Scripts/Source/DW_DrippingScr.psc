Scriptname DW_DrippingScr extends ReferenceAlias

DW_CORE property CORE auto

Actor akActor

Event OnInit()
	RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	RegisterForModEvent("HookAnimationStart", "AnimationStart")
	RegisterForModEvent("HookAnimationEnd", "AnimationEnd")
	CORE.MCM.Maintenance()
	CORE.DW_Status_Global.SetValue(1)
	debug.Notification("Dripping when aroused initialised.")
	RegisterForSingleUpdate(1)
Endevent

Event OnPlayerLoadGame()
	RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	RegisterForModEvent("HookAnimationStart", "AnimationStart")
	RegisterForModEvent("HookAnimationEnd", "AnimationEnd")
	CORE.bAnimating == false
	;check optionals
	CORE.MCM.Maintenance()
	CORE.DW_Status_Global.SetValue(1)
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	akActor = GetActorRef()
		
	if CORE.SLA.GetActorArousal(akActor) > CORE.DW_effects_light.GetValue()
		;visuals
		if !(CORE.bAnimating == true && CORE.DW_ModState9.GetValue() == 1)
			if (CORE.DW_ModState5.GetValue() == 1 || CORE.DW_ModState7.GetValue() == 1) && !akActor.HasSpell( CORE.DW_Visuals_Spell )
				akActor.AddSpell( CORE.DW_Visuals_Spell, false )
			endif
		endif
		;sound
		if !(CORE.bAnimating == true && CORE.DW_ModState10.GetValue() == 1) 
			;hearth beat
			if CORE.DW_ModState6.GetValue() == 1 && !akActor.HasSpell( CORE.DW_Heart_Spell )
				akActor.AddSpell( CORE.DW_Heart_Spell, false )
			endif
			;breath
			if CORE.DW_ModState8.GetValue() == 1 && !akActor.HasSpell( CORE.DW_Breath_Spell )
				akActor.AddSpell( CORE.DW_Breath_Spell, false )
			endif
		endif
	endif

	;dripping wet pc
	if CORE.SLA.GetActorArousal(akActor) >= CORE.DW_Arousal_threshold.GetValue()
		akActor.AddSpell( CORE.DW_Dripping_Spell, false )
	endif
	
	;dripping gag pc
	if CORE.DDi.IsWearingDDGag(akActor) || CORE.zbf.IsWearingZaZGag(akActor)
		CORE.DW_DrippingGag_Spell.cast( akActor )
	endif
	
	;npc cloak
	if CORE.DW_Cloak.GetValue() == 1
		Cell akTargetCell = akActor.GetParentCell()
		int iRef = 0
		
		while iRef <= akTargetCell.getNumRefs(43) ;GetType() 62-char,44-lvchar,43-npc
			Actor aNPC = akTargetCell.getNthRef(iRef, 43) as Actor
			
			if aNPC != none
				;dripping wet npc
				If CORE.SLA.GetActorArousal(aNPC) >= CORE.DW_Arousal_threshold.GetValue()
					CORE.DW_Dripping_Spell.cast( aNPC )
				EndIf
				
				;dripping gag npc
				if CORE.DDi.IsWearingDDGag(aNPC) || CORE.zbf.IsWearingZaZGag(aNPC)
					CORE.DW_DrippingGag_Spell.cast( aNPC )
				endif
			endif
			
			iRef = iRef + 1
		endWhile
	endif

	RegisterForSingleUpdate(CORE.DW_Timer.GetValue())
EndEvent

Event OnObjectUnequipped( Form akBaseObject, ObjectReference akReference )
	akActor = GetActorRef()
	if !(CORE.DDi.IsWearingDDGag(akActor) || CORE.zbf.IsWearingZaZGag(akActor))
		akActor.RemoveSpell(CORE.DW_DrippingGag_Spell)
	endif
EndEvent

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	Actor[] actors = CORE.SexLab.HookActors(_args)
	int idx = 0
	sslBaseAnimation animation = CORE.SexLab.HookAnimation(_args)
	
	if (animation.HasTag("Anal") || animation.HasTag("Vaginal")) && actors.Length > 1
		If CORE.SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1
			CORE.DW_DrippingCum_Spell.cast( actors[0] )
		EndIf
	endif
	
	While idx < actors.Length
		CORE.DW_DrippingSquirt_Spell.cast( actors[idx] )
		idx += 1
	EndWhile
EndEvent

Event AnimationStart(int threadID, bool HasPlayer)
	akActor = GetActorRef()
	if HasPlayer == true
		CORE.bAnimating = true
		if CORE.DW_ModState9.GetValue() == 1	;remove visuals
			akActor.RemoveSpell(CORE.DW_Visuals_Spell)
		endif
		if CORE.DW_ModState10.GetValue() == 1	;remove sound
			akActor.RemoveSpell(CORE.DW_Heart_Spell)
			akActor.RemoveSpell(CORE.DW_Breath_Spell)
		endif
	endif
EndEvent

Event AnimationEnd(int threadID, bool HasPlayer)
	if HasPlayer == true
		CORE.bAnimating = false
	endif
EndEvent
