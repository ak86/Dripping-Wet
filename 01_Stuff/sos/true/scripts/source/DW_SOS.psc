Scriptname DW_SOS extends Quest

Event OnInit()
	DW_CORE CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	CORE.DW_SOS_Check.SetValue(2)
EndEvent

bool Function GetSOS(Actor akActor)
	bool hasSchlong = false
	DW_CORE CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	if CORE.Plugin_SOS
		Quest sosScriptQuest = Quest.GetQuest("SOS_SetupQuest")
		if (sosScriptQuest)
			SOS_SetupQuest_Script sosScript = sosScriptQuest as SOS_SetupQuest_Script
			Faction SOS_SchlongifiedFaction = sosScript.SOS_SchlongifiedFaction

			If akActor.IsInFaction(SOS_SchlongifiedFaction)
				Quest addon = sosScript.GetActiveAddon(akActor)
				Faction addonFaction = SOS_Data.GetFaction(addon)
				if addonFaction != none
					if JsonUtil.StringListFind("/DW/SOS_NotAPenis", "notapenis", addonFaction.getname()) == -1
						return hasSchlong
					else
						return akActor.IsInFaction(SOS_SchlongifiedFaction)
					endif
				endif
			endif
		endif
	endif
	return hasSchlong
EndFunction