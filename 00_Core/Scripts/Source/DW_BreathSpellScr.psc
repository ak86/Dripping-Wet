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
	if StorageUtil.FormListHas(none, "DW.Actors", akActor)
		StorageUtil.FormListAdd(none, "DW.Actors", akActor, false)
	endIf
	if akActor.IsInLocation(Game.GetPlayer().getCurrentLocation())
		if (CORE.DW_ModState08.GetValue() == 1 && akActor == Game.GetPlayer()) || (CORE.DW_ModState00.GetValue() == 1 && akActor != Game.GetPlayer())
			float rank = CORE.SLA.GetActorArousal(akActor)
			if CORE.DW_ModState12.GetValue() == 0
				strSound = rank/100
			else
				strSound = 1
			endif
			
			if akActor.GetLeveledActorBase().GetSex() == 1		;female
				Sound1 = CORE.Breathing1
				Sound2 = CORE.Breathing2
			elseif akActor.GetLeveledActorBase().GetSex() == 0	;male
				Sound1 = CORE.Breathing3
				Sound2 = CORE.Breathing4
			else												;no beasts
				akActor.RemoveSpell(CORE.DW_Breath_Spell)
				return
			endif

			if  rank >= StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66)		;high arousal
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
			elseif rank >= StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33)		;low arousal
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
			else												;no arousal
				;debug.Notification("Arousal too low, Breathing effect stopping " +Sound1ID + " | " + Sound2ID)
				akActor.RemoveSpell(CORE.DW_Breath_Spell)
				return
			endif
			RegisterForSingleUpdate(StorageUtil.GetIntValue(none,"DW.DW_SpellsUpdateTimer", 1))
			return
		endif
	endif
	akActor.RemoveSpell(CORE.DW_Breath_Spell)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	if Sound1ID != 0
		Sound.StopInstance(Sound1ID)
		;debug.Notification("Breath1 removed")
	endif
	if Sound1ID != 0
		Sound.StopInstance(Sound2ID)
		;debug.Notification("Breath2 removed")
	endif
	if StorageUtil.FormListHas(none, "DW.Actors", akActor)
		StorageUtil.FormListRemove(none, "DW.Actors", akActor)
	endIf
	UnRegisterForUpdate()
EndEvent