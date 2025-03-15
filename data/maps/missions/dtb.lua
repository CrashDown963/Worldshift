local Frank = GetNamedObject("Frank")
local Adam = GetNamedObject("Adam")
local CagesItem = GetNamedObject("CagesItem")
local FrankItem = GetNamedObject("FrankItem")
local AdamItem = GetNamedObject("AdamItem")
local HardReward = GetNamedObject("HardReward")
local BossHologram = GetNamedObject("BossHologram")


local InvestigateObjective
local AdamObjective
local FrankObjective

local bPlayerDefeated

local bBossEngaged

local hBeams = {}
local EnabledBeams = {}

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  local cname
  if actors.Actor.IsValid(actor) then
    local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
    cname = cactor .. ":" .. name
  else
	  cname = name;
  end	
  print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value) .. "(last true: " .. xLastTrueTime .. ")")
  
  if name == "AD1On2" then
    EnabledBeams[1] = value
    UpdateBeams()
  elseif name == "AD2On2" then
    EnabledBeams[2] = value
    UpdateBeams()
  elseif name == "AD3On2" then
    EnabledBeams[3] = value
    UpdateBeams()
  elseif name == "AD4On2" then
    EnabledBeams[4] = value
    UpdateBeams()
  end
  
  if value and (xLastTrueTime < 0) then
    if (name == "BossInCombat") then  
      bBossEngaged = true
    elseif (name == "DoorsEventStarted") then
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("at cages")
      end
    elseif (name == "DoorsEventFinished") then
      if actors.Actor.IsValid(CagesItem) then
        CagesItem:SetVar("hidden", 0)
      end
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("cages done")
      end
    elseif (name == "PlayerAtAdam") then  
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("at adam")
      end
      if actors.Actor.IsValid(Adam) then
        if actors.Actor.IsValid(Frank) then
          if not bBossEngaged then
            Adam:Say("got company")
            Frank:Say("entertain guests")
            Adam:Say("come to adam")
          end  
        else
          Adam:Say("you killed frank")
        end
      end
      AdamObjective = ui.Objectives:Add("kill_adam", 1, " ", " ")
    elseif (name == "AdamDead") then  
      if AdamObjective then
        ui.Objectives:Del(AdamObjective)
        AdamObjective = nil
      end
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("adam dead")
      end
      if actors.Actor.IsValid(Frank) then
        Frank:Say("you killed adam")
      end
      if actors.Actor.IsValid(AdamItem) then
        AdamItem:SetVar("hidden", 0)
      end
    elseif (name == "PlayerAtFrank") then  
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("at frank")
      end
      if InvestigateObjective then
        ui.Objectives:Del(InvestigateObjective)
        InvestigateObjective = nil
      end
      FrankObjective = ui.Objectives:Add("kill_frank", 1, " ", " ")
    elseif (name == "FrankInCombat") then
      if actors.Actor.IsValid(Frank) then
        if actors.Actor.IsValid(Adam) then
          Frank:Say("adam watch me")
        else
          Frank:Say("revenge for adam")
        end
      end
    elseif (name == "SpawnBossHologram") then
      if FrankObjective then
        ui.Objectives:Del(FrankObjective)
        FrankObjective = nil
      end
      local Commander = GetCommander(GetPlayerFaction())
      if actors.Actor.IsValid(Commander) then
        Commander:Say("frank dead")
      end
      if actors.Actor.IsValid(BossHologram) then
        BossHologram:SetVar("hidden", 0)
        BossHologram:Say("come try me")
        if actors.Actor.IsValid(Commander) then
          Commander:Say("will come")
        end
      end
      if actors.Actor.IsValid(FrankItem) then
        FrankItem:SetVar("hidden", 0)
      end
    elseif (name == "GiveHardReward") then
      if actors.Actor.IsValid(HardReward) then
        HardReward:SetVar("hidden", 0)
      end
    elseif (name == "HideBossHologram") then
      if actors.Actor.IsValid(BossHologram) then
        BossHologram:SetVar("hidden", 1)
      end
    end
   end  
end

function UpdateBeams()
  for i = 1,4 do
    local hTop = GetNamedObjectHandle("BT" .. i);
    local hBottom = GetNamedObjectHandle("BB" .. i);
    if hTop and hBottom then
      if EnabledBeams[i] and not hBeams[i] then
        hBeams[i] = CreateP2PBeam("DrainLifeLightning", hTop, hBottom, "pt_ground", "pt_top")
      elseif not EnabledBeams[i] and hBeams[i] then
        RemoveP2PBeam(hBeams[i])
        hBeams[i] = nil
      end  
    end
  end
end

function ResetBeams()
  sleep(2)
  for i = 1,4 do
    if hBeams[i] then
      RemoveP2PBeam(hBeams[i])
      hBeams[i] = nil 
    end  
  end
  UpdateBeams();
  return "SUCCESS"
end

function RechargeAdam(params)
  local iBeams = 0
  for i = 1,4 do
    if hBeams[i] then
      iBeams = iBeams + 1
      local hTop = GetNamedObjectHandle("BT" .. i);
      if hTop then
        RemoveP2PBeam(hBeams[i])
        hBeams[i] = CreateP2PBeam("DrainLifeLightning", hTop, params.actor, "pt_ground", "pt_chest")
      end
    end
  end
  if iBeams < 1 then return end
  local amount = params.actor:GetMaxHP() * iBeams / 4;
  params.actor:Heal(amount)
  CreateThread(ResetBeams)
end

function UpdateObjectives()
  sleep(0.5)

  local Commander = GetCommander(GetPlayerFaction())
  if actors.Actor.IsValid(Commander) then
    Commander:Say("lets move")
  end
  
  InvestigateObjective = ui.Objectives:Add("investigate_dtb", 1, " ", " ")

  while true do
    sleep(1)
  end  
end

CreateThread(UpdateObjectives)
