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
			if !addonFaction.getname() ==  "SOS_Addon_InvFemSchlong_Faction" || !addonFaction.getname() ==  "SOS_Addon_PHF_Faction"
				hasSchlong = akActor.IsInFaction(SOS_SchlongifiedFaction)
			endif
		endif
	return hasSchlong
EndFunction