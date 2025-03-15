local AI_THINK_INTERVAL = 1

local AI_FIRST_ATTACK_TIME = 360
local AI_ATTACK_INTERVAL_MIN = 45
local AI_ATTACK_INTERVAL_MAX = 150

local AI_BUILD_LIST_RECALC_INTERVAL_MIN = 120
local AI_BUILD_LIST_RECALC_INTERVAL_MAX = 300

local AI_NEXT_UNIT_TYPE_RECALC_INTERVAL = 30

local g_fAITime = nil

--g_fAIAttackTime = {}
g_fAIBuildListRecalcTime = {}
g_fAINextUnitTypeRecalcTime = {}
g_sAINextUnitType = {}
g_nAINextUnitCount = {}
g_AIVars = {}

function GetAIVar(fact, var)
  if not g_AIVars[fact] then return nil end
  return g_AIVars[fact][var]
end

function SetAIVar(fact, var, val)
  if not g_AIVars[fact] then 
    g_AIVars[fact] = {}
  end
  g_AIVars[fact][var] = val  
end

local function AIProduceUnits(fact)
  if not g_fAIBuildListRecalcTime[fact] or g_fAITime >= g_fAIBuildListRecalcTime[fact] then
    
    if g_fAIBuildListRecalcTime[fact] then
      AIPickBuildList(fact)
    else
      AIPickBuildList(fact, true)
      AISpawn(fact)
      AIPickBuildList(fact)
    end
    g_fAIBuildListRecalcTime[fact] = g_fAITime + SIRND(AI_BUILD_LIST_RECALC_INTERVAL_MIN, AI_BUILD_LIST_RECALC_INTERVAL_MAX)
  end  
  if not g_fAINextUnitTypeRecalcTime[fact] or g_fAITime >= g_fAINextUnitTypeRecalcTime[fact] then
    g_fAINextUnitTypeRecalcTime[fact] = g_fAITime + AI_NEXT_UNIT_TYPE_RECALC_INTERVAL
    local ut, need = AIPickUnitToBuild(fact)
    g_sAINextUnitType[fact] = ut
    g_nAINextUnitCount[fact] = need
    if not ut then
      g_fAINextUnitTypeRecalcTime[fact] = nil
      return
    end  
    --print("AI " .. fact .. " next unit(s) " .. g_sAINextUnitType[fact] .. ": " .. g_nAINextUnitCount[fact])
  end
  local cnt = GetNumObjects(fact, g_sAINextUnitType[fact])
  if cnt < g_nAINextUnitCount[fact] then
    if AIProduce(fact, g_sAINextUnitType[fact]) then
      --print("AI " .. fact .. " producing " .. g_sAINextUnitType[fact])
    end
  else
    g_fAINextUnitTypeRecalcTime[fact] = nil
  end
end

local function AIThink(fact)
  if not IsFactionAIEnabled(fact) then return end
  AIProduceUnits(fact)
  AIAssignUnits(fact)
  if GetRes(fact) >= 500 then
    local h, act = FindActorByActionByClass(fact, "CUpgradeAction")
    if h and act then h:ExecuteAction(act, {}) end
  end  
end

local function AIMain()
  g_fAITime = GetTime()
  while true do
    local fTime = GetTime()
    while fTime - g_fAITime >= AI_THINK_INTERVAL do 
      g_fAITime = g_fAITime + AI_THINK_INTERVAL
      for fact=1,9 do
        AIThink(fact)
      end  
    end
    sleep()
  end
end

local function AIStart()
  if GetType() == "mission" or GetType() == "special_location" then
    return;
  end  
  CreateThread(AIMain)
end

AIStart()
