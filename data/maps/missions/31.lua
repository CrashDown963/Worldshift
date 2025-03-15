g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Tharksh = function() return GetNamedObject("Tharksh") end
g_init.PsiResonator = function() return GetNamedObject("PsiResonator") end

g.ResonatorAlone = false
g.HoldResonatorCheck = false
g.CheckFinalAmbush = false

g_Objectives.Protect = {
  Create = function() return ui.Objectives:Add("Protect the Psi Resonator", 1, " ", " ") end
}  
g_Objectives.FindShip = {
  Create = function() return ui.Objectives:Add("Find Tharksh's ship", 1, " ", " ") end
}  
g_Objectives.KillMaster = {
  Create = function() return ui.Objectives:Add("Defeat the enemy Master", 1, " ", " ") end
}  

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "PlayerAtReinforcementsTriggerArea" == name then
    g.Tharksh:Say("aliens detected")
    ExploreArea("EnemyMasterArea", 1)
    RevealArea("EnemyMasterArea", true)
    CreateMapPing(GetNamedObjectPos("Master1Location"))
    g.Denkar:Say("how many")
    g.Tharksh:Say("many")
    g.Denkar:Say("call reinforcements")
    g.Tharksh:Say("reinforcements called")
    CreateMapPing(GetNamedObjectPos("TharkshShipLocation"))
    g.Denkar:Say("hold the line")
    RunAfter(5, DeliverReinforcements)
    SetCondition("SpawnPatrolsFlag", true)
    ShowObjective("KillMaster")
  elseif "PlayerAtElephantsArea" == name then
    g.Denkar:Say("elephant worms")
  elseif "PlayerAtAmbushTriggerArea" == name then
    SetCondition("SpawnAmbushMaster", true)
  elseif "FirstAliensInCombat" == name then
    g.Tharksh:Say("blown cover")
    g.Denkar:Say("another master")
    g.Tharksh:Say("right")
  elseif "PlayerAtFinalArea" == name then
    g.Tharksh:Say("master ambush")
    g.Denkar:Say("no problem")
    HideObjective("FindShip")
    ShowObjective("KillMaster")
    g.CheckFinalAmbush = true
  elseif "FirstMasterDead" == name then
    HideObjective("KillMaster")
    g.Denkar:Say("tough aliens")
    g.Tharksh:Say("glad to hear that")
    g.Tharksh:Say("other ship")
    g.Denkar:Say("lets continue")
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
    if actors.Actor.IsValid(g.PsiResonator) then
      g.PsiResonator:SetVar("indestructible", 1)
      g.PsiResonator:SetVar("attackable", 0)
      g.HoldResonatorCheck = true
    else
      return "SUCCESS"
    end
    local thieves = {}
    SpawnObjects("Arbiter = 2", GetNamedObjectPos("PsiResonator"), 12, thieves)
    SpawnObjects("Master = 1", GetNamedObjectPos("PsiResonator"), 12, thieves)
    for _, thief in pairs(thieves) do
      if actors.Actor.IsValid(thief) then 
        thief:SetVar("attackable", 0)
        thief:SetVar("hold_fire", 1)
      end
    end
    RunAfter(2, function()
      for _, thief in pairs(thieves) do
        if actors.Actor.IsValid(thief) then thief:Execute("PrgDespawn") end
      end
      if actors.Actor.IsValid(g.PsiResonator) then g.PsiResonator:Execute("PrgDespawn") end
      RunAfter(3, function()
        LoseMission("vic_31psistolen")
      end)
    end)
  end
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
          LoseMission("vic_31psidestr")
        end)  
      end
    end  
    sleep(1)
  end
end

function DeliverReinforcements()
  local reinforcements = GetNamedGroup("Reinforcements")
  local unitSpeeds = {}
  for _, unit in ipairs(reinforcements) do
    table.insert(unitSpeeds, unit:GetVar("speed"))
    unit:SetVar("faction", GetPlayerFaction())
    unit:SetVar("speed", 400)
    unit:SetVar("actions_disabled", 1)
    unit:SetVar("attackable", 0)
    unit:SetVar("idle_follow", g.Tharksh.h)
    unit:Execute("PrgIdle", { h = g.Tharksh }) 
  end
  
  local unitsInRange = false
  local session = CheckpointData.session
  while not unitsInRange do
    for _, unit in ipairs(reinforcements) do
      if unit:DistTo(g.Tharksh) < 800 then
        unitsInRange = true
        break
      end
    end
    if not unitsInRange then
      sleep(2)
      if session ~= CheckpointData.session then
        break
      end  
    end
  end
  
  for i, unit in ipairs(reinforcements) do
    if session == CheckpointData.session then
      unit:SetVar("actions_disabled", 0)
      unit:SetVar("attackable", 1)
      unit:SetVar("idle_follow", 0)
    end  
    unit:SetVar("speed", unitSpeeds[i])
  end
  
  AddNamedGroupToInitialForces("Reinforcements")
end

function CheckFinalAmbush()
  while true do
    if g.CheckFinalAmbush then
      if IsGroupOfMobsDead("TharkshShipAmbush") and CheckCondition("AvatarsAtFinalArea") then
        g.CheckFinalAmbush = false
        HideObjective("KillMaster")
        g.Denkar:Say("lets get out of here")
        g.Tharksh:Say("ok")
        RunAfter(5, function()
          WinMission()
        end)
      else
        sleep(1)
      end    
    else
      sleep(1)
    end
  end      
end

function InitObjectives()
  ShowObjective("Protect")
  ShowObjective("FindShip")
  g.Tharksh:Say("ship to the east")
  g.Denkar:Say("protect the resonator")
  CreateThread(CheckResonator)
  CreateThread(CheckFinalAmbush)
end
