local ZulTharkSpawner = nil
local FirstChallengeSpawner = nil
local EggsChallengeSpawner = nil

local ExploreObjective = nil
local KillZulTharkObjective = nil
local KillErkhArulObjective = nil

local ZulTharkInCombat = false
local ErkhArulInCombat = false

local Ships = {}

local FirstChallengeSpawnList = {
  { id = "RenegadeTrisat", count = 2, chance = 50 },
  { id = "RenegadeTritech", count = 1, chance = 40 },
  { id = "RenegadeShifter", count = 1, chance = 10 },  
}

local EggsChallengeSpawnList = {
  { id = "RenegadeTrisat", count = 5, chance = 30 },
  { id = "RenegadeTritech", count = 3, chance = 30 },
  { id = "RenegadeShifter", count = 2, chance = 20 },
  { id = "RenegadeHarvester", count = 1, chance = 5 },
  { id = "RenegadeArbiter", count = 1, chance = 5 }, 
  { id = "RenegadeManipulator", count = 1, chance = 5 }, 
  { id = "RenegadeDominator", count = 1, chance = 5 }, 
}

local ZulTharkSpawnList = {
  { id = "RenegadeTrisat", count = 2, chance = 30 },
  { id = "RenegadeTritech", count = 1, chance = 50 },
  { id = "RenegadeShifter", count = 1, chance = 12 },
  { id = "RenegadeHarvester", count = 1, chance = 2 },
  { id = "RenegadeArbiter", count = 1, chance = 2 }, 
  { id = "RenegadeManipulator", count = 1, chance = 2 }, 
  { id = "RenegadeDominator", count = 1, chance = 2 }, 
}

function TeleportTroops(switch, user)
  local switchName = switch:GetVar("obj_name", "str")
  if switchName == nil then return end
  local _, e = string.find(switchName, "TeleporterSwitch")
  if e == nil then return end
  local switchNumber = string.sub(switchName, e + 1)
  local srcArea = "TeleporterArea" .. switchNumber
  local ptDest = GetNamedObjectPos("TeleportPos" .. switchNumber)
  local userFaction = user:GetFaction()
  TeleportUnits(userFaction, ptDest, srcArea, "all", "BigLightningStrike02", "respawn_react")
  if userFaction == GetPlayerFaction() then
    RunAfter(1, function()
      game.SetCameraPos(ptDest)
      return "SUCCESS"
    end)
  end
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if "ZulTharkInCombat" == name then
    if not ZulTharkSpawner then
      ZulTharkSpawner = NewEggSpawner()
      ZulTharkSpawner.spawnList = ZulTharkSpawnList
      ZulTharkSpawner.sleepTimeLo = 2
      ZulTharkSpawner.sleepTimeHi = 8
      ZulTharkInCombat = value
    end
    if value then ZulTharkSpawner:Start() else ZulTharkSpawner:Stop() end
    if not KillZulTharkObjective then
      if ExploreObjective then ui.Objectives:Del(ExploreObjective) end
      KillZulTharkObjective = ui.Objectives:Add("Defeat Zul'Thark", 1, " ", " ")
    end
  elseif "ErkhArulInCombat" == name then
    ErkhArulInCombat = value
  elseif "FirstChallengeInCombat" == name then
    if not FirstChallengeSpawner then
      FirstChallengeSpawner = NewEggSpawner()
      FirstChallengeSpawner.spawnList = FirstChallengeSpawnList
      FirstChallengeSpawner.sleepTimeLo = 8
      FirstChallengeSpawner.sleepTimeHi = 12
    end
    if value then FirstChallengeSpawner:Start() else FirstChallengeSpawner:Stop() end
  end

  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "EnableTeleporter1" == name then
    SetNamedObjectVar("TeleporterBall11", "hidden", 0)
    SetNamedObjectVar("TeleporterBall12", "hidden", 0)
  elseif "EnableTeleporter2" == name then
    SetNamedObjectVar("TeleporterBall21", "hidden", 0)
    SetNamedObjectVar("TeleporterBall22", "hidden", 0)
  elseif "EnableTeleporter3" == name then
    SetNamedObjectVar("TeleporterBall31", "hidden", 0)
    SetNamedObjectVar("TeleporterBall32", "hidden", 0)
  elseif "ErkhArulDead" == name then
    SetNamedObjectVar("ErkhArulArtifact", "hidden", 0)
  elseif "ZulTharkDead" == name then
    if KillZulTharkObjective then ui.Objectives:Del(KillZulTharkObjective) end
    local commander = GetCommander(GetPlayerFaction())
    if actors.Actor.IsValid(commander) then
      commander:Say("it is dead")
    end
    SetNamedObjectVar("ZulTharkArtifact", "hidden", 0)
  elseif "BeatenHard" == name then
    actor:Say("i was wrong")
  elseif "ErkhArulInCombat" == name then
    GetNamedObject("ErkhArul"):Say("bow to me")
    if not KillErkhArulObjective then
      KillErkhArulObjective = ui.Objectives:Add("Defeat Erkh Arul", 1, " ", " ")
    end
  end
end

function NewEggSpawner()
  Spawner = {}
  Spawner.running = false
  Spawner.sleepTimeLo = 1
  Spawner.sleepTimeHi = 5
  Spawner.spawnRadius = 2500
  Spawner.spawnList = {}
  Spawner.spawned = {}
  Spawner.faction = 12
  
  function Spawner:Start()
    this.running = true
    CreateThread(function()
      if not this.spawnList then return end  
      while this.running do
        local playerFactions = GetActiveFactions()
        local aliveCommanders = {}
        for _, faction in ipairs(playerFactions) do
          local commander = GetCommander(faction)
          if actors.Actor.IsValid(commander) then
            table.insert(aliveCommanders, commander)
          end
        end
        local numCommanders = table.getn(aliveCommanders)
        if numCommanders > 0 then
          local f = SIRND(1, numCommanders)
          local commander = aliveCommanders[f]
          local pt = commander:GetRandomPointInRange(commander:GetPos(), this.spawnRadius)
          if pt then
            local egg = SpawnObject("RenegadeEgg", pt, this.faction)
            table.insert(this.spawned, egg)
            egg:SetVar("hold_fire", 1)
            egg:SetVar("z_offset", -300)
            egg.spawner = this
            ZOffsetActor(egg, 0, 3, "DustAndDebris", "data/sounds/effects/common/rumble.wav")
            RunAfter(3, function()
              egg:SetVar("hold_fire", 0)
            end)
          end
        end
        this:CleanSpawned()
        local sleepTime = SIRND(this.sleepTimeLo, this.sleepTimeHi)
        sleep(sleepTime)
      end
      return "SUCCESS"
    end)
  end
  
  function Spawner:CleanSpawned()
    local newSpawned = {}
    for _, spawn in ipairs(this.spawned) do
      if actors.Actor.IsValid(spawn) then
        table.insert(newSpawned, spawn)
      end
    end
    this.spawned = newSpawned
  end
  
  function Spawner:ProcessSpawnList(egg)
    local totalChance = 0
    
    for _, spawnInfo in ipairs(this.spawnList) do
        totalChance = totalChance + spawnInfo.chance
    end
    
    local rndChance = SIRND(0, totalChance)
    local currentChance = 0
    
    for _, spawnInfo in ipairs(this.spawnList) do
      currentChance = currentChance + spawnInfo.chance
      if currentChance >= rndChance then
        SpawnObjects(spawnInfo.id .. " = " .. spawnInfo.count, 
          egg:GetPos(), this.faction, this.spawned)
        break
      end
    end
  end
  
  function Spawner:Stop()
    this.running = false
  end
  
  function Spawner:SwitchSpawnsFaction(faction)
    for _, spawn in ipairs(this.spawned) do
      if actors.Actor.IsValid(spawn) then
        spawn:SetVar("faction", faction)
      end
    end
    
    this.faction = faction
  end
  
  return Spawner
end

function DeployBridge(switch, user)
  SetNamedObjectVar("Bridge", "hidden", 0)
  SetNamedObjectVar("Bridge", "passable", 1)
end

function ErkhArulBattle()
  local erkhArul = GetNamedObject("ErkhArul")
  
  while actors.Actor.IsValid(erkhArul) do
    while not ErkhArulInCombat do
      sleep(1)
    end
    local sleepTime = SIRND(40, 60)
    sleep(sleepTime)
    if not actors.Actor.IsValid(erkhArul) then
      break
    end
    local freeShipPositions = {}
    for i = 1, 6 do
      local ship = Ships[i]
      if ship == nil or not actors.Actor.IsValid(ship) then
        Ships[i] = nil
        table.insert(freeShipPositions, i)
      end
    end
    local freeShipPosCount = table.getn(freeShipPositions)
    if freeShipPosCount > 0 then
      local ind = SIRND(1, freeShipPosCount)
      SpawnErkhArulShip(freeShipPositions[ind])
    end
  end
  
  return "SUCCESS"
end

function SpawnErkhArulShip(number)
  print("Spawn ship: " .. tostring(number))
  local orientationObj = GetNamedObject("ErkhArulShip" .. tostring(number))
  local ship = SpawnObject("ErkhArulAlienShip", orientationObj:GetPos(), 12)
  ship:FaceAs(orientationObj)
  ship:Execute()
  local length, action = ship:GetAnimLength("spawn")
  if length then
    ship:SetAnim("spawn")
    if action then
      sleep(action)
    else
      sleep(length)
    end
    ship:SpawnEffect("ShipHitsGroundEffect", ship)
    ship:PlaySnd("Data/Sounds/Effects/ErkhArulShip/hit.wav")
    ShakeCamera(ship:GetPos())
    if action then
      sleep(length - action)
    end
  end
  ship:SetAnim("idle_1")
  SetCondition("ShipLanded" .. tostring(number), true)
  SetCondition("DespawnSwitch" .. tostring(number), false)
  SetCondition("SpawnSwitch" .. tostring(number), true)
  RunAfter(1, function()
    SetCondition("ShipLanded" .. tostring(number), false)
  end)
  Ships[number] = ship
end

function SwitchStarted(switch, user)
  if actors.Actor.IsValid(user) then
    switch:SetVar("user_target_priority", user:GetVar("target_priority"))
    user:SetVar("target_priority", 5000)
  end
end

function SwitchUsed(switch, user)
  local userTargetPriority = switch:GetVar("user_target_priority")
  switch:SetVar("user_target_priority", nil)
  
  if actors.Actor.IsValid(user) and userTargetPriority then  
    user:SetVar("target_priority", userTargetPriority)
  end
  
  local switchPrefix = "ShipSwitch"
  local switchName = switch:GetVar("obj_name", "str")
  local number = tonumber(string.sub(switchName, string.len(switchPrefix) + 1))
  local ship = Ships[number]
  
  if actors.Actor.IsValid(ship) then
    -- ship:ActivateController("AutoDie", 1)
    ship:ActivateController("PeriodicDamage", 0)
    ship:SetVar("hacked", 1)
  end
end

function SwitchCanceled(switch, user)
  local userTargetPriority = switch:GetVar("user_target_priority")
  switch:SetVar("user_target_priority", nil)
  
  if actors.Actor.IsValid(user) and userTargetPriority then  
    user:SetVar("target_priority", userTargetPriority)
  end
end

function ShipDestroyed(ship, params)
  for i, sh in pairs(Ships) do
    if sh == ship then
      local number = tostring(i)
      SetCondition("ShipLanded" .. number, false)
      SetCondition("DespawnSwitch" .. number, true)
      SetCondition("SpawnSwitch" .. number, false)
      ship:SpawnEffect("ShipDestroyedEffect", ship)
      return
    end
  end
end

function onDamageTaken(params)
  if params.actor and actors.Actor.IsValid(params.actor) then
    local erkhProgram = params.actor:GetActivePrg()
    if params.damage and "PrgErkhArulThunderStorm" == erkhProgram then
      params.actor:Heal(params.damage * 2)
    end
  end
end

function ZulTharkBattle()
  local fact = 2
  local illusions = {}
  local zulThark = GetNamedObject("ZulThark")
  
  while actors.Actor.IsValid(zulThark) do
    while not ZulTharkInCombat do
      sleep(1)
    end
    
    local sleepTime = GetTime() + 30
    while GetTime() < sleepTime do
      if table.getn(illusions) > 0 then
        local allDead = true
        for _, illusion in ipairs(illusions) do
          if actors.Actor.IsValid(illusion) then
            allDead = false
            break
          end
        end
        if allDead then break end
      end
      sleep(1)
    end
    
    if ZulTharkSpawner and ZulTharkSpawner.running then
      if table.getn(illusions) > 0 then
        if actors.Actor.IsValid(zulThark) then
          zulThark:Execute("PrgPlayAnim", { anim = "heal_finish" })
        end
        for _, illusion in ipairs(illusions) do
          if actors.Actor.IsValid(illusion) then 
            illusion:CreateReact("teleport_officer_aliens")
            illusion:Execute("PrgDespawn")
          end
        end
        illusions = {}
      else
        if actors.Actor.IsValid(zulThark) then
          zulThark:Execute("PrgZulTharkHeal")
          zulThark:CreateReact("teleport_officer_aliens")
          zulThark:SetPos(GetNamedObjectPos("ZulTharkPosition"))
          zulThark:FaceTo("reset")
          zulThark:FaceTo(GetNamedObjectPos("ZulTharkOrientation"))
          sleep(3)
          local spawnStr = "RenegadeDominator = 1 { sight = 6000; scale = 1.6; siege_projectile = SiegeProjectile2; }"
          local positions = { 1, 2, 3, 4 }
          for i = 1, 2 do
            local ind = SIRND(1, table.getn(positions))
            local pos = table.remove(positions, ind)
            SpawnObjects(spawnStr, GetNamedObjectPos("DominatorPos" .. pos), 12, illusions)
          end
          for _, illusion in ipairs(illusions) do 
            illusion:CreateReact("teleport_officer_aliens")
          end          
        end
      end
      -- ZulTharkSpawner:SwitchSpawnsFaction(fact)
      if fact == 12 then fact = 2 else fact = 12 end
    end
  end
  return "SUCCESS"
end

RunAfter(1, function()
  SetNamedObjectVar("TeleporterBall11", "hidden", 1)
  SetNamedObjectVar("TeleporterBall12", "hidden", 1)
  SetNamedObjectVar("TeleporterBall21", "hidden", 1)
  SetNamedObjectVar("TeleporterBall22", "hidden", 1)
  SetNamedObjectVar("TeleporterBall31", "hidden", 1)
  SetNamedObjectVar("TeleporterBall32", "hidden", 1)
  SetNamedObjectVar("Bridge", "hidden", 1)
  SetNamedObjectVar("Bridge", "passable", 0)
  
  SetNamedObjectVar("ZulTharkArtifact", "hidden", 1)
  SetNamedObjectVar("ErkhArulArtifact", "hidden", 1)  
  
  EggsChallengeSpawner = NewEggSpawner()
  EggsChallengeSpawner.spawnList = EggsChallengeSpawnList
  local eggs = GetNamedGroup("EggsChallengeEggs")
  for _, egg in ipairs(eggs) do egg.spawner = EggsChallengeSpawner end
    
  for i = 1,6 do
    SetNamedObjectVar("ErkhArulShip" .. tostring(i), "hidden", 1)
  end

  CreateThread(ZulTharkBattle)
  CreateThread(ErkhArulBattle)
  ExploreObjective = ui.Objectives:Add("Investigate the renegades hideout", 1, " ", " ")
  return "SUCCESS"
end)
