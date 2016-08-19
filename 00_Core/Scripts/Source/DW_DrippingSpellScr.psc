Scriptname DW_DrippingSpellScr extends activemagiceffect

DW_CORE property CORE auto

Event OnEffectStart( Actor akTarget, Actor akCaster )
	if StorageUtil.FormListHas(none, "DW.Actors", akTarget)
		StorageUtil.FormListAdd(none, "DW.Actors", akTarget, false)
	endIf
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	if StorageUtil.FormListHas(none, "DW.Actors", akTarget)
		StorageUtil.FormListRemove(none, "DW.Actors", akTarget)
	endIf
EndEvent