Scriptname DW_DrippingSpellScr extends activemagiceffect

FormList Property DW_Actors Auto

Event OnEffectStart( Actor akTarget, Actor akCaster )
	DW_Actors.AddForm(akTarget)
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	DW_Actors.RemoveAddedForm(akTarget)
EndEvent