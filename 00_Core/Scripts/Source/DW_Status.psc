Scriptname DW_Status extends Quest

Event OnInit()
	RegisterForSingleUpdate(10)
EndEvent

Event OnUpdate()
	if StorageUtil.GetIntValue(game.getplayer(),"DW.PluginsCheck.scripts") != 1
		Debug.Messagebox("Dripping when aroused was not installed correctly, scripts are not running.\n This can be false alarm when starting new game but if message keeps repeating, then something is wrong, reinstall with correct plugins.")
		DWPluginsInfo()
		RegisterForSingleUpdate(10)
	endif
	StorageUtil.UnSetIntValue(game.getplayer(),"DW.PluginsCheck.scripts")
EndEvent

Function DWPluginsInfo()
	String msg = ""
	String Status = ""
	int i = 0
	String [] name = new string[4]
	Int[] value = new int[4]
	;bool ErrorsFound = False

	;individual check to see if scripts working at all, ;stop quest , ;start quest/runs OnInit check
	Quest.GetQuest("DW_SLA").stop()
	Quest.GetQuest("DW_SLA").start()
	Quest.GetQuest("DW_DDi").stop()
	Quest.GetQuest("DW_DDi").start()
	Quest.GetQuest("DW_zbf").stop()
	Quest.GetQuest("DW_zbf").start()
	Quest.GetQuest("DW_SOS").stop()
	Quest.GetQuest("DW_SOS").start()
	utility.wait(1) ; wait for quests startup and do their OnInit()

	value[0] = StorageUtil.GetIntValue(none,"DW.PluginsCheck.ddi")
	value[1] = StorageUtil.GetIntValue(none,"DW.PluginsCheck.sla")
	value[2] = StorageUtil.GetIntValue(none,"DW.PluginsCheck.sos")
	value[3] = StorageUtil.GetIntValue(none,"DW.PluginsCheck.zbf")


	name[0] = "DW.PluginsCheck.ddi"
	name[1] = "DW.PluginsCheck.sla"
	name[2] = "DW.PluginsCheck.sos"
	name[3] = "DW.PluginsCheck.zbf"

	msg = "Dripping Wet plugins check:\n"
	While i < name.Length
		if value[i] == 1
			Status = "off"
		elseif value[i] == 2
			Status = "on"
		else
			Status = "error"
			;ErrorsFound = True
		endif

		msg = msg + ("Plugin: " + name[i] + " Status: " + Status + "\n")
		i += 1
	endwhile
	
	;if ErrorsFound == True
		Debug.MessageBox(msg)
	;endif
	
	;reset StorageUtil for next run
	StorageUtil.UnSetIntValue(none,"DW.PluginsCheck.ddi")
	StorageUtil.UnSetIntValue(none,"DW.PluginsCheck.sla")
	StorageUtil.UnSetIntValue(none,"DW.PluginsCheck.sos")
	StorageUtil.UnSetIntValue(none,"DW.PluginsCheck.zbf")
EndFunction
