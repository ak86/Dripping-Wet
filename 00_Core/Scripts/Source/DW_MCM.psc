Scriptname DW_MCM extends SKI_ConfigBase

DW_CORE property CORE auto

int Page_Virginity_VC_OID
int Page_Virginity_VL_OID
bool ResetVC = false
bool ResetVL = false

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
	if (CORE.DW_ModState05.GetValue() == 0 || CORE.DW_ModState07.GetValue() == 0) && PlayerRef.HasSpell( CORE.DW_Visuals_Spell )	;remove visuals
		PlayerRef.RemoveSpell(CORE.DW_Visuals_Spell)
	endif
	if CORE.DW_ModState06.GetValue() == 0 && PlayerRef.HasSpell( CORE.DW_Heart_Spell )		;remove sound
		PlayerRef.RemoveSpell(CORE.DW_Heart_Spell)
	endif
	if CORE.DW_ModState08.GetValue() == 0 && PlayerRef.HasSpell( CORE.DW_Breath_Spell )		;remove sound
		PlayerRef.RemoveSpell(CORE.DW_Breath_Spell)
	endif
EndFunction

event OnConfigInit()
    ;ModName = "DW"
	self.RefreshStrings()
endEvent

Function RefreshStrings()
	Pages = new string[2]
	Pages[0] = "Settings"
	Pages[1] = "Virginity"
endFunction

event OnPageReset(string page)
;	if page == ""
;		self.LoadCustomContent("MilkMod/MilkLogo.dds")
;	else
;		self.UnloadCustomContent()
;	endif

	if page == "Settings"
		self.Page_Settings()
	elseif page == "Virginity"
		self.Page_Virginity()
	endif

endEvent

function Page_Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Configuration")
			AddSliderOptionST("DW_Timer_Slider", "Script Polling rate", CORE.DW_Timer.GetValue() as int, "{0} sec")
			AddSliderOptionST("DW_SpellsUpdateTimer_Slider", "Effects Polling rate", CORE.DW_SpellsUpdateTimer.GetValue() as int, "{0} sec")
			AddEmptyOption()

			AddToggleOptionST("PreDripping_Toggle", "Dripping Arousal effect", CORE.DW_ModState01.GetValue())
			AddSliderOptionST("Arousal_threshold_Slider", "Dripping Arousal threshold", CORE.DW_Arousal_threshold.GetValue() as int)
			AddEmptyOption()

			AddToggleOptionST("Cloak_Toggle", "NPC Dripping Cloak", CORE.DW_Cloak.GetValue())
			AddSliderOptionST("Cloak_Range_Slider", "Cloak range", CORE.DW_Cloak_Range.GetValue() as int)
			AddEmptyOption()
			
		
			AddToggleOptionST("CumDripping_Toggle", "Dripping Cum Effect", CORE.DW_ModState02.GetValue())
			AddToggleOptionST("SquirtDripping_Toggle", "Female Squirt effect", CORE.DW_ModState03.GetValue())
			AddEmptyOption()

			AddToggleOptionST("GagDrooling_Toggle", "Gag drooling effect", CORE.DW_ModState04.GetValue())
			AddEmptyOption()

			AddToggleOptionST("VLE_Toggle", "Virginity loss effect", CORE.DW_ModState13.GetValue())
			;AddToggleOptionST("VLT_Toggle", "Virginity loss texture", CORE.DW_ModState14.GetValue())
			AddToggleOptionST("VLM_Toggle", "Virginity messages", CORE.DW_ModState15.GetValue())
			AddEmptyOption()

			AddSliderOptionST("DW_effects_light_Slider", "Light Arousal effects threshold", CORE.DW_effects_light.GetValue() as int)
			AddSliderOptionST("DW_effects_heavy_Slider", "Heavy Arousal effects threshold", CORE.DW_effects_heavy.GetValue() as int)
			AddEmptyOption()

			AddToggleOptionST("Visual_Toggle", "Heavy Visuals effect", CORE.DW_ModState05.GetValue())
			AddToggleOptionST("Light_Visual_Toggle", "Light Visuals effect", CORE.DW_ModState07.GetValue())
			AddToggleOptionST("Visual_Disable_Toggle", "Disable during Sl anim", CORE.DW_ModState09.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Heart_Toggle", "Heartbeat effect", CORE.DW_ModState06.GetValue())
			AddToggleOptionST("Breathing_Toggle", "Breathing effect", CORE.DW_ModState08.GetValue())
			AddToggleOptionST("HeartVol_Toggle", "Heartbeat max volume", CORE.DW_ModState11.GetValue())
			AddToggleOptionST("BreathingVol_Toggle", "Breathing max volume", CORE.DW_ModState12.GetValue())
			AddToggleOptionST("Breathing_NPC_Toggle", "NPC Breathing effect", CORE.DW_ModState00.GetValue())
			AddToggleOptionST("Sound_Disable_Toggle", "Disable during Sl anim", CORE.DW_ModState10.GetValue())
			AddEmptyOption()

	SetCursorPosition(1)
		AddHeaderOption("Affected actors")
			int i = 0
			while i <= CORE.DW_Actors.GetSize()
				if CORE.DW_Actors.GetAt(i) != None
					AddTextOption((CORE.DW_Actors.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				endif
				i += 1
			endwhile
endfunction

function Page_Virginity()
	SetCursorFillMode(TOP_TO_BOTTOM)
		if CORE.PlayerVirginityLoss > 1
		AddHeaderOption("Player virginities lost")
			AddTextOption("Total:", CORE.PlayerVirginityLoss, OPTION_FLAG_DISABLED)
		endif
		AddHeaderOption("Player virginities claimed")
			AddTextOption("Total:", CORE.DW_VirginsClaimed.GetSize(), OPTION_FLAG_DISABLED)
			AddTextOption("Since game start:", CORE.DW_VirginsClaimedTG.GetSize(), OPTION_FLAG_DISABLED)
			Page_Virginity_VC_OID = AddToggleOption("Reset", ResetVC)
			int i = 0
			while i <= CORE.DW_VirginsClaimed.GetSize()
				if CORE.DW_VirginsClaimed.GetAt(i) != None
					AddTextOption((CORE.DW_VirginsClaimed.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				endif
				i += 1
			endwhile

	SetCursorPosition(1)
		AddHeaderOption("Skyrim virginities lost")
			AddTextOption("Total:", CORE.DW_VirginsList.GetSize(), OPTION_FLAG_DISABLED)
			Page_Virginity_VL_OID = AddToggleOption("Reset", ResetVL)
			i = 0
			while i <= CORE.DW_VirginsList.GetSize()
				if CORE.DW_VirginsList.GetAt(i) != None
					AddTextOption((CORE.DW_VirginsList.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				endif
				i += 1
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
		if CORE.DW_ModState01.GetValue() != 1
			CORE.DW_ModState01.SetValue(1)
		else
			CORE.DW_ModState01.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState01.GetValue())
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
		if CORE.DW_ModState02.GetValue() != 1
			CORE.DW_ModState02.SetValue(1)
		else
			CORE.DW_ModState02.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState02.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Cum dripping after Anal or Vaginal Sexlab animation, if 1 of actors is male or has SOS")
	endEvent
endState

state SquirtDripping_Toggle
	event OnSelectST()
		if CORE.DW_ModState03.GetValue() != 1
			CORE.DW_ModState03.SetValue(1)
		else
			CORE.DW_ModState03.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState03.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Female squirting during Sexlab orgasm ")
	endEvent
endState

state GagDrooling_Toggle
	event OnSelectST()
		if CORE.DW_ModState04.GetValue() != 1
			CORE.DW_ModState04.SetValue(1)
		else
			CORE.DW_ModState04.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState04.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Gag drooling with ZAZap and DDIntegration Gags")
	endEvent
endState

state VLE_Toggle
	event OnSelectST()
		if CORE.DW_ModState13.GetValue() != 1
			CORE.DW_ModState13.SetValue(1)
		else
			CORE.DW_ModState13.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState13.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Bleed effect")
	endEvent
endState

state VLT_Toggle
	event OnSelectST()
		if CORE.DW_ModState14.GetValue() != 1
			CORE.DW_ModState14.SetValue(1)
		else
			CORE.DW_ModState14.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState14.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Gag drooling with ZAZap and DDIntegration Gags")
	endEvent
endState

state VLM_Toggle
	event OnSelectST()
		if CORE.DW_ModState15.GetValue() != 1
			CORE.DW_ModState15.SetValue(1)
		else
			CORE.DW_ModState15.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState15.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("1,5,10,15,25")
	endEvent
endState

state Visual_Toggle
	event OnSelectST()
		if CORE.DW_ModState05.GetValue() != 1
			CORE.DW_ModState05.SetValue(1)
		else
			CORE.DW_ModState05.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState05.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player high arousal visuals")
	endEvent
endState

state Light_Visual_Toggle
	event OnSelectST()
		if CORE.DW_ModState07.GetValue() != 1
			CORE.DW_ModState07.SetValue(1)
		else
			CORE.DW_ModState07.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState07.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player low arousal visuals")
	endEvent
endState

state Visual_Disable_Toggle
	event OnSelectST()
		if CORE.DW_ModState09.GetValue() != 1
			CORE.DW_ModState09.SetValue(1)
		else
			CORE.DW_ModState09.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState09.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable visuals during sexlab animation")
	endEvent
endState

state Heart_Toggle
	event OnSelectST()
		if CORE.DW_ModState06.GetValue() != 1
			CORE.DW_ModState06.SetValue(1)
		else
			CORE.DW_ModState06.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState06.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Player arousal heartbeat sound")
	endEvent
endState

state Breathing_Toggle
	event OnSelectST()
		if CORE.DW_ModState08.GetValue() != 1
			CORE.DW_ModState08.SetValue(1)
		else
			CORE.DW_ModState08.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState08.GetValue())
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
		if CORE.DW_ModState00.GetValue() != 1
			CORE.DW_ModState00.SetValue(1)
		else
			CORE.DW_ModState00.SetValue(0)
			Maintenance()
		endif
		SetToggleOptionValueST(CORE.DW_ModState00.GetValue())
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

state Virginity_BloodLeak_Toggle
	event OnSelectST()
		if CORE.DW_ModState13.GetValue() != 1
			CORE.DW_ModState13.SetValue(1)
		else
			CORE.DW_ModState13.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState13.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable virginity loss bleeding effect")
	endEvent
endState

state Virginity_BloodTexture_Toggle
	event OnSelectST()
		if CORE.DW_ModState14.GetValue() != 1
			CORE.DW_ModState14.SetValue(1)
		else
			CORE.DW_ModState14.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState14.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable virginity loss bleeding textures")
	endEvent
endState

state Virginity_Messages_Toggle
	event OnSelectST()
		if CORE.DW_ModState15.GetValue() != 1
			CORE.DW_ModState15.SetValue(1)
		else
			CORE.DW_ModState15.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState15.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("Disable virginity claim messages")
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

state DW_SpellsUpdateTimer_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_SpellsUpdateTimer.GetValue())
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 60)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_SpellsUpdateTimer.SetValue(value)
		SetSliderOptionValueST(CORE.DW_SpellsUpdateTimer.GetValue(), "{0} sec")
	endEvent
	
	event OnHighlightST()
		SetInfoText("Visuals(PC), sound effects(PC, NPCs) spells polling rate")
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

event OnOptionSelect(int option)
	if option == Page_Virginity_VC_OID
		CORE.DW_VirginsClaimed.Revert()
		SetToggleOptionValue(Page_Virginity_VC_OID, true)
		ResetVC = false
	elseif option == Page_Virginity_VL_OID
		CORE.DW_VirginsList.Revert()
		SetToggleOptionValue(Page_Virginity_VL_OID, true)
		ResetVL = false
	endif
endevent
