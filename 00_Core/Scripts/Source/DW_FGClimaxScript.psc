;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname DW_FGClimaxScript Extends Quest Hidden

;BEGIN ALIAS PROPERTY AliasParticipant1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AliasParticipant1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AliasParticipant2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AliasParticipant2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;Debug.Trace(Self + "Stage Change lauched this quest")
SetCurrentStageID(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;Debug.Trace(Self + "Stage Change quest shut down")
stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	if CORE.Plugin_FGSE
		Orgasm(akRef1 as Actor, akRef2 as Actor)
		;OnStageChange(akRef1 as Actor, akRef2 as Actor)
	endif
endEvent

;process orgasm
Function Orgasm(Actor akRef1, Actor akRef2)
	Actor[] theActorRefs = GetEventData(akRef1, akRef2)
	if(theActorRefs)

		;debug.notification("DW FG Orgasm()")
	
		Actor[] actors = theActorRefs
		int idx = 0
		Int Chance = 50
		
		;Squirt for females, any position
		if CORE.DW_ModState03.GetValue() == 1
			While idx < actors.Length
				if CORE.DW_bSquirtChanceArousal.GetValue() != 1
					Chance = CORE.DW_SquirtChance.GetValue() as int
				else
					Chance = CORE.SLA.GetActorArousal(actors[idx])
				endif

				if Utility.RandomInt(0, 100) <= Chance
					if CORE.DW_bUseSLGenderForSquirt.GetValue() != 1\
					|| (actors[idx].GetLeveledActorBase().GetSex() == 1)
						CORE.DW_DrippingSquirt_Spell.cast( actors[idx] )
					endif
				endif
				idx += 1
			EndWhile
		endif
		
		;cum leak for actor[1] if male/partner has penis
		;or otherway around cum leak for actor[0] if male/partner has penis
		;looks like there is no way to tell what type of FG animation it is, so always assume intercource
		;there's probably fault in logic with group sex, but w/e
		if CORE.DW_ModState02.GetValue() == 1
			if actors.Length > 1
				If CORE.SOS.GetSOS(actors[actors.Length - 1]) == true || actors[actors.Length - 1].GetLeveledActorBase().GetSex() != 1
					Utility.Wait(0.1)
					CORE.DW_DrippingCum_Spell.cast( actors[0] )
				EndIf
				If CORE.SOS.GetSOS(actors[0]) == true || actors[0].GetLeveledActorBase().GetSex() != 1
					Utility.Wait(0.1)
					CORE.DW_DrippingCum_Spell.cast( actors[actors.Length - 1] )
				EndIf
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
EndFunction

;this whole thing cant be used in FG, since theres no way to know whos doing who
;process virginity
Function OnStageChange(Actor akRef1, Actor akRef2)
	Actor[] theActorRefs = GetEventData(akRef1, akRef2)
	if(theActorRefs)
		Actor[] actors = theActorRefs
		bool PCLooseV = false
		bool PCGainV = false
		int idx = 0
		
		if CORE.DW_ModState13.GetValue() == 1
			if actors.Length > 1
			
				;bool FGLE = Game.GetModbyName("FlowerGirls.esp") != 255
				bool UseStrapons = false
				While idx < actors.Length
					;if (actors[idx].GetLeveledActorBase().GetSex() != 1)
					;	UseStrapons = true
					;endif
					;if FGLE
					;	if actors[idx].IsEquipped(Game.GetFormFromFile(0xF5769, "FlowerGirls.esp"))\
					;	|| actors[idx].IsEquipped(Game.GetFormFromFile(0xF576A, "FlowerGirls.esp"))
					;		UseStrapons = true
					;	endif
					;endif
					;dom role is  -  male or futa or strapon
					if (actors[0].GetLeveledActorBase().GetSex() != 1 || (CORE.SOS.GetSOS(actors[0]) == true) || theActors[0].CheckUseStrapOn()); && theActors[idx].IsDomRole
						UseStrapons = true
					endif
					if theActors[0].IsPlayer
						;if theActors[idx].IsDomRole
							if UseStrapons
								PCGainV = true
							endif
						else
							if UseStrapons
								PCLooseV = true
							endif
						;endif
					endif
					idx += 1
				EndWhile
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript actors[0] " + actors[0].GetLeveledActorBase().getname())
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript actors[1] " + actors[1].GetLeveledActorBase().getname())
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript theActors[0] " + theActors[0].IsDomRole)
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript theActors[1] " + theActors[1].IsDomRole)
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript UseStrapons " + UseStrapons)
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript PCGainV " + PCGainV)
				Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript PCLooseV " + PCLooseV)

				;^check if dom actor(0) has penetrator and sub actor(1) has something to penetrate
				If (UseStrapons) && actors[actors.Length - 1].GetLeveledActorBase().GetSex() == 1
					If CORE.DW_VirginsList.Find(actors[actors.Length - 1]) == -1
						;player loosing virginity
						If (PCLooseV && CORE.DW_bPlayerIsVirgin.GetValue() == 1)
						;If (actors[0] == Game.GetPlayer() || actors[0] == VRPlayerParticipant && CORE.DW_bPlayerIsVirgin.GetValue() == 1)
							debug.Notification("$DW_VIRGINITYLOST")
							CORE.DW_bPlayerIsVirgin.SetValue(0)
							CORE.DW_PlayerVirginityLoss.SetValue(CORE.DW_PlayerVirginityLoss.GetValue() + 1)
							Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript PCGainV outcome " + PCGainV)

						;player claims npc virginity
						elseif PCGainV
							debug.Notification("$DW_VIRGINSCLAIMED")
							CORE.DW_VirginsClaimed.AddForm(actors[actors.Length - 1])
							CORE.DW_VirginsClaimedTG.AddForm(actors[actors.Length - 1])
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
							Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript PCLooseV outcome " + PCLooseV)
						EndIf
						;add non virgin npc to a list
						CORE.DW_VirginsList.AddForm(actors[actors.Length - 1])
						CORE.DW_DrippingBlood_Spell.cast( actors[actors.Length - 1] )
						;CORE.DW_DrippingBloodTextures_Spell.cast( actors[1] )
						Debug.Trace("DW_FGClimaxScript_DW_FGStagesScript outcome")
						return
					EndIf
				EndIf
			endif
		endif
	endif
EndFunction


Actor [] Function GetEventData(Actor akRef1, Actor akRef2)
	Actor[] allActors
	;;Get the thread which has these actors
	;;It also sets the variable theActors if successful
	theThread = ThreadFromActors(akRef1, akRef2)
	if(theThread)
		if(theActors.Length == 1)
			allActors = new Actor[1]
			allActors[0] = theActors[0].GetActorReference()
		elseif (theActors.Length == 2)
			allActors = new Actor[2]
			allActors[0] = theActors[0].GetActorReference()
			allActors[1] = theActors[1].GetActorReference()
		elseif (theActors.Length == 3)
			allActors = new Actor[3]
			allActors[0] = theActors[0].GetActorReference()
			allActors[1] = theActors[1].GetActorReference()
			allActors[2] = theActors[2].GetActorReference()
		elseif (theActors.Length == 4)	;;Currently not possible - For future possible use
			allActors = new Actor[3]
			allActors[0] = theActors[0].GetActorReference()
			allActors[1] = theActors[1].GetActorReference()
			allActors[2] = theActors[2].GetActorReference()
			allActors[3] = theActors[3].GetActorReference()
		endif
	endif
	return allActors
endFunction

dxSceneThread Function ThreadFromActors(Actor akRef1, Actor akRef2)

	Actor akActor
	if(akRef1)
		akActor = akRef1
	elseif(akRef2)
		akActor = akRef2
	else
		return None
	endif
	
	dxSceneThread thisScene = findThreadForActor(akActor)
	if(thisScene)
		theActors = getActorsForThead(thisScene)
		return thisScene
	endif
	return None
endFunction


dxSceneThread Function findThreadForActor(Actor ak)
	Quest FlowerGirlsThreadManagerQuest = Quest.GetQuest("FlowerGirlsThreadManager")
	if (FlowerGirlsThreadManagerQuest)
		dxThreadManager FGThreadManager = FlowerGirlsThreadManagerQuest as dxThreadManager
		
		int maxThreads = FGThreadManager.MaxThreads
		
		if(ak == None)
			return None
		endif
		int i = 0
		while(i < maxThreads)
			dxSceneThread thisThread = FGThreadManager.SceneThreads[i]
			if(thisThread.IsRunning())
				if(ak == thisThread.Participant01.GetActorReference())
					return thisThread
				elseif (ak == thisThread.Participant02.GetActorReference())
					return thisThread
				elseif  (ak == thisThread.Participant03.GetActorReference())
					return thisThread
				endif
			endif
			i += 1
		endwhile
	endif
	return None
endFunction

dxAliasActor[] Function getActorsForThead(dxSceneThread thisThread)
	;;Find out how many actors 
	dxAliasActor [] returnActors
	
	int actorCount = 0
	if(thisThread.Participant01 && thisThread.Participant01.getActorReference())
		actorCount = actorCount + 1
	endif
	if(thisThread.Participant02  && thisThread.Participant02.getActorReference())
		actorCount = actorCount + 1
	endif
	if(thisThread.Participant03  && thisThread.Participant03.getActorReference())
		actorCount = actorCount + 1
	endif
	
	debug.trace("Getting " + actorCount + " actors on thread " + thisThread)
	if(actorCount)
			
		if(actorCount == 1)
			returnActors = new dxAliasActor[1]
			if(thisThread.Participant01)
				returnActors[0] = thisThread.Participant01
			elseif(thisThread.Participant02)
				returnActors[0] = thisThread.Participant02
			elseif(thisThread.Participant03)
				returnActors[0] = thisThread.Participant03
			endif
			debug.trace("Returning 1 " + returnActors)
			return returnActors
		else
			if(actorCount == 2)
				returnActors = new dxAliasActor[2]
			elseif(actorCount == 3)
				returnActors = new dxAliasActor[3]
			endif

			int j = 0
			int i = 0
			while(i < actorCount)
				if(i == 0)
					returnActors[0] = thisThread.Participant01
				elseif(i == 1)
					returnActors[1] = thisThread.Participant02
				else
					returnActors[2] = thisThread.Participant03
				endif
				i = i + 1
			endWhile
			debug.trace("Returning " + returnActors)
			return returnActors
		endif
	endif
	debug.trace("Returning None Actors")
	return None
endFunction

dxSceneThread theThread = None
dxAliasActor[] theActors = None

DW_CORE property CORE auto