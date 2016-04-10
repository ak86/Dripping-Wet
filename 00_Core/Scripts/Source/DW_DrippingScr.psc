Scriptname DW_DrippingScr extends ReferenceAlias

SexLabFramework property SexLab auto
GlobalVariable Property DW_Timer Auto
GlobalVariable Property DW_Cloak Auto
GlobalVariable Property DW_Cloak_Range Auto
GlobalVariable Property DW_Arousal_threshold Auto

FormList Property DW_Actors Auto
Actor Property PlayerREF Auto
SPELL Property DW_Dripping_Spell Auto
SPELL Property DW_DrippingCum_Spell Auto
SPELL Property DW_DrippingSquirt_Spell Auto
SPELL Property DW_DrippingGag_Spell Auto

DW_MCM property MCM auto
DW_SOS property SOS auto
DW_SLA property SLA auto
DW_DDi property DDi auto
DW_zbf property zbf auto

Sound Property Heartbeat1 Auto
Sound Property Heartbeat2 Auto
Sound Property Breathing1 Auto
Sound Property Breathing2 Auto
Int Property Heartbeat1ID Auto
Int Property Heartbeat2ID Auto
Int Property Breathing1ID Auto
Int Property Breathing2ID Auto
ImageSpaceModifier Property HighArousalVisual Auto
ImageSpaceModifier Property LowArousalVisual Auto

bool bLowArousalVisual = false
bool bHighArousalVisual = false
bool bHeartbeat1ID = false
bool bHeartbeat2ID = false
bool bBreathing1ID = false
bool bBreathing2ID = false
bool bAnimating = false
Int rankprev = 0	;var to store arousal value for tracking arousal changes between script cycles

Event OnInit()
	RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	RegisterForSingleUpdate(1)
	RegisterForModEvent("HookAnimationStart", "AnimationStart")
	RegisterForModEvent("HookAnimationEnd", "AnimationEnd")
	if MCM.DW_ModState0.GetValue() == 1
		IntegrationCheck()
	endif
	debug.Notification("Dripping when aroused initialised.")
Endevent

Event OnPlayerLoadGame()
	RegisterForModEvent("OrgasmStart", "OnSexLabOrgasm")
	RegisterForModEvent("HookAnimationStart", "AnimationStart")
	RegisterForModEvent("HookAnimationEnd", "AnimationEnd")
	bHeartbeat1ID = false
	bHeartbeat2ID = false
	bBreathing1ID = false
	bBreathing2ID = false
	bHighArousalVisual = false
	bLowArousalVisual = false
	bAnimating == false
	;check optionals
	if MCM.DW_ModState0.GetValue() == 1
		IntegrationCheck()
	endif
EndEvent

function IntegrationCheck()
	if SLA.IsIntegraged() == false && Game.GetModbyName("SexLabAroused.esm") != 255
		debug.Notification("SexLabAroused found but support disabled in DW, reinstall DW")
	elseif SLA.IsIntegraged() == true && Game.GetModbyName("SexLabAroused.esm") == 255
		debug.Notification("SexLabAroused not found but support enabled in DW, reinstall DW")
	endif
	
	if zbf.IsIntegraged() == false && Game.GetModbyName("ZaZAnimationPack.esm ") != 255
		debug.Notification("ZaZAnimationPack found but support disabled in DW, reinstall DW")
	elseif zbf.IsIntegraged() == true && Game.GetModbyName("ZaZAnimationPack.esm") == 255
		debug.Notification("ZaZAnimationPack not found but support enabled in DW, reinstall DW")
	endif

	if DDi.IsIntegraged() == false && Game.GetModbyName("Devious Devices - Integration.esm") != 255
		debug.Notification("Devious Devices - Integration found but support disabled in DW, reinstall DW")
	elseif DDi.IsIntegraged() == true && Game.GetModbyName("Devious Devices - Integration.esm") == 255
		debug.Notification("Devious Devices - Integration not found but support enabled in DW, reinstall DW")
	endif
	
	if SOS.IsIntegraged() == false && Game.GetModbyName("Schlongs of Skyrim.esp") != 255
		debug.Notification("Schlongs of Skyrim (FULL?) found but support disabled in DW, reinstall DW")
	elseif SOS.IsIntegraged() == true && Game.GetModbyName("Schlongs of Skyrim.esp") == 255
		debug.Notification("Schlongs of Skyrim(FULL?) not found but support enabled in DW, reinstall DW")
	endif
endfunction	

Event OnUpdate()
	;checks for user smartness and oldversion values
	if MCM.DW_effects_heavy.GetValue() <= 0 || MCM.DW_effects_heavy.GetValue() >= 100 || MCM.DW_effects_heavy.GetValue() <= MCM.DW_effects_light.GetValue()
		MCM.DW_effects_heavy.SetValue(66)
	endif
	if MCM.DW_effects_light.GetValue() <= 0 || MCM.DW_effects_light.GetValue() >= 100 || MCM.DW_effects_light.GetValue() <= MCM.DW_effects_light.GetValue()
		MCM.DW_effects_light.SetValue(33)
	endif
	
	int rank = SLA.GetActorArousal(PlayerREF)
	float strSound1 = (rank - MCM.DW_effects_light.GetValue()) / (MCM.DW_effects_heavy.GetValue() - MCM.DW_effects_light.GetValue())	;sound volume for Breathing1 and Heartbeat1
	float strHighArousalVisual = (rank - MCM.DW_effects_heavy.GetValue()) / (100 - MCM.DW_effects_heavy.GetValue())						;effect strength for HighArousalVisual
	float strLowArousalVisual = (rank - MCM.DW_effects_light.GetValue()) / (100 - MCM.DW_effects_light.GetValue())						;effect strength for LowArousalVisual

	;visual high,disable
	if MCM.DW_ModState5.GetValue() == 1 && rank >= MCM.DW_effects_heavy.GetValue() && DDi.IsWearingDDBlindfold(PlayerREF) == false && !(bAnimating == true && MCM.DW_ModState9.GetValue() == 1)
		if rank != rankprev		;if arousal changed then update visual effect
			if bHighArousalVisual == true
				HighArousalVisual.Remove()	;Remove effect for updating it strength
			endif
			HighArousalVisual.Apply(strHighArousalVisual)
			bHighArousalVisual = true
		endif
	else
		if bHighArousalVisual == true
			HighArousalVisual.Remove()
			bHighArousalVisual = false
		endif
	endif

	;visual low,disable
	if MCM.DW_ModState7.GetValue() == 1 && rank >= MCM.DW_effects_light.GetValue() && DDi.IsWearingDDBlindfold(PlayerREF) == false && !(bAnimating == true && MCM.DW_ModState9.GetValue() == 1)
		if rank != rankprev		;if arousal changed then update visual effect
			if bLowArousalVisual == true
				LowArousalVisual.Remove()	;Remove effect for updating it strength
			endif
			LowArousalVisual.Apply(strLowArousalVisual)
			bLowArousalVisual = true
		endif
	else
		if bLowArousalVisual == true
			LowArousalVisual.Remove()
			bLowArousalVisual = false
		endif
	endif
		
	;sound heart high,low,disable
	if MCM.DW_ModState6.GetValue() == 1 && rank >= MCM.DW_effects_heavy.GetValue() && !(bAnimating == true && MCM.DW_ModState10.GetValue() == 1)
		if bHeartbeat2ID == false
			Heartbeat2ID = Heartbeat2.play(PlayerRef)
			bHeartbeat2ID = true
			if bHeartbeat1ID == true
				Sound.StopInstance(Heartbeat1ID)
				bHeartbeat1ID = false
			endif
		endif
		Sound.SetInstanceVolume(Heartbeat2ID, 1)
	elseif MCM.DW_ModState6.GetValue() == 1 && rank >= MCM.DW_effects_light.GetValue() && !(bAnimating == true && MCM.DW_ModState10.GetValue() == 1)
		if bHeartbeat1ID == false
			Heartbeat1ID = Heartbeat1.play(PlayerRef)
			bHeartbeat1ID = true
			if bHeartbeat2ID == true
				Sound.StopInstance(Heartbeat2ID)
				bHeartbeat2ID = false
			endif
		endif
		Sound.SetInstanceVolume(Heartbeat1ID, strSound1)
	else
		if bHeartbeat1ID == true
			Sound.StopInstance(Heartbeat1ID)
			bHeartbeat1ID = false
		endif
		if bHeartbeat2ID == true
			Sound.StopInstance(Heartbeat2ID)
			bHeartbeat2ID = false
		endif
	endif
	
	;sound breath high,low,disable
	if MCM.DW_ModState8.GetValue() == 1 && rank >= MCM.DW_effects_heavy.GetValue()
		if bBreathing2ID == false
			Breathing2ID = Breathing2.play(PlayerRef)
			bBreathing2ID = true
			if bBreathing1ID == true
				Sound.StopInstance(Breathing1ID)
				bBreathing1ID = false
			endif
		endif
		Sound.SetInstanceVolume(Breathing2ID, 1)
	elseif MCM.DW_ModState8.GetValue() == 1 && rank >= MCM.DW_effects_light.GetValue()
		if bBreathing1ID == false
			Breathing1ID = Breathing1.play(PlayerRef)
			bBreathing1ID = true
			if bBreathing2ID == true
				Sound.StopInstance(Breathing2ID)
				bBreathing2ID = false
			endif
		endif
		Sound.SetInstanceVolume(Breathing1ID, strSound1)
	else
		if bBreathing2ID == true
			Sound.StopInstance(Breathing2ID)
			bBreathing2ID = false
		endif
		if bBreathing1ID == true
			Sound.StopInstance(Breathing1ID)
			bBreathing1ID = false
		endif
	endif

	;dripping wet pc
	if rank >= DW_Arousal_threshold.GetValue()
		DW_Dripping_Spell.cast( PlayerREF )
	endif
	
	;dripping gag pc
	if DDi.IsWearingDDGag(PlayerREF) || zbf.IsWearingZaZGag(PlayerREF)
		DW_DrippingGag_Spell.cast( PlayerREF )
	endif
	
	;npc cloak
	if DW_Cloak.GetValue() == 1
		Cell akTargetCell = PlayerREF.GetParentCell()
		int iRef = 0
		
		while iRef <= akTargetCell.getNumRefs(43) ;GetType() 62-char,44-lvchar,43-npc
			Actor aNPC = akTargetCell.getNthRef(iRef, 43) as Actor
			
			if aNPC != none
				;dripping wet npc
				If SLA.GetActorArousal(aNPC) >= DW_Arousal_threshold.GetValue()
					DW_Dripping_Spell.cast( aNPC )
				EndIf
				
				;dripping gag npc
				if DDi.IsWearingDDGag(aNPC) || zbf.IsWearingZaZGag(aNPC)
					DW_DrippingGag_Spell.cast( aNPC )
				endif
			endif
			
			iRef = iRef + 1
		endWhile
	endif

	rankprev = rank	;update arousal value to compare on the next cycle
	
	RegisterForSingleUpdate(DW_Timer.GetValue())
EndEvent

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	Actor[] actors = SexLab.HookActors(_args)
	int idx = 0
	sslBaseAnimation animation = SexLab.HookAnimation(_args)
	
	if (animation.HasTag("Anal") || animation.HasTag("Vaginal")) && actors.Length > 1
		If SOS.GetSOS(actors[1]) == true || actors[1].GetLeveledActorBase().GetSex() != 1
			DW_DrippingCum_Spell.cast( actors[0] )
		EndIf
	endif
	
	While idx < actors.Length
		DW_DrippingSquirt_Spell.cast( actors[idx] )
		idx += 1
	EndWhile
EndEvent

Event AnimationStart(int threadID, bool HasPlayer)
	if HasPlayer == true && MCM.DW_ModState9.GetValue() == 1
		bAnimating = true
		if bHighArousalVisual == true
			HighArousalVisual.Remove()
			bHighArousalVisual = false
		endif
		if bLowArousalVisual == true
			LowArousalVisual.Remove()
			bLowArousalVisual = false
		endif
	endif
	
	if HasPlayer == true && MCM.DW_ModState10.GetValue() == 1
		bAnimating = true
		if bHeartbeat1ID == true
			Sound.StopInstance(Heartbeat1ID)
			bHeartbeat1ID = false
		endif
		if bHeartbeat2ID == true
			Sound.StopInstance(Heartbeat2ID)
			bHeartbeat2ID = false
		endif
		if bBreathing2ID == true
			Sound.StopInstance(Breathing2ID)
			bBreathing2ID = false
		endif
		if bBreathing1ID == true
			Sound.StopInstance(Breathing1ID)
			bBreathing1ID = false
		endif
	endif
EndEvent

Event AnimationEnd(int threadID, bool HasPlayer)
	if HasPlayer == true
		bAnimating = false
	endif
EndEvent
