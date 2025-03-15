g_init.Eji = function() return GetNamedObject("Eji") end
g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Master = function() return GetNamedObject("Master") end
g_init.Arna = function() return GetNamedObject("Arna") end
g_init.Kuna = function() return GetNamedObject("Kuna") end

local EjiPos = GetNamedObjectPos("EjiPos")

g.MasterDamage = 0
g.EjiDamage = 0

g_Objectives.EngageObjective = {
  Create = function() return ui.Objectives:Add("Find suitable spot for Eji", 1, " ", " ") end
}
g_Objectives.KickMasterObjective = {
  Create = function() return ui.Objectives:Add("Attack the enemy psychic", 1, " ", " ") end
}
g_Objectives.ProtectEjiObjective = {
  Create = function() return ui.Objectives:Add("Protect Eji", 1, " ", " ") end
}

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "PlayerAtEjiArea" == name then
    SetCondition("SpawnMobs", true)
  elseif "EjiAtEjiArea" == name then
    g.Eji:Say("found spot")
    g.Denkar:Say("get him")
    g.Eji:Say("concentration")
    g.Arna:Say("guard eji")
    g.Kuna:Say("attack alien")
    HideObjective("EngageObjective")
    ShowObjective("KickMasterObjective")
    ShowObjective("ProtectEjiObjective")
    CreateThread(PsychicBattle)
  end
end

function PsychicBattle()
  local session = CheckpointData.session
  RevealArea("MasterArea", true)
  ExploreArea("MasterArea", GetPlayerFaction())

  g.Eji:SetVar("absorb_damage", 1)
  g.Eji:SetVar("target_priority", 2000)
  g.Eji:SetVar("reset_prg", 1)
  g.Eji:Execute("PrgMove", { pt = EjiPos } )
  g.Eji:SetInteractive(false)
  g.Eji:ActivateController("psychic_shield", 1)
  g.Eji:ActivateController("damage_monitor", 1)
  g.Eji:EnableAbilities(false)
  
  SetCondition("SpawnMobs", true)

  ui.MindDuel:Start(g.Eji.h, g.Master.h)

  for i = 1,8 do
    sleep(0.5)
    if session ~= CheckpointData.session then
      g.Eji:SetVar("absorb_damage", 0)
      g.Eji:SetVar("target_priority", 1)
      g.Eji:SetInteractive(true)
      g.Eji:ActivateController("psychic_shield", 0)
      g.Eji:ActivateController("damage_monitor", 0)
      g.Eji:EnableAbilities(true)
      ui.MindDuel:Stop()
      return "SUCCESS"
    end
  end  

  local maxPower = 5000
  local ejiVelocity = 50
  local masterVelocity = 50
  local ejiPower = 0
  local masterPower = 1500
  local ejiWins = false
  g.EjiDamage = 0
  g.MasterDamage = 0
  
  while true do
    if g.MasterDamage > 0 then
      masterPower = masterPower - g.MasterDamage
      if masterPower < 0 then masterPower = 0 end
      g.MasterDamage = 0
      if masterPower == 0 and ejiPower >= maxPower then
        ejiWins = true
        break
      end
    else
      masterPower = masterPower + masterVelocity
    end
    
    if g.EjiDamage > 0 then
      ejiPower = ejiPower - g.EjiDamage
      if ejiPower < 0 then ejiPower = 0 end
      g.EjiDamage = 0
      if ejiPower == 0 and masterPower >= maxPower then
        -- Master wins
        break
      end
    else
      ejiPower = ejiPower + ejiVelocity
    end
    
    if ejiPower + masterPower > maxPower then
      local delta = ejiPower + masterPower - maxPower
      if ejiVelocity > masterVelocity then 
        masterPower = masterPower - delta 
      elseif ejiVelocity < masterVelocity then
        ejiPower = ejiPower - delta
      else
        ejiPower = ejiPower - delta / 2
        masterPower = masterPower - delta / 2
      end
      if masterPower < 0 then masterPower = 0 end
      if ejiPower < 0 then ejiPower = 0 end
      if masterPower == 0 and ejiPower >= maxPower then
        ejiWins = true
        break
      elseif ejiPower == 0 and masterPower >= maxPower then
        -- Master wins
        break
      end
    end
    
    ejiVelocity = (1.0 - (ejiPower / maxPower)) * 30 + 10
    masterVelocity = (1.0 - (masterPower / maxPower)) * 30 + 10
    
    -- print("Eji V: " .. tostring(ejiVelocity) .. " Master V: " .. tostring(masterVelocity))
    ui.MindDuel:Update(ejiPower, masterPower, maxPower)
    -- UpdatePowerDisplay(ejiPower, masterPower, maxPower)
    sleep(0.2)
    if session ~= CheckpointData.session then
      g.Eji:SetVar("absorb_damage", 0)
      g.Eji:SetVar("target_priority", 1)
      g.Eji:SetInteractive(true)
      g.Eji:ActivateController("psychic_shield", 0)
      g.Eji:ActivateController("damage_monitor", 0)
      g.Eji:EnableAbilities(true)
      ui.MindDuel:Stop()
      return "SUCCESS"
    end
  end
  
  -- ui.MindDuel:Stop()
  SetCondition("SpawnMobs", false)
  HideObjective("KickMasterObjective")
  HideObjective("ProtectEjiObjective")
    
  if ejiWins then
    g.Master:Die()
    g.Eji:Say("it is done")
    g.Arna:Say("shard changing")
    RunAfter(4, function()
      ui.MindDuel:Stop()
      WinMission()
    end)  
  else
    g.Eji:Say("too strong")
    g.Denkar:Say("eji no")
    RunAfter(4, function()
      g.Eji:Die()
    end)  
  end
  
  return "SUCCESS"
end

function onDamageDone(params)
end

function onDamageTaken(params)
  if params.damage and params.actor and params.actor.h == g.Eji.h then
    g.EjiDamage = g.EjiDamage + params.damage
  end
  
  if params.damage and params.actor and params.actor.h == g.Master.h then
    g.MasterDamage = g.MasterDamage + params.damage
  end
end

function InitObjectives()
  g.Master:ActivateController("psychic_shield", 1)
  g.Master:ActivateController("damage_monitor", 1)
  g.Master:SetVar("absorb_damage", 1)
  
  ShowObjective("EngageObjective")
  g.Denkar:SayTo(g.Eji, "do you sense")
  g.Eji:SayTo(g.Denkar, "too far")
  g.Denkar:SayTo(g.Eji, "find spot")
end
