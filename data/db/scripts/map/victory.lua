g_iFactStatus = {} -- nil: defeated from start, 1: acive, 2: defeated, 3: victorious
local sMsg = nil
local iMsgPriority = -1

g_bPlayerDefeated = false
g_bAllDefeated = false
g_sLeaderID = nil

local function Msg(s, p, param)
  if not s then
    sMsg = nil
    iMsgPriority = -1
  elseif (p or 0) > iMsgPriority then
    sMsg = ui.TEXT{s, param}
    iMsgPriority = (p or 0)
  end  
end

function CheckPvPVictory()
  local iPlayer = GetPlayerFaction()
  
  while true do
    local bActiveEnemy = false
    local bDefeatedEnemy = false
    Msg(nil)
    for iFact = 1,9 do
      if IsFactionDefeated(iFact) then
        if g_iFactStatus[iFact] == 1 then
          g_iFactStatus[iFact] = 2
          if iFact == iPlayer then
            PLEvent("PvPEnd", "lost");
            Msg("victory_defeat", 2)
            SetPlayerWin(false)
          else
            Msg("victory_playerdefeated", 1, iFact)
          end  
        end
      else
        if g_iFactStatus[iFact] == 2 then
          if iFact == iPlayer then
            Msg("victory_nolongerdefeated")
          else
            Msg("victory_playernolongerdefeated", nil, iFact)
          end  
        end
        if g_iFactStatus[iFact] ~= 3 then
          g_iFactStatus[iFact] = 1
        end  
      end
      if IsEnemyFaction(iPlayer, iFact) then
        if g_iFactStatus[iFact] == 1 then
          bActiveEnemy = true
        elseif g_iFactStatus[iFact] == 2 then
          bDefeatedEnemy = true
        end  
      end
    end
    
    if (not bActiveEnemy) and (g_iFactStatus[iPlayer] == 1) and (game.IsMultiplayer() or bDefeatedEnemy) then
      PLEvent("PvPEnd", "won");
      g_iFactStatus[iPlayer] = 3
      Msg("victory_victory", 2)
      SetPlayerWin(true)
    elseif bActiveEnemy and (g_iFactStatus[iPlayer] == 3) then
      g_iFactStatus[iPlayer] = 1
      Msg("victory_nolongervictory")
    end
    if sMsg then
      ui.ErrText:ShowText(sMsg)
      if iMsgPriority >= 2 then
        if not game.IsMultiplayer() then
          Pause()
        end  
        ui.Victory:Show()
      end
    end
    sleep(5)
  end  
end

local function GetDeadAvatarInfo(tAvatarsInfo)
  local hDeadAvatar
  local hAliveAvatar
  
  for k, v in pairs(tAvatarsInfo) do
    if not hAliveAvatar and actors.Actor.IsValid(k) then
      hAliveAvatar = k
    end
    if not hDeadAvatar and not actors.Actor.IsValid(k) then
      hDeadAvatar = k
    end
  end
  
  return tAvatarsInfo[hDeadAvatar], tAvatarsInfo[hAliveAvatar]
end

local function CreateAvatarInfo(tAvatars)
  if not tAvatars then return nil end
  local tAvatarsInfo = {}
  
  for i, avatar in ipairs(tAvatars) do
    tAvatarsInfo[avatar.h] = {
      h = avatar.h,
      name = avatar:GetVar("name_var", "str"),
      conv_icon = avatar:GetVar("name_var", "str")
    }
  end
  
  return tAvatarsInfo
end

g_bCheatWin = nil

function CheatWinMission()
  g_bCheatWin = true
end

function WinMission(descr)
  if onVictory and onVictory() then return false end
  PLEvent("MisWon", GetName());
  GiveMissionRewards()
  ui.Victory.description = ui.TEXT(descr or "victory_missiondone")
  SetPlayerWin(true)
  Pause()
  ui.Victory:Show()
  return true
end

function LoseMission(descr)
  if onDefeat and onDefeat() then return false end
  PLEvent("MisLost", GetName());
  ui.Victory.description = ui.TEXT(descr or "victory_missionfail")
  SetPlayerWin(false)
  Pause()
  ui.Victory:Show()
  return false --true
end

local function CheckMissionVictory()
  local tAvatarsInfo = CreateAvatarInfo(GetNamedGroup("Avatars"))
 
  while true do
    if g_bCheatWin then
      g_bCheatWin = nil
      if WinMission("victory_missiondone") then
        return "SUCCESS"
      end
    end

    if tAvatarsInfo then 
      local tDeadAvatar, tAliveAvatar = GetDeadAvatarInfo(tAvatarsInfo)
      if tDeadAvatar then
        if not onDeadAvatar or not onDeadAvatar(tDeadAvatar, tAliveAvatar) then
          local sName = tDeadAvatar.name
          if LoseMission(sName .. "_dead") then
            return "SUCCESS"
          end
        end
      end -- if tDeadAvatar
    end
    
    local fVictoryTime = GetConditionLastTrueTime("Victory")
    local fDefeatTime = GetConditionLastTrueTime("Defeat")
    
    if fVictoryTime or fDefeatTime then 
      if fVictoryTime and fVictoryTime ~= -1 then
        if WinMission("victory_missiondone") then
          return "SUCCESS"
        end
      end
      if fDefeatTime and fDefeatTime ~= -1 then
        if LoseMission("victory_missionfail") then
          return "SUCCESS"
        end
      end
    end
    sleep(1)
  end
end

local function SetSLPlayerLeaderDead(bDead)
  g_bPlayerDefeated = bDead
  HidePlayerActions(bDead);
  if bDead then
    ui.LeaderDead.visible = true
    ui.LeaderDead:Show()
  else
    ui.LeaderDead.visible = false
    ui.LeaderDead:Hide()
  end
end

function onRessurectSwitchUse(Switch, User)
  local id = Switch:GetVar("leader_id", "str")
  if not id then return end
  local h = Switch:GetVar("leader_handle", "int") or 0
  local fact = Switch:GetFaction()
  --print("Ressurecting " .. id .. "(" .. h .. ") faction " .. fact);
  local Leader = ResurrectLeader(fact, id, Switch:GetPos(), h)
  if not Leader then
    return
  end
  local RanBoo = GetNamedObject("RanBoo")
  if RanBoo then
    local RanBooTarget = RanBoo:GetVar("idle_follow", "int")
    if RanBooTarget and RanBooTarget == h then
      RanBoo:SetVar("idle_follow", Leader.h)
      RanBoo:SetVar("reset_prg", 0)
    end
  end
  Leader:CreateReact("teleport_officer_humans")
  if fact == GetPlayerFaction() then
    SetSLPlayerLeaderDead(false)
  end
end

local function CheckSpecialLocationVictory()
  while true do
    if g_bCheatWin then
      g_bCheatWin = nil
      if not onVictory or not onVictory() then 
        --GiveMissionRewards()
        ui.Victory.description = ui.TEXT("victory_missiondone")
        SetPlayerWin(true)
        Pause()
        ui.Victory:Show()
        return "SUCCESS"
      end
    end

    local fVictoryTime = GetConditionLastTrueTime("Victory")
    local fDefeatTime = GetConditionLastTrueTime("Defeat")
    
    if fVictoryTime or fDefeatTime then 
      if fVictoryTime and fVictoryTime ~= -1 then
        if not onVictory or not onVictory() then 
          PLEvent("SLWon", GetName());
          ui.Victory.description = ui.TEXT("victory_missiondone")
          SetPlayerWin(true)
          Pause()
          ui.Victory:Show()
          return "SUCCESS"
        end
      end
      if fDefeatTime and fDefeatTime ~= -1 then
        g_bPlayerDefeated = true
        if not onDefeat or not onDefeat() then
          ui.Victory.description = ui.TEXT("victory_missionfail")
          PLEvent("SLLost", GetName());
          SetPlayerWin(false)
          Pause()
          ui.Victory:Show()
          return "SUCCESS"
        end
      end
    end
    
    if not g_bPlayerDefeated then
      local Commander = GetCommander(GetPlayerFaction())
      if not actors.Actor.IsValid(Commander) then
       if g_sLeaderID then
          ui.Victory.description = ui.TEXT(g_sLeaderID .. "_dead")
        else
          ui.Victory.description = ui.TEXT("victory_missionfail")
        end  
        SetSLPlayerLeaderDead(true)
        --if not onDefeat or not onDefeat(GetPlayerFaction()) then
          --g_bPlayerDefeated = true
          --if g_sLeaderID then
            --ui.Victory.description = ui.TEXT(g_sLeaderID .. "_dead")
          --else
            --ui.Victory.description = ui.TEXT("victory_missionfail")
          --end  
          --PLEvent("SLLost", GetName())
          --SetPlayerWin(false)
          --ui.Victory:Show()
        --end
      elseif not g_sLeaderID then
        g_sLeaderID = Commander:GetName()
      end
    end
    
    if not g_bAllDefeated then
      if (not actors.Actor.IsValid(GetCommander(1))) and
         (not actors.Actor.IsValid(GetCommander(2))) and
         (not actors.Actor.IsValid(GetCommander(3))) then
        g_bAllDefeated = true
        if not onDefeat or not onDefeat(GetPlayerFaction()) then
          if g_sLeaderID then
            ui.Victory.description = ui.TEXT(g_sLeaderID .. "_dead")
          else
            ui.Victory.description = ui.TEXT("victory_missionfail")
          end  
          PLEvent("SLLost", GetName())
          SetPlayerWin(false)
          ui.Victory:Show()
        end
        Pause() 
        return "SUCCESS"
      end   
    end  

    sleep(1)
  end  
end


local function VCStart()
  sleep(0.5)
  local sName = GetName();

  if GetType() == "mission" then
    PLEvent("MisStart", sName)
    CreateThread(CheckMissionVictory);
    return "SUCCESS"
  end
  
  if GetType() == "special_location" then
    PLEvent("SLStart", sName .. "|" .. (DumpPlayerForce() or ""))
    CreateThread(CheckSpecialLocationVictory);
    return "SUCCESS"
  end
  
  if GetType() == "random" then
    PLEvent("PvPStart", sName .. "|" .. DumpPlayerForce())
    CreateThread(CheckPvPVictory)
    return "SUCCESS"
  end  
  
  return "SUCCESS"
end

CreateThread(VCStart)
