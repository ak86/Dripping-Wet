Scriptname DW_BreathSpellScr extends activemagiceffect

DW_CORE property CORE auto

Actor akActor

Int Sound1ID = 0
Int Sound2ID = 0
Sound Sound1
Sound Sound2
float strSound

Event OnEffectStart( Actor akTarget, Actor akCaster )
	akActor = akTarget
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	;sound Breath high,low,none
	;debug.Notification(Sound1ID+" Breath cycle start "+Sound2ID)
	if akActor.IsInLocation(Game.GetPlayer().getCurrentLocation())
		if (CORE.DW_ModState08.GetValue() == 1 && akActor == Game.GetPlayer()) || (CORE.DW_ModState00.GetValue() == 1 && akActor != Game.GetPlayer())
			float rank = CORE.SLA.GetActorArousal(akActor)
			if CORE.DW_ModState12.GetValue() == 0
				strSound = rank/100
			else
				strSound = 1
			endif
			
			if akActor.GetLeveledActorBase().GetSex() == 1			;female
				Sound1 = CORE.Breathing1
				Sound2 = CORE.Breathing2
			;elseif akActor.GetLeveledActorBase().GetSex() == 0		;male
			;	Sound1 = CORE.Breathing3
			;	Sound2 = CORE.Breathing4
			else													;no beasts :/
				;debug.Notification("Actor is beast, Breathing effect stopping")
				akActor.RemoveSpell(CORE.DW_Breath_Spell)
				return
			endif

			if  rank >= CORE.DW_effects_heavy.GetValue()		;high arousal
				if Sound1ID != 0
					;debug.Notification(Sound1ID+" Breath1 stop")
					Sound.StopInstance(Sound1ID)
					Sound1ID = 0
				endif
				if Sound2ID == 0
					Sound2ID = Sound2.play(akActor)
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
					Sound1ID = Sound1.play(akActor)
					Sound.SetInstanceVolume(Sound1ID, strSound)
				else
					;debug.Notification(Sound1ID+" Breath1 update")
					Sound.SetInstanceVolume(Sound1ID, strSound)
				endif
			endif
			RegisterForSingleUpdate(CORE.DW_SpellsUpdateTimer.GetValue())
			return
		endif
	endif
	akActor.RemoveSpell(CORE.DW_Breath_Spell)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	;debug.Notification("Breath1+2 removed")
	Sound.StopInstance(Sound1ID)
	Sound.StopInstance(Sound2ID)
	Sound1ID = 0
	Sound2ID = 0
EndEvent