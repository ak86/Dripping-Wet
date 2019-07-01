Scriptname DW_SLA extends Quest

Event OnInit()
	;StorageUtil.SetIntValue(none,"DW.PluginsCheck.sla",2)
EndEvent

int Function GetActorArousal(Actor akActor)
	DW_CORE CORE = Game.GetFormFromFile(0xD62, "DW.esp") as DW_CORE
	Faction slaArousal
	int rank = 0
	
	;Sexlab
	if CORE.Plugin_SLAR
		slaArousal = Game.GetFormFromFile(0x3FC36, "SexLabAroused.esm") As Faction
		if ( slaArousal )
			rank = akActor.GetFactionRank(slaArousal)
			if rank > 0
				return rank
			endif
		endIf
	endIf
	
	;Flower grils
	if CORE.Plugin_AR
		slaArousal = Game.GetFormFromFile(0x3FC36, "ArousedRedux.esm") As Faction
		if ( slaArousal )
			rank = akActor.GetFactionRank(slaArousal)
			if rank > 0
				return rank
			endif
		endIf
	endIf
	
	Return rank
EndFunction