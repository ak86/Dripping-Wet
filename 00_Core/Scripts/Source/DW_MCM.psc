Scriptname DW_MCM extends SKI_ConfigBase

DW_CORE property CORE auto

int Page_Virginity_VC_OID
int Page_Virginity_VL_OID
bool ResetVC = false
bool ResetVL = false

Function Maintenance()
	if StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66) < 0 || StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66) == 100
		StorageUtil.SetIntValue(none,"DW.DW_effects_heavy", 66)
	endif
	if StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33) < 0 || StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33) == 100
		StorageUtil.SetIntValue(none,"DW.DW_effects_light", 33)
	endif
	if StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33) >= StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66) && StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66) >= 1
		StorageUtil.SetIntValue(none,"DW.DW_effects_light", StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66) - 1)
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
			AddSliderOptionST("DW_Timer_Slider", "$DW_SCRIPTPOLLRATE", StorageUtil.GetIntValue(none,"DW.DW_Timer", 10), "$DW_SECONDS")
			AddSliderOptionST("DW_SpellsUpdateTimer_Slider", "$DW_EFFECTPOLLRATE", StorageUtil.GetIntValue(none,"DW.DW_SpellsUpdateTimer", 1), "$DW_SECONDS")
			AddEmptyOption()

			AddToggleOptionST("PreDripping_Toggle", "$DW_DRIPAROUSALEFF", CORE.DW_ModState01.GetValue())
			AddSliderOptionST("Arousal_threshold_Slider", "$DW_DRIPAROUSALTHRES", StorageUtil.GetIntValue(none,"DW.Arousal_threshold", 50))
			AddToggleOptionST("DrippingSLGender_Toggle", "$DW_DRIPAROUSALEFFSLGender", StorageUtil.GetIntValue(none,"DW.UseSLGenderForDripp"))
			AddEmptyOption()

			AddToggleOptionST("Cloak_Toggle", "$DW_NPCDRIPCLOAK", StorageUtil.GetIntValue(none,"DW.DW_Cloak", 1))
			AddSliderOptionST("Cloak_Range_Slider", "$DW_CLOAKRANGE", CORE.DW_Cloak_Range.GetValue() as int)
			AddEmptyOption()
			
		
			AddToggleOptionST("CumDripping_Toggle", "$DW_DRIPCUMEFF", CORE.DW_ModState02.GetValue())
			AddToggleOptionST("SquirtDripping_Toggle", "$DW_FEMSQUIRTEFF", CORE.DW_ModState03.GetValue())
			AddSliderOptionST("SquirtDrippingChance_Slider", "$DW_FEMSQUIRTCHANCE", StorageUtil.GetIntValue(none,"DW.SquirtChance", 50))
			AddToggleOptionST("SquirtSLGender_Toggle", "$DW_FEMSQUIRTEFFSLGender", StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt"))
			AddEmptyOption()

			AddToggleOptionST("GagDrooling_Toggle", "$DW_GAGDROOLEFF", CORE.DW_ModState04.GetValue())
			AddEmptyOption()

			AddToggleOptionST("VLE_Toggle", "$DW_VIRGINLOSSEFF", CORE.DW_ModState13.GetValue())
			;AddToggleOptionST("VLT_Toggle", "$DW_VIRGINLOSSTEX", CORE.DW_ModState14.GetValue())
			AddToggleOptionST("VLM_Toggle", "$DW_VIRGINMSG", CORE.DW_ModState15.GetValue())
			AddToggleOptionST("VLISLS_Toggle", "$DW_IGNORESLSTAT", StorageUtil.GetIntValue(none,"DW.bSLStatsIgnore"))
			AddEmptyOption()

			;AddToggleOptionST("DW_effects_Toggler", "DW_USOP", StorageUtil.GetIntValue(none,"DW.bUseSpells"))
			AddEmptyOption()

			AddSliderOptionST("DW_effects_light_Slider", "$DW_LIGHTAROUSALEFFTHRES", StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33))
			AddSliderOptionST("DW_effects_heavy_Slider", "$DW_HEAVYAROUSALEFFTHRES", StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66))
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
		AddHeaderOption("$DW_AFFECTEDACTORS")
			int i = StorageUtil.FormListCount(none, "DW.Actors")
				while(i > 0)
					i -= 1
					Actor Actors = StorageUtil.FormListGet(none, "DW.Actors", i) as Actor
					if Actors != None
						AddTextOption(Actors.GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
					endif
				endwhile
endfunction

function Page_Virginity()
	SetCursorFillMode(TOP_TO_BOTTOM)
		if StorageUtil.GetIntValue(none,"DW.PlayerVirginityLoss", 0) > 0
			AddHeaderOption("$DW_PCVIRGINLOST")
				AddTextOption("$DW_TOTAL", StorageUtil.GetIntValue(none,"DW.PlayerVirginityLoss", 0), OPTION_FLAG_DISABLED)
		endif
		
		AddHeaderOption("$DW_PCVIRGINSCLAIMED")
			AddTextOption("$DW_TOTAL", CORE.DW_VirginsClaimed.GetSize(), OPTION_FLAG_DISABLED)
			AddTextOption("$DW_SINCEGAMESTART", CORE.DW_VirginsClaimedTG.GetSize(), OPTION_FLAG_DISABLED)
			Page_Virginity_VC_OID = AddToggleOption("$DW_RESET", ResetVC)
			int i = 0
			while i <= CORE.DW_VirginsClaimed.GetSize()
				if CORE.DW_VirginsClaimed.GetAt(i) != None
					AddTextOption((CORE.DW_VirginsClaimed.GetAt(i) as Actor).GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				endif
				i += 1
			endwhile

	SetCursorPosition(1)
		AddHeaderOption("$DW_NPCSVIRGNLOST")
			AddTextOption("$DW_TOTAL", CORE.DW_VirginsList.GetSize(), OPTION_FLAG_DISABLED)
			Page_Virginity_VL_OID = AddToggleOption("$DW_RESET", ResetVL)
			
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
		if StorageUtil.GetIntValue(none,"DW.DW_Cloak", 1) != 1
			StorageUtil.SetIntValue(none,"DW.DW_Cloak", 1)
		else
			StorageUtil.SetIntValue(none,"DW.DW_Cloak", 0)
		endif
		SetToggleOptionValueST(StorageUtil.GetIntValue(none,"DW.DW_Cloak", 1))
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
		if StorageUtil.GetIntValue(none,"DW.UseSLGenderForDripp") != 1
			StorageUtil.SetIntValue(none,"DW.UseSLGenderForDripp", 1)
		else
			StorageUtil.SetIntValue(none,"DW.UseSLGenderForDripp", 0)
		endif
		SetToggleOptionValueST(StorageUtil.GetIntValue(none,"DW.UseSLGenderForDripp"))
	endEvent
endState

state Arousal_threshold_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(StorageUtil.GetIntValue(none,"DW.Arousal_threshold", 50))
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		StorageUtil.SetIntValue(none,"DW.Arousal_threshold", value as int)
		SetSliderOptionValueST(StorageUtil.GetIntValue(none,"DW.Arousal_threshold"))
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

state SquirtSLGender_Toggle
	event OnSelectST()
		if StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt") != 1
			StorageUtil.SetIntValue(none,"DW.UseSLGenderForSquirt", 1)
		else
			StorageUtil.SetIntValue(none,"DW.UseSLGenderForSquirt", 0)
		endif
		SetToggleOptionValueST(StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt"))
	endEvent
endState

state SquirtDrippingChance_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(StorageUtil.GetIntValue(none,"DW.SquirtChance", 50))
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		StorageUtil.SetIntValue(none,"DW.SquirtChance", value as int)
		SetSliderOptionValueST(StorageUtil.GetIntValue(none,"DW.SquirtChance"))
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
		if StorageUtil.GetIntValue(none,"DW.bSLStatsIgnore") != 1
			StorageUtil.SetIntValue(none,"DW.bSLStatsIgnore", 1)
		else
			StorageUtil.SetIntValue(none,"DW.bSLStatsIgnore", 0)
		endif
		SetToggleOptionValueST(StorageUtil.GetIntValue(none,"DW.bSLStatsIgnore"))
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_IGNORESLSTAT_DESC")
	endEvent
endState

state DW_effects_Toggler
	event OnSelectST()
		if StorageUtil.GetIntValue(none,"DW.bUseSpells")
			StorageUtil.SetIntValue(none,"DW.bUseSpells", 1)
		else
			StorageUtil.SetIntValue(none,"DW.bUseSpells", 0)
		endif
		SetToggleOptionValueST(StorageUtil.GetIntValue(none,"DW.bUseSpells"))
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_USOP_DESC")
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
		SetSliderDialogStartValue(StorageUtil.GetIntValue(none,"DW.DW_Timer", 10))
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(5, 120)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		StorageUtil.SetIntValue(none,"DW.DW_Timer", value as int)
		SetSliderOptionValueST(StorageUtil.GetIntValue(none,"DW.DW_Timer", 10), "$DW_SECONDS")
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_SCRIPTPOLLRATE_DESC")
	endEvent
endState

state DW_SpellsUpdateTimer_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(StorageUtil.GetIntValue(none,"DW.DW_SpellsUpdateTimer", 1))
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 60)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		StorageUtil.SetIntValue(none,"DW.DW_SpellsUpdateTimer", value as int)
		SetSliderOptionValueST(StorageUtil.GetIntValue(none,"DW.DW_SpellsUpdateTimer", 1), "$DW_SECONDS")
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_EFFECTPOLLRATE_DESC")
	endEvent
endState

state DW_effects_light_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33))
		SetSliderDialogDefaultValue(33)
		SetSliderDialogRange(1, 99)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		StorageUtil.SetIntValue(none,"DW.DW_effects_light", value as int)
		SetSliderOptionValueST(StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33))
		Maintenance()
	endEvent
	
	event OnHighlightST()
		SetInfoText("$DW_LIGHTAROUSALEFFTHRES_DESC")
	endEvent
endState

state DW_effects_heavy_Slider
	event OnSliderOpenST()
		SetSliderDialogStartValue(StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66))
		SetSliderDialogDefaultValue(66)
		SetSliderDialogRange(1, 99)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		StorageUtil.SetIntValue(none,"DW.DW_effects_heavy", value as int)
		SetSliderOptionValueST(StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66))
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
		StorageUtil.SetIntValue(none,"DW.bPlayerIsVirgin", 1)
		CORE.DW_VirginsList.Revert()
		SetToggleOptionValue(Page_Virginity_VL_OID, true)
		ResetVL = false
	endif
endevent
