Scriptname DW_zbf extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.zbf",2)
EndEvent

bool Function IsWearingZaZGag (Actor akActor)
	Keyword zbfWornGag = Keyword.GetKeyword("zbfWornGag")
	if zbfWornGag != none
		if akActor.WornHasKeyword(zbfWornGag)
			Return true
		endif
	endif
	Return false
EndFunction