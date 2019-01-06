Scriptname DW_Status extends Quest

DW_CORE CORE

Event OnInit()
	CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	RegisterForSingleUpdate(10)
EndEvent

Event OnUpdate()
	if CORE.DW_PluginsCheck.GetValue() != 1
		DWPluginsInfo()
		RegisterForSingleUpdate(10)
	endif
	CORE.DW_PluginsCheck.SetValue(0)
EndEvent

Function DWPluginsInfo()
	String msg = ""
	String Status = ""
	int i = 0
	String [] name = new string[1]
	Int[] value = new int[1]
	bool ErrorsFound = False

	;individual check to see if scripts working at all
	;stop quest
	;reset quest (so that scripts run OnInit() during quest start)
	;start quest (OnInit() resets values if script has launched)
	Quest.GetQuest("DW_Dripping_SOS").stop()
	Quest.GetQuest("DW_Dripping_SOS").reset()
	Quest.GetQuest("DW_Dripping_SOS").start()
	utility.wait(1) ; wait for quests startup and do their OnInit()

	value[0] = CORE.DW_SOS_Check.GetValue() as int

	name[0] = "Schlongs of Skyrim (Full)"

	msg = "Dripping Wet plugins check:\n"
	While i < name.Length
		if value[i] == 1
			Status = "off"
		elseif value[i] == 2
			Status = "on"
		else
			Status = "error"
			ErrorsFound = True
		endif

		msg = msg + ("Plugin: " + name[i] + " Status: " + Status + "\n")
		i += 1
	endwhile
	
	if ErrorsFound == True
		Debug.MessageBox(msg)
		Debug.Messagebox("Dripping when aroused was not installed correctly, scripts are not running.\n This can be false alarm when starting new game but if message keeps repeating, then something is wrong, reinstall with correct plugins.")
	endif
	
	;reset for next run
	CORE.DW_SOS_Check.SetValue(0)
EndFunction
