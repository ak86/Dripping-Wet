Scriptname DW_Status extends Quest

GlobalVariable Property DW_Status_Global Auto

Event OnInit()
	RegisterForSingleUpdate(60)
EndEvent

Event OnPlayerLoadGame()
	RegisterForSingleUpdate(30)
EndEvent

Event OnUpdate()
	if DW_Status_Global.GetValue() != 1
		Debug.Messagebox("Dripping when aroused was not installed correctly, scripts are not running. \n This can be false alarm when starting new game but if message keeps repeating, then something is wrong, reinstall with correct plugins.")
		RegisterForSingleUpdate(30)
	endif
	DW_Status_Global.SetValue(0)
EndEvent
