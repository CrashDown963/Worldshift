local CommandersPossessed = false
local OneShotConditions = {}
local FactionCommanders = {}
local CommanderVars = {}
local OldGetCommander = GetCommander
local EvilPriestSecondAppearance = GetNamedObject("EvilPriestSecondAppearance")
local CorruptedHighPriestThirdAppearance = GetNamedObject("CorruptedHighPriestThirdAppearance")
local FirstHighPriestPos = GetNamedObjectPos("FirstHighPriestPos")
local PlayerFactions = GetActiveFactions()

local StartupObjective = nil
local SaveCommandersObjective = nil
local BattleCommandersObjective = nil
local SaveCommandersStartTime = nil
local SaveCommandersTime = 420
local DefeatTheEvilPriestObjective = nil

local FirstEncounterArtifact = GetNamedObject("FirstEncounterArtifact")
local VillageArtifact1 = GetNamedObject("VillageArtifact1")
local VillageArtifact2 = GetNamedObject("VillageArtifact2")
local BossArtifact = GetNamedObject("BossArtifact")
local BossExtraArtifact1 = GetNamedObject("BossExtraArtifact1")
local BossExtraArtifact2 = GetNamedObject("BossExtraArtifact2")

function AtLeastOneOfficerLeft()
  local PlayerUnits = GetNamedGroup("PlayerUnits")
  for _, unit in ipairs(PlayerUnits) do    
    if actors.Actor.IsValid(unit) and unit:GetVar("officer") == 1 then 
      return true 
    end
  end
  return false
end

function CustomGetCommander(faction)
  if AtLeastOneOfficerLeft() then
    for i, f in ipairs(PlayerFactions) do
      if f == faction then 
        local commander = FactionCommanders[i]
        if actors.Actor.IsValid(commander) then return commander end
        commander = OldGetCommander(faction)
        if actors.Actor.IsValid(commander) then
          FactionCommanders[i] = commander
          return commander
        end
        FactionCommanders[i] = nil
      end
    end
  else
    return OldGetCommander(faction)
  end
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  onOneShotCondition(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
end

function onOneShotCondition(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if OneShotConditions[name] then return end
  OneShotConditions[name] = true
  
  if "OnlyOneFromFirstEncounterAlive" == name then
    ObductCommanders()
  elseif "StartCommandersBattle" == name then
    StartCommandersBattle()
  elseif "PlayerAtEvilPriestSecondEncounterArea" == name then
    EvilPriestSecondAppearance:Say("open cages")
  elseif "FirstEncounterDead" == name then
    print("Showing FirstEncounterArtifact")
    FirstEncounterArtifact:SetVar("hidden", 0)
  elseif "Village1Cleared" == name then
    VillageArtifact1:SetVar("hidden", 0)
  elseif "Village2Cleared" == name then    
    VillageArtifact2:SetVar("hidden", 0)
  elseif "FinalBossDefeated" == name then
    BossArtifact:SetVar("hidden", 0)
    local Village1Cleared = CheckCondition("Village1Cleared")
    local Village2Cleared = CheckCondition("Village2Cleared")
    if not Village1Cleared and not Village2Cleared then
      BossExtraArtifact2:SetVar("hidden", 0)
    elseif (Village1Cleared and not Village2Cleared) or (Village2Cleared and not Village1Cleared) then
      BossExtraArtifact1:SetVar("hidden", 0)
    end
  elseif "FinalBossInCombat" == name then
    CorruptedHighPriestThirdAppearance:Say("final battle-cf")
    CloseGate("NorthGate")
  end
end

local function OpenGate(gate, offset, time)
  ZOffsetNamedGroup(gate, offset or -600, time or 4.5, "DustAndDebris", "data/sounds/effects/common/rumble.wav")
  RunAfter(time or 4.5, function()
    SetGroupVar(gate, "passable", 1)
  end)
end

local function OpenCage(gate, offset, time)
  ZOffsetNamedGroup(gate, offset or -600, time or 4.5, "DustAndDebrisSmall", "data/sounds/effects/common/rumble.wav")
  RunAfter(time or 4.5, function()
    SetGroupVar(gate, "passable", 1)
  end)
end

function CloseGate(gate)
  ZOffsetNamedGroup(gate, 0, 4.5, "DustAndDebris", "data/sounds/effects/common/rumble.wav")
  RunAfter(time or 4.5, function()
    SetGroupVar(gate, "passable", 0)
  end)
end

local function StoreCommandersVars()
  for i, factionNo in ipairs(PlayerFactions) do
    local commander = GetCommander(factionNo)
    if actors.Actor.IsValid(commander) then
      local vars = {
        aggro_range = commander:GetVar("aggro_range"),
        sight = commander:GetVar("sight")
      }
      table.insert(CommanderVars, vars)
    else
      table.insert(CommanderVars, {})
    end
  end
end

local function RestoreCommanderVars(factionNo)
  for i, iFactionNo in ipairs(PlayerFactions) do
    if iFactionNo == factionNo then
      local commander = GetCommander(factionNo)
      local vars = CommanderVars[i]
      if actors.Actor.IsValid(commander) then
        commander:SetVar("aggro_range", vars.aggro_range or 500)
        commander:SetVar("sight", vars.sight or 1600)      
      end
      break
    end
  end
end

local function RestoreCommander(factionNo, commander)
  commander:RemoveEffect("all")
  commander:SetVar("indestructible", 0)
  commander:SetVar("reset_prg", 1)
  RestoreCommanderVars(factionNo)
  commander:Heal(commander:GetMaxHP() * 0.5)
  commander:Say("where am i")
end

function ObductCommanders()
  CreateThread(function()
    local EvilPriest = 
      SpawnObject("CorruptedHighPriestImage", FirstHighPriestPos, 12)
    EvilPriest:SetVar("boss", 0)
    EvilPriest:SetVar("hold_fire", 1)
    EvilPriest:SetVar("attackable", 0)
    EvilPriest:Say("your minds")
    SpawnObject("PurpleEnergyBurst_Inverse", FirstHighPriestPos, 12)
    sleep(3)
    StoreCommandersVars()
    for i, factionNo in ipairs(PlayerFactions) do
      local RezSwitch = GetFirstObject(factionNo, "ResurrectLeader")
      if RezSwitch then
        onRessurectSwitchUse(RezSwitch, nil)
        RezSwitch:Destroy()
      end
      local commander = GetCommander(factionNo)
      if actors.Actor.IsValid(commander) then
        --commander:RemoveEffect("CorruptedMind")
        commander:RemoveEffect("all")
        commander:Heal(1000000)
        commander:IncreasePower(1000000)
        EvilPriestSecondAppearance:SpawnEffect("CPCorruptedMind", commander)
        EvilPriestSecondAppearance:SpawnEffect("CPCorruptedBody", commander)
        SpawnObject("PurpleEnergyBurst", commander:GetPos(), factionNo)
        commander:SetPos(GetNamedObjectPos("Cage" .. i .. "Pos"))
        commander:StopMoving()
        commander:SelectMe(false, false)
        commander:SetVar("aggro_range", 4500)
        commander:SetVar("sight", 4500)
        commander:SetVar("indestructible", 1)
        commander:SetVar("attackable", 0)
        commander:SetVar("hold_fire", 1)
        commander:SetVar("reset_prg", 1)
      end
    end
    sleep(1)
    SpawnObject("PurpleEnergyBurst", FirstHighPriestPos, 12)
    print("Despawning EvilPriest")
    EvilPriest:Execute("PrgDespawn")
    CommandersPossessed = true
    OpenGate("EastGate1")
    OpenGate("EastGate2")
    OpenGate("WestGate1")
    OpenGate("WestGate2")
    if StartupObjective then ui.Objectives:Del(StartupObjective) end
    SaveCommandersObjective = ui.Objectives:Add("Save your leaders", 1, " ", "5:00")
    SaveCommandersStartTime = GetTime()
    CreateThread(UpdateTimer)
    return "SUCCESS"
  end)
end

function UpdateTimer()
  while SaveCommandersObjective ~= nil do
    local passed = GetTime() - SaveCommandersStartTime
    local left = SaveCommandersTime - passed
    if left < 0 then left = 0 end
    SaveCommandersObjective.Row12:Set(SecondsToStr(left))
    if left > 61 then
      SaveCommandersObjective.Row12:SetColor(ui.colors.white)
    elseif left > 31 then
      SaveCommandersObjective.Row12:SetColor(ui.colors.yellow)
    else  
      SaveCommandersObjective.Row12:SetColor(ui.colors.red)
      ui.FlashWND(SaveCommandersObjective.Row12, 0.1)
    end
    if left == 0 then break end
    sleep(0.5)
  end
  
  if SaveCommandersObjective then
    for _, commander in ipairs(FactionCommanders) do
      commander:SetVar("indestructible", 0)
      commander:SetVar("attackable", 1)
      DamageUnit(commander, 15000, "lightning")
      GetCommander = OldGetCommander
    end
  end
  
  return "SUCCESS"
end

function StartCommandersBattle()
  if SaveCommandersObjective then ui.Objectives:Del(SaveCommandersObjective) end
  SaveCommandersObjective = nil
  
  if BattleCommandersObjective then ui.Objectives:Del(BattleCommandersObjective) end
  BattleCommandersObjective = ui.Objectives:Add("Defeat your leaders", 1, " ", " ")

  OpenCage("Cage1", -350, 5)
  OpenCage("Cage2", -350, 5)
  OpenCage("Cage3", -350, 5)
  CloseGate("WestGate1")
  CloseGate("WestGate2")
  RunAfter(6, function()
    for i, factionNo in ipairs(PlayerFactions) do
      local commander = GetCommander(factionNo)
      if actors.Actor.IsValid(commander) then
        commander:SetVar("attackable", 1)
        commander:SetVar("hold_fire", 0)
      end
    end
    return "SUCCESS"
  end)
  
  CreateThread(function()
    while true do
      local allCommandersRestored = true
      for i, factionNo in ipairs(PlayerFactions) do
        local commander = GetCommander(factionNo)
        if actors.Actor.IsValid(commander) and commander:GetVar("faction") == 12 then
          allCommandersRestored = false
          if commander:GetHP() == 0 then
            RestoreCommander(factionNo, commander)
          end
        end
      end
      if allCommandersRestored then break end
      sleep(0.5)
    end
    EvilPriestSecondAppearance:Say("you strong")
    sleep(3)
    SpawnObject("PurpleEnergyBurst", EvilPriestSecondAppearance:GetPos(), 12)
    EvilPriestSecondAppearance:Execute("PrgDespawn")
    OpenGate("WestGate3")
    OpenGate("WestGate4")
    OpenGate("NorthGate")
    if BattleCommandersObjective then ui.Objectives:Del(BattleCommandersObjective) end
    DefeatTheEvilPriestObjective = ui.Objectives:Add("Defeat the evil priest", 1, " ", " ")
    return "SUCCESS"
  end) 
end

function SummonMinions(spell, src, tgt)
  local minions = {}
  local sapwnVars = " { CAutoDieController AutoDie { duration = 60; show_progress = 0; } }"
  if SIRND(0, 1) == 1 then
    SpawnObjects("CorruptedShade = 1" .. sapwnVars, src:GetPos(), src:GetFaction(), minions)
    SpawnObjects("CorruptedGhostMinion = 2" .. sapwnVars, src:GetPos(), src:GetFaction(), minions)
  else
    SpawnObjects("CorruptedGhost = 1" .. sapwnVars, src:GetPos(), src:GetFaction(), minions)
    SpawnObjects("CorruptedShadeMinion = 2" .. sapwnVars, src:GetPos(), src:GetFaction(), minions)
  end
  for _, spawn in ipairs(minions) do
    spawn:SetVar("hold_fire", 1)
    spawn:SetVar("z_offset", -600)
    ZOffsetActor(spawn, 0, 5, "DustAndDebris", "data/sounds/effects/common/rumble.wav")
    RunAfter(5, function()
      spawn:SetVar("hold_fire", 0)
    end)
  end
end

function ArtifactTaken(switch, user)
  local linkedObjName = switch:GetVar("attach_to", "str")
  local linkedObj = linkedObjName and GetNamedObject(linkedObjName) or nil
  if linkedObj then
    linkedObj:SetVar("hidden", 1)
    GiveItem(linkedObj:GetVar("drop_id"))
  end
end

RunAfter(2, function()
  if table.getn(PlayerFactions) == 2 then
    SetCondition("TwoPlayers", true)
  elseif table.getn(PlayerFactions) == 3 then
    SetCondition("ThreePlayers", true)
  end
  
  for _, factionNo in ipairs(PlayerFactions) do
    local commander = GetCommander(factionNo)
    table.insert(FactionCommanders, GetCommander(factionNo))
  end
  
  GetCommander = CustomGetCommander
  
  if StartupObjective then ui.Objectives:Del(StartupObjective) end
  StartupObjective = ui.Objectives:Add("Explore the Corrupted Fields", 1, " ", " ")
  
  FirstEncounterArtifact:SetVar("hidden", 1)
  VillageArtifact1:SetVar("hidden", 1)
  VillageArtifact2:SetVar("hidden", 1)
  BossArtifact:SetVar("hidden", 1)
  BossExtraArtifact1:SetVar("hidden", 1)
  BossExtraArtifact2:SetVar("hidden", 1)
end)
