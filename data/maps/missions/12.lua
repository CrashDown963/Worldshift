g_init.Denkar = function() return GetNamedObject("NiVarra") end

local numOriginalVillageGuards = GetNumAliveInGroup("VillageGuards")
local numOriginalBaseDefenders = GetNumAliveInGroup("BaseDefenders")

g.Rescued1 = nil
g.Rescued2 = nil
g.Rescued3 = nil
g.Rescued4 = nil
g.RescuedVillage = nil


g_Objectives.VillageObjective = {
  Create = function() return ui.Objectives:Add("Help the village", 1, "Defenders alive:", numOriginalVillageGuards) end,
  Update = function(Objective)
    local VillageGuards = GetNumAliveInGroup("VillageGuards")
    Objective.Row12:Set(VillageGuards)  
    if VillageGuards <= 0 then
      LoseMission()
    end
  end
}

g_Objectives.BaseObjective = {
  Create = function() return ui.Objectives:Add("Clear the enemy camp", 1, "Enemies left:", numOriginalBaseDefenders) end,
  Update = function(Objective)
    local BaseDefenders = GetNumAliveInGroup("BaseDefenders")
    Objective.Row12:Set(BaseDefenders)
  end
}

g_Objectives.ReinforceObjective = {
  Create = function() return ui.Objectives:Add("Get help", 1, "Helpers:", 0) end,
  Update = function(Objective)
    Objective.Row12:Set(GetNumHelpers())
  end
}

function GetNumRescues()
  local n = 0
  if g.Rescued1 then n = n + 1 end
  if g.Rescued2 then n = n + 1 end
  if g.Rescued3 then n = n + 1 end
  if g.Rescued4 then n = n + 1 end
  return n
end

function GetNumHelpers()
  local n = 0
  if g.Rescued1 then n = n + GetNumAliveInGroup("Helpers1") end
  if g.Rescued2 then n = n + GetNumAliveInGroup("Helpers2") end
  if g.Rescued3 then n = n + GetNumAliveInGroup("Helpers3") end
  if g.Rescued4 then n = n + GetNumAliveInGroup("Helpers4") end
  return n
end

function AnnounceNewRescue()
  if GetNumRescues() == 1 then
    g.Denkar:Say("good start")
    ShowObjective("ReinforceObjective")
  elseif GetNumRescues() == 4 then
    g.Denkar:Say("got help")
    HideObjective("ReinforceObjective")
  else  
    g.Denkar:Say("more help")
  end  
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  --local cname
  --if actors.Actor.IsValid(actor) then
  --  local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
  --  cname = cactor .. ":" .. name
  --else
	--  cname = name;
  --end	
  --print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value))

  if (value and name == "NiVarraAtBlockade" and (xLastTrueTime < 0 or xTimeNow - xLastTrueTime > 20)) then
    if GetNumRescues() == 0 then
      g.Denkar:Say("road blocked")
      ShowObjective("ReinforceObjective")
    elseif GetNumRescues() == 4 then
      g.Denkar:Say("break blockade")
    else
      g.Denkar:Say("still need help")
    end  
  end
  
  if value and (xLastTrueTime < 0) then
    if (name == "Rescue1") then
      g.Rescued1 = true
      SetGroupVar("Helpers1", "faction", 1)
      AnnounceNewRescue()
    elseif (name == "Rescue2") then
      g.Rescued2 = true
      SetGroupVar("Helpers2", "faction", 1)
      AnnounceNewRescue()
    elseif (name == "Rescue3") then
      g.Rescued3 = true
      SetGroupVar("Helpers3", "faction", 1)
      AnnounceNewRescue()
    elseif (name == "Rescue4") then
      g.Rescued4 = true
      SetGroupVar("Helpers4", "faction", 1)
      AnnounceNewRescue()
    elseif (name == "RescueVillage") then
      g.RescuedVillage = true
      SetGroupVar("VillageGuards", "faction", 1)
      HideObjective("VillageObjective")
      HideObjective("ReinforceObjective")
      g.Denkar:Say("village damaged")
      g.Denkar:Say("push")
      ShowObjective("BaseObjective")
    elseif (name == "Enc1Start") then
      SetGroupVar("Enc1Units", "hold_fire", 0)
    elseif (name == "Enc2Start") then
      SetGroupVar("Enc2Units", "hold_fire", 0)
    elseif (name == "Enc3Start") then
      SetGroupVar("Enc3Units", "hold_fire", 0)
    elseif (name == "Enc4Start") then
      SetGroupVar("Enc4Units", "hold_fire", 0)
    end
  end  
end

function InitObjectives()
  ExploreArea("VillageArea", 1)
  RevealArea("VillageArea", true)
  g.Denkar:Say("under attack-12")
  ShowObjective("VillageObjective")
end
