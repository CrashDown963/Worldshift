g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end

g_Objectives.ReachDeathPlace = {
  Create = function() return ui.Objectives:Add("Reach Onkar's place of death", 1, " ", " ") end
}  

g_Objectives.TakeDiary = {
  Create = function() return ui.Objectives:Add("Take the diary", 1, " ", " ") end
}  

g_Objectives.Escape = {
  Create = function() return ui.Objectives:Add("Reach the extraction point", 1, " ", " ") end
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
    if (name == "RA1") then
      g.Ganthu:Say("looks hard")
      g.Denkar:Say("we can do it")
      g.Ganthu:Say("casualties")
      g.Denkar:Say("not running")
      g.Ganthu:Say("clear judgement")
      g.Denkar:Say("you right")
    elseif (name == "SpawnDeathPlaceAssassins") then
      g.Denkar:Say("assassins")
    elseif (name == "DenkarVisitedDeathPlace") then
      g.Denkar:Say("found diary")
      HideAllObjectives()
      ShowObjective("TakeDiary")
    elseif (name == "BigSpawn") then
      DestroyObjectByName("BigSpawnBlocker")
      ExploreArea("BigSpawnArea", 1)
      RevealArea("BigSpawnArea", true)
      local ptPing = GetNamedObjectPos("BigSpawnMapPingPos")
      if ptPing then CreateMapPing(ptPing) end
      g.Ganthu:Say("look east")
      g.Denkar:Say("where came from")
      g.Ganthu:Say("coming our way")
      g.Ganthu:Say("consider running")
      g.Denkar:Say("lets run")
      HideAllObjectives()
      ShowObjective("Escape")
      ExploreArea("EscapeArea", 1)
    end
  end  
end

function InitObjectives()
  g.Denkar:Say("score to settle")
  g.Ganthu:Say("take it easy")
  ShowObjective("ReachDeathPlace")
end

