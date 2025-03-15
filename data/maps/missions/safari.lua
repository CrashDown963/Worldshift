local Queen = GetNamedObject("Queen")
local Mech0 = GetNamedObject("Mech0")
local Jack = GetNamedObject("Jack")
local Bill = GetNamedObject("Bill")
local BillHardItem = GetNamedObject("BillHardItem")
local ScorpionBoss = GetNamedObject("ScorpionBoss")

local ExploreObjective
local QueenObjective
local Mech0Objective
local JackObjective
local BillObjective

local EggSpawnTimeLo = 15
local EggSpawnTimeHi = 30
local ScorpionBattleEggsPlaces = GetNamedGroup("ScorpionBattleEggs")
local ScorpionBattleEggs = {}
local ScorpionBattleSpawns = {}
local ScorpionBossInCombat = false

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  local cname
  if actors.Actor.IsValid(actor) then
    local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
    cname = cactor .. ":" .. name
  else
	  cname = name;
  end	
  print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value))

  if "ScorpionBossInCombat" == name then
    ScorpionBossInCombat = value
    
    if not ScorpionBossInCombat and actors.Actor.IsValid(ScorpionBoss) then
      ResetScorpionBattle()
    end
  end

  if value and (xLastTrueTime < 0) then
    if (name == "QueenInCombat") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("kill queen")
      end
      QueenObjective = ui.Objectives:Add("Kill the Queen", 1, " ", " ")
    elseif (name == "QueenDead") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("killed queen")
      end
      if QueenObjective then
        ui.Objectives:Del(QueenObjective)
        QueenObjective = nil
      end  
    elseif (name == "Mech0InCombat") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("kill mech0")
      end
      Mech0Objective = ui.Objectives:Add("Kill Mech 0", 1, " ", " ")
    elseif (name == "Mech0Dead") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("killed mech0")
      end
      if Mech0Objective then
        ui.Objectives:Del(Mech0Objective)
        Mech0Objective = nil
      end  
    elseif (name == "JackInCombat") then
      if actors.Actor.IsValid(Jack) then
        Jack:Say("jack in combat")
      end
      JackObjective = ui.Objectives:Add("Kill Jack", 1, " ", " ")
    elseif (name == "JackDead") then
      if JackObjective then
        ui.Objectives:Del(JackObjective)
        JackObjective = nil
      end
      if ExploreObjective then
        ExploreObjective.Row11:Set("Find Bill")
      end
    elseif (name == "PlayerAtBill") then
      local Commander = GetCommander(GetPlayerFaction())
      Bill:PlaySnd(Bill:GetVar("jungle_snd", "str"))
      if actors.Actor.IsValid(Commander) then
        Commander:Say("at bill")
      end
      if ExploreObjective then
        ui.Objectives:Del(ExploreObjective)
      end
      BillObjective = ui.Objectives:Add("Kill Bill", 1, " ", " ")
    elseif (name == "BillInCombat") then
      Bill:Say("bill in combat")
    elseif (name == "BillDead") then
      if BillObjective then
        ui.Objectives:Del(BillObjective)
        BillObjective = nil
      end
    elseif (name == "SpawnBillHardItem") then
      if actors.Actor.IsValid(BillHardItem) then
        BillHardItem:SetVar("hidden", 0)
      end
    end
  end
end

function InitScorpionBattle()
  for i, eggPlace in ipairs(ScorpionBattleEggsPlaces) do
    eggPlace:SetVar("hidden", 1)
    if not actors.Actor.IsValid(ScorpionBattleEggs[i]) then
      local egg = SpawnObject("SafariEgg", eggPlace:GetPos(), 12, eggPlace)
      ScorpionBattleEggs[i] = egg
    end
  end
  CreateThread(ScorpionBattle)
  return "SUCCESS"
end

function ResetScorpionBattle()
  for _, spawn in ipairs(ScorpionBattleSpawns) do
    if actors.Actor.IsValid(spawn) then
      spawn:Execute("PrgDespawn")
    end
  end
  ScorpionBattleSpawns = {}
  for i, egg in ipairs(ScorpionBattleEggs) do
    if actors.Actor.IsValid(egg) then
      egg:Heal(egg:GetMaxHP())
    else
      eggPlace = ScorpionBattleEggsPlaces[i]
      local egg = SpawnObject("SafariEgg", eggPlace:GetPos(), 12, eggPlace)
      egg:Execute("PrgPlayAnim", { anim = "egg_build" })
      ScorpionBattleEggs[i] = egg
    end
  end
end

function ScorpionBattle()
  local secondsWithAllDead = 0
  local sleepTime = SIRND(EggSpawnTimeLo, EggSpawnTimeHi)
  local spawning = true
  
  while actors.Actor.IsValid(ScorpionBoss) do
    local destroyedEggs = {}
    local aliveEgg = false
    
    for i, egg in ipairs(ScorpionBattleEggs) do
      if not actors.Actor.IsValid(egg) then
        local eggInfo = {
          ind = i,
          eggPlace = ScorpionBattleEggsPlaces[i]
        }
        table.insert(destroyedEggs, eggInfo)
      else
        aliveEgg = true
      end
    end
    
    if not aliveEgg then
      spawning = true
    end
    
    if table.getn(destroyedEggs) == 0 then
      spawning = false
      secondsWithAllDead = 0
      sleepTime = SIRND(EggSpawnTimeLo, EggSpawnTimeHi)
    end
    
    if spawning then
      secondsWithAllDead = secondsWithAllDead + 1
      if secondsWithAllDead > sleepTime and table.getn(destroyedEggs) > 0 then
        local spawnInfo = destroyedEggs[SIRND(1, table.getn(destroyedEggs))]
        local eggPlace = spawnInfo.eggPlace
        local egg = SpawnObject("SafariEgg", eggPlace:GetPos(), 12, eggPlace)
        egg:Execute("PrgPlayAnim", { anim = "egg_build" })
        ScorpionBattleEggs[spawnInfo.ind] = egg
        secondsWithAllDead = 0
        sleepTime = SIRND(EggSpawnTimeLo, EggSpawnTimeHi)
      end
    end

--    print("aliveEgg = " .. tostring(aliveEgg) .. " spawning = " .. tostring(spawning) .. " secondsWithAllDead = " .. tostring(secondsWithAllDead))
    sleep(1)
  end
  
  return "SUCCESS"
end

function onEggSpawn(spawn)
  table.insert(ScorpionBattleSpawns, spawn)
end

function UpdateObjectives()
  sleep(0.5)
  
  local Commander = GetCommander(GetPlayerFaction())
  if actors.Actor.IsValid(Commander) then
    Commander:Say("explore")
  end
  ExploreObjective = ui.Objectives:Add("Explore the area", 1, " ", " ")
  
  while true do
    sleep(1)
  end
end

function PingBosses()
  while true do
    if actors.Actor.IsValid(Queen) then
      CreateMapPing(Queen:GetPos(), "boss")
      Queen:PlaySnd("data/sounds/bosses/queenidle/")
    end
    
    if actors.Actor.IsValid(Mech0) then
      CreateMapPing(Mech0:GetPos(), "boss")
    end
    
    if actors.Actor.IsValid(Jack) then
      CreateMapPing(Jack:GetPos(), "boss")
    end
    
    if actors.Actor.IsValid(Bill) then
      CreateMapPing(Bill:GetPos(), "boss")
    end
    
    if actors.Actor.IsValid(ScorpionBoss) then
      CreateMapPing(ScorpionBoss:GetPos(), "boss")
    end
    
    sleep(25)
  end
end

CreateThread(UpdateObjectives)
RunAfter(10, PingBosses)
RunAfter(1, InitScorpionBattle)

