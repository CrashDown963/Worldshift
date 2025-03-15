g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Keen = function() return GetNamedObject("Keen") end
g_init.Gate2 = function() return GetNamedObject("Door2") end

g.CNDNSpawnMineReinforcements = false
g.CNDNOpenDoor1 = false
g.CNDNPlayerAtGateControl = false
g.CNDNPlayerAtDoor1Area = false
g.CNDNPlayerAtRoadBlockArea = false
g.CNDNPlayerInBase = false
g.CNDNMineOfficerInCombat = false
g.CNDNMineOfficerDead = false
g.CNDNPlayerAtBaseRevealArea = false
g.CNDNVictoryCond = false
g.BeamsActive = true

g_Objectives.StealFlyerObjective = {
  Create = function() return ui.Objectives:Add("Find escape vehicle", 1, " ", " ") end
}  

g_Objectives.ConfrontDefendersObjective = {
  Create = function() return ui.Objectives:Add("Eliminate the mine defenders", 1, " ", " ") end
}

g_Objectives.EnterTheBaseObjective = {
  Create = function() return ui.Objectives:Add("Enter the camp", 1, " ", " ") end
}  

local ShipPos = GetNamedObjectPos("ShipPos")

function round(num)
  return math.floor(num + 0.5)
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end

  if "OpenDoor1" == name and not g.CNDNOpenDoor1 then
    g.CNDNOpenDoor1 = true
    g.Ganthu:Say("gate opened")
    HideObjective("ConfrontDefendersObjective")
    ShowObjective("EnterTheBaseObjective")
  elseif "PlayerInBase" == name then
    g.CNDNPlayerInBase = true
    HideObjective("EnterTheBaseObjective")
  elseif "PlayerAtDoor1Area" == name and not g.CNDNPlayerAtDoor1Area then
    g.CNDNPlayerAtDoor1Area = true
    g.Ganthu:Say("gate here")
  elseif "GreenskinsDead" == name then
    if xLastTrueTime < 0 then
      local CagesItem = GetNamedObject("CagesItem")
      if actors.Actor.IsValid(CagesItem) then
        CagesItem:SetVar("hidden", 0)
      end  
    end  
  elseif "PlayerAtRoadBlockArea" == name and not g.CNDNPlayerAtRoadBlockArea then
    g.CNDNPlayerAtRoadBlockArea = true
    g.Ganthu:Say("what is this")
    g.Denkar:Say("force field")
    g.Ganthu:Say("passage")
  elseif "PlayerAtGateControl" == name and not g.CNDNPlayerAtGateControl then
    g.CNDNPlayerAtGateControl = true
    if g.BeamsActive then
      g.Denkar:Say("can open but beams")
    else
      g.Denkar:Say("can open no beams")
    end
  elseif "MineOfficerInCombat" == name and not g.CNDNMineOfficerInCombat then
    g.CNDNMineOfficerInCombat = true
    actor:Say("get them")
  elseif "MineOfficerDead" == name and not g.CNDNMineOfficerDead then
    g.CNDNMineOfficerDead = true
    g.Denkar:Say("officer down")
  elseif "PlayerAtBaseRevealArea" == name and not g.CNDNPlayerAtBaseRevealArea then
    g.CNDNPlayerAtBaseRevealArea = true
    ExploreArea("BaseArea", 1)
    RevealArea("BaseArea", true)
    g.Denkar:Say("base found")
    if actors.Actor.IsValid(g.Keen) then
      g.Keen:Say("come get some")
      g.Denkar:Say("duel of honor")
      g.Keen:Say("no duel")
      g.Denkar:Say("had to try")
    end  
  elseif "VictoryCond" == name and not g.CNDNVictoryCond then
    g.CNDNVictoryCond = true
    SetGroupVar("BaseDefenders", "sight", -1)
    SetGroupVar("Avatars", "interactive", 0)
    SetGroupVar("Avatars", "sight", 0)
    SetGroupVar("Avatars", "attackable", 0)
    local Avatars = GetNamedGroup("Avatars")
    
    for _, avatar in ipairs(Avatars) do
      avatar:SelectMe(false, false)
      avatar:SetPos(ShipPos)
      avatar:StopMoving()
      avatar:SetVar("reset_prg", 1)
      RemoveUnitFromSelectionGroups(avatar)
    end
    
    g.Keen:Say("my ship")
    g.Ganthu:Say("hurry-14")
    g.Denkar:Say("trying")
  elseif "SpawnMineReinforcements" == name and not g.CNDNSpawnMineReinforcements then
    g.CNDNSpawnMineReinforcements = true
    SetGroupVar("MineReinforcements", "path", "PathToMines")
  end
end

function CheckActionVisible(gizmo, params)
  if "M14ForcefieldControl" == params.action then
    return g.BeamsActive
  elseif "M14GateControl" == params.action then
    return actors.Actor.IsValid(g.Gate2)
  end
  
  return false
end

function TurnOffForcefield(switch, user)
  g.BeamsActive = false
  g.Denkar:SayTo(g.Ganthu, "unlocking")
  SetGroupVar("Greenskins", "attackable", 1)
  SetGroupVar("Greenskins", "sight", 2500)  
  SetGroupVar("Greenskins", "hold_fire", 0)  
  SetCondition("Arrows3b", true)
  SetGroupVar("Shields", "passable", 1)
end

function OpenNorthGate(switch, user)
  g.Denkar:Say("opening")
  SetCondition("OpenDoor2", true)
end

---
-- Initial dialogue
---

local BeamsCreated = false
local beams = {}

local function CreateBeams()
  if BeamsCreated then return end
  for i = 1, 3 do
    local num = tostring(i)
    local p1 = GetNamedObject("Pylon" .. num .. "1")
    local p2 = GetNamedObject("Pylon" .. num .. "2")
    table.insert(beams, CreateP2PBeam("14ForceFieldBeam", p1, p2, "pt_ray1", "pt_ray1"))
    table.insert(beams, CreateP2PBeam("14ForceFieldBeam", p1, p2, "pt_ray2", "pt_ray2"))
    table.insert(beams, CreateP2PBeam("14ForceFieldBeam", p1, p2, "pt_ray3", "pt_ray3"))
  end
  BeamsCreated = true
end

local function DestroyBeams()
  if not BeamsCreated then return end
  for _, beam in ipairs(beams) do RemoveP2PBeam(beam) end
  BeamsCreated = false
  beams = {}
end

function UpdateBeamsThread()
  while true do
    if g.BeamsActive ~= BeamsCreated then
      if BeamsCreated then DestroyBeams() else CreateBeams() end
    end
    if g.BeamsActive then
      DamageUnitsInArea("DamageArea1", 5000, 0, "lightning")
      DamageUnitsInArea("DamageArea2", 5000, 0, "lightning")
      DamageUnitsInArea("DamageArea3", 5000, 0, "lightning")
      sleep(0.30)
    else
      sleep(1)  
    end
  end  
end

function InitObjectives()
  g.Denkar:SetVar("conv_icon_row", 1)
  g.Denkar:SetVar("conv_icon_col", 1)
  g.Ganthu:SetVar("conv_icon_row", 1)
  g.Ganthu:SetVar("conv_icon_col", 5)
  g.Keen:SetVar("conv_icon_row", 2)
  g.Keen:SetVar("conv_icon_col", 4)
  CreateThread(UpdateBeamsThread)
  ShowObjective("StealFlyerObjective")
  g.Denkar:SayTo(g.Ganthu, "need diversion")
  g.Ganthu:SayTo(g.Denkar, "mine nearby")
  g.Denkar:SayTo(g.Ganthu, "lets try")
  ShowObjective("ConfrontDefendersObjective")
  SetGroupVar("Shields", "hidden", 1)
end
