Scriptname DW_MCM extends SKI_ConfigBase

DW_CORE property CORE auto

int Page_Virginity_VC_OID
int Page_Virginity_VL_OID
bool ResetVC = false
bool ResetVL = false
bool ForceStart = false

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
	ForceStart = false
EndFunction

event OnConfigInit()
    ModName = "Dripping When Aroused"
	self.RefreshStrings()
endEvent

Function RefreshStrings()
	Pages = new string[2]
	Pages[0] = "$DW_SETTINGS"
	Pages[1] = "$DW_VIRGINITY"
endFunction

event OnPageReset(string page)
;	if page == ""
;		self.LoadCustomContent("MilkMod/MilkLogo.dds")
;	else
;		self.UnloadCustomContent()
;	endif

	if page == "$DW_SETTINGS"
		self.Page_Settings()
	elseif page == "$DW_VIRGINITY"
		self.Page_Virginity()
	endif

endEvent

function Page_Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$DW_CONFIG")
			AddSliderOptionST("DW_Timer_Slider", "$DW_SCRIPTPOLLRATE", CORE.DW_Timer.GetValue(), "$DW_SECONDS")
			AddSliderOptionST("DW_SpellsUpdateTimer_Slider", "$DW_EFFECTPOLLRATE", CORE.DW_SpellsUpdateTimer.GetValue(), "$DW_SECONDS")
			AddEmptyOption()

			AddToggleOptionST("PreDripping_Toggle", "$DW_DRIPAROUSALEFF", CORE.DW_ModState01.GetValue())
			AddSliderOptionST("Arousal_threshold_Slider", "$DW_DRIPAROUSALTHRES", CORE.DW_Arousal_threshold.GetValue())
			AddToggleOptionST("DrippingSLGender_Toggle", "$DW_DRIPAROUSALEFFSLGender", CORE.DW_bUseSLGenderForDripp.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Cloak_Toggle", "$DW_NPCDRIPCLOAK", CORE.DW_bCloak.GetValue())
			AddSliderOptionST("Cloak_Range_Slider", "$DW_CLOAKRANGE", CORE.DW_Cloak_Range.GetValue() as int)
			AddEmptyOption()
			
		
			AddToggleOptionST("CumDripping_Toggle", "$DW_DRIPCUMEFF", CORE.DW_ModState02.GetValue())
			AddToggleOptionST("SquirtDripping_Toggle", "$DW_FEMSQUIRTEFF", CORE.DW_ModState03.GetValue())
			AddToggleOptionST("SquirtDrippingA_Toggle", "$DW_FEMSQUIRTEFFAROUSAL", CORE.DW_bSquirtChanceArousal.GetValue())
			AddSliderOptionST("SquirtDrippingChance_Slider", "$DW_FEMSQUIRTCHANCE", CORE.DW_SquirtChance.GetValue())
			AddToggleOptionST("SquirtSLGender_Toggle", "$DW_FEMSQUIRTEFFSLGender", CORE.DW_bUseSLGenderForSquirt.GetValue())
			AddEmptyOption()
			
			AddToggleOptionST("MilkleakPC_Toggle", "$DW_MILKLEAKPCEFF", CORE.DW_ModState16.GetValue())
			AddToggleOptionST("MilkleakNPC_Toggle", "$DW_MILKLEAKNPCEFF", CORE.DW_ModState17.GetValue())
			AddEmptyOption()

			AddToggleOptionST("GagDrooling_Toggle", "$DW_GAGDROOLEFF", CORE.DW_ModState04.GetValue())
			AddEmptyOption()

			AddToggleOptionST("VLE_Toggle", "$DW_VIRGINLOSSEFF", CORE.DW_ModState13.GetValue())
			;AddToggleOptionST("VLT_Toggle", "$DW_VIRGINLOSSTEX", CORE.DW_ModState14.GetValue())
			AddToggleOptionST("VLM_Toggle", "$DW_VIRGINMSG", CORE.DW_ModState15.GetValue())
			AddToggleOptionST("VLISLS_Toggle", "$DW_IGNORESLSTAT", CORE.DW_bSLStatsIgnore.GetValue())
			AddEmptyOption()

			;AddToggleOptionST("DW_effects_Toggler", "DW_USOP", StorageUtil.GetIntValue(none,"DW.bUseSpells"))
			AddEmptyOption()

			AddSliderOptionST("DW_effects_light_Slider", "$DW_LIGHTAROUSALEFFTHRES", CORE.DW_effects_light.GetValue())
			AddSliderOptionST("DW_effects_heavy_Slider", "$DW_HEAVYAROUSALEFFTHRES", CORE.DW_effects_heavy.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Visual_Toggle", "$DW_HEAVYVISEFF", CORE.DW_ModState05.GetValue())
			AddToggleOptionST("Light_Visual_Toggle", "$DW_LIGHTVISEFF", CORE.DW_ModState07.GetValue())
			AddToggleOptionST("Visual_Disable_Toggle", "$DW_DISABLEVISINSLANIM", CORE.DW_ModState09.GetValue())
			AddEmptyOption()

			AddToggleOptionST("Heart_Toggle", "$DW_HEARTBEATEFF", CORE.DW_ModState06.GetValue())
			AddToggleOptionST("Breathing_Toggle", "$DW_BREATHEFF", CORE.DW_ModState08.GetValue())
			AddToggleOptionST("HeartVol_Toggle", "$DW_HEARTBEATMAXVOL", CORE.DW_ModState11.GetValue())
			AddToggleOptionST("BreathingVol_Toggle", "$DW_BREATHMAXVOL", CORE.DW_ModState12.GetValue())
			AddToggleOptionST("Breathing_NPC_Toggle", "$DW_NPCBREATHEFF", CORE.DW_ModState00.GetValue())
			AddToggleOptionST("Sound_Disable_Toggle", "$DW_DISABLESNDINSLANIM", CORE.DW_ModState10.GetValue())
			AddEmptyOption()

	SetCursorPosition(1)
		AddToggleOptionST("Force_Start_Toggle", "$DW_Force_Start", ForceStart)
		AddEmptyOption()
		AddHeaderOption("$DW_PSE")
		Actor PlayerRef = Game.GetPlayer()
			if PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x9eef , "DW.esp") as magiceffect)
					AddTextOption("$DW_PHVE", OPTION_FLAG_DISABLED)
			endIf
			if PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x9ef0 , "DW.esp") as magiceffect)
					AddTextOption("$DW_PHBE", OPTION_FLAG_DISABLED)
			endIf
			if PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x9ef1 , "DW.esp") as magiceffect)
					AddTextOption("$DW_PHHE", OPTION_FLAG_DISABLED)
			endIf
			AddEmptyOption()
		;AddHeaderOption("$DW_AFFECTEDACTORS")
		;	int i = StorageUtil.FormListCount(none, "DW.Actors")
		;		while(i > 0)
		;			i -= 1
		;			Actor Actors = StorageUtil.FormListGet(none, "DW.Actors", i) as Actor
		;			if Actors != None
		;				AddTextOption(Actors.GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
		;			endif
		;		endwhile
endfunction

function Page_Virginity()
	SetCursorFillMode(TOP_TO_BOTTOM)
		if CORE.DW_PlayerVirginityLoss.GetValue() > 0
			AddHeaderOption("$DW_PCVIRGINLOST")
				AddTextOption("$DW_TOTAL", CORE.DW_PlayerVirginityLoss.GetValue(), OPTION_FLAG_DISABLED)
		endif
		
		AddHeaderOption("$DW_PCVIRGINSCLAIMED")
			AddTextOption("$DW_TOTAL", CORE.DW_VirginsClaimed.GetSize(), OPTION_FLAG_DISABLED)
			AddTextOption("$DW_SINCEGAMESTART", CORE.DW_VirginsClaimedTG.GetSize(), OPTION_FLAG_DISABLED)
			Page_Virginity_VC_OID = AddToggleOption("$DW_RESET", ResetVC)
			int i = CORE.DW_VirginsClaimed.GetSize()
			while i > 0
				i -= 1
				if CORE.DW_VirginsClaimed.GetAt(i) != None
					if (CORE.DW_VirginsClaimed.GetAt(i) as Actor).GetLeveledActorBase().GetName() != ""
						AddTextOption((CORE.DW_VirginsClaimed.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
					endif
				endif
			endwhile

	SetCursorPosition(1)
		AddHeaderOption("$DW_NPCSVIRGNLOST")
			AddTextOption("$DW_TOTAL", CORE.DW_VirginsList.GetSize(), OPTION_FLAG_DISABLED)
			Page_Virginity_VL_OID = AddToggleOption("$DW_RESET", ResetVL)
			
			i = CORE.DW_VirginsList.GetSize()
			while i > 0
				i -= 1
				if CORE.DW_VirginsList.GetAt(i) != None
					if (CORE.DW_VirginsClaimed.GetAt(i) as Actor).GetLeveledActorBase().GetName() != ""
						AddTextOption((CORE.DW_VirginsList.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
					endif
				endif
			endwhile
endfunction

state Cloak_Toggle
	event OnSelectST()
		if CORE.DW_bCloak.GetValue() != 1
			CORE.DW_bCloak.SetValue(1)
		else
			CORE.DW_bCloak.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_bCloak.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_NPCDRIPCLOAK_DESC")
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
		SetInfoText("$DW_DRIPAROUSALEFF_DESC")
	endEvent
endState

state DrippingSLGender_Toggle
	event OnSelectST()
		if CORE.DW_bUseSLGenderForDripp.GetValue() != 1
			CORE.DW_bUseSLGenderForDripp.SetValue(1)
		else
			CORE.DW_bUseSLGenderForDripp.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_bUseSLGenderForDripp.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_DRIPAROUSALEFFSLGender_DESC")
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
		CORE.DW_Arousal_threshold.SetValue(value as int)
		SetSliderOptionValueST(CORE.DW_Arousal_threshold.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_DRIPAROUSALTHRES_DESC")
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
		SetInfoText("$DW_DRIPCUMEFF_DESC")
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
		SetInfoText("$DW_FEMSQUIRTEFF_DESC")
	endEvent
endState

state SquirtDrippingA_Toggle
	event OnSelectST()
		if CORE.DW_bSquirtChanceArousal.GetValue() != 1
			CORE.DW_bSquirtChanceArousal.SetValue(1)
		else
			CORE.DW_bSquirtChanceArousal.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_bSquirtChanceArousal.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_FEMSQUIRTEFFAROUSAL_DESC")
	endEvent
endState

state SquirtSLGender_Toggle
	event OnSelectST()
		if CORE.DW_bUseSLGenderForSquirt.GetValue() != 1
			CORE.DW_bUseSLGenderForSquirt.SetValue(1)
		else
			CORE.DW_bUseSLGenderForSquirt.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_bUseSLGenderForSquirt.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_FEMSQUIRTEFFSLGender_DESC")
	endEvent
endState

state SquirtDrippingChance_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(CORE.DW_SquirtChance.GetValue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		CORE.DW_SquirtChance.SetValue(value as int)
		SetSliderOptionValueST(CORE.DW_SquirtChance.GetValue())
	endEvent
endState

state MilkleakPC_Toggle
	event OnSelectST()
		if CORE.DW_ModState16.GetValue() != 1
			CORE.DW_ModState16.SetValue(1)
		else
			CORE.DW_ModState16.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState16.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_MILKLEAKPCEFF_DESC")
	endEvent
endState

state MilkleakNPC_Toggle
	event OnSelectST()
		if CORE.DW_ModState17.GetValue() != 1
			CORE.DW_ModState17.SetValue(1)
		else
			CORE.DW_ModState17.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_ModState17.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_MILKLEAKNPCEFF_DESC")
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
		SetInfoText("$DW_GAGDROOLEFF_DESC")
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
		SetInfoText("$DW_VIRGINLOSSEFF_DESC")
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
		SetInfoText("$DW_VIRGINLOSSTEX_DESC")
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
		SetInfoText("$DW_VIRGINMSG_DESC")
	endEvent
endState

state VLISLS_Toggle
	event OnSelectST()
		if CORE.DW_bSLStatsIgnore.GetValue() != 1
			CORE.DW_bSLStatsIgnore.SetValue(1)
		else
			CORE.DW_bSLStatsIgnore.SetValue(0)
		endif
		SetToggleOptionValueST(CORE.DW_bSLStatsIgnore.GetValue())
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_IGNORESLSTAT_DESC")
	endEvent
endState

;state DW_effects_Toggler
;	event OnSelectST()
;		if CORE.DW_bUseSpells.GetValue()
;			CORE.DW_bUseSpells.SetValue(1)
;		else
;			CORE.DW_bUseSpells.SetValue(0)
;		endif
;		SetToggleOptionValueST(CORE.DW_bUseSpells.GetValue())
;	endEvent
;	
;	event OnHighlightST()
;		SetInfoText("$DW_USOP_DESC")
;	endEvent
;endState

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
		SetInfoText("$DW_HEAVYVISEFF_DESC")
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
		SetInfoText("$DW_LIGHTVISEFF_DESC")
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
		SetInfoText("$DW_DISABLEVISINSLANIM_DESC")
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
		SetInfoText("$DW_HEARTBEATEFF_DESC")
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
		SetInfoText("$DW_BREATHEFF_DESC")
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
		SetInfoText("$DW_HEARTBEATMAXVOL_DESC")
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
		SetInfoText("$DW_BREATHMAXVOL_DESC")
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
		SetInfoText("$DW_NPCBREATHEFF_DESC")
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
		SetInfoText("$DW_DISABLESNDINSLANIM_DESC")
	endEvent
endState

state Force_Start_Toggle
	event OnSelectST()
		if ForceStart
			!ForceStart
		else
			ForceStart
			CORE.Startup()
			CORE.DW_bSquirtChanceArousal.SetValue(1)
			Quest.GetQuest("DW_Dripping_Status").stop()
			Quest.GetQuest("DW_Dripping_Status").start()
		endif
		
		SetToggleOptionValueST(ForceStart)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_Force_Start_DESC")
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
		SetInfoText("$DW_VIRGINBLOOD_DESC")
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
		SetInfoText("$DW_VIRGINBLOODTEX_DESC")
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
		SetInfoText("$DW_VIRGINCLAIMEDMSG_DESC")
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
		CORE.DW_Timer.SetValue(value as int)
		SetSliderOptionValueST(CORE.DW_Timer.GetValue(), "$DW_SECONDS")
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_SCRIPTPOLLRATE_DESC")
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
		CORE.DW_SpellsUpdateTimer.SetValue(value as int)
		SetSliderOptionValueST(CORE.DW_SpellsUpdateTimer.GetValue(), "$DW_SECONDS")
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_EFFECTPOLLRATE_DESC")
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
		CORE.DW_effects_light.SetValue(value as int)
		SetSliderOptionValueST(CORE.DW_effects_light.GetValue())
		Maintenance()
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_LIGHTAROUSALEFFTHRES_DESC")
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
		CORE.DW_effects_heavy.SetValue(value as int)
		SetSliderOptionValueST(CORE.DW_effects_heavy.GetValue())
		Maintenance()
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_HEAVYAROUSALEFFTHRES_DESC")
	endEvent
endState

event OnOptionSelect(int option)
	if option == Page_Virginity_VC_OID
		CORE.DW_VirginsClaimed.Revert()
		SetToggleOptionValue(Page_Virginity_VC_OID, true)
		ResetVC = false
	elseif option == Page_Virginity_VL_OID
		CORE.DW_bPlayerIsVirgin.SetValue(1)
		CORE.DW_VirginsList.Revert()
		SetToggleOptionValue(Page_Virginity_VL_OID, true)
		ResetVL = false
	endif
endevent
