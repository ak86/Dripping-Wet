Scriptname DW_VisualsSpellScr extends activemagiceffect

DW_CORE property CORE auto

Actor akActor

float strVisual

Event OnEffectStart( Actor akTarget, Actor akCaster )
	akActor = akCaster
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	if !(CORE.bAnimating == true && CORE.DW_ModState09.GetValue() == 1)
		if (CORE.DW_ModState05.GetValue() == 1 || CORE.DW_ModState07.GetValue() == 1)
			if CORE.DDi.IsWearingDDBlindfold(akActor) == false
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

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	CORE.HighArousalVisual.Remove()
	CORE.LowArousalVisual.Remove()
EndEvent