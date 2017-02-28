Scriptname DW_SOS extends Quest

Event OnInit()
	StorageUtil.SetIntValue(none,"DW.PluginsCheck.sos",2)
EndEvent

bool Function IsIntegraged ()
	Return True
EndFunction

bool Function GetSOS(Actor akActor)
	bool hasSchlong = false
	SOS_SetupQuest_Script sosScript = Quest.GetQuest("SOS_SetupQuest") as SOS_SetupQuest_Script
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
	return hasSchlong
EndFunction