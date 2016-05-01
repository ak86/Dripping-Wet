Scriptname DW_MCM extends SKI_ConfigBase

DW_CORE property CORE auto

Function Maintenance()
	if CORE.DW_effects_heavy.GetValue() < 0 || CORE.DW_effects_heavy.GetValue() == 100
		CORE.DW_effects_heavy.SetValue(66)
	endif
	if CORE.DW_effects_light.GetValue() < 0 || CORE.DW_effects_light.GetValue() == 100
		CORE.DW_effects_light.SetValue(33)
	endif
	if CORE.DW_effects_light.GetValue() >= CORE.DW_effects_heavy.GetValue() && CORE.DW_effects_heavy.GetValue() >= 1
		CORE.DW_effects_light.SetValue(CORE.DW_effects_heavy.GetValue() - 1)
	endif
	
	Actor PlayerRef = Game.GetPlayer()
	if (CORE.DW_ModState5.GetValue() == 0 || CORE.DW_ModState7.GetValue() == 0) && PlayerRef.HasSpell( CORE.DW_Visuals_Spell )	;remove visuals
		PlayerRef.RemoveSpell(CORE.DW_Visuals_Spell)
	endif
	if CORE.DW_ModState6.GetValue() == 0 && PlayerRef.HasSpell( CORE.DW_Heart_Spell )		;remove sound
		PlayerRef.RemoveSpell(CORE.DW_Heart_Spell)
	endif
	if CORE.DW_ModState8.GetValue() == 0 && PlayerRef.HasSpell( CORE.DW_Breath_Spell )		;remove sound
		PlayerRef.RemoveSpell(CORE.DW_Breath_Spell)
	endif
EndFunction

event OnPageReset(string page)
	Page_Settings()
endEvent

function Page_Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Configuration")
			AddSliderOptionST("DW_Timer_Slider", "Scrip Polling rate", CORE.DW_Timer.GetValue() as int, "{0} sec")
			AddEmptyOption()

			AddToggleOptionST("PreDripping_Toggle", "Dripping Arousal effect", CORE.DW_ModState1.GetValue())
			AddSliderOptionST("Arousal_threshold_Slider", "Dripping Arousal threshold", CORE.DW_Arousal_threshold.GetValue() as int)
			AddEmptyOption()

			AddToggleOptionST("Cloak_Toggle", "NPC Dripping Cloak", CORE.DW_Cloak.GetValue())
			AddSliderOptionST("Cloak_Range_Slider", "Cloak range", CORE.DW_Cloak_Range.GetValue() as int)
			AddEmptyOption()
			
		
			AddToggleOptionST("CumDripping_Toggle", "Dripping Cum Effect", CORE.DW_ModState2.GetValue())
			AddToggleOptionST("SquirtDripping_Toggle", "Female Squirt effect", CORE.DW_ModState3.GetValue())
			AddEmptyOption()

			AddToggleOptionST("GagDrooling_Toggle", "Gag drooling effect", CORE.DW_ModState4.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Visual_Toggle", "Heavy Visuals effect", CORE.DW_ModState5.GetValue())
			AddToggleOptionST("Light_Visual_Toggle", "Light Visuals effect", CORE.DW_ModState7.GetValue())
			AddToggleOptionST("Visual_Disable_Toggle", "Disable during Sl anim", CORE.DW_ModState9.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Heart_Toggle", "Heartbeat effect", CORE.DW_ModState6.GetValue())
			AddToggleOptionST("Breathing_Toggle", "Breathing effect", CORE.DW_ModState8.GetValue())
			AddToggleOptionST("HeartVol_Toggle", "Heartbeat max volume", CORE.DW_ModState11.GetValue())
			AddToggleOptionST("BreathingVol_Toggle", "Breathing max volume", CORE.DW_ModState12.GetValue())
			AddToggleOptionST("Breathing_NPC_Toggle", "NPC Breathing effect", CORE.DW_ModState0.GetValue())
			AddToggleOptionST("Sound_Disable_Toggle", "Disable during Sl anim", CORE.DW_ModState10.GetValue())
			AddEmptyOption()
		
			AddSliderOptionST("DW_effects_light_Slider", "Light Arousal effects threshold", CORE.DW_effects_light.GetValue() as int)
			AddSliderOptionST("DW_effects_heavy_Slider", "Heavy Arousal effects threshold", CORE.DW_effects_heavy.GetValue() as int)

			SetCursorPosition(1)
		AddHeaderOption("Affected actors")
			int i = 0
			while i <= CORE.DW_Actors.GetSize()
				if CORE.DW_Actors.GetAt(i) != None
					AddTextOption((CORE.DW_Actors.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				endif
				i = i +1
			endwhile
endfunction	

state Cloak_Toggle
	event OnSelectST()
		if CORE.DW_Cloak.GetValue() != 1
			CORE.DW_Cloak.SetValue(1)
		else
			CORE.DW_Cloak.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_Cloak.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Cloak for NPCs dripping,gag,breath effects")
	endEvent
endState

state Cloak_Range_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_Cloak_Range.GetValue())
		SetSliderDialogDefaultValue(500)
		SetSliderDialogRange(0, 5000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_Cloak_Range.SetValue(value)
		SetSliderOptionValueST(CORE.DW_Cloak_Range.GetValue())
	endEvent
endState

state PreDripping_Toggle
	event OnSelectST()
		if CORE.DW_ModState1.GetValue() != 1
			CORE.DW_ModState1.SetValue(1)
		else
			CORE.DW_ModState1.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState1.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Female arousal dripping effect")
	endEvent
endState

state Arousal_threshold_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_Arousal_threshold.GetValue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_Arousal_threshold.SetValue(value)
		SetSliderOptionValueST(CORE.DW_Arousal_threshold.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Amount of arousal required for dripping effect")
	endEvent
endState

state CumDripping_Toggle
	event OnSelectST()
		if CORE.DW_ModState2.GetValue() != 1
			CORE.DW_ModState2.SetValue(1)
		else
			CORE.DW_ModState2.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState2.GetValue())
	endEvent
	event OnHighlightST()
		SetInfoText("Cum dripping after Anal or Vaginal Sexlab animation, if 1 of actors is male or has SOS")
	endEvent
endState

state SquirtDripping_Toggle
	event OnSelectST()
		if CORE.DW_ModState3.GetValue() != 1
			CORE.DW_ModState3.SetValue(1)
		else
			CORE.DW_ModState3.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState3.GetValue())
	endEvent
	event OnHighlightST()
		SetInfoText("Female squirting during Sexlab orgasm ")
	endEvent
endState

state GagDrooling_Toggle
	event OnSelectST()
		if CORE.DW_ModState4.GetValue() != 1
			CORE.DW_ModState4.SetValue(1)
		else
			CORE.DW_ModState4.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState4.GetValue())
	endEvent
	event OnHighlightST()
		SetInfoText("Gag drooling with ZAZap and DDIntegration Gags")
	endEvent
endState

state Visual_Toggle
	event OnSelectST()
		if CORE.DW_ModState5.GetValue() != 1
			CORE.DW_ModState5.SetValue(1)
		else
			CORE.DW_ModState5.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState5.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player high arousal visuals")
	endEvent
endState

state Light_Visual_Toggle
	event OnSelectST()
		if CORE.DW_ModState7.GetValue() != 1
			CORE.DW_ModState7.SetValue(1)
		else
			CORE.DW_ModState7.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState7.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player low arousal visuals")
	endEvent
endState

state Visual_Disable_Toggle
	event OnSelectST()
		if CORE.DW_ModState9.GetValue() != 1
			CORE.DW_ModState9.SetValue(1)
		else
			CORE.DW_ModState9.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState9.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable visuals during sexlab animation")
	endEvent
endState

state Heart_Toggle
	event OnSelectST()
		if CORE.DW_ModState6.GetValue() != 1
			CORE.DW_ModState6.SetValue(1)
		else
			CORE.DW_ModState6.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState6.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player arousal heartbeat sound")
	endEvent
endState

state Breathing_Toggle
	event OnSelectST()
		if CORE.DW_ModState8.GetValue() != 1
			CORE.DW_ModState8.SetValue(1)
		else
			CORE.DW_ModState8.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState8.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player arousal breathing sound")
	endEvent
endState

state HeartVol_Toggle
	event OnSelectST()
		if CORE.DW_ModState11.GetValue() != 1
			CORE.DW_ModState11.SetValue(1)
		else
			CORE.DW_ModState11.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState11.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Use always max volume for heartbeat sound instead of arousal based")
	endEvent
endState

state BreathingVol_Toggle
	event OnSelectST()
		if CORE.DW_ModState12.GetValue() != 1
			CORE.DW_ModState12.SetValue(1)
		else
			CORE.DW_ModState12.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState12.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Use always max volume for breathing sound instead of arousal based")
	endEvent
endState

state Breathing_NPC_Toggle
	event OnSelectST()
		if CORE.DW_ModState0.GetValue() != 1
			CORE.DW_ModState0.SetValue(1)
		else
			CORE.DW_ModState0.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState0.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Npc arousal breathing sound")
	endEvent
endState

state Sound_Disable_Toggle
	event OnSelectST()
		if CORE.DW_ModState10.GetValue() != 1
			CORE.DW_ModState10.SetValue(1)
		else
			CORE.DW_ModState10.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState10.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable heart/breath sound during sexlab animation")
	endEvent
endState

state DW_Timer_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_Timer.GetValue())
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(5, 120)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_Timer.SetValue(value)
		SetSliderOptionValueST(CORE.DW_Timer.GetValue(), "{0} sec")
	endEvent
	
	event OnHighlightST()
		SetInfoText("Cloak polling rate, PC and NPC")
	endEvent
endState

state DW_effects_light_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_effects_light.GetValue())
		SetSliderDialogDefaultValue(33)
		SetSliderDialogRange(1, 99)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_effects_light.SetValue(value)
		SetSliderOptionValueST(CORE.DW_effects_light.GetValue())
		Maintenance()
	endEvent
	
	event OnHighlightST()
		SetInfoText("Amount of arousal required for light visual/sound effects")
	endEvent
endState

state DW_effects_heavy_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_effects_heavy.GetValue())
		SetSliderDialogDefaultValue(66)
		SetSliderDialogRange(1, 99)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_effects_heavy.SetValue(value)
		SetSliderOptionValueST(CORE.DW_effects_heavy.GetValue())
		Maintenance()
	endEvent
	
	event OnHighlightST()
		SetInfoText("Amount of arousal required for heavy visual/sound effects")
	endEvent
endState
