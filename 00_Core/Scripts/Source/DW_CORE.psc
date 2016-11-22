Scriptname DW_CORE extends Quest

SexLabFramework property SexLab auto
DW_SOS property SOS auto
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
GlobalVariable Property DW_Cloak_Range Auto

FormList Property DW_VirginsList Auto
FormList Property DW_VirginsClaimed Auto
FormList Property DW_VirginsClaimedTG Auto

SPELL Property DW_Dripping_Spell Auto
SPELL Property DW_DrippingCum_Spell Auto
SPELL Property DW_DrippingBlood_Spell Auto
SPELL Property DW_DrippingSquirt_Spell Auto
SPELL Property DW_DrippingGag_Spell Auto
SPELL Property DW_Breath_Spell Auto
SPELL Property DW_Heart_Spell Auto
SPELL Property DW_Visuals_Spell Auto

Sound Property Breathing1 Auto				;F Low
Sound Property Breathing2 Auto				;F High
Sound Property Breathing3 Auto				;M Low
Sound Property Breathing4 Auto				;M High
Sound Property Heartbeat1 Auto				;Low
Sound Property Heartbeat2 Auto				;High

ImageSpaceModifier Property HighArousalVisual Auto
ImageSpaceModifier Property LowArousalVisual Auto

;StorageUtil.SetIntValue(none,"DW.bAnimating", 1) ;SL player animation detection for stopping sound/visual effects
;StorageUtil.SetIntValue(none,"DW.UseSLGenderForSquirt", 1)
;StorageUtil.SetIntValue(none,"DW.UseSLGenderForDripp", 1)

Event RV(Form apForm)
	Actor akActor = apForm as Actor
	if akActor != None 
		if DW_VirginsList.HasForm(akActor)
			DW_VirginsList.RemoveAddedForm(akActor)
			debug.Trace(akActor.GetLeveledActorBase().GetName() +" virginity restored")
		endif
		if akActor == Game.GetPlayer()
			StorageUtil.SetIntValue(none,"DW.bPlayerIsVirgin", 1)
			debug.Trace("PC virginity restored")
		endif
	endif
EndEvent

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	Actor[] actors = SexLab.HookActors(_args)
	int idx = 0
	sslBaseAnimation animation = SexLab.HookAnimation(_args)
	
	if DW_ModState03.GetValue() == 1
		While idx < actors.Length
			if Utility.RandomInt(0, 100) <= StorageUtil.GetIntValue(none,"DW.SquirtChance", 50)
				if (SexLab.GetGender( actors[idx] ) == 0 && StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt") == 1) || StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt") == 1
					DW_DrippingSquirt_Spell.cast( actors[idx] )
				endif
			endif
			idx += 1
		EndWhile
	endif
	
	if DW_ModState02.GetValue() == 1
		if (animation.HasTag("Anal") || animation.HasTag("Vaginal")) && actors.Length > 1
			If SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1
				Utility.Wait(1.0)
				DW_DrippingCum_Spell.cast( actors[0] )
			EndIf
		endif
	endif
EndEvent

Event OnDDOrgasm(string eventName, string argString, float argNum, form sender)
	Actor akActor = Game.GetPlayer()
	if DW_ModState03.GetValue() == 1 && akActor.GetLeveledActorBase().GetName() == argString
		if (SexLab.GetGender( akActor ) == 0 && StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt") == 1) || StorageUtil.GetIntValue(none,"DW.UseSLGenderForSquirt") == 1
			DW_DrippingSquirt_Spell.cast( akActor )
		endif
	endif
EndEvent

Event OnSexLabStageChange(String _eventName, String _args, Float _argc, Form _sender)
	Actor[] actors = SexLab.HookActors(_args)
	int idx = 0
	sslBaseAnimation animation = SexLab.HookAnimation(_args)
	
	if DW_ModState13.GetValue() == 1
		if animation.HasTag("Vaginal") && actors.Length > 1
			;check if dom actor(1) has penetrator and sub actor(0) has something to penetrate
			If (SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1) && actors[0].GetLeveledActorBase().GetSex() == 1
				If DW_VirginsList.Find(actors[0]) == -1
					;add non virgin npc to a list
					;check if actor sl virgin
                    If SexLab.HadSex(actors[0]) && (SexLab.GetSkillLevel(actors[0], "Vaginal") > 0)
						;check if we ignore sl stats
						If StorageUtil.GetIntValue(none,"DW.bSLStatsIgnore") != 1 
							;check if actor is  not a player
							If actors[0] != Game.GetPlayer()
								DW_VirginsList.AddForm(actors[0])
								return
							EndIf
						EndIf
					EndIf
					
					;player loosing virginity
					If actors[0] == Game.GetPlayer() && StorageUtil.GetIntValue(none,"DW.bPlayerIsVirgin", 1)
						debug.Notification("$DW_VIRGINITYLOST")
						StorageUtil.SetIntValue(none,"DW.bPlayerIsVirgin", 0)
						StorageUtil.AdjustIntValue(none,"DW.PlayerVirginityLoss", 1)

						;player claims npc virginity
					elseif actors[1] == Game.GetPlayer() 
						debug.Notification("$DW_VIRGINSCLAIMED")
						DW_VirginsClaimed.AddForm(actors[0])
						DW_VirginsClaimedTG.AddForm(actors[0])
						If DW_ModState15.GetValue() == 1
							If DW_VirginsClaimedTG.GetSize() == 1
								debug.Messagebox("$DW_FIRSTBLOOD")
							elseif DW_VirginsClaimedTG.GetSize() == 5
								debug.Messagebox("$DW_POWERPLAY")
							elseif DW_VirginsClaimedTG.GetSize() == 10
								debug.Messagebox("$DW_BRUTALITY")
							elseif DW_VirginsClaimedTG.GetSize() == 15
								debug.Messagebox("$DW_DOMINATION")
							elseif DW_VirginsClaimedTG.GetSize() == 25
								debug.Messagebox("$DW_ANNIHILATION")
							EndIf
						EndIf
					EndIf
					DW_VirginsList.AddForm(actors[0])
					DW_DrippingBlood_Spell.cast( actors[0] )
					;DW_DrippingBloodTextures_Spell.cast( actors[0] )
					return
				EndIf
			EndIf
		endif
	endif
EndEvent

Event OnAnimationStart(int threadID, bool HasPlayer)
	Actor akActor = Game.GetPlayer()
	if HasPlayer == true
		StorageUtil.SetIntValue(none,"DW.bAnimating", 1)
		if DW_ModState09.GetValue() == 1	;remove visuals
			akActor.RemoveSpell(DW_Visuals_Spell)
		endif
		if DW_ModState10.GetValue() == 1	;remove sound
			akActor.RemoveSpell(DW_Heart_Spell)
			akActor.RemoveSpell(DW_Breath_Spell)
		endif
	endif
EndEvent

Event OnAnimationEnd(int threadID, bool HasPlayer)
	if HasPlayer == true
		StorageUtil.SetIntValue(none,"DW.bAnimating", 0)
	endif
EndEvent