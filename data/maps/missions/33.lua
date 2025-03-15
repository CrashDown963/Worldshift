g_init.Kuna = function() return GetNamedObject("Kuna") end
g_init.Arna = function() return GetNamedObject("Arna") end
g_init.Priest = function() return GetNamedObject("Priest") end
g_init.Ship = function() return GetNamedObject("Ship") end

local Turrets = { "dp1", "dp2", "dp3", "dp4" }
local Chargers = { "cp1", "cp2", "cp3", "cp4", "cp5", "cp6" }

g.CNDNKunaInBreederRange = false
g.UpdateBreederObjective = false

local TURRET_TIME = 45
local CurrentTurret = 0
TurretStartTime = nil

g.SpawnTurrets = true
g_load.SpawnTurrets = function()
  CurrentTurret = 0
  CreateNextTurret()
end

g_Objectives.BaseObjective = {
  Create = function()
    local o = ui.Objectives:Add("Destroy the AA site", 1, " ", " ") 
    if g.UpdateBreederObjective then
      o.Row11:Set("AA facility hull")
    end
    return o
  end,
  Update = function(Objective)
    if not g.UpdateBreederObjective then return end
    local breeder = GetNamedObject("Breeder")
    local hp
    if actors.Actor.IsValid(breeder) then
      hp = breeder:GetVar("hit_points_percent")
    else
      hp = 0
    end
    Objective.Row12:Set(hp .. "%")
    if hp <= 0 then
      g.UpdateBreederObjective = false
      g.Kuna:Say("victory-33")
      g.Arna:Say("help denkar")
      RunAfter(3, function()
        WinMission()
      end)  
    end  
  end
}

g_Objectives.TimerObjective = {
  Create = function() return ui.Objectives:Add("Protect the ship", 1, "Time until next turret arrives:", tostring(TURRET_TIME)) end,
  Update = function(Objective)
    local time = TURRET_TIME - (GetTime() - TurretStartTime)
    if time < 0 then time = 0 end
    Objective.Row12:Set(math.floor(time))
  end
}

g_Objectives.MutantsObjective = {
  Create = function() return ui.Objectives:Add("Help the mutants", 1, " ", " ") end,
  Update = function(Objective)
    if not actors.Actor.IsValid(g.Priest) then
      HideObjective("MutantsObjective")
    end
  end
}

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if "KunaSeesBreeder" == name then g.CNDNKunaInBreederRange = value end
  if not value then return end
  if xLastTrueTime >= 0 then return end

  if "PlayerAtAmbushArea" == name then
    SetGroupVar("Ambush", "attackable", 1)
    SetGroupVar("Mutants", "attackable", 1)
    g.Priest:Say("help")
    ShowObjective("MutantsObjective")
  elseif "AmbushDead" == name and actors.Actor.IsValid(g.Priest) then
    g.Priest:Say("thanks for help")
    g.Arna:Say("gift welcome")
    local horrors = {}
    SpawnObjects("HowlingHorror = 3", g.Priest:GetPos(), GetPlayerFaction(), horrors)
    for _, horror in ipairs(horrors) do horror:Execute("PrgIdle", { h = g.Kuna }) end
    local brutes = {}
    SpawnObjects("Brute = 3", g.Priest:GetPos(), GetPlayerFaction(), brutes)
    for _, brute in ipairs(brutes) do brute:Execute("PrgIdle", { h = g.Kuna }) end
    HideObjective("MutantsObjective")
  elseif "SpawnFinalGroup" == name then
    g.Arna:Say("sensors misbehaving")
    g.Kuna:Say("found site")
    g_Objectives.BaseObjective.Objective.Row11:Set("AA facility hull")
    g.UpdateBreederObjective = true
  end
end

function CreateNextTurret()
  CurrentTurret = CurrentTurret + 1
  if CurrentTurret == 1 then
    for _, turret in ipairs(Turrets) do
      DestroyObjectByName(turret .. "_upgranim")
    end
  elseif CurrentTurret == 2 then
    g.Kuna:Say("turret1 online")
  elseif CurrentTurret == 3 then
    g.Kuna:Say("turret2 online")
  elseif CurrentTurret == 4 then
    g.Kuna:Say("turret3 online")
  elseif CurrentTurret == 5 then
    g.Kuna:Say("turret4 online")
  end
  if CurrentTurret > table.getn(Turrets) then 
    g.SpawnTurrets = nil
    HideObjective("TimerObjective")
    SetCondition("FirstAttackers", false)
    SetCondition("SecondAttackers", false)
    SetCondition("ThirdAttackers", false)
    return 
  end
  TurretStartTime = GetTime()
  CreateThread(CreateProtonTurret(TURRET_TIME, Turrets[CurrentTurret], CreateNextTurret, CheckpointData.session))
end

function CreateProtonTurret(waitTime, buildObjName, notifyFunc, session)
  return function()
    if CheckpointData.session ~= session then 
      return "SUCCESS"
    end
    local buildObj = GetNamedObject(buildObjName)
    if buildObj == nil then return end
    local pos = buildObj:GetPos()
    local orientHandle = buildObj.h
    SpawnObject("ProtonTurretUpgradingAnim", pos, GetPlayerFaction(), orientHandle, buildObjName .. "_upgranim")
    sleep(waitTime)
    if CheckpointData.session ~= session then
      DestroyObjectByName(buildObjName .. "_upgranim")
      return "SUCCESS"
    end  
    SpawnObject("ProtonTurretUpgradedAnim", pos, GetPlayerFaction(), orientHandle)
    sleep(1)
    if CheckpointData.session ~= session then
      DestroyObjectByName(buildObjName .. "_upgranim")
      return "SUCCESS"
    end  
    local turret = SpawnObject("ProtonTurret", pos, GetPlayerFaction(), orientHandle)
    turret:SetVar("target_priority", 50)
    DestroyObjectByName(buildObjName .. "_upgranim")
    if notifyFunc then notifyFunc() end
    return "SUCCESS"
  end
end

function CheckShip()
  while true do
    if not actors.Actor.IsValid(g.Ship) then
      LoseMission("vic_33shipdes")
    end
    sleep(2)
  end
end

function Charger()
  local breeder = GetNamedObject("Breeder")

  while actors.Actor.IsValid(breeder) do
    local curCharge = 1
    local beamHandles = { }

    while table.getn(Chargers) > table.getn(beamHandles) do
      local charger = GetNamedObjectHandle(Chargers[curCharge])

      table.insert(beamHandles, CreateP2PBeam("33ChargeBeam", charger, breeder, "pt_top", "pt_top"))
      curCharge = curCharge + 1
      if table.getn(Chargers) == table.getn(beamHandles) and g.CNDNKunaInBreederRange then
        g.Kuna:Say("gonna blow")
      end
      sleep(2)
    end

    for _, beam in ipairs(beamHandles) do RemoveP2PBeam(beam) end
    breeder:SpawnEffect("M33BreederBoomEffect", breeder)
    sleep(25)
  end
end


function InitObjectives()
  g.Kuna:Say("defences coming")
  CreateThread(CheckShip)
  CreateThread(Charger)
  CreateNextTurret()
  ShowObjective("BaseObjective")
  ShowObjective("TimerObjective")
end
