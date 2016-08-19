Scriptname DW_HeartSpellScr extends activemagiceffect

DW_CORE property CORE auto

Actor akActor

Int Sound1ID = 0
Int Sound2ID = 0
float strSound

Event OnEffectStart( Actor akTarget, Actor akCaster )
	akActor = akTarget
	RegisterForSingleUpdate(1)
	GoToState("Playing")
EndEvent

State Playing
EndState

Event OnUpdate()
	;sound heartbeat high,low,none
	;debug.Notification(Sound1ID+" Beat cycle start "+Sound2ID)
	if StorageUtil.FormListHas(none, "DW.Actors", akActor)
		StorageUtil.FormListAdd(none, "DW.Actors", akActor, false)
	endIf
	if CORE.DW_ModState06.GetValue() == 1					;heartbeat sound enabled
		float rank = CORE.SLA.GetActorArousal(akActor)
		if CORE.DW_ModState11.GetValue() == 0
			strSound = rank/100
		else
			strSound = 1
		endif

		if rank >= StorageUtil.GetIntValue(none,"DW.DW_effects_heavy", 66)			;high arousal
			if Sound1ID != 0
				;debug.Notification(Sound1ID+" Beat1 stop")
				Sound.StopInstance(Sound1ID)
				Sound1ID = 0
			endif
			if Sound2ID == 0
				Sound2ID = CORE.Heartbeat2.play(akActor)
				;debug.Notification(Sound2ID+" Beat2 start")
				Sound.SetInstanceVolume(Sound2ID, strSound)
			else
				;debug.Notification(Sound2ID+" Beat2 update")
				Sound.SetInstanceVolume(Sound2ID, strSound)
			endif
			;CORE.Heartbeat2.PlayAndWait(akActor)
		elseif rank >= StorageUtil.GetIntValue(none,"DW.DW_effects_light", 33)		;low arousal
			if Sound2ID != 0
				;debug.Notification(Sound2ID+" Beat2 stop")
				Sound.StopInstance(Sound2ID)
				Sound2ID = 0
			endif
			if Sound1ID == 0
				;debug.Notification(Sound1ID+" Beat1 start")
				Sound1ID = CORE.Heartbeat1.play(akActor)
				Sound.SetInstanceVolume(Sound1ID, strSound)
			else
				;debug.Notification(Sound1ID+" Beat1 update")
				Sound.SetInstanceVolume(Sound1ID, strSound)
			endif
			;CORE.Heartbeat1.PlayAndWait(akActor)
		else												;no arousal
			;debug.Notification("Arousal too low, Heartbeat effect stopping " +Sound1ID + " | " + Sound2ID)
			akActor.RemoveSpell(CORE.DW_Heart_Spell)
			return
		endif
		RegisterForSingleUpdate(StorageUtil.GetIntValue(none,"DW.DW_SpellsUpdateTimer", 1))
		return
	endif
	akActor.RemoveSpell(CORE.DW_Heart_Spell)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	if Sound1ID != 0
		Sound.StopInstance(Sound1ID)
		;debug.Notification("Beat1 removed")
	endif
	if Sound1ID != 0
		Sound.StopInstance(Sound2ID)
		;debug.Notification("Beat2 removed")
	endif
	if StorageUtil.FormListHas(none, "DW.Actors", akActor)
		StorageUtil.FormListRemove(none, "DW.Actors", akActor)
	endIf
	UnRegisterForUpdate()
EndEvent