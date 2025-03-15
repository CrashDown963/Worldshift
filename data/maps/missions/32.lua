g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Tharksh = function() return GetNamedObject("Tharksh") end
g_init.Ship = function() return GetNamedObject("Ship") end
g_init.SpiderNest = function() return GetNamedObject("SpiderNest") end
g_init.PsiResonator = function() return GetNamedObject("PsiResonator") end

g.Wave1Dead = false
g.Wave2Dead = false
g.PlayerAtAcidArea = false
g.AcidExipreTimes = {}
g.AcidsExpired = 0
g.AcidAreaSolved = false
g.ResonatorAlone = false
g.HoldResonatorCheck = true

g_Objectives.ShipObjective = {
  Create = function() return ui.Objectives:Add("Protect the ship", 1, "Ship hull:", "100%") end,
  Update = function(Objective)
    local hp
    if actors.Actor.IsValid(g.Ship) then
      hp = g.Ship:GetVar("hit_points_percent")
    else
      hp = 0
    end  
    Objective.Row12:Set(hp .. "%")
  end
}
g_Objectives.LocateBase = {
  Create = function() return ui.Objectives:Add("Locate the enemy base", 1, " ", " ") end
}  
g_Objectives.DestroyBase = {
  Create = function() return ui.Objectives:Add("Destroy the enemy base", 1, " ", " ") end
}  
g_Objectives.AcidArea = {
  Create = function() return ui.Objectives:Add("Deal with the gas", 1, " ", " ") end
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
  
  if name == "PlayerAtAcidArea" then
    g.PlayerAtAcidArea = value
    if actors.Actor.IsValid(g.SpiderNest) then
      ResetAcids()
    end  
  end
  
  if value and (xLastTrueTime < 0) then
    if (name == "Wave1Dead") then
      g.Denkar:Say("is this your best")
      g.Tharksh:Say("alien roar")
      g.Denkar:Say("oops")
    elseif (name == "Wave2Dead") then
      g.Denkar:Say("waves over")
      g.Tharksh:Say("base nearby")
      HideObjective("ShipObjective")
      ShowObjective("LocateBase")
      g.PsiResonator = SpawnObject("PsiResonator", GetNamedObjectPos("ResonatorPos"), GetPlayerFaction())
      if g.PsiResonator then g.PsiResonator:SetVar("obj_name", "PsiResonator") end
      g.HoldResonatorCheck = false
    elseif (name == "PlayerAtAcidArea") then  
      g.Tharksh:Say("avoid gas")
      g.Denkar:Say("stop gas")
    elseif (name == "PlayerAtBaseArea") then  
      g.Denkar:Say("found base")
      HideObjective("LocateBase")
      ShowObjective("DestroyBase")
    end
  end  
end

function ChargeAcidGeyser(geyser_name)
  local now = GetTime()
  local old = g.AcidExipreTimes[geyser_name]
  local new = now + 60
  local expired = old and (old < 0)
  if expired then
    SetNamedObjectVar(geyser_name, "tex_id", 0)
    if g.PlayerAtAcidArea and g.AcidsExpired == 4 then
    end
    g.AcidsExpired = g.AcidsExpired - 1
    --print("AcidsExpired: " .. g.AcidsExpired)
  end  
  g.AcidExipreTimes[geyser_name] = new
end

function StopAcidGeyser(geyser_name)
  local old = g.AcidExipreTimes[geyser_name]
  if (old < 0) then return end
  local now = GetTime()
  local expired = old and (old <= now)
  if expired then
    SetNamedObjectVar(geyser_name, "tex_id", 3)
    g.AcidsExpired = g.AcidsExpired + 1
    g.AcidExipreTimes[geyser_name] = -1
    --print("AcidsExpired: " .. g.AcidsExpired)
  end
end

function ResetAcids()
  for i=1,4 do
    ChargeAcidGeyser("Geyser" .. i)
  end
end

function UpdateAcids()
  while true do
    if not g_Objectives.AcidArea.Objective and g.PlayerAtAcidArea and g.AcidsExpired < 4 then
      ShowObjective("AcidArea")
    elseif g_Objectives.AcidArea.Objective and not g.PlayerAtAcidArea and g.AcidsExpired >= 4 then
      HideObjective("AcidArea")
      if not g.AcidAreaSolved then
        g.AcidAreaSolved = true
      end
    end
    if g.PlayerAtAcidArea then
      local old = g.AcidsExpired
      for i=1,4 do
        StopAcidGeyser("Geyser" .. i)
      end
      if old < 4 and g.AcidsExpired >= 4 and not g.AcidAreaSolved then
        SetCondition("Arrows2", true);
        g.Denkar:Say("safe")
      end  
      for i=1,10 do
        DamageUnitsInArea("GasArea2", 1, 1, "poison")
        if g.AcidsExpired < 4 then
          DamageUnitsInArea("GasArea1", 2000, 1, "poison")
        end  
        sleep(0.1)
      end  
    else
      sleep(1)
    end  
  end  
end

CreateThread(UpdateAcids)

function CheckWaves()
  while true do
    if not g.Wave1Dead and IsGroupOfMobsDead("Wave1Mobs", true) then
      g.Wave1Dead = true
      SetCondition("Wave1Dead", true)
    end
    if not g.Wave2Dead and IsGroupOfMobsDead("Wave2Mobs", true) then
      g.Wave2Dead = true
      SetCondition("Wave2Dead", true)
    end
    sleep(1)
  end  
end

CreateThread(CheckWaves)

function CheckResonator()
  while true do
    if not g.HoldResonatorCheck then
      if not actors.Actor.IsValid(g.PsiResonator) then
        g.HoldResonatorCheck = true
        g.Denkar:Say("doomed")
        RunAfter(8, function()
          LoseMission("vic_32psidestr")
        end)  
      end
    end  
    sleep(1)
  end
end

CreateThread(CheckResonator)

function PsiResonatorAlone(params)
  if actors.Actor.IsValid(g.Denkar) then
    g.Denkar:Say("resonator alone")
    CreateMapPing(GetNamedObjectPos("PsiResonator"))
  end
  g.ResonatorAlone = true
  RunAfter(10, SpawnResonatorThieves)
end

function SpawnResonatorThieves()
  print("Blaaaaaaaaaaaa")
  if g.ResonatorAlone then
    if actors.Actor.IsValid(g.PsiResonator) then
      g.PsiResonator:SetVar("indestructible", 1)
      g.PsiResonator:SetVar("attackable", 0)
      g.HoldResonatorCheck = true
    else
      return "SUCCESS"
    end
    local thieves = {}
    SpawnObjects("Arbiter = 2", g.PsiResonator:GetPos(), 12, thieves)
    SpawnObjects("Master = 1", g.PsiResonator:GetPos(), 12, thieves)
    for _, thief in ipairs(thieves) do
      if actors.Actor.IsValid(thief) then 
        thief:SetVar("attackable", 0)
        thief:SetVar("hold_fire", 1)
      end
    end
    RunAfter(2, function()
      for _, thief in ipairs(thieves) do
        if actors.Actor.IsValid(thief) then thief:Execute("PrgDespawn") end
      end
      if actors.Actor.IsValid(g.PsiResonator) then g.PsiResonator:Execute("PrgDespawn") end
      RunAfter(3, function()
        LoseMission("vic_32psistolen")
      end)  
    end)
  end
end

function PsiResonatorNotAlone(params)
  g.ResonatorAlone = false
end

function InitObjectives()
  g.Denkar:Say("protect ship")
  ShowObjective("ShipObjective")
end
