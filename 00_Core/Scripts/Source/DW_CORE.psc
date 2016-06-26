Scriptname DW_CORE extends Quest

SexLabFramework property SexLab auto
DW_SOS property SOS auto
DW_SLA property SLA auto
DW_DDi property DDi auto
DW_zbf property zbf auto
DW_MCM property MCM auto

GlobalVariable Property DW_Timer Auto
GlobalVariable Property DW_SpellsUpdateTimer Auto
GlobalVariable Property DW_Cloak Auto
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
GlobalVariable Property DW_effects_light Auto
GlobalVariable Property DW_effects_heavy Auto
GlobalVariable Property DW_Cloak_Range Auto
GlobalVariable Property DW_Arousal_threshold Auto
GlobalVariable Property DW_Status_Global Auto

FormList Property DW_Actors Auto
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

Bool Property bAnimating = false Auto		;SL player animation detection for stopping sound/visual effects
Bool Property bPlayerIsVirgin = true Auto

Int Property PlayerVirginityLoss Auto






Event OnInit()
	RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	RegisterForModEvent("HookAnimationStart", "AnimationStart")
	RegisterForModEvent("HookAnimationEnd", "AnimationEnd")
	RegisterForModEvent("HookStageStart", "OnSexLabOrgasm")
	RegisterForModEvent("PlayerRestoreVirginity", "PRV")
	MCM.Maintenance()
	DW_Status_Global.SetValue(1)
	debug.Notification("Dripping when aroused initialised.")
	RegisterForSingleUpdate(1)
Endevent

Event OnPlayerLoadGame()
	RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	RegisterForModEvent("HookAnimationStart", "AnimationStart")
	RegisterForModEvent("HookAnimationEnd", "OnSexLabStageChange")
	RegisterForModEvent("PlayerRestoreVirginity", "PRV")
	bAnimating == false
	;check optionals
	MCM.Maintenance()
	DW_Status_Global.SetValue(1)
	RegisterForSingleUpdate(1)
	DW_VirginsClaimedTG.Revert()
EndEvent

Event PRV()
	bPlayerIsVirgin = true
EndEvent

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	Actor[] actors = SexLab.HookActors(_args)
	int idx = 0
	sslBaseAnimation animation = SexLab.HookAnimation(_args)
	
	if DW_ModState02.GetValue() == 1
		if (animation.HasTag("Anal") || animation.HasTag("Vaginal")) && actors.Length > 1
			If SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1
				DW_DrippingCum_Spell.cast( actors[0] )
			EndIf
		endif
	endif
	
	if DW_ModState03.GetValue() == 1
		While idx < actors.Length
			DW_DrippingSquirt_Spell.cast( actors[idx] )
			idx += 1
		EndWhile
	endif
EndEvent

Event OnSexLabStageChange(String _eventName, String _args, Float _argc, Form _sender)
	Actor[] actors = SexLab.HookActors(_args)
	int idx = 0
	sslBaseAnimation animation = SexLab.HookAnimation(_args)
	
	if DW_ModState13.GetValue() == 1
		if animation.HasTag("Vaginal") && actors.Length > 1
			If SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1
				If DW_VirginsList.Find(actors[0]) == -1
					If actors[0] == Game.GetPlayer() && bPlayerIsVirgin == true 
						debug.Notification("You have lost your virginity!")
						bPlayerIsVirgin = false
						PlayerVirginityLoss += 1
					elseif actors[1] == Game.GetPlayer() 
						debug.Notification("You have claimed " + actors[0].GetLeveledActorBase().GetName() + " virginity!")
						DW_VirginsClaimed.AddForm(actors[0])
						DW_VirginsClaimedTG.AddForm(actors[0])
						If DW_ModState15.GetValue() == 1
							If DW_VirginsClaimedTG.GetSize() == 1
								debug.Messagebox("First Blood!")
							elseif DW_VirginsClaimedTG.GetSize() == 5
								debug.Messagebox("Power Play!")
							elseif DW_VirginsClaimedTG.GetSize() == 10
								debug.Messagebox("Brutality!")
							elseif DW_VirginsClaimedTG.GetSize() == 15
								debug.Messagebox("Domination!")
							elseif DW_VirginsClaimedTG.GetSize() == 25
								debug.Messagebox("Complete Annihilation!")
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

Event AnimationStart(int threadID, bool HasPlayer)
	Actor akActor = Game.GetPlayer()
	if HasPlayer == true
		bAnimating = true
		if DW_ModState09.GetValue() == 1	;remove visuals
			akActor.RemoveSpell(DW_Visuals_Spell)
		endif
		if DW_ModState10.GetValue() == 1	;remove sound
			akActor.RemoveSpell(DW_Heart_Spell)
			akActor.RemoveSpell(DW_Breath_Spell)
		endif
	endif
EndEvent

Event AnimationEnd(int threadID, bool HasPlayer)
	if HasPlayer == true
		bAnimating = false
	endif
EndEvent

