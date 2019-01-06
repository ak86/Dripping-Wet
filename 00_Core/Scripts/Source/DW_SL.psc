Scriptname DW_SL extends quest

DW_CORE property CORE auto

int Function GetGender(Actor akActor)
	if CORE.Plugin_SL
		Quest SexLabQuest = Quest.GetQuest("SexLabQuestFramework")
		if (SexLabQuest)
			SexLabFramework SexLab = SexLabQuest as SexLabFramework
			Return SexLab.GetGender( akActor )
		else
			Return akActor.GetLeveledActorBase().GetSex()
		endif
	endif
EndFunction

;---------------------
;if no sexlab
;events can be removed
;---------------------

;Catch sexlab orgasm
Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	if CORE.Plugin_SL
		Quest SexLabQuest = Quest.GetQuest("SexLabQuestFramework")
		if (SexLabQuest)
			SexLabFramework SexLab = SexLabQuest as SexLabFramework
			Actor[] actors = SexLab.HookActors(_args)
			int idx

			While idx < actors.Length
				Orgasm(actors[idx], _args)
				idx += 1
			EndWhile
		endif
	endif
EndEvent

;Catch sexlab SLSO orgasm
Event OnSexLabOrgasmSeparate(Form ActorRef, Int Thread)
	actor akActor = ActorRef as actor
	string _args =  Thread as string
	
	Orgasm(akActor, _args)
EndEvent

;process orgasm
Function Orgasm(Actor akActor, String _args)
	if CORE.Plugin_SL
		Quest SexLabQuest = Quest.GetQuest("SexLabQuestFramework")
		if (SexLabQuest)
			SexLabFramework SexLab = SexLabQuest as SexLabFramework
			;Sexlab.Log("DW SL Orgasm()")
		
			Actor[] actors = SexLab.HookActors(_args)
			int idx = 0
			Int Chance = 50
			sslBaseAnimation animation = SexLab.HookAnimation(_args)
			
			;Squirt for females, any position
			if CORE.DW_ModState03.GetValue() == 1
				While idx < actors.Length
					if akActor == actors[idx]
						if CORE.DW_bSquirtChanceArousal.GetValue() != 1
							Chance = CORE.DW_SquirtChance.GetValue() as int
						else
							Chance = CORE.SLA.GetActorArousal(actors[idx])
						endif

						if Utility.RandomInt(0, 100) <= Chance
							if CORE.DW_bUseSLGenderForSquirt.GetValue() != 1\
							|| (GetGender( actors[idx] ) == 1  && actors[idx].GetLeveledActorBase().GetSex() == 1 && CORE.DW_bUseSLGenderForSquirt.GetValue() == 1)
								CORE.DW_DrippingSquirt_Spell.cast( actors[idx] )
							endif
						endif
					endif
					idx += 1
				EndWhile
			endif
			
			;cum leak for reciever[0] if male/partner has penis
			;there's fault in logic with group sex, but w/e
			if CORE.DW_ModState02.GetValue() == 1
				if (animation.HasTag("Anal") || animation.HasTag("Vaginal")) && actors.Length > 1
					if akActor != actors[0]
						If CORE.SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1
							Utility.Wait(1.0)
							CORE.DW_DrippingCum_Spell.cast( actors[0] )
						EndIf
					endif
				endif
			endif

			;disabled since idk how to align ejaculation effect with penis
			;idx = 0
			;While idx < actors.Length
			;	if CORE.SOS.GetSOS(actors[idx]) == true
			;		CORE.DW_DrippingSOSCum_Spell.cast( actors[idx] )
			;	endif
			;	idx += 1
			;EndWhile
		endif
	endif
EndFunction
	
Event OnSexLabStageChange(String _eventName, String _args, Float _argc, Form _sender)
	if CORE.Plugin_SL
		Quest SexLabQuest = Quest.GetQuest("SexLabQuestFramework")
		if (SexLabQuest)
			SexLabFramework SexLab = SexLabQuest as SexLabFramework
			;Sexlab.Log("DW OnSexLabStageChange()")
			
			Actor[] actors = SexLab.HookActors(_args)
			int idx = 0
			sslBaseAnimation animation = SexLab.HookAnimation(_args)
			
			;SexLabUtil.PrintConsole("vaginal?" + animation.HasTag("Vaginal"))
			;SexLabUtil.PrintConsole("has sos?" + CORE.SOS.GetSOS(actors[1]))
			;SexLabUtil.PrintConsole("name + gender" + actors[0].GetLeveledActorBase().GetName() + actors[0].GetLeveledActorBase().GetSex() + " , " + actors[1].GetLeveledActorBase().GetName() + actors[1].GetLeveledActorBase().GetSex())
			if CORE.DW_ModState13.GetValue() == 1
				if animation.HasTag("Vaginal") && actors.Length > 1
					;check if dom actor(1) has penetrator and sub actor(0) has something to penetrate
					If ((CORE.SOS.GetSOS(actors[1]) == true || SexLab.Config.UseStrapons == true) || actors[1].GetLeveledActorBase().GetSex() != 1) && actors[0].GetLeveledActorBase().GetSex() == 1
						If CORE.DW_VirginsList.Find(actors[0]) == -1
							;add non virgin npc to a list
							;check if actor sl virgin
							If SexLab.HadSex(actors[0]) && (SexLab.GetSkillLevel(actors[0], "Vaginal") > 0)
								;check if we ignore sl stats
								If CORE.DW_bSLStatsIgnore.GetValue() != 1 
									;check if actor is  not a player
									If actors[0] != Game.GetPlayer()
										CORE.DW_VirginsList.AddForm(actors[0])
										return
									EndIf
								EndIf
							EndIf
							
							;player loosing virginity
							If (actors[0] == Game.GetPlayer() && CORE.DW_bPlayerIsVirgin.GetValue() == 1)
								debug.Notification("$DW_VIRGINITYLOST")
								CORE.DW_bPlayerIsVirgin.SetValue(0)
								CORE.DW_PlayerVirginityLoss.SetValue(CORE.DW_PlayerVirginityLoss.GetValue() + 1)

								;player claims npc virginity
							elseif actors[1] == Game.GetPlayer() 
								debug.Notification("$DW_VIRGINSCLAIMED")
								CORE.DW_VirginsClaimed.AddForm(actors[0])
								CORE.DW_VirginsClaimedTG.AddForm(actors[0])
								If CORE.DW_ModState15.GetValue() == 1
									If CORE.DW_VirginsClaimedTG.GetSize() == 1
										debug.Notification("$DW_FIRSTBLOOD")
									elseif CORE.DW_VirginsClaimedTG.GetSize() == 5
										debug.Notification("$DW_POWERPLAY")
									elseif CORE.DW_VirginsClaimedTG.GetSize() == 10
										debug.Notification("$DW_BRUTALITY")
									elseif CORE.DW_VirginsClaimedTG.GetSize() == 15
										debug.Notification("$DW_DOMINATION")
									elseif CORE.DW_VirginsClaimedTG.GetSize() == 25
										debug.Notification("$DW_ANNIHILATION")
									EndIf
								EndIf
							EndIf
							CORE.DW_VirginsList.AddForm(actors[0])
							CORE.DW_DrippingBlood_Spell.cast( actors[0] )
							;CORE.DW_DrippingBloodTextures_Spell.cast( actors[0] )
							return
						EndIf
					EndIf
				endif
			endif
		endif
	endif
EndEvent

Event OnAnimationStart(string eventName, string strArg, float numArg, Form sender)
	if CORE.Plugin_SL
		Quest SexLabQuest = Quest.GetQuest("SexLabQuestFramework")
		if (SexLabQuest)
			SexLabFramework SexLab = SexLabQuest as SexLabFramework
			
			sslThreadController thread = SexLab.GetController(strArg as int)
			if thread.HasPlayer == true
				Actor akActor = Game.GetPlayer()
				CORE.DW_bAnimating.SetValue(1)
				if CORE.DW_ModState09.GetValue() == 1	;remove visuals
					akActor.RemoveSpell(CORE.DW_Visuals_Spell)
				endif
				if CORE.DW_ModState10.GetValue() == 1	;remove sound
					akActor.RemoveSpell(CORE.DW_Heart_Spell)
					akActor.RemoveSpell(CORE.DW_Breath_Spell)
				endif
			endif
		endif
	endif
EndEvent

Event OnAnimationEnd(string eventName, string strArg, float numArg, Form sender)
	if CORE.Plugin_SL
		Quest SexLabQuest = Quest.GetQuest("SexLabQuestFramework")
		if (SexLabQuest)
			SexLabFramework SexLab = SexLabQuest as SexLabFramework
			
			sslThreadController thread = SexLab.GetController(strArg as int)
			if thread.HasPlayer == true
				CORE.DW_bAnimating.SetValue(0)
			endif
		endif
	endif
EndEvent