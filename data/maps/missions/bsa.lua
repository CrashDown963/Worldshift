local PlayerFactions = GetActiveFactions()
local NumPlayerFactions = table.getn(PlayerFactions)
local BeamsActive = false
local Announcer = GetNamedObject("Announcer")
local Reward = GetNamedObject("Reward")
local CurrentObjective = nil
local CurrentPhase = 1

function OperateBeam(beamPosName, beamAreaName, interval, beamPos)
  return function()
    while BeamsActive do
      sleep(interval)
      local beams = {}
      table.insert(beams, CreateP2PBeam("BSABeam", beamPos, beamPos, "pt_ray01", "pt_ray02"))
      table.insert(beams, CreateP2PBeam("BSABeam", beamPos, beamPos, "pt_ray02", "pt_ray03"))
      table.insert(beams, CreateP2PBeam("BSABeam", beamPos, beamPos, "pt_ray03", "pt_ray04"))
      table.insert(beams, CreateP2PBeam("BSABeam", beamPos, beamPos, "pt_ray04", "pt_ray01"))
      table.insert(beams, CreateP2PBeam("BSABeam", beamPos, beamPos, "pt_ray02", "pt_ray04"))
      table.insert(beams, CreateP2PBeam("BSABeam", beamPos, beamPos, "pt_ray01", "pt_ray03"))
      sleep(5)
      for _, beam in ipairs(beams) do RemoveP2PBeam(beam) end
      local beamPos = GetNamedObjectPos(beamPosName)
      SpawnObject("ExplosionHuge_02_NoTrails", beamPos)
      ShakeCamera(beamPos)
      DamageUnitsInArea(beamAreaName, 7000, 0, "fire", 100)
    end
    return "SUCCESS"
  end
end

function SpawnBattleYamu()
  Announcer:Say("yamu coming")
  if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
  CurrentObjective = ui.Objectives:Add("Defeat the Battle Yamu", 1, " ", " ")
  SetCondition("SpawnYamu", true)
  RunAfter(25, SpawnKaiRiders("Yamu"))
  RunAfter(2, MonitorMonster("Yamu"))
end

function SpawnHowlingHorror()
  Announcer:Say("horror coming")
  if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
  CurrentObjective = ui.Objectives:Add("Defeat the Reptile", 1, " ", " ")
  SetCondition("SpawnHorror", true)
  BeamsActive = true
  PhaseOneBoss = "Horror"
  for areaNo = 1, 6 do
    local interval = SIRND(3, 10)
    CreateThread(OperateBeam(
                  "Beam" .. areaNo, 
                  "BeamArea" .. areaNo, 
                  interval, 
                  "BeamPos" .. areaNo
                )
              )
  end
  RunAfter(25, SpawnKaiRiders("Horror"))
  RunAfter(2, MonitorMonster("Horror"))
end

function SpawnKaiRiders(monsterName)
  return function()
    if IsGroupOfMobsDead(monsterName) then return end
    for i = 1, NumPlayerFactions do
      SetCondition("SpawnKaiRiders" .. tostring(i), true)
    end
  end
end

function MonitorArmies(armyName, switchPhase)
  return function()
    while true do
      if IsGroupOfMobsDead(armyName , false) then
        if switchPhase then
          SwitchPhase()
        else
          Announcer:Say("final battle-bsa")
          SetCondition("ShowPhaseSwitches", true)
          SetCondition("HidePhaseSwitches", false)
        end
        if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
        return "SUCCESS"
      end
      sleep(1)
    end
  end
end

function MonitorMonster(name)
  return function()
    while true do
      if IsGroupOfMobsDead(name) then
        BeamsActive = false
        for i = 1, NumPlayerFactions do
          SetCondition("SpawnKaiRiders" .. tostring(i), false)
        end
        if "Yamu" == name then
          Announcer:Say("yamu dead")
        else
          Announcer:Say("reptile dead")
        end
        Announcer:Say("monster killed")
        SetCondition("ShowPhaseSwitches", true)
        SetCondition("HidePhaseSwitches", false)
        if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
        return "SUCCESS"
      end
      sleep(1)
    end
  end
end

function SwitchPhase()
  if CurrentPhase == 1 then
    if SIRND(1, 2) == 2 then
      SpawnHowlingHorror()
    else
      SpawnBattleYamu()
    end
  elseif CurrentPhase == 2 then
    Announcer:Say("wave1")
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat all enemies", 1, " ", " ")
    SetCondition("SpawnTroopers", true)
    RunAfter(2, function()
      SetCondition("SpawnTroopers", false)
      CreateThread(MonitorArmies("Army", true))
    end)
  elseif CurrentPhase == 3 then
    Announcer:Say("wave2")
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat the machines", 1, " ", " ")
    SetCondition("SpawnTroopers", true)
    SetCondition("SpawnRippers", true)
    SetCondition("SpawnAssaultBots", true)
    RunAfter(2, function()
      SetCondition("SpawnTroopers", false)
      SetCondition("SpawnRippers", false)
      SetCondition("SpawnAssaultBots", false)
      CreateThread(MonitorArmies("Army", true))
    end)
  elseif CurrentPhase == 4 then
    Announcer:Say("wave3")
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat the third wave", 1, " ", " ")
    SetCondition("SpawnTroopers", true)
    SetCondition("SpawnRippers", true)
    SetCondition("SpawnAssaultBots", true)
    SetCondition("SpawnJudges", true)
    SetCondition("SpawnSurgeons", true)
    SetCondition("SpawnAssassins", true)
    SetCondition("SpawnConstructors", true)
    RunAfter(2, function()
      SetCondition("SpawnTroopers", false)
      SetCondition("SpawnRippers", false)
      SetCondition("SpawnAssaultBots", false)
      SetCondition("SpawnJudges", false)
      SetCondition("SpawnSurgeons", false)
      SetCondition("SpawnAssassins", false)
      SetCondition("SpawnConstructors", false)
      CreateThread(MonitorArmies("Army", false))
    end)
  elseif CurrentPhase == 5 then
    Announcer:Say("wave4")
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat the Hellfires", 1, " ", " ")
    SetCondition("SpawnFinalBosses", true)
    RunAfter(2, function()
      CreateThread(MonitorArmies("FinalBosses", true))
    end)
  else
    if actors.Actor.IsValid(Reward) then
      Reward:SetVar("hidden", 0)
      Announcer:Say("claim prize")
    else
      SetCondition("Victory", true)
    end
  end
  CurrentPhase = CurrentPhase + 1
  return "SUCCESS"
end

function NextPhase()
  if CheckCondition("HidePhaseSwitches") then return end
  SetCondition("ShowPhaseSwitches", false)
  SetCondition("HidePhaseSwitches", true)
  SwitchPhase()
end

function YamuHit()
  if SIRND(1, 4) == 1 then
    Announcer:Say("yamu hit")
  end
end

function onDefeat(faction)
  if faction == GetPlayerFaction() and CurrentPhase == 2 and CheckCondition("SpawnHorror") then
    ui.LeaderDead.visible = false
    ui.LeaderDead:Hide()
    Announcer:Say("reptile wins")
    sleep(3)
  end
end

RunAfter(1, function()
  SetGroupVar("Spectators", "sight", 0)
  SetGroupVar("Spectators", "attackable", 0)
  SetGroupVar("Spectators", "reset_prg", 0)
  
  SetGroupVar("Assassins", "sight", 0)
  SetGroupVar("Assassins", "attackable", 0)
  SetGroupVar("Assassins", "reset_prg", 0)

  Announcer:SetVar("conv_icon_row", 3)
  Announcer:SetVar("conv_icon_col", 5)
  
  Announcer:Say("greetings")
  Announcer:Say("give sign")
  SetCondition("ShowPhaseSwitches", true)
  SetCondition("HidePhaseSwitches", false)
end)
