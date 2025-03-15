local BigPriest = GetNamedObject("BigPriest")
local RanBoo = GetNamedObject("RanBoo")
local BigBoss = GetNamedObject("BigBoss")
local BigBossArtifact = GetNamedObject("BigBossArtifact")
local Xelrad = GetNamedObject("Xelrad")
local VillageItem = GetNamedObject("VillageItem")
local RetaliateItem = GetNamedObject("RetaliateItem")
local DeviceItem = GetNamedObject("DeviceItem")

local PSSW = {}
PSSW[1] = GetNamedObject("PSSW1")
PSSW[2] = GetNamedObject("PSSW2")
PSSW[3] = GetNamedObject("PSSW3")
PSSW[4] = GetNamedObject("PSSW4")
PSSW[5] = GetNamedObject("PSSW5")
PSSW[6] = GetNamedObject("PSSW6")
local PSSWUsed = 0
local ADSW = GetNamedObject("ADSW")

local BBT = {}
BBT[1] = GetNamedObject("BBT1")
BBT[2] = GetNamedObject("BBT2")
BBT[3] = GetNamedObject("BBT3")

local BPSW = {}
BPSW[1] = GetNamedObject("BPSW1")
BPSW[2] = GetNamedObject("BPSW2")
BPSW[3] = GetNamedObject("BPSW3")
local BPSWOfs = {}

local TalkObjective
local DefendVillageObjective
local RetaliateObjective
local PowerSourcesObjective
local XelradObjective
local BigBossObjective

local CheckNomadWave

local BigBossCombatStartTime
local NextBBSpawnTime
local BBSPAWN_INTERVAL = 30

local RanBooTarget

local BBSapwnVars = " { despawn_condition = DespawnBossAdds; sight = -1; sight_incombat = -1; sight_area = BigBossArea; chase_range = -1 }"
local BBSpawnVariants = {
  [1] = { GarbageHealer = 2, Nomad = 5 },
  [2] = { GarbageHealer = 1, Nomad = 2, GarbageAssaulter = 1, KharumBossTechnician = 1 },
  [3] = { Nomad = 5, GarbageAssaulter = 3 },
  [4] = { GarbageAssaulter = 2, KharumBossTechnician = 2, GarbageHellfire = 1 },
  [5] = { GarbageHellfire = 3 },
  [6] = { KharumBossTechnician = 3 },
  [7] = { Scavenger2 = 2 },
}

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  local cname
  if actors.Actor.IsValid(actor) then
    local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
    cname = cactor .. ":" .. name
  else
	  cname = name;
  end	
  print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value))

  if name == "BigBossInCombat" then
    if value then
      BigBoss:Say("i kill you")
      if (xLastTrueTime < 0) then
        if BigBossObjective then
          ui.Objectives:Del(BigBossObjective)
          BigBossObjective = nil
        end
        BigBossObjective = ui.Objectives:Add("Defeat Trashmaster Ulv", 1, " ", " ")
      end  
      BigBossCombatStartTime = GetTime()
      NextBBSpawnTime = BigBossCombatStartTime
    else
      BigBossCombatStartTime = nil
      NextBBSpawnTime = nil
    end
  elseif name == "Spawn" and value and actors.Actor.IsValid(actor) and actors.Actor.IsValid(BigPriest) then
    if BPSWOfs.x and (actor == BPSW[1] or actor == BPSW[2] or actor == BPSW[3]) then
      local ptP = BigPriest:GetPos()
      local ptS = {}
      ptS.x = ptP.x + BPSWOfs.x
      ptS.y = ptP.y + BPSWOfs.y
      ptS.z = ptP.z + BPSWOfs.z
      actor:SetPos(ptS)
    end  
  end
  
  if value and (xLastTrueTime < 0) then
    if (name == "XelradInCombat") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("kill Xelrad")
      end
      XelradObjective = ui.Objectives:Add("Kill Xelrad", 1, " ", " ")
      elseif (name == "XelradDead") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("killed Xelrad")
      end
      if XelradObjective then
        ui.Objectives:Del(XelradObjective)
        XelradObjective = nil
      end
    end
  end

  if value and (xLastTrueTime < 0) then
    if (name == "NomadWave") then
      CheckNomadWave = true
      BigPriest:Say("nomad wave")
      ui.Objectives:Del(TalkObjective)
      TalkObjective = nil
      DefendVillageObjective = ui.Objectives:Add("Protect the village", 1, "Help the villagers to survive the attack", " ")
    elseif (name == "NomadWaveDead") then
      if actors.Actor.IsValid(VillageItem) then
        VillageItem:SetVar("hidden", 0)
      end
      CheckNomadWave = nil
      BigPriest:Say("nomad wave dead")
      ui.Objectives:Del(DefendVillageObjective)
      DefendVillageObjective = nil
      TalkObjective = ui.Objectives:Add("Village is safe", 1, "Talk to the village's High Priest", " ")
    elseif (name == "Retaliate") then
      BigPriest:Say("retaliate")
      ui.Objectives:Del(TalkObjective)
      TalkObjective = nil
      RetaliateObjective = ui.Objectives:Add("Eliminate the threat", 1, "Attack sources neutralized:", "0/4")
    elseif (name == "Retaliated") then
      if actors.Actor.IsValid(RetaliateItem) then
       RetaliateItem:SetVar("hidden", 0)
      end
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
       Commander:Say("retaliated")
      end
      ui.Objectives:Del(RetaliateObjective)
      RetaliateObjective = nil
      TalkObjective = ui.Objectives:Add("Threat eliminated", 1, "Talk to the village's High Priest", " ")
    elseif (name == "TalkToRanBoo") then
      BigPriest:Say("talk to ran boo")
      ui.Objectives:Del(TalkObjective)
      TalkObjective = nil
      TalkObjective = ui.Objectives:Add("Talk to Ran Boo", 1, "Find Ran Boo", " ")
    elseif (name == "SpawnRanBoo") then  
      RanBoo:SetVar("hidden", 0)
      RanBoo:Say("ran boo spawned")
    elseif (name == "PowerSourcesActivated") then
      if PowerSourcesObjective then
        PowerSourcesObjective.Row11:Set("Return to the village")
        PowerSourcesObjective.Row12:Set(" ")
      end
    elseif (name == "ADActivated") then
      if actors.Actor.IsValid(DeviceItem) then
        DeviceItem:SetVar("hidden", 0)
      end
      RanBoo:Say("ancient device activated")
      SetNamedObjectVar("ADAnim", "hidden", 0)
      if PowerSourcesObjective then
        ui.Objectives:Del(PowerSourcesObjective)
        PowerSourcesObjective = nil
      end
      BigBossObjective = ui.Objectives:Add("Engage Trashmaster Ulv", 1, "Find Trashmaster Ulv in the northern hideout", " ")
    elseif (name == "BossDead") then
      if actors.Actor.IsValid(BigBossArtifact) then
        BigBossArtifact:SetVar("hidden", 0)
      end
      if BigBossObjective then
        ui.Objectives:Del(BigBossObjective)
        BigBossObjective = nil
      end
    end
  end
end

function RanBooFollow(switch, user)
  if not actors.Actor.IsValid(RanBoo) then return end
  RanBooTarget = user
  RanBoo:SetVar("hold_fire", 0)
  RanBoo:SetVar("attackable", 1)
  RanBoo:Say("lets go")
  PowerSourcesObjective = ui.Objectives:Add("Activate the ancient device", 1, "Power sources activated:", "0/3")
  ui.Objectives:Del(TalkObjective)
  TalkObjective = nil
  RanBoo:SetVar("idle_follow", RanBooTarget.h)
  local prm = { h = RanBooTarget }
  RanBoo:Execute("PrgIdle", prm)
  RunAfter(10, PingPSSW)
  CreateThread(CheckRanBooIdleFollow)
end

function RanBooFollow2(switch, user)
  if not actors.Actor.IsValid(RanBoo) then return end
  RanBooTarget = user
  RanBoo:SetVar("idle_follow", RanBooTarget.h)
  local prm = { h = RanBooTarget }
  RanBoo:Execute("PrgIdle", prm)
end

function CheckRanBooIdleFollow()
  local switch = nil
  local idle_start = nil
  while true do
    if not actors.Actor.IsValid(RanBoo) then return "SUCCESS" end
    if RanBoo:IsIdle() then
      if not switch then
        local now = GetTime()
        if not idle_start then
          idle_start = now
        elseif now - idle_start >= 5 then
          switch = SpawnObject("RanBooFollowSwitch", RanBoo:GetPos(), 0)
          switch:SetVar("z_offset", 104)
        end  
      end
    else
      idle_start = nil
      if switch then
        switch:Destroy()
        switch = nil
      end
    end
    sleep(0.2)
  end
end

function PowerSourceActivated(switch, user)
  for i = 1, 6 do
    if actors.Actor.IsValid(PSSW[i]) and PSSW[i].h == switch.h then
      PSSW[i] = nil
    end
  end  
  PSSWUsed = PSSWUsed + 1
  PowerSourcesObjective.Row12:Set(PSSWUsed .. "/3")
  if PSSWUsed >= 3 then
    SetCondition("PowerSourcesActivated", true)
    RanBoo:Say("last power source")
  end
  local prm = { h = RanBooTarget }
  RanBoo:Execute("PrgIdle", prm)
end

function PingPSSW()
  while true do
    for i = 1, 6 do
      if actors.Actor.IsValid(PSSW[i]) and PSSWUsed < 3 then
        CreateMapPing(PSSW[i]:GetPos(), "boss")
      end
    end  
    sleep(25)
  end
end


function CheckPSSWUse()
  if not actors.Actor.IsValid(RanBoo) then return end
  for i = 1, 6 do
    if actors.Actor.IsValid(PSSW[i]) and RanBoo:DistTo(PSSW[i]) <= 1200 and 
       RanBoo:GetPrimaryTarget() ~= PSSW[i] and SwitchUsable(PSSW[i], RanBoo) then
      RanBoo:Say("found power source")
      local prm = { h = PSSW[i] }
      RanBoo:Execute("PrgUseSwitch", prm)
    end
  end
end

function CheckADSWUse()
  if not actors.Actor.IsValid(RanBoo) then return end
  if not actors.Actor.IsValid(ADSW) then return end
  if RanBoo:GetPrimaryTarget() == ADSW then return end
  if RanBoo:DistTo(ADSW) > 3000 then return end
  if not SwitchUsable(ADSW, RanBoo) then return end
  RanBoo:Say("activating ancient device")
  local prm = { h = ADSW }
  RanBoo:Execute("PrgUseSwitch", prm)
end

function CheckBBSpawns()
  if not NextBBSpawnTime then return end
  if GetTime() < NextBBSpawnTime then return end
  NextBBSpawnTime = NextBBSpawnTime + BBSPAWN_INTERVAL

  for iBBT = 1, 3 do 
    if BBT[iBBT] then
      local sVT = ""
      local iType = SIRND(1,6)
      for id,cnt in pairs(BBSpawnVariants[iType]) do
        sVT = sVT .. id .. "=" .. cnt .. BBSapwnVars .. ";"
      end
      print("BBT " .. iBBT .. ": " .. sVT)
      SpawnObjects(sVT, BBT[iBBT]:GetPos(), 12)
    end  
  end  
end

function UpdateObjectives()
  if actors.Actor.IsValid(BigPriest) and actors.Actor.IsValid(BPSW[1]) then
    local ptP = BigPriest:GetPos()
    local ptS = BPSW[1]:GetPos()
    BPSWOfs.x = ptS.x - ptP.x
    BPSWOfs.y = ptS.y - ptP.y
    BPSWOfs.z = ptS.z - ptP.z
  end
  sleep(0.5)
 
  ExploreArea("KharumVillage", 1)
  ExploreArea("KharumVillage", 2)
  ExploreArea("KharumVillage", 3)
  RevealArea("KharumVillage", true);
  local Commander = GetCommander(GetPlayerFaction())
  if actors.Actor.IsValid(Commander) then
    Commander:Say("help village")
  end
  TalkObjective = ui.Objectives:Add("Help the village", 1, "Talk to the village's High Priest", " ")
  
  while true do
    CheckBBSpawns()
    
    if CheckNomadWave and IsGroupOfMobsDead("NomadWave") then
      SetCondition("NomadWaveDead", true)
    end
    
    if RetaliateObjective then
      local n = GetNumAliveInGroup("TD1") + GetNumAliveInGroup("TD2") + GetNumAliveInGroup("TD3") + GetNumAliveInGroup("TD4");
      RetaliateObjective.Row12:Set(4-n .. "/4")
    end

    if PowerSourcesObjective then
      if PSSWUsed < 3 then
        CheckPSSWUse()
      end
      CheckADSWUse()
    end
    
    sleep(1)
  end
end

CreateThread(UpdateObjectives)