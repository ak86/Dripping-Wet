Scriptname DW_SOS extends Quest

Event OnInit()
	DW_CORE CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	CORE.DW_SOS_Check.SetValue(1)
EndEvent

bool Function GetSOS(Actor akActor)
	bool hasSchlong = false
	return hasSchlong
EndFunction