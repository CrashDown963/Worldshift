g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Onkar = function() return GetNamedObject("Onkar") end
g.BlastPos = nil
g.VP1Revealed = nil
g.VP2Revealed = nil
g.Beacon = nil

g_Objectives.ClearTheWay = {
  Create = function() return ui.Objectives:Add("Clear the way", 1, "Eliminate the hostile creatures", " ") end
}

g_Objectives.SaveDenkar = {
  Create = function() return ui.Objectives:Add("Save Denkar", 1, " ", " ") end,
  Update = function(Objective)
    if g.VP1Revealed then
      Objective.Row11:Set("Avoid the patrols") 
    else
      Objective.Row11:Set(" ")
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
  
  if value then
    if (name == "VP1Revealed") then
      if not g.VP1Revealed and g_Objectives.SaveDenkar.Objective then
        g.Denkar:Say("avoid patrols")
        g.VP1Revealed = true
      end  
    elseif (name == "VP2Revealed") then
      if not g.VP2Revealed and g_Objectives.SaveDenkar.Objective then
        g.Denkar:Say("another patrol")
        g.VP2Revealed = true
      end  
    end
  end
  
  if value and (xLastTrueTime < 0) then
    if (name == "FirstEncounterEnd") then
      g.Onkar:Say("not harmless")
      g.Onkar:SayTo(g.Denkar, "take troops")
      ShowObjective("ClearTheWay")
    elseif (name == "A1End") then
      g.Onkar:Say("keep moving")
      SetGroupVar("P2Units", "path", "A1Path")  
    elseif (name == "A2End") then
      SetWeatherPreset(4)
      g.Onkar:Say("we are coming")
      SetGroupVar("P2Units", "path", "A2Path")  
    elseif (name == "TakeSouth") then
      g.Onkar:Say("go south")
    elseif (name == "OnkarAtDeathSpot") then
      g.Onkar:Say("hang around")
    elseif (name == "OnkarEngaged") then
      g.Onkar:Say("under attack-11")
      g.Denkar:Say("coming")
      g.Onkar:Say("save yourself")
      g.Denkar:Say("nooo")
      HideObjective("ClearTheWay")
      ShowObjective("SaveDenkar")
    elseif (name == "BlastOnkarStarted") then
      g.BlastPos = g.Onkar:GetPos()
      g.Beacon = SpawnObject("ProtonBlastBeacon", g.BlastPos, 12)
    elseif (name == "BlastOnkarHit") then
      SpawnObject("ProtonBlastExplosion", g.BlastPos, 12)
      if g.Beacon then 
        g.Beacon:Destroy()
        g.Beacon = nil
      end
      ShakeCamera(g.BlastPos)
      local P2Units = GetNamedGroup("P2Units")
      if P2Units then
        for _, unit in ipairs(P2Units) do
          if unit then unit:Die() end
        end
      end
    end
  end  
end

function InitObjectives()
  SetWeatherPreset(3)
  g.Onkar:Say("incoming")
end

