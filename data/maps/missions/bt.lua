local LanZealot = GetNamedObject("LanZealot")
local MechsReward = GetNamedObject("MechsReward")
local KroggolReward = GetNamedObject("KroggolReward")
local LanZealotReward = GetNamedObject("LanZealotReward")
local LZDoor = GetNamedObject("LZDoor")

local CurrentObjective = nil
local PlayerFactions = GetActiveFactions()

local DroidPlaces = { "DroidPlace1", "DroidPlace2", "DroidPlace3", "DroidPlace4" }
local DroidBattlePhases = { { 1 }, { 2, 3 }, { 2, 3, 4 }, { 1, 2, 3, 4 } }

local LanZealotPhasesHealth = { 100, 80, 50 }

local YellowFFLeft = 3

local LZSwitchUsed = 0

local LanZealotReached = false

local function TeleportArmy(factionNo)
  local ptDest = GetNamedObjectPos("TeleportPosTrash" .. factionNo)
  TeleportUnits(factionNo, ptDest, nil, "non_officers", "BigLightningStrike02", "respawn_react")
  
  local ptDest = GetNamedObjectPos("TeleportPosOfficers" .. factionNo)
  TeleportUnits(factionNo, ptDest, nil, "officers", "BigLightningStrike02", "respawn_react")

  local ptDest = GetNamedObjectPos("TeleportPosCommander" .. factionNo)
  TeleportUnits(factionNo, ptDest, nil, "commander", "BigLightningStrike02", "respawn_react")

  if factionNo == GetPlayerFaction() then
    RunAfter(1, function()
      game.SetCameraPos(ptDest)
      return "SUCCESS"
    end)
  end
end

local function TeleportDroid(waitTime, buildObjName, droids)
  local buildObj = GetNamedObject(buildObjName)
  local faction = 12
  
  if buildObj == nil then 
    return function()
      print("Invalid build object name: " .. buildObjName)
      return "SUCCESS"
    end
  end
  
  return function()
    local pos = buildObj:GetPos()
    local orientHandle = buildObj.h
    SpawnObject("BridgeDroidTeleportingAnim", pos, faction, orientHandle, buildObjName .. "_upgranim1")
    local endTime = GetTime() + waitTime
    while GetTime() < endTime do
      if not actors.Actor.IsValid(buildObj) then
        DestroyObjectByName(buildObjName .. "_upgranim")
        return "SUCCESS"
      end
      sleep(0.2)
    end
    if not actors.Actor.IsValid(buildObj) then
      DestroyObjectByName(buildObjName .. "_upgranim")
      return "SUCCESS"
    end
    SpawnObject("BridgeDroidTeleportedAnim", pos, faction, orientHandle, buildObjName .. "_upgranim2")
    sleep(0.47)
    local droid = SpawnObject("BridgeDroid", pos, faction, orientHandle)
    DestroyObjectByName(buildObjName .. "_upgranim1")
    DestroyObjectByName(buildObjName .. "_upgranim2")
    table.insert(droids, droid)
    return "SUCCESS"
  end
end

local function DroidsBattle()
  local phase = 0
  local droids = {}
  local spawning = false
  
  while true do
    local atLeastOneDroidAlive = false
    
    for _, droid in ipairs(droids) do
      if actors.Actor.IsValid(droid) then
        atLeastOneDroidAlive = true
        break
      end
    end
    
    if not atLeastOneDroidAlive then
      phase = phase + 1
      if phase > 4 then
        break
      end
      sleep(5)
      droids = {}
      local phasePositions = DroidBattlePhases[phase]
      local creatingThreads = {}
      for _, pos in ipairs(phasePositions) do
        local thread = CreateThread(TeleportDroid(3, DroidPlaces[pos], droids))
        table.insert(creatingThreads, thread)
      end
      WaitFor(creatingThreads)
    end
    sleep(1)
  end
  
  SetCondition("SpawnGate1Switch", true)
  
  if actors.Actor.IsValid(MechsReward) then
    MechsReward:SetVar("hidden", 0)
  end
  
  return "SUCCESS"
end

local function LockUnit(unit, lock)
  print("Locking unit: " .. tostring(lock))
  if lock then
    unit:SetVar("attackable", 0)
    unit:SetVar("hold_fire", 1)
    unit:SetVar("interactive", 0)
  else
    unit:SetVar("attackable", 1)
    unit:SetVar("hold_fire", 0)
    unit:SetVar("interactive", 1)
  end
end

local function LockUnits(units, lock)
  for _, unit in ipairs(units) do
    LockUnit(unit, lock)
  end
end

local function PrepareLanZealotBattlePhase(phase)
  if phase == 1 then
    LockUnits(GetNamedGroup("LanZealotArmy"), true)
    for _, factNo in ipairs(PlayerFactions) do
      LockUnits(GetPlayerUnits(factNo, "officers"), true)
      LockUnits(GetPlayerUnits(factNo, "trash"), true)
      LockUnit(GetCommander(factNo), false)
      for _, factNo in ipairs(PlayerFactions) do
        TeleportArmy(factNo)
      end
    end
  elseif phase == 2 then
    for _, factNo in ipairs(PlayerFactions) do
      LockUnits(GetPlayerUnits(factNo, "officers"), false)
    end
    LockUnits(GetNamedGroup("LanZealotOfficers1"), false)
    LockUnits(GetNamedGroup("LanZealotOfficers2"), false)
  elseif phase == 3 then
    for _, factNo in ipairs(PlayerFactions) do
      LockUnits(GetPlayerUnits(factNo, "trash"), false)
    end
    LockUnits(GetNamedGroup("LanZealotTroopers1"), false)
    LockUnits(GetNamedGroup("LanZealotTroopers2"), false)
  end
end

local function LanZealotBattleAlt()
  local LanZealot = GetNamedObject("LanZealot")
  local phase = 1
  
  while actors.Actor.IsValid(LanZealot) do
    local bossHpPercent = LanZealot:GetVar("hit_points_percent")
    if bossHpPercent <= LanZealotPhasesHealth[phase] then
      print("Phase: " .. tostring(phase))
      PrepareLanZealotBattlePhase(phase)
      phase = phase + 1
    end
    sleep(1)
  end
end

local function DelRndUnits(groupName, unitCount)
  local officers = GetNamedGroup(groupName)
  while unitCount > 0 do
    local offCount = table.getn(officers)
    local ind = SIRND(1, offCount)
    officers[ind]:Destroy()
    table.remove(officers, ind)
    unitCount = unitCount - 1 
  end
end

local function LanZealotBattle()
  for _, factNo in ipairs(PlayerFactions) do
    for _, factNo in ipairs(PlayerFactions) do
      local commander = GetCommander(factNo)
      if actors.Actor.IsValid(commander) then
        RefillForces(commander)
        local ptDest = GetNamedObjectPos("TeleportPosCommander" .. factNo)
        TeleportUnits(factNo, ptDest, nil, "all", "BigLightningStrike02", "respawn_react")
        commander:PlaySnd("Data/Sounds/Effects/Teleport/Reinforce.wav")
        if factNo == GetPlayerFaction() then
          RunAfter(1, function()
            game.SetCameraPos(ptDest)
            return "SUCCESS"
          end)
        end
      end
    end
  end
  local LanZealot = GetNamedObject("LanZealot")
  while actors.Actor.IsValid(LanZealot) do
    sleep(1)
  end
  return "SUCCESS"
end

function OpenGate2()
  LanZealotReached = true
  if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
  CurrentObjective = ui.Objectives:Add("Defeat Lan Zealot", 1, " ", " ")
  if actors.Actor.IsValid(LanZealot) then
    LanZealot:Say("impressed")
  end  

  SetNamedObjectVar("LZDoor", "hidden", 1)
  SetNamedObjectVar("LZDoor", "passable", 1)
  
  --CreateThread(LanZealotBattle)
end

local function InitMap()
  CurrentObjective = ui.Objectives:Add("Reach Lan Zealot", 1, " ", " ")
  
  for _, buildObjName in ipairs(DroidPlaces) do
    local buildObj = GetNamedObject(buildObjName)
    if buildObj then
      buildObj:SetVar("hidden", 1)
    end
  end
  
  DelRndUnits("LanZealotOfficers1", 2)
  DelRndUnits("LanZealotOfficers2", 2)
  
  local b1Dead = true
  local b2Dead = true
  
  while true do
    if not actors.Actor.IsValid(LanZealot) then return "SUCCESS" end
    local bSomeoneDied = false
    local bSomeoneAlive = false
    if actors.Actor.IsValid(GetCommander(1)) then
      b1Dead = false
      bSomeoneAlive = true
    elseif not b1Dead then
      bSomeoneDied = true
      b1Dead = true
    end  
    if actors.Actor.IsValid(GetCommander(2)) then
      b2Dead = false
      bSomeoneAlive = true
    elseif not b2Dead then
      bSomeoneDied = true
      b2Dead = true
    end 
    if bSomeoneDied and bSomeoneAlive then
      LanZealot:Say("bites the dust")
    end
    sleep(1)
  end
  
  return "SUCCESS"
end

function onDefeat(faction)
  if not actors.Actor.IsValid(LanZealot) then return end
  
  if (not actors.Actor.IsValid(GetCommander(1))) and (not actors.Actor.IsValid(GetCommander(2))) then
    if LanZealotReached then
      LanZealot:Say("victory again")
    else
      LanZealot:Say("disappointed")
    end
    sleep(5)
  end
end

function onRedShieldUse(switch, user)
  SetLZShield(user, "lzshield_red")
  SetLZWeapon(user, nil)
end

function onBlueShieldUse(switch, user)
  SetLZShield(user, "lzshield_blue")
  SetLZWeapon(user, nil)
end

function onYellowShieldUse(switch, user)
  SetLZShield(user, "lzshield_yellow")
  SetLZWeapon(user, nil)
end

function onRedWeaponUse(switch, user)
  SetLZWeapon(user, "red")
  SetLZShield(user, nil)
end

function onBlueWeaponUse(switch, user)
  SetLZWeapon(user, "blue")
  SetLZShield(user, nil)
end

function onYellowWeaponUse(switch, user)
  SetLZWeapon(user, "yellow")
  SetLZShield(user, nil)
end

function onLZSwitchUse(switch, user)
  if LZSwitchUsed < 9 then
    LZSwitchUsed = LZSwitchUsed + 1
    if actors.Actor.IsValid(LanZealot) then
      LanZealot:ActivateController("P1DamageBuff", 1)
    end  
  else
    SetCondition("LZPhase1", false)
    if actors.Actor.IsValid(LanZealot) then
      LanZealot:ActivateController("P1DamageBuff", 0)
    end  
    SetLZWeapon(LanZealot, "green")
    SetLZShield(LanZealot, nil)
    local c1 = GetCommander(1)
    SetLZWeapon(c1, "green")
    SetLZShield(c1, nil)
    local c2 = GetCommander(2)
    SetLZWeapon(c2, "green")
    SetLZShield(c2, nil)
    return;
  end  

  local rnd

  rnd = SIRND(1,3)
  if rnd == 1 then SetLZShield(user, "lzshield_red");
  elseif rnd == 2 then SetLZShield(user, "lzshield_blue");
  else SetLZShield(user, "lzshield_yellow");
  end
  
  rnd = SIRND(1,3)
  if rnd == 1 then SetLZWeapon(user, "red")
  elseif rnd == 2 then SetLZWeapon(user, "blue")
  else SetLZWeapon(user, "yellow")
  end
end

function BTAirStrikeThread()
  local faction = 4
  --print(faction)
  return function ()
    local tick = 7
    local min_per_tick = 1
    local max_per_tick = 2
    while YellowFFLeft > 0 do
      local xSleep = tick; --SRND(tick / 2,tick)
      local spawns = SIRND(min_per_tick, max_per_tick)
      local dir = SIRND(-1, 1)
      local prevdir
      for cnt2 = 1, spawns do
        local ptStart, ptBomb, hBomb, ptEnd = GetBomberPoints(faction, dir)
        local n
        if prevdir then
          n = -(prevdir + dir)
        else  
          n = dir + SIRND(0, 1) * 2 - 1
          if n < -1 then n = 1 elseif n > 1 then n = -1 end
        end
        prevdir = dir
        dir = n  
        if not ptStart then break end
        local Bomber = SpawnObject("Bomber", ptStart, faction)
        if not Bomber then break end
        local prm = {}
        prm.h = hBomb;
        prm.pt = ptBomb;
        prm.ptEnd = ptEnd
        Bomber:Execute("PrgAirAssault", prm)
        local slp = SRND(1,2)
        xSleep = xSleep - slp;
        sleep(slp)
      end  
      if xSleep < 0.5 then xSleep = 0.5 end
      sleep(xSleep)
    end
    return "SUCCESS"
  end
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if "LanZealotInCombat" == name and not value then
    LZSwitchUsed = 0
    SetCondition("LZPhase1", true)
    if actors.Actor.IsValid(LanZealot) then
      LanZealot:ActivateController("P1DamageBuff", 0)
    end  
    SetLZWeapon(LanZealot, nil)
    SetLZShield(LanZealot, nil)
    local c1 = GetCommander(1)
    SetLZWeapon(c1, nil)
    SetLZShield(c1, nil)
    local c2 = GetCommander(2)
    SetLZWeapon(c2, nil)
    SetLZShield(c2, nil)
  end

  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "PlayerAtDroidsFightArea" == name then
    SetGroupVar("FFB2", "hidden", 0)
    SetGroupVar("FFB2", "passable", 0)
    if actors.Actor.IsValid(LanZealot) then
      LanZealot:Say("challenge")
    end  
    CreateThread(DroidsBattle)
  elseif "FFY1SwitchUsed" == name then 
    SetGroupVar("FFY1", "hidden", 1)
    SetGroupVar("FFY1", "passable", 1)
    YellowFFLeft = YellowFFLeft - 1
    if YellowFFLeft <= 0 then
      SetCondition("YellowFFDone", true)
    end
  elseif "FFY2SwitchUsed" == name then 
    SetGroupVar("FFY2", "hidden", 1)
    SetGroupVar("FFY2", "passable", 1)
    YellowFFLeft = YellowFFLeft - 1
    if YellowFFLeft <= 0 then
      SetCondition("YellowFFDone", true)
    end
  elseif "FFY3SwitchUsed" == name then 
    SetGroupVar("FFY3", "hidden", 1)
    SetGroupVar("FFY3", "passable", 1)
    YellowFFLeft = YellowFFLeft - 1
    if YellowFFLeft <= 0 then
      SetCondition("YellowFFDone", true)
    end
  elseif "FFBSwitchUsed" == name then 
    SetGroupVar("FFB", "hidden", 1)
    SetGroupVar("FFB", "passable", 1)
    SetGroupVar("FFB2", "hidden", 1)
    SetGroupVar("FFB2", "passable", 1)
    if YellowFFLeft > 0 then
      CreateThread(BTAirStrikeThread())
    end  
  elseif "PlayerAtKroggol" == name then
    if actors.Actor.IsValid(LanZealot) then
      LanZealot:Say("dont disappoint")
    end  
  --elseif "KroggolInCombat" == name then 
  --  SetGroupVar("FFY1", "hidden", 0)
  --  SetGroupVar("FFY1", "passable", 0)
  elseif "KroggolDead" == name then 
  --  SetGroupVar("FFY1", "hidden", 1)
  --  SetGroupVar("FFY1", "passable", 1)
    if actors.Actor.IsValid(KroggolReward) then
      KroggolReward:SetVar("hidden", 0)
    end
  elseif "LanZealotDead" == name then 
    if actors.Actor.IsValid(LanZealotReward) then
      LanZealotReward:SetVar("hidden", 0)
    end
  end
end

RunAfter(1, InitMap)
