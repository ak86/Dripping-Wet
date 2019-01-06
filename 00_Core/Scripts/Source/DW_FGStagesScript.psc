;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname DW_FGStagesScript Extends Quest Hidden

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
	;/
	this should probably hold code for disabling visuals/sfx
	and reenable them postsex
	if CORE.Plugin_FGSE
		bool isKissingScene = False
		int firstSexStage = 0
		Actor[] theActorRefs = GetEventData(akRef1 as Actor, akRef2 as Actor)
		Debug.Trace("DW_FGStagesScript started with keyword " + akKeyword + ", akRef1 " + akRef1 + ", akRef2 " + akRef2 + ", aiValue1 " + aiValue1 + ", aiValue2 " + aiValue2)
		if(theActorRefs)
			int i = 0
			while(i < theActors.Length)
				if(theActors[i].IsUsingKissing)
					isKissingScene = true
					;;Force a break out of the while
					i = theActors.Length
				endif
				i = i+ 1
			endWhile
			if(isKissingScene)
				firstSexStage = 3
				Debug.Trace("DW_FGStagesScript kissing")
			else
				Debug.Trace("DW_FGStagesScript stage change")
				OnStageChange(theActorRefs)
			endif
		endif
	endif
	/;
endEvent

Function OnStageChange(Actor[] theActorRefs)
	if(theActorRefs)
		Actor[] actors = theActorRefs
		int idx = 1
		
		if CORE.DW_ModState13.GetValue() == 1
			if actors.Length > 1
			
				;bool FGLE = Game.GetModbyName("FlowerGirls.esp") != 255
				bool FGSE = Game.GetModbyName("FlowerGirls SE.esm") != 255
				bool UseStrapons = false
				While idx < actors.Length && UseStrapons == false
					if (actors[idx].GetLeveledActorBase().GetSex() != 1)
						UseStrapons = true
					endif
					;if FGLE
					;	if actors[idx].IsEquipped(Game.GetFormFromFile(0xF5769, "FlowerGirls.esp"))\
					;	|| actors[idx].IsEquipped(Game.GetFormFromFile(0xF576A, "FlowerGirls.esp"))
					;		UseStrapons = true
					;	endif
					;endif
					if FGSE
						if actors[idx].IsEquipped(Game.GetFormFromFile(0xF5769, "FlowerGirls SE.esm"))\
						|| actors[idx].IsEquipped(Game.GetFormFromFile(0xF576A, "FlowerGirls SE.esm"))
							UseStrapons = true
						endif
					endif
					idx += 1
				EndWhile
				Debug.Trace("DW_FGStagesScript UseStrapons " + UseStrapons)

				;check if dom actor(1) has penetrator and sub actor(0) has something to penetrate
				If ((CORE.SOS.GetSOS(actors[actors.Length - 1]) == true) || UseStrapons || actors[actors.Length - 1].GetLeveledActorBase().GetSex() != 1) && actors[0].GetLeveledActorBase().GetSex() == 1
						
					If CORE.DW_VirginsList.Find(actors[0]) == -1
						;add non virgin npc to a list
						
						;player loosing virginity
						If (actors[0] == Game.GetPlayer() && CORE.DW_bPlayerIsVirgin.GetValue() == 1)
							debug.Notification("$DW_VIRGINITYLOST")
							CORE.DW_bPlayerIsVirgin.SetValue(0)
							CORE.DW_PlayerVirginityLoss.SetValue(CORE.DW_PlayerVirginityLoss.GetValue() + 1)

							;player claims npc virginity
						elseif actors[actors.Length - 1] == Game.GetPlayer() 
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