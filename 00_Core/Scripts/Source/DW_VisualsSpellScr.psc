Scriptname DW_VisualsSpellScr extends activemagiceffect

Actor akActor
float strVisual

Event OnEffectStart( Actor akTarget, Actor akCaster )
	akActor = akCaster
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	DW_CORE CORE = Quest.GetQuest("DW_Dripping") as DW_CORE
	if StorageUtil.FormListHas(none, "DW.Actors", akActor)
		StorageUtil.FormListAdd(none, "DW.Actors", akActor, false)
	endIf
	;play loop if:
	;either visuals enabled
	;not Blindfolded
	;in sl action, 1p, not disabled by mcm
	if (CORE.DW_ModState05.GetValue() == 1 || CORE.DW_ModState07.GetValue() == 1)
		if CORE.DDi.IsWearingDDBlindfold(akActor) == false 
			if (StorageUtil.GetIntValue(none,"DW.bAnimating", 0) == 1 && CORE.DW_ModState09.GetValue() != 1) || StorageUtil.GetIntValue(none,"DW.bAnimating", 0) == 0
				float rank = CORE.SLA.GetActorArousal(akActor)
				strVisual = rank / 100						;effect strength

				;visual high
				if CORE.DW_ModState05.GetValue() == 1 && rank >= StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66) && Game.GetCameraState() == 0
					CORE.HighArousalVisual.PopTo(CORE.HighArousalVisual,strVisual)
				else
					CORE.HighArousalVisual.Remove()
				endif

				;visual low
				if CORE.DW_ModState07.GetValue() == 1 && rank >= StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33)
					CORE.LowArousalVisual.PopTo(CORE.LowArousalVisual,strVisual)
				else
					CORE.LowArousalVisual.Remove()
				endif
				RegisterForSingleUpdate(StorageUtil.GetIntValue(none,"DW.DW_SpellsUpdateTimer", 1))
				return
			endif
		endif
	endif
	akActor.RemoveSpell(CORE.DW_Visuals_Spell)
EndEvent

Event OnPlayerLoadGame()
	DW_CORE CORE = Quest.GetQuest("DW_Dripping") as DW_CORE
	;CORE.sexlab.Log("OnPlayerLoadGame(), visuals effect stopping ")
	akActor.RemoveSpell(CORE.DW_Visuals_Spell)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	DW_CORE CORE = Quest.GetQuest("DW_Dripping") as DW_CORE
	CORE.HighArousalVisual.Remove()
	CORE.LowArousalVisual.Remove()
	if StorageUtil.FormListHas(none, "DW.Actors", akActor)
		StorageUtil.FormListRemove(none, "DW.Actors", akActor)
	endIf
EndEvent