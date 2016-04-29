Scriptname DW_BreathSpellScr extends activemagiceffect

DW_CORE property CORE auto

Actor akActor

Int Sound1ID = 0
Int Sound2ID = 0
float strSound

Event OnEffectStart( Actor akTarget, Actor akCaster )
	akActor = akTarget
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	;sound Breath high,low,none
	;debug.Notification(Sound1ID+" Breath cycle start "+Sound2ID)
	if CORE.DW_ModState8.GetValue() == 1					;Breath sound enabled
		float rank = CORE.SLA.GetActorArousal(akActor)
		strSound = rank/100

		if  rank >= CORE.DW_effects_heavy.GetValue()		;high arousal
			if Sound1ID != 0
				;debug.Notification(Sound1ID+" Breath1 stop")
				Sound.StopInstance(Sound1ID)
				Sound1ID = 0
			endif
			if Sound2ID == 0
				Sound2ID = CORE.Breathing2.play(akActor)
				;debug.Notification(Sound2ID+" Breath2 start")
				Sound.SetInstanceVolume(Sound2ID, strSound)
			else
				;debug.Notification(Sound2ID+" Breath2 update")
				Sound.SetInstanceVolume(Sound2ID, strSound)
			endif
		elseif rank >= CORE.DW_effects_light.GetValue()		;low arousal
			if Sound2ID != 0
				;debug.Notification(Sound2ID+" Breath2 stop")
				Sound.StopInstance(Sound2ID)
				Sound2ID = 0
			endif
			if Sound1ID == 0
				;debug.Notification(Sound1ID+" Breath1 start")
				Sound1ID = CORE.Breathing1.play(akActor)
				Sound.SetInstanceVolume(Sound1ID, strSound)
			else
				;debug.Notification(Sound1ID+" Breath1 update")
				Sound.SetInstanceVolume(Sound1ID, strSound)
			endif
		else
			;debug.Notification(Sound1ID+" Breath1+2 stop "+Sound2ID)
			akActor.RemoveSpell(CORE.DW_Breath_Spell)
			return
		endif
	else
		;debug.Notification(Sound1ID+" Breath1+2 stop "+Sound2ID)
		akActor.RemoveSpell(CORE.DW_Breath_Spell)
		return
	endif
	RegisterForSingleUpdate(1)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	;debug.Notification("Breath1+2 removed")
	Sound.StopInstance(Sound1ID)
	Sound.StopInstance(Sound2ID)
	Sound1ID = 0
	Sound2ID = 0
EndEvent