Scriptname DW_DrippingScr extends ReferenceAlias

DW_CORE property CORE auto

Actor akActor

Event OnInit()
	RegisterForSingleUpdate(1)
Endevent

Event OnPlayerLoadGame()
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	akActor = GetActorRef()
	;cast - spell using onHit to trigger effects
	;addspell - abilities that run constantly
		
	if CORE.SLA.GetActorArousal(akActor) > CORE.DW_effects_light.GetValue()
		;visuals
		if !(CORE.bAnimating == true && CORE.DW_ModState09.GetValue() == 1)
			if (CORE.DW_ModState05.GetValue() == 1 || CORE.DW_ModState07.GetValue() == 1) && !akActor.HasSpell( CORE.DW_Visuals_Spell )
				akActor.AddSpell( CORE.DW_Visuals_Spell, false )
			endif
		endif
		;sound
		if !(CORE.bAnimating == true && CORE.DW_ModState10.GetValue() == 1) 
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
				
				;breath npc
				if CORE.DW_ModState00.GetValue() == 1 && !aNPC.HasSpell( CORE.DW_Breath_Spell )
					aNPC.AddSpell( CORE.DW_Breath_Spell, false )
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