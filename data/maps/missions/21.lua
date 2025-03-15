g_init.NiVarra = function() return GetNamedObject("Ni'Varra") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Kuna = function() return GetNamedObject("Kuna") end
g_init.Master1 = function() return GetNamedObject("AlienMaster1") end
g_init.Breeder = function() return GetNamedObject("Breeder") end

local numOriginalVillageGuards = GetNumAliveInGroup("VillageGuards")
local numOriginalLabTurrets = GetNumAliveInGroup("LabTurrets")

g_Objectives.VillageObjective = {
  Create = function() return ui.Objectives:Add("Protect the village", 1, "Defenders alive:", numOriginalVillageGuards) end,
  Update = function(Objective)
    local numVillageGuards = GetNumAliveInGroup("VillageGuards")
    Objective.Row12:Set(numVillageGuards)
    if numVillageGuards > 15 then
      Objective.Row12:SetColor(ui.colors.white)
    elseif numVillageGuards > 5 then
      Objective.Row12:SetColor(ui.colors.yellow)
    else  
      Objective.Row12:SetColor(ui.colors.red)
      ui.FlashWND(Objective.Row12, 0.1)
    end
  end
}

g_Objectives.LabObjective = {
  Create = function() return ui.Objectives:Add("Protect the lab", 1, "Turrets left:", numOriginalLabTurrets) end,
  Update = function(Objective)
    local numLabTurrets = GetNumAliveInGroup("LabTurrets")
    Objective.Row12:Set(numLabTurrets)
    if numLabTurrets > 4 then
      Objective.Row12:SetColor(ui.colors.white)
    elseif numLabTurrets > 1 then
      Objective.Row12:SetColor(ui.colors.yellow)
    else  
      Objective.Row12:SetColor(ui.colors.red)
      ui.FlashWND(Objective.Row12, 0.1)
    end
  end
}

g_Objectives.AliensObjective = {
  Create = function() return ui.Objectives:Add("Defeat The Hive", 1, "Master killed:", "no", 1, "Breeder destroyed:", "no") end,
  Update = function(Objective)
    if actors.Actor.IsValid(g.Master1) then
      Objective.Row12:Set("no")
    else
      Objective.Row12:Set("YES")
    end
    if actors.Actor.IsValid(g.Breeder) then
      Objective.Row22:Set("no")
    else
      Objective.Row22:Set("YES")
    end
  end
}

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  --local cname
  --if actors.Actor.IsValid(actor) then
  --  local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
  --  cname = cactor .. ":" .. name
  --else
	--  cname = name;
  --end	
  --print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value))
  if value and (xLastTrueTime < 0) then
    if (name == "Master1InCombat") then
      g.NiVarra:Say("knew it", nil, 1)
    elseif (name == "CallLabReinforcements") then
      g.Kuna:Say("kuna reinforcements")
    elseif (name == "SpawnLabReinforcements") then
      local LabReinforcePoint = GetNamedObjectPos("LabReinforcePoint")
      if LabReinforcePoint then
        local Lilly = SpawnObject("Surgeon", LabReinforcePoint, 1)
        if Lilly then 
          Lilly:SetVar("obj_name", "Lilly") 
          Lilly:SetVar("name", "Lilly")
          Lilly:SetVar("conv_icon_row", 6)
          Lilly:SetVar("conv_icon_col", 5)
          g.Kuna:Say("kuna - where are the reinf")
          Lilly:Say("lilly - i am afraid i am")
        else
          print("Could not spawn Lilly")
        end
      else
        print("LabReinforcePoint not found")
      end  
    end
  end  
end

--local h = CreateP2PBeam("NanoRestoreBeam", C, M)
--RemoveP2PBeam(h)

function InitObjectives()
  ExploreArea("VillageArea", 1)
  RevealArea("VillageArea", true);
  ExploreArea("LabArea", 1)
  RevealArea("LabArea", true);

  g.Ganthu:SayTo(g.NiVarra, "save village")
  g.Kuna:SayTo(g.NiVarra, "save lab")
  g.NiVarra:SayTo(g.Kuna, "save both")
  g.Kuna:SayTo(g.NiVarra, "enemy")

  ShowObjective("VillageObjective")
  ShowObjective("LabObjective")
  ShowObjective("AliensObjective")
end
