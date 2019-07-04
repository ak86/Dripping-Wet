Scriptname DW_CORE extends Quest

DW_SOS property SOS auto
DW_SL property SL auto
DW_SLA property SLA auto
DW_DDi property DDi auto
DW_zbf property zbf auto
DW_MCM property MCM auto

GlobalVariable Property DW_ModState00 Auto		; NPC Breathing effect
GlobalVariable Property DW_ModState01 Auto		; Arousal Dripping effect
GlobalVariable Property DW_ModState02 Auto		; Cum effect
GlobalVariable Property DW_ModState03 Auto		; Squirt effect
GlobalVariable Property DW_ModState04 Auto		; Gag effect
GlobalVariable Property DW_ModState05 Auto		; Heavy Visuals effect
GlobalVariable Property DW_ModState06 Auto		; Heartbeat effect
GlobalVariable Property DW_ModState07 Auto		; Light Visuals effect
GlobalVariable Property DW_ModState08 Auto		; Breathing effect
GlobalVariable Property DW_ModState09 Auto		; Visuals Disable during SL animation
GlobalVariable Property DW_ModState10 Auto		; Sound Disable during SL animation
GlobalVariable Property DW_ModState11 Auto		; Hearth Sound volume max/arousal based
GlobalVariable Property DW_ModState12 Auto		; Breath Sound volume max/arousal based
GlobalVariable Property DW_ModState13 Auto		; Virginity loss effect
GlobalVariable Property DW_ModState14 Auto		; Virginity loss texture effect
GlobalVariable Property DW_ModState15 Auto		; Virginity game messages
GlobalVariable Property DW_ModState16 Auto		; PC Milkleak effect
GlobalVariable Property DW_ModState17 Auto		; NPC Milkleak effect
GlobalVariable Property DW_Cloak_Range Auto

GlobalVariable Property DW_Timer Auto
GlobalVariable Property DW_bCloak Auto
GlobalVariable Property DW_PluginsCheck Auto
GlobalVariable Property DW_SOS_Check Auto
GlobalVariable Property DW_bAnimating Auto
GlobalVariable Property DW_SpellsUpdateTimer Auto
GlobalVariable Property DW_effects_heavy Auto
GlobalVariable Property DW_effects_light Auto
GlobalVariable Property DW_SquirtChance Auto
GlobalVariable Property DW_bSquirtChanceArousal Auto
GlobalVariable Property DW_Arousal_threshold Auto

GlobalVariable Property DW_bUseSLGenderForSquirt Auto
GlobalVariable Property DW_bSLStatsIgnore Auto

GlobalVariable Property DW_bUseSLGenderForDripp Auto

GlobalVariable Property DW_bPlayerIsVirgin Auto
GlobalVariable Property DW_PlayerVirginityLoss Auto

FormList Property DW_VirginsList Auto
FormList Property DW_VirginsClaimed Auto
FormList Property DW_VirginsClaimedTG Auto

SPELL Property DW_Dripping_Spell Auto
SPELL Property DW_DrippingCum_Spell Auto
SPELL Property DW_DrippingSOSCum_Spell Auto
SPELL Property DW_DrippingBlood_Spell Auto
SPELL Property DW_DrippingSquirt_Spell Auto
SPELL Property DW_DrippingGag_Spell Auto
SPELL Property DW_Breath_Spell Auto
SPELL Property DW_Heart_Spell Auto
SPELL Property DW_Visuals_Spell Auto
SPELL Property DW_Milkleak_Spell Auto

Sound Property Breathing1 Auto				;F Low
Sound Property Breathing2 Auto				;F High
Sound Property Breathing3 Auto				;M Low
Sound Property Breathing4 Auto				;M High
Sound Property Heartbeat1 Auto				;Low
Sound Property Heartbeat2 Auto				;High

ImageSpaceModifier Property HighArousalVisual Auto
ImageSpaceModifier Property LowArousalVisual Auto

Bool Property Plugin_DD = false auto
Bool Property Plugin_ZaZ = false auto
Bool Property Plugin_SOS = false auto

;Sexlab
Bool Property Plugin_SL = false auto
Bool Property Plugin_SLAR = false auto
;FlowerGirls
Bool Property Plugin_FGSE = false auto
Bool Property Plugin_AR = false auto

Function Startup()
	Plugin_DD = (Game.GetModbyName("Devious Devices - Assets.esm") != 255)
	Plugin_ZaZ = (Game.GetModbyName("ZaZAnimationPack.esm") != 255)
	Plugin_SOS = (Game.GetModbyName("Schlongs of Skyrim.esp") != 255)
	
	Plugin_SL = (Game.GetModbyName("SexLab.esm") != 255)
	Plugin_SLAR = (Game.GetModbyName("SexLabAroused.esm") != 255)

	Plugin_FGSE = (Game.GetModbyName("FlowerGirls SE.esm") != 255)
	Plugin_AR = (Game.GetModbyName("ArousedRedux.esm") != 255)

	SL.RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	SL.RegisterForModEvent("SexLabOrgasmSeparate", "OnSexLabOrgasmSeparate")
	SL.RegisterForModEvent("DeviceActorOrgasm", "OnDDOrgasm")
	SL.RegisterForModEvent("AnimationStart", "OnAnimationStart")
	SL.RegisterForModEvent("AnimationEnd", "OnAnimationEnd")
	SL.RegisterForModEvent("StageStart", "OnSexLabStageChange")
	RegisterForModEvent("RestoreVirginity", "RV")
	
	Utility.wait(1)
	DW_PluginsCheck.SetValue(1)
	Maintenance()
	DW_VirginsClaimedTG.Revert()
	RegisterForSingleUpdate(1)
	;debug.Notification("DW startup" + DW_PluginsCheck.GetValue())
EndFunction

Function Maintenance()
	if DW_effects_heavy.GetValue() < 0 || DW_effects_heavy.GetValue() == 100
		DW_effects_heavy.SetValue(66)
	endif
	if DW_effects_light.GetValue() < 0 || DW_effects_light.GetValue() == 100
		DW_effects_light.SetValue(33)
	endif
	if DW_effects_light.GetValue() >= DW_effects_heavy.GetValue() && DW_effects_heavy.GetValue() >= 1
		DW_effects_light.SetValue(DW_effects_heavy.GetValue() - 1)
	endif
	
	Actor PlayerRef = Game.GetPlayer()
	if (DW_ModState05.GetValue() == 0 || DW_ModState07.GetValue() == 0) && PlayerRef.HasSpell( DW_Visuals_Spell )	;remove visuals
		PlayerRef.RemoveSpell(DW_Visuals_Spell)
	endif
	if DW_ModState06.GetValue() == 0 && PlayerRef.HasSpell( DW_Heart_Spell )		;remove sound
		PlayerRef.RemoveSpell(DW_Heart_Spell)
	endif
	if DW_ModState08.GetValue() == 0 && PlayerRef.HasSpell( DW_Breath_Spell )		;remove sound
		PlayerRef.RemoveSpell(DW_Breath_Spell)
	endif
EndFunction


Event OnUpdate()
	Actor akActor = Game.GetPlayer()
	;cast - spell using onHit to trigger effects
	;addspell - abilities that run constantly

	if SLA.GetActorArousal(akActor) > DW_effects_light.GetValue()
		;visuals
			if !akActor.HasSpell( DW_Visuals_Spell )
				akActor.AddSpell( DW_Visuals_Spell, false )
			endif
		;sound
			;hearth beat
			if !akActor.HasSpell( DW_Heart_Spell )
				akActor.AddSpell( DW_Heart_Spell, false )
			endif
			;breath
			if !akActor.HasSpell( DW_Breath_Spell )
				akActor.AddSpell( DW_Breath_Spell, false )
			endif
	endif

	;dripping wet pc
	if SLA.GetActorArousal(akActor) >= DW_Arousal_threshold.GetValue()
		if DW_bUseSLGenderForDripp.GetValue() != 1\
		|| (SL.GetGender( akActor ) == 1  && akActor.GetLeveledActorBase().GetSex() == 1 && DW_bUseSLGenderForDripp.GetValue() == 1)
			akActor.AddSpell( DW_Dripping_Spell, false )
		endif
	endif
	
	;dripping gag pc
	if DDi.IsWearingDDGag(akActor) || zbf.IsWearingZaZGag(akActor)
		DW_DrippingGag_Spell.cast( akActor )
	endif
	
	;npc cloak
	if DW_bCloak.GetValue() == 1
		Cell akTargetCell = akActor.GetParentCell()
		int iRef = 0
		
		while iRef <= akTargetCell.getNumRefs(43) ;GetType() 62-char,44-lvchar,43-npc
			Actor aNPC = akTargetCell.getNthRef(iRef, 43) as Actor
			
			if aNPC != none
				;dripping wet npc
				If SLA.GetActorArousal(aNPC) >= DW_Arousal_threshold.GetValue()
					If DW_bUseSLGenderForDripp.GetValue() != 1\
					|| (SL.GetGender( aNPC ) == 1 && aNPC.GetLeveledActorBase().GetSex() == 1 && DW_bUseSLGenderForDripp.GetValue() == 1)
						DW_Dripping_Spell.cast( aNPC )
					EndIf
				EndIf
				
				;dripping gag npc
				if DDi.IsWearingDDGag(aNPC) || zbf.IsWearingZaZGag(aNPC)
					DW_DrippingGag_Spell.cast( aNPC )
				endif
				
				;breath npc
				if DW_ModState00.GetValue() == 1 && !aNPC.HasSpell( DW_Breath_Spell ) && aNPC != akActor
					aNPC.AddSpell( DW_Breath_Spell, false )
				endif
			endif
			
			iRef = iRef + 1
		endWhile
	endif
	
	if DW_Timer.GetValue() > 0
		RegisterForSingleUpdate(DW_Timer.GetValue())
	endif
EndEvent

Event RV(Form apForm)
	Actor akActor = apForm as Actor
	if akActor != None 
		if DW_VirginsList.HasForm(akActor)
			DW_VirginsList.RemoveAddedForm(akActor)
			debug.Trace(akActor.GetLeveledActorBase().GetName() +" virginity restored")
		endif
		if akActor == Game.GetPlayer()
			DW_bPlayerIsVirgin.SetValue(1)
			debug.Trace("PC virginity restored")
		endif
	endif
EndEvent
