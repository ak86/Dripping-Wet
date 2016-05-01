Scriptname DW_CORE extends Quest

SexLabFramework property SexLab auto
DW_SOS property SOS auto
DW_SLA property SLA auto
DW_DDi property DDi auto
DW_zbf property zbf auto
DW_MCM property MCM auto

GlobalVariable Property DW_Timer Auto
GlobalVariable Property DW_Cloak Auto
GlobalVariable Property DW_ModState0 Auto		; NPC Breathing effect
GlobalVariable Property DW_ModState1 Auto		; Pussy effect
GlobalVariable Property DW_ModState2 Auto		; Cum effect
GlobalVariable Property DW_ModState3 Auto		; Squirt effect
GlobalVariable Property DW_ModState4 Auto		; Gag effect
GlobalVariable Property DW_ModState5 Auto		; Heavy Visuals effect
GlobalVariable Property DW_ModState6 Auto		; Heartbeat effect
GlobalVariable Property DW_ModState7 Auto		; Light Visuals effect
GlobalVariable Property DW_ModState8 Auto		; Breathing effect
GlobalVariable Property DW_ModState9 Auto		; Visuals Disable during SL animation
GlobalVariable Property DW_ModState10 Auto		; Sound Disable during SL animation
GlobalVariable Property DW_ModState11 Auto		; Hearth Sound volume max/arousal based
GlobalVariable Property DW_ModState12 Auto		; Breath Sound volume max/arousal based
GlobalVariable Property DW_effects_light Auto
GlobalVariable Property DW_effects_heavy Auto
GlobalVariable Property DW_Cloak_Range Auto
GlobalVariable Property DW_Arousal_threshold Auto
GlobalVariable Property DW_Status_Global Auto

FormList Property DW_Actors Auto

SPELL Property DW_Dripping_Spell Auto
SPELL Property DW_DrippingCum_Spell Auto
SPELL Property DW_DrippingSquirt_Spell Auto
SPELL Property DW_DrippingGag_Spell Auto
SPELL Property DW_Breath_Spell Auto
SPELL Property DW_Heart_Spell Auto
SPELL Property DW_Visuals_Spell Auto

Sound Property Breathing1 Auto				;F Low
Sound Property Breathing2 Auto				;F High
Sound Property Breathing3 Auto				;M Low
Sound Property Breathing4 Auto				;M High
Sound Property Heartbeat1 Auto				;Low
Sound Property Heartbeat2 Auto				;High

ImageSpaceModifier Property HighArousalVisual Auto
ImageSpaceModifier Property LowArousalVisual Auto

bool Property bAnimating = false Auto		;SL player animation detection for stopping sound/visual effects
