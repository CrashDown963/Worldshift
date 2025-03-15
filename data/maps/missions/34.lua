g_init.JudgeDavidov = function() return GetNamedObject("Jurran Judge 1") end
g_init.JudgeSmirnov = function() return GetNamedObject("Jurran Judge 2") end
g_init.AbsoluteJudge = function() return GetNamedObject("Jurran Judge 3") end
g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Tharksh = function() return GetNamedObject("Tharksh") end
g_init.Vasilii = function() return GetNamedObject("Vasilii") end
g_init.Priest = function() return GetNamedObject("Priest") end
g_init.Kuna = function() return GetNamedObject("Kuna") end
g_init.PsiResonator = function() return GetNamedObject("PsiResonator") end
g_init.Temple = function() return GetNamedObject("Temple") end

local VasiliiPoints = { "vp1", "vp2", "vp3" }
local BlockTurrets = { "bt1", "bt2", "bt3", "bt4" }
local ShipWaitTime = 110
g.ShipWaitStartTime = 0
g.ResonatorAlone = false
g.HoldResonatorCheck = false
g.VasiliiThread = false
local VasiliiThread = false

g_Objectives.BaseObjective = {
  Create = function() return ui.Objectives:Add("Proceed onward", 1, "Protect the Psi Resonator", " ") end
}

g_Objectives.VasiliiObjective = {
  Create = function() return ui.Objectives:Add("Eliminate Vasilii", 1, "Vasilii health left:", " ") end,
  Update = function(Objective)
    if not actors.Actor.IsValid(g.Vasilii) then return end
    local hp = g.Vasilii:GetVar("hit_points_percent") or 0
    Objective.Row12:Set(hp .. "%")
  end
}

g_Objectives.MutantsObjective = {
  Create = function() return ui.Objectives:Add("Destroy the mutants temple", 1, "Temple hit points:", " ") end,
  Update = function(Objective)
    if actors.Actor.IsValid(g.Temple) then
      local hp = g.Temple:GetVar("hit_points_percent") or 0
      Objective.Row12:Set(hp .. "%")
    else  
      HideObjective("MutantsObjective")
      g.Denkar:Say("sorry ganthu")
    end  
  end
}

g_Objectives.KunaWaitObjective = {
  Create = function() return ui.Objectives:Add("Secure the landing zone", 1, "Time until the ship arrives:", SecondsToStr(ShipWaitTime)) end,
  Update = function(Objective)
    local timeLeft = ShipWaitTime - (GetTime() - g.ShipWaitStartTime)
    if timeLeft <= 0 then timeLeft = 0 end
    Objective.Row12:Set(SecondsToStr(timeLeft))
    if timeLeft > 0 then return end

    SetCondition("SpawnFinalAmbushers", false)
    HideObjective("KunaWaitObjective")
    if actors.Actor.IsValid(g.PsiResonator) then
      g.PsiResonator:SetVar("indestructible", 1)
      g.PsiResonator:SetVar("attackable", 0)
      g.HoldResonatorCheck = true
    else
      return
    end
    g.Kuna:Say("arriving")
    RunAfter(3, function()
      local resonatorPos = GetNamedObjectPos("PsiResonator")
      local thieves = {}
      SpawnObjects("Harvester = 2", resonatorPos, 6, thieves)
      SpawnObjects("Dominator = 2", resonatorPos, 6, thieves)
      for _, thief in ipairs(thieves) do
        if actors.Actor.IsValid(thief) then 
          thief:SetVar("attackable", 0)
          thief:SetVar("hold_fire", 1)
        end
      end
      g.Denkar:Say("who are these")
      g.Tharksh:Say("tharksh puzzled")
      RunAfter(4, function()
        for _, thief in ipairs(thieves) do
          if actors.Actor.IsValid(thief) then thief:Execute("PrgDespawn") end
        end
        if actors.Actor.IsValid(g.PsiResonator) then g.PsiResonator:Execute("PrgDespawn") end
        RunAfter(1, function()
          g.Denkar:Say("they stole the resonator")
          g.Kuna:Say("we must hurry")
          RunAfter(5, function()
            WinMission()
          end)  
        end)  
      end)  
    end)  
  end
}


function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "Judge1SeesEnemy" == name then
    g.JudgeDavidov:Say("judge 1 sees enemy")
    g.Denkar:Say("me friend")
    g.JudgeDavidov:Say("you enemy")
    g.Tharksh:Say("fight inevitable")
    g.Denkar:Say("self defend")
  elseif "Judge2SeesEnemy" == name then
    g.JudgeSmirnov:Say("judge 2 sees enemy")
    g.Denkar:Say("turrets coming")
    g.Tharksh:Say("handle turrets")
    g.Denkar:Say("turrets advise")
    CreateThread(CreateProtonTurret(25, "Turret11"))
    CreateThread(CreateProtonTurret(25, "Turret12"))
    CreateThread(CreateProtonTurret(25, "Turret13"))
  elseif "Judge3SeesEnemy" == name then
    g.AbsoluteJudge:Say("judge 3 sees enemy")
  elseif "VasiliiSeesEnemy" == name then
    CreateThread(VasiliiControl)
  elseif "HuntersDead" == name then
    g.Denkar:Say("hunters killed")
  elseif "PlayerAtPriestArea" == name then
    CreateThread(MutantsFight)
  elseif "PlayerAtFinalFightArea" == name then
    SetGroupVar("FinalFight", "hold_fire", 0)
    g.Denkar:Say("humans fight mutants")
    g.Tharksh:Say("they will attack us")
    g.Denkar:Say("we wait-34")
  elseif "FinalFightersDead" == name then
    RunAfter(3, FinalScene)
  end
end

function FinalScene()
  HideObjective("BaseObjective")
  RunAfter(3, function()
    g.Denkar:Say("transmission")
    g.Kuna:Say("hi guys")
    g.Denkar:Say("get us out")
    g.Kuna:Say("secure the lz")
    SetCondition("SpawnFinalAmbushers", true)
    g.ShipWaitStartTime = GetTime()
    ShowObjective("KunaWaitObjective")
  end)  
  return "SUCCESS"
end

function MutantsFight()
  g.Priest:Say("stop or i kill you")
  g.Denkar:Say("i mean no harm")
  g.Priest:Say("you murderer")
  RunAfter(3, function()
    SetGroupVar("Defenders", "attackable", 1)
    SetGroupVar("Defenders", "hold_fire", 0)
    SetCondition("SpawnDefendersFlag", true)
    g.Denkar:Say("destroy temple")
    ShowObjective("MutantsObjective")
  end)
  return "SUCCESS"
end

function DisableTurrets()
  g.Denkar:Say("switch done")
  for _, turretName in ipairs(BlockTurrets) do
    local turret = GetNamedObject(turretName)
    if turret then
      turret:SetVar("hold_fire", 1) 
      turret:SetVar("attackable", 0) 
    end
  end
end

function VasiliiControl()
  local session = CheckpointData.session
  g.VasiliiThread = true
  VasiliiThread = true
  g.Vasilii:Say("stop right there")
  g.Denkar:Say("no fight")
  g.Vasilii:Say("lay your weapons")
  g.Denkar:Say("wont happen")
  g.Vasilii:Say("hard way")
  for i = 1,25 do
    sleep(1)
    if CheckpointData.session ~= session then 
      VasiliiThread = false
      return "SUCCESS"
    end
  end  
  g.Vasilii:SetVar("attackable", 1)
  g.Vasilii:SetVar("hold_fire", 0)

  ShowObjective("VasiliiObjective")
  
  local teleportTime = 8
  local nextTeleportTime = 0
  local lastPos = ""
  local pos = ""

  while actors.Actor.IsValid(g.Vasilii) do
    if GetTime() > nextTeleportTime then
      while lastPos == pos do
        pos = VasiliiPoints[SIRND(1, table.getn(VasiliiPoints))]
      end
      lastPos = pos
      g.Vasilii:SetPos(GetNamedObjectPos(pos))
      nextTeleportTime = GetTime() + teleportTime
    end
    sleep(0.5)
    if CheckpointData.session ~= session then 
      VasiliiThread = false
      return "SUCCESS"
    end
  end

  HideObjective("VasiliiObjective")

  g.VasiliiThread = false
  VasiliiThread = false
  g.Denkar:Say("switch")
  g.Tharksh:Say("hurry-34")
  return "SUCCESS"
end

function CreateProtonTurret(waitTime, buildObjName)
  local session = CheckpointData.session
  return function()
    if CheckpointData.session ~= session then 
      return "SUCCESS"
    end
    local buildObj = GetNamedObject(buildObjName)
    local faction = 12
    if buildObj == nil then return end
    local pos = buildObj:GetPos()
    local orientHandle = buildObj.h
    SpawnObject("ProtonTurretUpgradingAnim", pos, faction, orientHandle, buildObjName .. "_upgranim")
    local endTime = GetTime() + waitTime
    while GetTime() < endTime do
      if not actors.Actor.IsValid(buildObj) then
        DestroyObjectByName(buildObjName .. "_upgranim")
        return "SUCCESS"
      end
      sleep(0.2)
      if CheckpointData.session ~= session then
        DestroyObjectByName(buildObjName .. "_upgranim")
        return "SUCCESS"
      end  
    end
    if not actors.Actor.IsValid(buildObj) then
      DestroyObjectByName(buildObjName .. "_upgranim")
      return "SUCCESS"
    end
    SpawnObject("ProtonTurretUpgradedAnim", pos, faction, orientHandle)
    sleep(1)
    if CheckpointData.session ~= session then
      DestroyObjectByName(buildObjName .. "_upgranim")
      return "SUCCESS"
    end  
    local turret = SpawnObject("ProtonTurret", pos, faction, orientHandle)
    turret:ActivateController("crew", 0);
    DestroyObjectByName(buildObjName)
    DestroyObjectByName(buildObjName .. "_upgranim")
    return "SUCCESS"
  end
end

function PsiResonatorAlone(params)
  if actors.Actor.IsValid(g.Denkar) then
    g.Denkar:Say("resonator alone")
    CreateMapPing(GetNamedObjectPos("PsiResonator"))
  end
  g.ResonatorAlone = true
  RunAfter(10, SpawnResonatorThieves)
end

function SpawnResonatorThieves()
  if g.ResonatorAlone then
    local thieves = {}
    if actors.Actor.IsValid(g.PsiResonator) then
      g.PsiResonator:SetVar("indestructible", 1)
      g.PsiResonator:SetVar("attackable", 0)
      g.HoldResonatorCheck = true
    else
      return "SUCCESS"
    end
    SpawnObjects("EliteTrooper = 5", GetNamedObjectPos("PsiResonator"), 12, thieves)
    for _, thief in ipairs(thieves) do
      if actors.Actor.IsValid(thief) then 
        thief:SetVar("attackable", 0)
        thief:SetVar("hold_fire", 1)
      end
    end
    RunAfter(2, function()
      for _, thief in ipairs(thieves) do
        if actors.Actor.IsValid(thief) then thief:Execute("PrgDespawn") end
      end
      if actors.Actor.IsValid(g.PsiResonator) then g.PsiResonator:Execute("PrgDespawn") end
      RunAfter(3, function()
        LoseMission("vic_34psistolen")
      end)  
    end)  
  end
  return "SUCCESS"
end

function PsiResonatorNotAlone(params)
  g.ResonatorAlone = false
end

function CheckResonator()
  while true do
    if not g.HoldResonatorCheck then
      if not actors.Actor.IsValid(g.PsiResonator) then
        g.HoldResonatorCheck = true
        g.Denkar:Say("doomed")
        RunAfter(8, function()
          LoseMission("vic_34psidestr")
        end)  
      end
    end  
    sleep(1)
  end
end

function CheckVasiliiThread()
  while true do 
    if g.VasiliiThread and not VasiliiThread then
      CreateThread(VasiliiControl)
    end
    sleep(1)
  end  
end

function InitObjectives()
  ShowObjective("BaseObjective")
  g.Denkar:Say("follow the path")
  CreateThread(CheckResonator)
  CreateThread(CheckVasiliiThread)
end
