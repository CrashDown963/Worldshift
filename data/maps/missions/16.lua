g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Eji = function() return GetNamedObject("Eji") end

g.Gate1Opened = false
g.KeyCardStealed = false
g.ExplosivesStealed = false
g.AlarmsActivated = false
g.CurrentCharge = 1
g.ExplosiveChargesPlaces = {}
g.ExplosivesDetonated = {}

g_Objectives.RemoveGuards = {
  Create = function() return ui.Objectives:Add("Remove the guards from the road", 1, "Denkar should divert the guards attention", " ") end
}  
g_Objectives.Sneak = {
  Create = function() return ui.Objectives:Add("Sneak through the base", 1, "Reach the service entrance", " ") end
}  
g_Objectives.Enter = {
  Create = function() return ui.Objectives:Add("Enter the base", 1, " ", " ") end
}  

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "FirstPatrolDead" == name then

  elseif "PlayerBehindDoor" == name then
  
  elseif "GanthuSeesEastGuards" == name and not g.AlarmsActivated then
    g.Ganthu:StopMoving()
    g.Ganthu:SetVar("reset_prg", true)
    g.Eji:Say("guards east")
    g.Ganthu:Say("cant pass")
  elseif "GanthuSeesNorthGuards" == name and not g.AlarmsActivated then
    g.Ganthu:StopMoving()
    g.Ganthu:SetVar("reset_prg", true)
    g.Ganthu:Say("kill guards")
  elseif "PlayerAtRoadBlock1Area" == name then
    for pos, place in pairs(g.ExplosiveChargesPlaces) do
      if place == "ExplosivesPlace1" and g.ExplosivesDetonated[pos] then return end
    end
    g.Ganthu:StopMoving()
    g.Ganthu:SetVar("reset_prg", true)
    g.Ganthu:SayTo(g.Denkar, "too many")
    g.Denkar:SayTo(g.Ganthu, "diversion east")
    g.Ganthu:SayTo(g.Denkar, "careful-16")
    HideAllObjectives()
    ShowObjective("RemoveGuards")
  elseif "PlayerAtRoadBlock2Area" == name then
    for pos, place in pairs(g.ExplosiveChargesPlaces) do
      if place == "ExplosivesPlace2" and g.ExplosivesDetonated[pos] then return end
    end
    g.Ganthu:Say("another block")
    HideAllObjectives()
    ShowObjective("RemoveGuards")
  elseif "PlayerAtRoadBlock3Area" == name then
    for pos, place in pairs(g.ExplosiveChargesPlaces) do
      if place == "ExplosivesPlace3" and g.ExplosivesDetonated[pos] then return end
    end
    g.Ganthu:Say("third block")
    g.Denkar:Say("last one")
    g.Eji:Say("panic")
    HideAllObjectives()
    ShowObjective("RemoveGuards")
  elseif "PlayerAtExplosivesArea" == name then
    g.Denkar:Say("found bombs")
  elseif "PlayerAtBombSite1" == name then
    g.Denkar:Say("bomb spot")
  end
end

function CheckActionVisible(gizmo, params)
  if not params.action then return false end

  local _, e = string.find(params.action, "M16DetonateCharge")
  
  if e then
    local chargeNumber = tonumber(string.sub(params.action, e + 1, e + 1))
    if g.ExplosivesDetonated[chargeNumber] then 
      return false 
    end
    return g.ExplosiveChargesPlaces[chargeNumber]
  end
  
  return false
end

function StealExplosives(switch, user)
  if g.ExplosivesStealed then return end
  g.ExplosivesStealed = true
  BroadcastTarget(g.Denkar, 1500)
  SetCondition("ExplosivesStealed", true)
  g.Denkar:Say("got bombs")
end

function ExplosivesAttached(switch, user)
  if not g.ExplosivesStealed then return end
  local switchName = switch:GetVar("obj_name", "str")
  if not switchName then return end
  
  local _, e = string.find(switchName, "ExplosivesSwitch")
  if e == nil then return end
  local placeName = "ExplosivesPlace" .. string.sub(switchName, e + 1, e + 1)

  g.ExplosiveChargesPlaces[g.CurrentCharge] = placeName
  g.CurrentCharge = g.CurrentCharge + 1
  BroadcastTarget(g.Denkar, 1500)
  BroadcastSelectionChange()
  g.Denkar:Say("bomb planted")
end

function KeycardAcquired(switch, user)
  g.Denkar:Say("got key")
  g.KeyCardStealed = true
end

function OpenGate1(switch, user)
  if g.Gate1Opened or not g.KeyCardStealed then return end
  SetCondition("OpenGate1", true)
  g.Gate1Opened = true
  g.Denkar:Say("can sneak")
  g.Ganthu:Say("not too close")
  HideAllObjectives()
  ShowObjective("Sneak")
end

function onAlarmActivated(spell, src, tgt)
  SetCondition("UseAlarms", false)
  src:FloatText(ui.TEXT("flt.Alarm! Alarm!"))
  BroadcastTarget(g.Denkar, -1)
  g.AlarmsActivated = true
  SetCondition("OpenGate1", true)
  g.Gate1Opened = true
end

function onMobDeath(mob)
  local objName = mob:GetVar("obj_name", "str")
  if "GateGuard" == objName then
    SetNamedObjectPos("Keycard", mob:GetPos())
  end
end

function DetonateExplosives(obj, params)
  if not params.action then return end
  local _, e = string.find(params.action, "M16DetonateCharge")
  if e == nil then return end
  local chargeNumber = tonumber(string.sub(params.action, e + 1, e + 1))
  if g.ExplosiveChargesPlaces[chargeNumber] == nil then return end
  if g.ExplosivesDetonated[chargeNumber] then return end
  g.ExplosivesDetonated[chargeNumber] = true 
  local holes = { "boom1", "boom2", "boom3" }
  g.Denkar:Say(holes[chargeNumber])
  local ExplosionPos = GetNamedObjectPos(g.ExplosiveChargesPlaces[chargeNumber])
  SpawnObject("Explosion_2_Big", ExplosionPos)
  ShakeCamera(ExplosionPos)
  if g.AlarmsActivated then return end
  if chargeNumber == 1 then
    SetCondition("Arrows5", true);
  else
    SetCondition("Arrows5", false);
    if chargeNumber == 3 then
      SetCondition("Arrows9", true);
    end
  end
  local ChargePlace = g.ExplosiveChargesPlaces[chargeNumber]
  local _, e = string.find(ChargePlace, "ExplosivesPlace")
  if e == nil then return end
  local BombSquadNumber = string.sub(ChargePlace, e + 1, e + 1)
  RunAfter(3, function()
    local BombSquadOfficerName = "BombSquadOfficer" .. BombSquadNumber
    local Officer = GetNamedObject(BombSquadOfficerName)
    if Officer then 
      Officer:SetVar("conv_icon_row", 4)
      Officer:SetVar("conv_icon_col", 2)
      Officer:Say("heard boom")
    end
    local BombSquadName = "BombSquad" .. BombSquadNumber
    SetGroupVar(BombSquadName, "path", "BombSite" .. BombSquadNumber)
    SetGroupVar(BombSquadName, "reset_prg", 0)
    HideAllObjectives()
    ShowObjective("Sneak")
    if BombSquadNumber == "2" then
      SetCondition("SpawnBombSquad4", true)
    end
  end)
end

function InitObjectives()
  g.Denkar:SayTo(g.Ganthu, "alarms 1")
  g.Denkar:SayTo(g.Ganthu, "alarms 2")
  g.Ganthu:SayTo(g.Denkar, "crowd control")
  g.Denkar:SayTo(g.Ganthu, "lets go")
  ExploreArea("ExitArea", GetPlayerFaction())
  ShowObjective("Enter")
end
