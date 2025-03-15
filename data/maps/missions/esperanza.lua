local BossArtifact = GetNamedObject("BossArtifact")
local BossExtraArtifact1 = GetNamedObject("BossExtraArtifact1")
local BossExtraArtifact2 = GetNamedObject("BossExtraArtifact2")
local AncientSmith = GetNamedObject("AncientSmith")
local EastClone = GetNamedObject("EastClone")
local WestClone = GetNamedObject("WestClone")
local CurrentObjective = nil

function OpenGate(gate)
  ZOffsetNamedGroup(gate, -600, 5, "DustAndDebris", "data/sounds/effects/common/rumble.wav")
  RunAfter(5, function()
    SetGroupVar(gate, "passable", 1)
  end)
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  print("cond " .. tostring(name) .. " = " .. tostring(value))
  if xLastTrueTime > 0 or value == false then return end
  
  if "EastCloneDead" == name then
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Find the renegade commander", 1, " ", " ")
    OpenGate("EastGate")
    if actors.Actor.IsValid(AncientSmith) then
      AncientSmith:ActivateController("AncientSmithBerserkAura", 0)
      if CheckCondition("WestCloneDead") then
        AncientSmith:ActivateController("PowerAnim", 0)
      end
    end
  elseif "WestCloneDead" == name then
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Find the renegade commander", 1, " ", " ")
    OpenGate("WestGate")
    if actors.Actor.IsValid(AncientSmith) then
      AncientSmith:ActivateController("AncientSmithHealAura", 0)
      if CheckCondition("EastCloneDead") then
        AncientSmith:ActivateController("PowerAnim", 0)
      end
    end
  elseif "EastCloneInCombat" == name then
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat Ancient Smith", 1, " ", " ")
    if CheckCondition("WestCloneDead") then
      EastClone:Say("we meet again")
      GetCommander(GetPlayerFaction()):Say("didnt we")
      EastClone:Say("cant kill me")
    end
  elseif "WestCloneInCombat" == name then
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat Ancient Smith", 1, " ", " ")
    if CheckCondition("EastCloneDead") then
      WestClone:Say("we meet again")
      GetCommander(GetPlayerFaction()):Say("didnt we")
      WestClone:Say("cant kill me")
    end
  elseif "OpenSouthGate" == name then
    OpenGate("SouthGate")
  elseif "FinalSmithInCombat" == name then
    if CurrentObjective then ui.Objectives:Del(CurrentObjective) end
    CurrentObjective = ui.Objectives:Add("Defeat Ancient Smith", 1, " ", " ")
    AncientSmith:Say("mistake")
  elseif "FinalSmithDead" == name then
    BossArtifact:SetVar("hidden", 0)
    local EastCloneDead = CheckCondition("EastCloneDead")
    local WestCloneDead = CheckCondition("WestCloneDead")
    if not EastCloneDead and not WestCloneDead then
      BossExtraArtifact2:SetVar("hidden", 0)
    elseif (EastCloneDead and not WestCloneDead) or (EastCloneDead and not WestCloneDead) then
      BossExtraArtifact1:SetVar("hidden", 0)
    end
  end
end

RunAfter(1, function()
  BossArtifact:SetVar("hidden", 1)
  BossExtraArtifact1:SetVar("hidden", 1)
  BossExtraArtifact2:SetVar("hidden", 1)
  GetCommander(GetPlayerFaction()):Say("creeps")
  CurrentObjective = ui.Objectives:Add("Find the renegade commander", 1, " ", " ")
end)
