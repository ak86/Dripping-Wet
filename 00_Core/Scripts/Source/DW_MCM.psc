Scriptname DW_MCM extends SKI_ConfigBase

GlobalVariable Property DW_Timer Auto
GlobalVariable Property DW_Cloak Auto
GlobalVariable Property DW_ModState0 Auto
GlobalVariable Property DW_ModState1 Auto
GlobalVariable Property DW_ModState2 Auto
GlobalVariable Property DW_ModState3 Auto
GlobalVariable Property DW_ModState4 Auto
GlobalVariable Property DW_ModState5 Auto
GlobalVariable Property DW_ModState6 Auto
GlobalVariable Property DW_ModState7 Auto
GlobalVariable Property DW_ModState8 Auto
GlobalVariable Property DW_ModState9 Auto
GlobalVariable Property DW_ModState10 Auto
GlobalVariable Property DW_effects_light Auto
GlobalVariable Property DW_effects_heavy Auto
GlobalVariable Property DW_Cloak_Range Auto
GlobalVariable Property DW_Arousal_threshold Auto
FormList Property DW_Actors Auto

event OnPageReset(string page)
	Page_Settings()
endEvent

function Page_Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Configuration")
			AddToggleOptionST("IntegrationWarnings_Toggle", "Integration warnings", DW_ModState0.GetValue())
			AddSliderOptionST("DW_Timer_Slider", "Scrip Polling rate", DW_Timer.GetValue() as int, "{0} sec")
			AddEmptyOption()

			AddToggleOptionST("PreDripping_Toggle", "Dripping Arousal effect", DW_ModState1.GetValue())
			AddSliderOptionST("Arousal_threshold_Slider", "Dripping Arousal threshold", DW_Arousal_threshold.GetValue() as int)
			AddEmptyOption()

			AddToggleOptionST("Cloak_Toggle", "NPC Dripping Cloak", DW_Cloak.GetValue())
			AddSliderOptionST("Cloak_Range_Slider", "Cloak range", DW_Cloak_Range.GetValue() as int)
			AddEmptyOption()
			
		
			AddToggleOptionST("CumDripping_Toggle", "Dripping Cum Effect", DW_ModState2.GetValue())
			AddToggleOptionST("SquirtDripping_Toggle", "Female Squirt effect", DW_ModState3.GetValue())
			AddEmptyOption()

			AddToggleOptionST("GagDrooling_Toggle", "Gag drooling effect", DW_ModState4.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Visual_Toggle", "Heavy Visuals effect", DW_ModState5.GetValue())
			AddToggleOptionST("Light_Visual_Toggle", "Light Visuals effect", DW_ModState7.GetValue())
			AddToggleOptionST("Visual_Disable_Toggle", "Disable during Sl anim", DW_ModState9.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Heart_Toggle", "Heartbeat effect", DW_ModState6.GetValue())
			AddToggleOptionST("Breathing_Toggle", "Breathing effect", DW_ModState8.GetValue())
			AddToggleOptionST("Sound_Disable_Toggle", "Disable during Sl anim", DW_ModState10.GetValue())
			AddEmptyOption()
		
			AddSliderOptionST("DW_effects_light_Slider", "Light Arousal effects threshold", DW_effects_light.GetValue() as int)
			AddSliderOptionST("DW_effects_heavy_Slider", "Heavy Arousal effects threshold", DW_effects_heavy.GetValue() as int)

			SetCursorPosition(1)
		AddHeaderOption("Affected actors")
			int i = 0
			while i <= DW_Actors.GetSize()
				if DW_Actors.GetAt(i) != None
					AddTextOption((DW_Actors.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				endif
				i = i +1
			endwhile
endfunction	

state Cloak_Toggle
	event OnSelectST()
		if DW_Cloak.GetValue() != 1
			DW_Cloak.SetValue(1)
		else
			DW_Cloak.SetValue(0)
		endif
		SetToggleOptionValueST(DW_Cloak.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Cloak for NPCs dripping effect")
	endEvent
endState

state Cloak_Range_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(DW_Cloak_Range.GetValue())
		SetSliderDialogDefaultValue(500)
		SetSliderDialogRange(0, 5000)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		DW_Cloak_Range.SetValue(value)
		SetSliderOptionValueST(DW_Cloak_Range.GetValue())
	endEvent
endState

state IntegrationWarnings_Toggle
	event OnSelectST()
		if DW_ModState0.GetValue() != 1
			DW_ModState0.SetValue(1)
		else
			DW_ModState0.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState0.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Integration warnings during game launch")
	endEvent
endState

state PreDripping_Toggle
	event OnSelectST()
		if DW_ModState1.GetValue() != 1
			DW_ModState1.SetValue(1)
		else
			DW_ModState1.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState1.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Female arousal dripping effect")
	endEvent
endState

state Arousal_threshold_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(DW_Arousal_threshold.GetValue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		DW_Arousal_threshold.SetValue(value)
		SetSliderOptionValueST(DW_Arousal_threshold.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Amount of arousal required for dripping effect")
	endEvent
endState

state CumDripping_Toggle
	event OnSelectST()
		if DW_ModState2.GetValue() != 1
			DW_ModState2.SetValue(1)
		else
			DW_ModState2.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState2.GetValue())
	endEvent
	event OnHighlightST()
		SetInfoText("Cum dripping after Anal or Vaginal Sexlab animation, if 1 of actors is male or has SOS")
	endEvent
endState

state SquirtDripping_Toggle
	event OnSelectST()
		if DW_ModState3.GetValue() != 1
			DW_ModState3.SetValue(1)
		else
			DW_ModState3.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState3.GetValue())
	endEvent
	event OnHighlightST()
		SetInfoText("Female squirting during Sexlab orgasm ")
	endEvent
endState

state GagDrooling_Toggle
	event OnSelectST()
		if DW_ModState4.GetValue() != 1
			DW_ModState4.SetValue(1)
		else
			DW_ModState4.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState4.GetValue())
	endEvent
	event OnHighlightST()
		SetInfoText("Gag drooling with ZAZap and DDIntegration Gags")
	endEvent
endState

state Visual_Toggle
	event OnSelectST()
		if DW_ModState5.GetValue() != 1
			DW_ModState5.SetValue(1)
		else
			DW_ModState5.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState5.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player high arousal visuals")
	endEvent
endState

state Light_Visual_Toggle
	event OnSelectST()
		if DW_ModState7.GetValue() != 1
			DW_ModState7.SetValue(1)
		else
			DW_ModState7.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState7.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player high arousal visuals(light version)")
	endEvent
endState

state Visual_Disable_Toggle
	event OnSelectST()
		if DW_ModState9.GetValue() != 1
			DW_ModState9.SetValue(1)
		else
			DW_ModState9.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState9.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable visuals during sexlab animation")
	endEvent
endState

state Heart_Toggle
	event OnSelectST()
		if DW_ModState6.GetValue() != 1
			DW_ModState6.SetValue(1)
		else
			DW_ModState6.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState6.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player high arousal heartbeat sound")
	endEvent
endState

state Breathing_Toggle
	event OnSelectST()
		if DW_ModState8.GetValue() != 1
			DW_ModState8.SetValue(1)
		else
			DW_ModState8.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState8.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player high arousal breathing sound")
	endEvent
endState

state Sound_Disable_Toggle
	event OnSelectST()
		if DW_ModState10.GetValue() != 1
			DW_ModState10.SetValue(1)
		else
			DW_ModState10.SetValue(0)
		endif
		SetToggleOptionValueST(DW_ModState10.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable heart/breath sound during sexlab animation")
	endEvent
endState

state DW_Timer_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(DW_Timer.GetValue())
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(5, 120)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		DW_Timer.SetValue(value)
		SetSliderOptionValueST(DW_Timer.GetValue(), "{0} sec")
	endEvent
	
	event OnHighlightST()
		SetInfoText("Cloak polling rate, PC and NPC")
	endEvent
endState

state DW_effects_light_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(DW_effects_light.GetValue())
		SetSliderDialogDefaultValue(33)
		SetSliderDialogRange(1, 99)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		DW_effects_light.SetValue(value)
		SetSliderOptionValueST(DW_effects_light.GetValue())

		if DW_effects_light.GetValue() >= DW_effects_heavy.GetValue()
			DW_effects_light.SetValue(DW_effects_heavy.GetValue() - 1)
		endif
		if DW_effects_light.GetValue() == 0 || DW_effects_light.GetValue() == 100 || DW_effects_heavy.GetValue() == DW_effects_light.GetValue()
			DW_effects_heavy.SetValue(33)
		endif
	endEvent
	
	event OnHighlightST()
		SetInfoText("Amount of arousal required for light visual/sound effects")
	endEvent
endState

state DW_effects_heavy_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(DW_effects_heavy.GetValue())
		SetSliderDialogDefaultValue(66)
		SetSliderDialogRange(1, 99)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		DW_effects_heavy.SetValue(value)
		SetSliderOptionValueST(DW_effects_heavy.GetValue())
		
		if DW_effects_light.GetValue() >= DW_effects_heavy.GetValue()
			DW_effects_light.SetValue(DW_effects_heavy.GetValue() - 1)
		endif
		if DW_effects_heavy.GetValue() == 0 || DW_effects_heavy.GetValue() == 100 || DW_effects_heavy.GetValue() == DW_effects_light.GetValue()
			DW_effects_heavy.SetValue(66)
		endif
	endEvent
	
	event OnHighlightST()
		SetInfoText("Amount of arousal required for heavy visual/sound effects")
	endEvent
endState
