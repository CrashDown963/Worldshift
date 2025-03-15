--local ScoutPosition = GetNamedObjectPos("ScoutPosition")
--local DefendersPosition = GetNamedObjectPos("DefendersPosition")
--local WarriorsPosition = GetNamedObjectPos("WarriorsPosition")

g_init.Scout = function() return GetNamedObject("Scout") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Eji = function() return GetNamedObject("Eji") end

--local MissionCommand = GetNamedObject("MissionCommand")

local ImbaSpawners = GetNamedGroup("ImbaSpawners")
local PlayerFaction = GetPlayerFaction()

--local GanthuWarriors = GetNamedGroup("GanthuWarriors")
--local PlayerSquad = GetNamedGroup("PlayerSquad")
--local WarriorsCount = GetNumAliveInGroup("GanthuWarriors")

g.CNDNAssassinsInCombat = false
g.CNDNRaghoScoutAtDefendersSite = false
g.CNDNGanthuAtEjiArea = false
g.CNDNRaghoConfronted = 0
g.CNDNRaghoKilled = 0
g.CNDNDespawnRaghoTraitor = false
g.CNDNRaghoFinalConfronted = false
g.CNDNRaghoFinalKilled = false
g.CNDNFinalWords = false

g.CheckAttackers = true
g.CheckVillageDefenders = true
g.PingEji = true
g.DisableVictory = false

g_Objectives.ProtectXenolite = {
  Create = function() return ui.Objectives:Add("Protect the xenolite", 1, "Defenders alive:", 0) end,
  Update = function(Objective)
    local DefendersLeft = GetNumAliveInGroup("Defenders")
    Objective.Row12:Set(DefendersLeft)
    if not g.CheckAttackers then return end
    if DefendersLeft == 0 then
      LoseMission("vic_13defdead")
      return
    end
    if IsGroupOfMobsDead("Attackers") then
      g.Ganthu:Say("last of them")
      SetCondition("SpawnRaghoScout", true)
      g.CheckAttackers = false
    end
  end
}  
  
g_Objectives.DefendVillage = {
  Create = function() return ui.Objectives:Add("Return to the village", 1, "Village defenders alive", " ") end,
  Update = function(Objective)
    local DefendersLeft = GetNumAliveInGroup("VillageDefenders")
    Objective.Row12:Set(DefendersLeft)
    if not g.CheckVillageDefenders then return end
    if DefendersLeft == 0 then
      LoseMission("vic_13vdefdead")
    end
  end
}

g_Objectives.SneakInCamp = {
  Create = function() return ui.Objectives:Add("Sneak in the camp", 1, "Use the passage to the southeast", " ") end
}  

g_Objectives.SaveEji = {
  Create = function() return ui.Objectives:Add("Escape the village", 1, "Go north with Eji", " ") end
}  

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  
  if "GanthuInRaghoArea1" == name then
    ForceImbaSpawners()
  elseif"GanthuInRaghoArea2" == name then
    ForceImbaSpawners()
  elseif"GanthuInRaghoArea3" == name then
    ForceImbaSpawners()
  elseif"GanthuInRaghoArea4" == name then
    ForceImbaSpawners()
  elseif "ScoutOnPosition" == name then
    g.Scout:SayTo(g.Ganthu, "under attack-13")
    g.Ganthu:SayTo(g.Scout, "take me there")
    RunAfter(6, function()
      ShowObjective("ProtectXenolite")
      g.Ganthu:SetInteractive(true)
      g.Scout:SetVar("path", "DefendersPosition")
      g.Ganthu:StopMoving()
      g.Ganthu:SetVar("reset_prg", true)
      g.Ganthu:SelectMe()
      RevealArea("StartArea", false)
    end)
  elseif not g.CNDNAssassinsInCombat and "AssassinsInCombat" == name then
    g.CNDNAssassinsInCombat = true
    local Assassin = GetNamedGroup("ChiefAssassin")[1]
    local Ragho = GetNamedGroup("RaghoTraitor")[1]
    
    if actors.Actor.IsValid(Ragho) and actors.Actor.IsValid(Assassin) and actors.Actor.IsValid(g.Ganthu) then
      Ragho:SayTo(Assassin, "kill him")
      Assassin:Say("die freak")
      g.Ganthu:SayTo(Ragho, "trap")
      Ragho:SayTo(g.Ganthu, "me traitor")
      g.Ganthu:Say("village endangered")
      Ragho:SetVar("faction", 12)
    end
    
    ExploreArea("EjiArea", 1)
    RevealArea("EjiArea", true)
    RunAfter(0, PingEji)
    ExploreArea("VillageDefendersArea", 1)
    RevealArea("VillageDefendersArea", true)
    CreateMapPing(GetNamedObjectPos("VillageDefendersPos"), "defense")
    HideAllObjectives()
    ShowObjective("DefendVillage")
  elseif not g.CNDNRaghoScoutAtDefendersSite and "RaghoScoutAtDefendersSite" == name then
    g.CNDNRaghoScoutAtDefendersSite = true
    local Ragho = GetNamedGroup("RaghoScout")[1]
    Ragho:SayTo(g.Ganthu, "diversion")
    g.Ganthu:SayTo(Ragho, "i will go")
    HideAllObjectives()
    ShowObjective("SneakInCamp");
  elseif not g.CNDNGanthuAtEjiArea and "GanthuAtEjiArea" == name then
    g.CNDNGanthuAtEjiArea = true
    g.PingEji = false
    g.Ganthu:SayTo(g.Eji, "come")
    g.Eji:SayTo(g.Ganthu, "yes master")
    g.Eji:SetVar("faction", 1)
    g.Eji:Execute("PrgIdle", { h = g.Ganthu }) 
    HideAllObjectives()
    ShowObjective("SaveEji")
    SetCondition("SpawnFinalAttackersFlag", false)
    g.CheckVillageDefenders = false
  elseif g.CNDNRaghoConfronted < 3 and "RaghoConfronted" == name then
    if g.CNDNRaghoConfronted == 0 then
      local Ragho = GetCurrentRagho()
      if Ragho then
        Ragho:SayTo(g.Ganthu, "you die eji sold")
        g.Ganthu:SayTo(Ragho, "not eji")
        Ragho:SayTo(g.Ganthu, "too late")
        if g_Objectives.DefendVillage.Objective then
          g_Objectives.DefendVillage.Objective.Title:Set("Save Eji")
        end  
      end
    elseif g.CNDNRaghoConfronted == 1 then
      local Ragho = GetCurrentRagho()
      if Ragho then
        g.Ganthu:SayTo(Ragho, "use skills")
        Ragho:SayTo(g.Ganthu, "strong leader")
      end
    elseif g.CNDNRaghoConfronted == 2 then
      local Ragho = GetCurrentRagho()
      if Ragho then
        g.Ganthu:SayTo(Ragho, "come to your senses")
        Ragho:SayTo(g.Ganthu, "no turning back")
      end
    end
    g.CNDNRaghoConfronted = g.CNDNRaghoConfronted + 1
  elseif g.CNDNRaghoKilled < 3 and "RaghoKilled" == name then
    if g.CNDNRaghoKilled == 0 then
      g.Ganthu:Say("disappeared")
    elseif g.CNDNRaghoKilled == 1 then
      g.Ganthu:Say("not again")
    elseif g.CNDNRaghoKilled == 2 then
      g.Ganthu:Say("just die")
    end
    g.CNDNRaghoKilled = g.CNDNRaghoKilled + 1
  elseif not g.CNDNRaghoFinalConfronted and "RaghoFinalConfronted" == name then
    g.CNDNRaghoFinalConfronted = true
    RaghoFinal = GetNamedGroup("RaghoFinal")[1]
    RaghoFinal:SayTo(g.Ganthu, "give child")
    g.Eji:SayTo(RaghoFinal, "what")
    g.Ganthu:SayTo(RaghoFinal, "never")
  elseif not g.CNDNRaghoFinalKilled and "RaghoFinalKilled" == name then
    g.CNDNRaghoFinalKilled = true
    g.Ganthu:Say("enough teleporting")
  elseif not g.CNDNDespawnRaghoTraitor and "DespawnRaghoTraitor" == name then
    g.CNDNDespawnRaghoTraitor = true
    g.Ganthu:Say("where did he go")
  end
end

function ForceImbaSpawners()
  for _, spawner in ipairs(ImbaSpawners) do spawner:ForceSpawnCheck() end
end

function PingEji()
  while g.PingEji do
    CreateMapPing(GetNamedObjectPos("Eji"), "defense")
    sleep(20)
  end
end

function GetCurrentRagho()
  local CurrentRagho = GetNamedGroup("RaghoSpawner1")[1]
  if CurrentRagho then return CurrentRagho end
  CurrentRagho = GetNamedGroup("RaghoSpawner2")[1]
  if CurrentRagho then return CurrentRagho end
  CurrentRagho = GetNamedGroup("RaghoSpawner3")[1]
  if CurrentRagho then return CurrentRagho end
  CurrentRagho = GetNamedGroup("RaghoSpawner4")[1]
  if CurrentRagho then return CurrentRagho end
end

function onVictory()
  if g.DisableVictory then return true end
  if not g.CNDNFinalWords then
    g.CNDNFinalWords = true
    g.DisableVictory = true
    CreateThread(FinalWords)
    return true
  end
end

function FinalWords()
  g.Eji:Say("what now")
  g.Ganthu:Say("journey")
  RunAfter(13, function()
    g.DisableVictory = false
    WinMission()
  end)  
end

function InitObjectives()
  ExploreArea("StartArea", 1)
  RevealArea("StartArea", true)
  ExploreArea("XenoliteMines", 1)
  RevealArea("XenoliteMines", true)
end
