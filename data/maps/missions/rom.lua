local P1Timer
local P1TimerStart
local P2Objective
local P3Objective
local HF1337 = GetNamedObject("HF1337")
local PowerGenerator = GetNamedObject("P2PowerGenerator")
local ShieldGenerator = GetNamedObject("P2ShieldGenerator")
local Cannon = GetNamedObject("Cannon")
local CannonItem = GetNamedObject("CannonItem")
local hPowerBeam
local hShieldBeam
local bP2ReinforcementsCalled = {}
local bP2ReinforcementsEnabled
local EnableBeams

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  --local cname
  --if actors.Actor.IsValid(actor) then
  --  local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
  --  cname = cactor .. ":" .. name
  --else
	--  cname = name;
  --end	
  --print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value) .. "(last true: " .. xLastTrueTime .. ")")
  if value and (xLastTrueTime < 0) then
    if (name == "P1Started") then
      HF1337:Say("intruders")
      P1Timer = ui.Objectives:Add("Engage HF1337", 1, "Shuttle arrives in:", "5:00")
      P1TimerStart = xTimeNow
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("hurry-rom")
      end
    elseif (name == "P1Fail") then
      HF1337:Say("shuttle arrived")
      ui.Objectives:Del(P1Timer)
      P1Timer = nil
      if not g_bPlayerDefeated then
        g_bPlayerDefeated = true
        SetPlayerWin(false)
        ui.Victory:Show()
      end
      if not g_bAllDefeated then
        g_bAllDefeated = true
        Pause()
      end  
    elseif (name == "P2Started") then
      HF1337:Say("cancel shuttle")
      ui.Objectives:Del(P1Timer)
      P1Timer = nil
      P2Objective = ui.Objectives:Add("Destroy HF1337", 1, "Hull:", "100%", 1, "Energy:", "100%")
    elseif (name == "P2End") then
      --HF1337:Say("activate cannon")
      ui.Objectives:Del(P2Objective)
      P2Objective = nil
      P3Objective = ui.Objectives:Add("Deactivate the cannon", 1, "Power cores left:", "4")
      ExploreArea("P3WestArea", 1)
      ExploreArea("P3WestArea", 2)
      ExploreArea("P3WestArea", 3)
      RevealArea("P3WestArea", true)
      ExploreArea("P3SouthArea", 1)
      ExploreArea("P3SouthArea", 2)
      ExploreArea("P3SouthArea", 3)
      RevealArea("P3SouthArea", true)
      ExploreArea("P3EastArea", 1)
      ExploreArea("P3EastArea", 2)
      ExploreArea("P3EastArea", 3)
      RevealArea("P3EastArea", true)
      ExploreArea("P3NorthArea", 1)
      ExploreArea("P3NorthArea", 2)
      ExploreArea("P3NorthArea", 3)
      RevealArea("P3NorthArea", true)
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("deactivate cannon")
      end
    elseif (name == "DestroyCannon") then
      if actors.Actor.IsValid(Cannon) then
        Cannon:Die()
      end
      if actors.Actor.IsValid(CannonItem) then
        CannonItem:SetVar("hidden", 0)
      end
    end
  end  
  if name == "P2PlayerUnitInArea" then
    if value then
      if xLastTrueTime < 0 then
        ExploreArea("P2Area", 1)
        ExploreArea("P2Area", 2)
        ExploreArea("P2Area", 3)
        local Commander = GetCommander(GetPlayerFaction())
        if actors.Actor.IsValid(Commander) then
          Commander:Say("boss seen", nil, 1)
        end
      end
      RevealArea("P2Area", true)
    else
      RevealArea("P2Area", false)
    end
  end
  UpdateBeams()
end

function UpdateBeams()
  if not EnableBeams then
    return
  end
    
  if actors.Actor.IsValid(HF1337) and actors.Actor.IsValid(PowerGenerator) then
    if not hPowerBeam then
      hPowerBeam = CreateP2PBeam("EnergyGeneratorBeam", PowerGenerator, HF1337, "pt_top", "pt_center")
    end
  else
    if hPowerBeam then
      RemoveP2PBeam(hPowerBeam)
      hPowerBeam = nil
    end  
  end
  if actors.Actor.IsValid(HF1337) and actors.Actor.IsValid(ShieldGenerator) then
    if not hShieldBeam then
      hShieldBeam = CreateP2PBeam("ShieldGeneratorBeam", ShieldGenerator, HF1337, "pt_cast", "pt_center")
      local regen = HF1337:GetVar("shield_regen_buffed") or 1000000
      HF1337:SetControllerVar("shield", "regen_per_minute", regen)
    end
  else
    if hShieldBeam then
      RemoveP2PBeam(hShieldBeam)
      hShieldBeam = nil
      local regen = HF1337:GetVar("shield_regen_base") or 0
      HF1337:SetControllerVar("shield", "regen_per_minute", regen)
    end
  end  
end

function UpdateObjectives()
  sleep(0.5)
  EnableBeams = true
  UpdateBeams()
  if actors.Actor.IsValid(HF1337) then
    if actors.Actor.IsValid(PowerGenerator) then
      PowerGenerator:AimAt(HF1337)
    end
    if actors.Actor.IsValid(ShieldGenerator) then
      ShieldGenerator:AimAt(HF1337)
    end
  end
  
  while true do
    if P1Timer then
      local xPassed = GetTime() - P1TimerStart
      local xLeft = 300 - xPassed
      if xLeft < 0 then xLeft = 0 end
      P1Timer.Row12:Set(SecondsToStr(xLeft))
      if xLeft > 61 then
        P1Timer.Row12:SetColor(ui.colors.white)
        --ui.FlashWND(P1Timer.Row12, 0)
      elseif xLeft > 31 then
        P1Timer.Row12:SetColor(ui.colors.yellow)
        --ui.FlashWND(P1Timer.Row12, 0)
      else  
        P1Timer.Row12:SetColor(ui.colors.red)
        ui.FlashWND(P1Timer.Row12, 0.1)
      end
    end
    if P2Objective then
      local hp, energy
      if actors.Actor.IsValid(HF1337) then
        hp = HF1337:GetVar("hit_points_percent")
        energy = HF1337:GetVar("energy_percent")
      else
        hp = 0
        energy = 0
      end
      P2Objective.Row12:Set(hp .. "%")
      P2Objective.Row22:Set(energy .. "%")
    end
    if P3Objective then
      local PowerCores = GetNumAliveInGroup("P3Generators")
      P3Objective.Row12:Set(PowerCores)
    end
    
    sleep(1)
  end  
end

CreateThread(UpdateObjectives)
