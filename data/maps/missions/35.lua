g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Tharksh = function() return GetNamedObject("Tharksh") end
g_init.Kuna = function() return GetNamedObject("Kuna") end
g_init.Arna = function() return GetNamedObject("Arna") end

g.AllUnitsTeleported = false

local TeleportPosIn = GetNamedObjectPos("in_shield")
local TeleportPosOut = GetNamedObjectPos("out_of_shield")
local TeleportPosBreeder1 = GetNamedObjectPos("TeleportPos1")

g_Objectives.BaseObjective = {
  Create = function() return ui.Objectives:Add("Escort Eji to the Shard", 1, " ", " ") end
}
g_Objectives.Find = {
  Create = function() return ui.Objectives:Add("Sneak to the teleporter controls", 1, "Use only alien units", " ") end
}
g_Objectives.Activate = {
  Create = function() return ui.Objectives:Add("Activate the teleporter", 1, " ", " ") end
}
g_Objectives.Disable = {
  Create = function() return ui.Objectives:Add("Disable the teleporter", 1, " ", " ") end
}
g_Objectives.Port = {
  Create = function() return ui.Objectives:Add("Teleport all friendly units", 1, "Get the human troops in the teleporter cage", " ") end
}
g_Objectives.Use = {
  Create = function() return ui.Objectives:Add("Use the teleporter to escape", 1, "All avatars must be in range", " ") end
}

function SetObjective(name)
  HideObjective("Find")
  HideObjective("Activate")
  HideObjective("Disable")
  HideObjective("Port")
  HideObjective("Use")
  if name then
    ShowObjective(name)
  end  
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  onOneShotCondition(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  
  if name == "SpawnMobs1" and not value then
    g.Tharksh:Say("spawner 1 disabled")
    SetObjective(nil)
  elseif name == "SpawnMobs2" and not value then
    g.Denkar:Say("spawner 2 disabled")
    SetObjective(nil)
  elseif name == "SpawnMobs3" and not value then
    g.Tharksh:Say("spawner 3 disabled")
    g.Arna:Say("not funny")
    SetObjective(nil)
  elseif name =="SpawnMobs4" and not value then
    g.Tharksh:Say("describe situation")
    g.Denkar:Say("we have a plan")
    g.Tharksh:Say("jaar lash units")
    g.Denkar:Say("we wait-35")
    g.Arna:Say("dont like")
    g.Denkar:Say("no choice")
    SetObjective("Find")
  elseif name == "SpawnMobs5" and not value then
    g.Denkar:Say("done")
    SetObjective(nil)
  end
end

function onOneShotCondition(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "PlayerAfterBreeder1" == name then
    SetCondition("SpawnMobs5", true)
  elseif "PlayerAtBreeder2" == name then
    SetCondition("SpawnBreeder2Defenders", true)
    if g.AllUnitsTeleported then
      g.Denkar:Say("dead end")
      g.Tharksh:Say("enable teleporter")
      SetObjective("Activate")
    end
  elseif "PlayerAtSpawner1" == name then
    g.Denkar:Say("is it a teleporter")
    g.Tharksh:Say("disable spawner 1")
    g.Denkar:Say("can we use it")
    g.Tharksh:Say("receiver only")
    SetObjective("Disable")
  elseif "PlayerAtSpawner2" == name then
    g.Kuna:Say("disable spawner 2")
    SetObjective("Disable")
  elseif "PlayerAtSpawner3" == name then
    g.Arna:Say("disable spawner 3")
    g.Denkar:Say("cant leave them")
    SetObjective("Disable")
  elseif "PlayerAtSpawner4" == name then
    g.Denkar:Say("disable spawner 4")
    g.Kuna:Say("this is the last")
    SetObjective("Disable")
  elseif "PlayerAtBreeder1" == name then
    g.Tharksh:Say("teleporter controls")
    SetObjective("Port")
  elseif "AllUnitsTeleported" == name then
    g.AllUnitsTeleported = true
    SetObjective(nil)
  elseif g.AllUnitsTeleported and "PlayerAtSpawner5" == name then
    g.Denkar:Say("disable spawner 5")
    g.Arna:Say("hurry-35")
    g.Tharksh:Say("fast enough")
    SetObjective("Disable")
  elseif g.AllUnitsTeleported and "Teleport2Switch" == name then
    SetObjective("Use")
  end

end

function TeleportIn(switch, user)
  user:SetPos(TeleportPosIn)
  user:SetVar("reset_prg", 1)
end

function TeleportOut(switch, user)
  user:SetPos(TeleportPosOut)
  user:SetVar("reset_prg", 1)
end

function ActivateTeleporter(switch, user)
  TeleportUnits(GetPlayerFaction(), TeleportPosBreeder1, "Teleporter1", "all", "BigLightningStrike02", "respawn_react")
end

function InitObjectives()
  ShowObjective("BaseObjective")
end
