Scriptname DW_VisualsSpellScr extends activemagiceffect

DW_CORE CORE

Actor akActor
float strVisual

Event OnEffectStart( Actor akTarget, Actor akCaster )
	akActor = akCaster
	CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	;play loop if:
	;either visuals enabled
	;not Blindfolded
	;in sl action, not disabled
	if (CORE.DW_ModState05.GetValue() == 1 || CORE.DW_ModState07.GetValue() == 1)
		if CORE.DDi.IsWearingDDBlindfold(akActor) == false && CORE.zbf.IsWearingZaZBlindfold(akActor) == false 
			if (CORE.DW_bAnimating.GetValue() == 1 && CORE.DW_ModState09.GetValue() != 1) || CORE.DW_bAnimating.GetValue() == 0
				float rank = CORE.SLA.GetActorArousal(akActor)
				strVisual = rank / 100						;effect strength

				;visual high
				if CORE.DW_ModState05.GetValue() == 1 && rank >= CORE.DW_effects_heavy.GetValue()
					CORE.HighArousalVisual.PopTo(CORE.HighArousalVisual,strVisual)
				else
					CORE.HighArousalVisual.Remove()
				endif

				;visual low
				if CORE.DW_ModState07.GetValue() == 1 && rank >= CORE.DW_effects_light.GetValue()
					CORE.LowArousalVisual.PopTo(CORE.LowArousalVisual,strVisual)
				else
					CORE.LowArousalVisual.Remove()
				endif
				RegisterForSingleUpdate(CORE.DW_SpellsUpdateTimer.GetValue())
				return
			endif
		endif
	endif
	akActor.RemoveSpell(CORE.DW_Visuals_Spell)
EndEvent

Event OnPlayerLoadGame()
	CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	;CORE.sexlab.Log("OnPlayerLoadGame(), visuals effect stopping ")
	akActor.RemoveSpell(CORE.DW_Visuals_Spell)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	CORE.HighArousalVisual.Remove()
	CORE.LowArousalVisual.Remove()
EndEvent