g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Arna = function() return GetNamedObject("Arna") end
g_init.Artifact1 = function() return GetNamedObject("Artifact1") end
g_init.Artifact2 = function() return GetNamedObject("Artifact2") end
g_init.BeamSource1 = function() return GetNamedObject("BeamSource1") end
g_init.BeamSource2 = function() return GetNamedObject("BeamSource2") end
g_init.TechniciansOperatingGenerator = function() return {} end

g.BasesExamined = {}
g.CNDNiVarraAtAncientRuins = false
g.CNDNArtifact1Examined = false
g.CNDNArnaAtPowerGenerator = false
g.CNDNPowerGeneratorActive = false
g.CNDNArnaInFrontOfBeam = false
g.CNDNTechnicianWarning = false
g.CNDNPlayerAtSecondArtifact = false
g.CNDNArtifact2Examined = false
g.TechniciansDead = false

g_Objectives.TechniciansObjective = {
  Create = function() return ui.Objectives:Add("Protect the technicians", 1, "Technicians alive", " ") end,
  Update = function(Objective)
    local numTechnicians = GetNumObjects(1, "Technician") --GetNumAliveInGroup("Technicians")
    Objective.Row12:Set(numTechnicians)
    if not g.TechniciansDead and numTechnicians <= 0 then
      g.TechniciansDead = true
      g.Arna:Say("technicians are dead")
      RunAfter(5, function()
        LoseMission()
      end)
    end
  end
}

g_Objectives.ScoutObjective = {
  Create = function() return ui.Objectives:Add("Scout the area", 1, "Follow the path", " ") end
}  
g_Objectives.ExamineAD = {
  Create = function() return ui.Objectives:Add("Examine the ancient device", 1, " ", " ") end
}  
g_Objectives.ActivatePowerGen = {
  Create = function() return ui.Objectives:Add("Activate the power generator", 1, " ", " ") end
}  
g_Objectives.FindAnother = {
  Create = function() return ui.Objectives:Add("Find another ancient device", 1, " ", " ") end
}  
g_Objectives.ExamineRuins = {
  Create = function() return ui.Objectives:Add("Examine the ruins", 1, " ", " ") end
}  
g_Objectives.ReturnToFirst = {
  Create = function() return ui.Objectives:Add("Return to the first site", 1, " ", " ") end
}  
g_Objectives.FindPower = {
  Create = function() return ui.Objectives:Add("Find power", 1, "Find the ancient power source", " ") end
}  
g_Objectives.Escape = {
  Create = function() return ui.Objectives:Add("Reach the extraction point", 1, " ", " ") end
}  

function ChangeObjective(name)
  HideObjective("ScoutObjective")
  HideObjective("ExamineAD")
  HideObjective("ActivatePowerGen")
  HideObjective("FindAnother")
  HideObjective("ExamineRuins")
  HideObjective("ReturnToFirst")
  HideObjective("FindPower")
  HideObjective("Escape")
  ShowObjective(name)
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if name == "PlayerAtAncientRuins" and not g.CNDNiVarraAtAncientRuins and value then
    g.CNDNiVarraAtAncientRuins = true
    g.Denkar:Say("check this out")
    local Technician = GetFirstObject(1, "Technician")
    if Technician then
      Technician:Say("need time")
    end
    g.Arna:Say("hurry-23")
    ChangeObjective("ExamineAD")
  elseif string.find(name, "PlayerAtBaseEntrance") ~= nil and value then
    local s, e = string.find(name, "PlayerAtBaseEntrance")
    local num = string.sub(name, e + 1)
    if g.BasesExamined[num] == nil then
      g.BasesExamined[num] = true
      g.Denkar:Say("stay away from base")
    end
  elseif name == "ArnaAtPowerGenerator" and not g.CNDNArnaAtPowerGenerator and value then
    g.CNDNArnaAtPowerGenerator = true
    g.Arna:Say("start generator")
    g.Denkar:Say("expect trouble")
    ChangeObjective("ActivatePowerGen")
  elseif name == "ArnaInFrontOfBeam" and not g.CNDNArnaInFrontOfBeam and g.CNDNPowerGeneratorActive and value then
    g.CNDNArnaInFrontOfBeam = true
    CreateMapPing(GetNamedObjectPos("Arna"))
    g.Arna:Say("path blocked")
    ChangeObjective("FindAnother")
  elseif name == "PlayerAtSecondArtifact" and not g.CNDNPlayerAtSecondArtifact and value then
    g.CNDNPlayerAtSecondArtifact = true
    g.Arna:Say("found another site")
    local Technician = GetFirstObject(1, "Technician")
    if Technician then
      Technician:Say("affirmative")
      if not g.CNDNPowerGeneratorActive then
        Technician:Say("no power")
        return
      end
    end
    ChangeObjective("ExamineRuins")
  elseif name == "HeroesAtExitArea" and g.CNDNArtifact2Examined and value then
    g.Arna:Say("victory-23")
    WinMission()
  end
end

function CheckActionVisible(actor, params)
  if params.action == "ActivatePowerGeneratorAction" then
    return not g.CNDNPowerGeneratorActive
  end
  
  if params.action == "PickM23Artifact" then
    if not g.CNDNPowerGeneratorActive then
      -- if the party is at second artifact and they didn't activate the power generator - do not allow picking
      return false
    end
  end
  
  return true
end

function PowerGeneratorActivationStarted(switch, user)
  g.TechniciansOperatingGenerator[user] = true
end

function PowerGeneratorActivationCancelled(switch, user)
  g.TechniciansOperatingGenerator[user] = nil
end

function PowerGeneratorActivationComplete(switch, user)
  g.TechniciansOperatingGenerator[user] = nil
  if actors.Actor.IsValid(user) and not g.CNDNPowerGeneratorActive then
    g.CNDNPowerGeneratorActive = true
    UpdateActorActions(user)
    user:Say("generator online")
    g.Arna:Say("go back")
    ChangeObjective("ReturnToFirst")
  end
end

function M23ArtifactPickingComplete(switch, technician)
  if switch == g.Artifact1 and not g.CNDNArtifact1Examined then
    g.CNDNArtifact1Examined = true
    technician:Say("need power")
	  g.Arna:Say("find power")
	  ChangeObjective("FindPower")
  end
  if switch == g.Artifact2 and not g.CNDNArtifact2Examined then
    g.CNDNArtifact2Examined = true
    technician:Say("got it")
	  g.Arna:Say("go home")
	  ChangeObjective("Escape")
  end
end

function BeamDamage()
  local BeamsCreated = false
  local Beam1 = nil
  local Beam2 = nil
  local Beam3 = nil
  
  while true do
    if g.CNDNPowerGeneratorActive then
      if not BeamsCreated then
        BeamsCreated = true
        Beam1 = CreateP2PBeam("23ForceFieldBeam", g.BeamSource1, g.BeamSource2, "pt_ray1", "pt_ray1")
        Beam2 = CreateP2PBeam("23ForceFieldBeam", g.BeamSource1, g.BeamSource2, "pt_ray2", "pt_ray2")
        Beam3 = CreateP2PBeam("23ForceFieldBeam", g.BeamSource1, g.BeamSource2, "pt_ray3", "pt_ray3")
      end
      DamageUnitsInArea("BeforeBeam1", 20, 0, "lightning")
      DamageUnitsInArea("BeforeBeam2", 20, 0, "lightning")
      DamageUnitsInArea("BeamArea", 5000, 0, "lightning")
      sleep(0.25)
    else
      if BeamsCreated then
        BeamsCreated = false
        RemoveP2PBeam(Beam1)
        Beam1 = nil
        RemoveP2PBeam(Beam2)
        Beam2 = nil
        RemoveP2PBeam(Beam3)
        Beam3 = nil
      end
      sleep(1)
    end    
  end
end

CreateThread(BeamDamage)

function GeneratorDamage()
  while true do
    for technician, v in pairs(g.TechniciansOperatingGenerator) do
      if actors.Actor.IsValid(technician) then
        if not g.CNDNTechnicianWarning then
          g.CNDNTechnicianWarning = true
          technician:Say("heal me")
        end
        DamageUnit(technician, 5, "lightning")
      end
    end
    sleep(1)
  end
end

CreateThread(GeneratorDamage)

function InitObjectives()
  RemoveNamedGroupFromInitialForces("Technicians")
  g.Arna:Say("scout the area")
  g.Denkar:Say("careful-23")
  ShowObjective("TechniciansObjective")
  ShowObjective("ScoutObjective")
end
