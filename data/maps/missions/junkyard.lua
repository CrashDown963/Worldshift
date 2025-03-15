local BigBoss = GetNamedObject("BigBoss")
local Gorgar = GetNamedObject("Gorgar")
local SideItem = GetNamedObject("SideItem")
local TeleportArtifact = GetNamedObject("TeleportArtifact")
local GorgarExtraItem = GetNamedObject("GorgarExtraItem")
local DitzItem = GetNamedObject("DitzItem")
local BossExtraItem = GetNamedObject("BossExtraItem")
local XesskItem = GetNamedObject("XesskItem")
local Machine1 = GetNamedObject("Machine1")
local Machine2 = GetNamedObject("Machine2")
local Machine3 = GetNamedObject("Machine3")
local Machine4 = GetNamedObject("Machine4")
local BossGate = GetNamedObject("BossGate")

local StartTime
local TeleportUsed
local TeleportArtifactDespawned

local TeleportObjective
local GorgarObjective
local BigBossObjective
local SpiderObjective

local g_ptTeleportDest = {}
local g_nTeleportDest = 0

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  local cname
  if actors.Actor.IsValid(actor) then
    local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
    cname = cactor .. ":" .. name
  else
	  cname = name;
  end	
  print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value))

  if name == "Machine1On" then
    if actors.Actor.IsValid(Machine1) then
      if value then
        Machine1:SetAnim("working")
      else
        Machine1:SetAnim("idle1")
      end
    end
  elseif name == "Machine2On" then
    if actors.Actor.IsValid(Machine2) then
      if value then
        Machine2:SetAnim("working")
      else
        Machine2:SetAnim("idle1")
      end
    end
  elseif name == "Machine3On" then
    if actors.Actor.IsValid(Machine3) then
      if value then
        Machine3:SetAnim("working")
      else
        Machine3:SetAnim("idle1")
      end
    end
  elseif name == "Machine4On" then
    if actors.Actor.IsValid(Machine4) then
      if value then
        Machine4:SetAnim("working")
      else
        Machine4:SetAnim("idle1")
      end
    end
  end

  if value and (xLastTrueTime < 0) then
    if (name == "Started") then
      BigBoss:Say("intruders")
      StartTime = xTimeNow
      if not TeleportUsed then
        if not TeleportObjective then
          TeleportObjective = ui.Objectives:Add("Teleport", 1, "Clean up time:", "3:00")
        end  
        local Commander = GetCommander(GetPlayerFaction())
        if actors.Actor.IsValid(Commander) then
          Commander:Say("hurry-junkyard")
        end
      end  
    elseif (name == "TeleportUsed") then
      TeleportUsed = true
      if not TeleportArtifactDespawned then
        local Commander = GetCommander(GetPlayerFaction())
        if actors.Actor.IsValid(Commander) then
          Commander:Say("ported on time")
        end
        --if TeleportObjective then
        --  TeleportObjective.Row11:Set(" ")
        --  TeleportObjective.Row12:Set(" ")
        --end  
      end
      if TeleportObjective then
        ui.Objectives:Del(TeleportObjective)
        TeleportObjective = nil
        if not GorgarObjective and actors.Actor.IsValid(Gorgar) then
          GorgarObjective = ui.Objectives:Add("Defeat Gorgar the Late", 1, " ", " ")
        end  
      end
    elseif (name == "KirxxaIsDead") then
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:Say("kirxxa dead")
      end
    elseif (name == "GorgarDead") then
      if GorgarObjective then
        ui.Objectives:Del(GorgarObjective)
        GorgarObjective = nil
      end
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:Say("gorgar dead")
        if not BigBossObjective then
          BigBossObjective = ui.Objectives:Add("Defeat Trashmaster Ditz", 1, " ", " ")
        end  
      end
    elseif (name == "DespawnTeleportArtifact") then
      TeleportArtifactDespawned = true
      if actors.Actor.IsValid(TeleportArtifact) then
        TeleportArtifact:SetVar("hidden", 1)
      end 
      if not TeleportUsed then
        local Commander = GetCommander(GetPlayerFaction())
        if actors.Actor.IsValid(Commander) then
          Commander:Say("late with port")
        end
        if TeleportObjective then
          TeleportObjective.Row11:Set(" ")
          TeleportObjective.Row12:Set(" ")
        end  
      end
    elseif (name == "SpawnGorgarExtraItem") then
      if actors.Actor.IsValid(GorgarExtraItem) then
        GorgarExtraItem:SetVar("hidden", 0)
      end  
    elseif (name == "SpawnBossExtraItem") then
      if actors.Actor.IsValid(BossExtraItem) then
        BossExtraItem:SetVar("hidden", 0)
      end  
    elseif (name == "BossEngaged") then
      if actors.Actor.IsValid(BigBoss) then
        if not BigBossObjective then
          BigBossObjective = ui.Objectives:Add("Defeat Trashmaster Ditz", 1, " ", " ")
        end  
        BigBoss:Say("coming")
        BigBoss:SetVar("path", "BossPath")
      end  
      if actors.Actor.IsValid(BossGate) then
        BossGate:CloseGate({})
      end
      TeleportUnits(1, nil, "!BossArea", "all", "BigLightningStrike02")
      TeleportUnits(2, nil, "!BossArea", "all", "BigLightningStrike02")
      TeleportUnits(3, nil, "!BossArea", "all", "BigLightningStrike02")
    elseif (name == "Teleport4Used") then
        local Commander = GetCommander(GetPlayerFaction())
        if actors.Actor.IsValid(Commander) then
          Commander:Say("reinforcements")
        end 
	elseif (name == "BossExited") then
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:SetVar("path", "")
        BigBoss:SetVar("sight", -1)
      end  
    elseif (name == "SpawnTechnicians") then
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:Say("call technicians")
      end
    elseif (name == "ABotWave") then
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:Say("a-bot wave")
      end
    elseif (name == "NomadWave") then
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:Say("nomad wave")
      end
    elseif (name == "MachinesWave") then
      if actors.Actor.IsValid(BigBoss) then
        BigBoss:Say("machines wave")
      end
    elseif (name == "BossDead") then
      if actors.Actor.IsValid(DitzItem) then
        DitzItem:SetVar("hidden", 0)
      end
      if BigBossObjective then
        ui.Objectives:Del(BigBossObjective)
        BigBossObjective = nil
      end
    elseif (name == "SpawnXessk") then
      if not SpiderObjective then
        SpiderObjective = ui.Objectives:Add("Defeat Xessk", 1, " ", " ")
      end  
    elseif (name == "SpawnXesskItem") then
      if actors.Actor.IsValid(XesskItem) then
        XesskItem:SetVar("hidden", 0)
      end  
      if SpiderObjective then
        ui.Objectives:Del(SpiderObjective)
        SpiderObjective = nil
      end
    end
  end
end

function GetTeleportDest()
  if g_nTeleportDest < 1 then
    local iRnd1 = SIRND(1, 100)
    local iRnd2 = SIRND(1, 100)
    if iRnd1 < 50 then
      g_ptTeleportDest[1] = GetNamedObjectPos("TDest1")
      if (iRnd2 < 50) then
        g_ptTeleportDest[2] = GetNamedObjectPos("TDest2")
        g_ptTeleportDest[3] = GetNamedObjectPos("TDest3")
        print("Teleport order: 1,2,3")
      else
        g_ptTeleportDest[2] = GetNamedObjectPos("TDest3")
        g_ptTeleportDest[3] = GetNamedObjectPos("TDest2")
        print("Teleport order: 1,3,2")
      end  
    else
      g_ptTeleportDest[1] = GetNamedObjectPos("TDest2")
      if (iRnd2 < 50) then
        g_ptTeleportDest[2] = GetNamedObjectPos("TDest1")
        g_ptTeleportDest[3] = GetNamedObjectPos("TDest3")
        print("Teleport order: 2,1,3")
      else
        g_ptTeleportDest[2] = GetNamedObjectPos("TDest3")
        g_ptTeleportDest[3] = GetNamedObjectPos("TDest1")
        print("Teleport order: 2,3,1")
      end  
    end
    g_nTeleportDest = 1
  end
  local pt = g_ptTeleportDest[g_nTeleportDest]
  if g_nTeleportDest < 3 then
    g_nTeleportDest = g_nTeleportDest + 1
  end 
  return pt
end

function TeleportUnitsThread(src_area, iFact)
  return function ()
    local ptDest = GetTeleportDest()
    TeleportUnits(iFact, ptDest, src_area, "officers", "BigLightningStrike02", "respawn_react")
    TeleportUnits(iFact, nil, nil, "non_officers", "BigLightningStrike02")
    sleep(1)
    if iFact == GetPlayerFaction() then
      game.SetCameraPos(ptDest)
    end  
    return "SUCCESS"
  end
end

function UseTeleport1(switch, user)
  local iFact = user:GetFaction()
  print("Player " .. iFact .. " used teleport 1")
  CreateThread(TeleportUnitsThread("TSrc1", iFact))
end

function UseTeleport2(switch, user)
  local iFact = user:GetFaction()
  print("Player " .. iFact .. " used teleport 2")
  CreateThread(TeleportUnitsThread("TSrc2", iFact))
end

function UseTeleport3(switch, user)
  local iFact = user:GetFaction()
  print("Player " .. iFact .. " used teleport 3")
  CreateThread(TeleportUnitsThread("TSrc3", iFact))
end

function UseTeleport4(switch, user)
  local iFact = user:GetFaction()
  print("Player " .. iFact .. " used teleport 4")
  local ptDest = GetNamedObjectPos("TDest4") or user:GetPos()
  TeleportUnits(iFact, ptDest, nil, "non_officers", "BigLightningStrike02", "respawn_react")
end

function UpdateObjectives()
  sleep(0.5)
  if actors.Actor.IsValid(GorgarExtraItem) then
    GorgarExtraItem:SetVar("hidden", 1)
  end  
  if actors.Actor.IsValid(DitzItem) then
    DitzItem:SetVar("hidden", 1)
  end
  if actors.Actor.IsValid(BossExtraItem) then
    BossExtraItem:SetVar("hidden", 1)
  end
  if actors.Actor.IsValid(XesskItem) then
    XesskItem:SetVar("hidden", 1)
  end
  
  while true do
    if TeleportObjective and not TeleportUsed and not TeleportArtifactDespawned then
      local xPassed = GetTime() - StartTime
      local xLeft = 180 - xPassed
      if xLeft < 0 then xLeft = 0 end
      TeleportObjective.Row12:Set(SecondsToStr(xLeft))
      if xLeft > 61 then
        TeleportObjective.Row12:SetColor(ui.colors.white)
        --ui.FlashWND(TeleportObjective.Row12, 0)
      elseif xLeft > 31 then
        TeleportObjective.Row12:SetColor(ui.colors.yellow)
        --ui.FlashWND(TeleportObjective.Row12, 0)
      else  
        TeleportObjective.Row12:SetColor(ui.colors.red)
        ui.FlashWND(TeleportObjective.Row12, 0.1)
      end
    end

    sleep(1)
  end
end

CreateThread(UpdateObjectives)