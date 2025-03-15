g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Arna = function() return GetNamedObject("Arna") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.UmbaguPriest = function() return GetNamedObject("UmbaguPriest") end

g.CheckAmbush1 = false
g.CheckVillageAttackers = false

local BruteSpawnPoint = GetNamedObjectPos("BruteSpawnPoint")
local BruteWayPoint = GetNamedObjectPos("BruteWayPoint")

g_Objectives.Search = {
  Create = function() return ui.Objectives:Add("Search the area ahead", 1, " ", " ") end
}  

g_Objectives.Explore = {
  Create = function() return ui.Objectives:Add("Explore the area ahead", 1, " ", " ") end
}  

g_Objectives.HelpMutants = {
  Create = function() return ui.Objectives:Add("Help the mutants", 1, " ", " ") end
}  

g_Objectives.HelpDefenders = {
  Create = function() return ui.Objectives:Add("Help the village defenders", 1, " ", " ") end
}  

g_Objectives.KillBoss = {
  Create = function() return ui.Objectives:Add("Kill the Big One", 1, " ", " ") end
}  

local CurrentObjective = nil

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  if xLastTrueTime >= 0 then return end
  
  if "SpiderGroup1Dead" == name then
    g.Denkar:Say("nasty bugs")
    g.Arna:Say("expect more bugs")
  elseif "SpiderGroup2Dead" == name then
    g.Denkar:Say("too hard")
    g.Ganthu:Say("have faith")
  elseif "PlayerAtAmbushArea1" == name then
    SetGroupVar("UmbaguPeople1", "attackable", 1)  
    SetGroupVar("UmbaguPeople2", "attackable", 1)  
    SetGroupVar("Ambush1", "attackable", 1)  
    g.UmbaguPriest:Say("kill bugs")
    g.Ganthu:Say("must help")
    g.CheckAmbush1 = true
    HideAllObjectives()
    ShowObjective("HelpMutants")
  elseif "PlayerAtNestingGrounds1" == name then
    g.Arna:Say("what the")
    g.Ganthu:Say("nesting place")
    g.Denkar:Say("clear nest")
    g.Arna:Say("check artifact")
  elseif "PlayerAtBigOneArea" == name then
    g.Denkar:Say("giant spider")
  elseif "VictoryCond" == name then
    WinMission()
  end
end

function CheckAmbush1()
  while true do
    if g.CheckAmbush1 then
      if IsGroupOfMobsDead("Ambush1") then
        g.CheckAmbush1 = false
        g.CheckVillageAttackers = true
        SetCondition("SpawnAttackers", true)
        if actors.Actor.IsValid(g.UmbaguPriest) then
          g.UmbaguPriest:Say("village attacked")
          g.Denkar:Say("join forces")
          RunAfter(2, function()
            SetGroupVar("UmbaguPeople1", "path", "DefendersPos")  
            HideAllObjectives()
            ShowObjective("HelpDefenders")
          end)
        end
      else
        sleep(0.5)
      end  
    else
      sleep(1)
    end  
  end  
end

CreateThread(CheckAmbush1)

function CheckVillageAttackers()
  while true do 
    if g.CheckVillageAttackers then
      if IsGroupOfMobsDead("VillageAttackers") then
        g.CheckVillageAttackers = false
        if actors.Actor.IsValid(g.UmbaguPriest) then
          g.UmbaguPriest:Say("you saved us")
          g.Arna:Say("we seek ruins")
          g.UmbaguPriest:Say("beware monster")
          g.Denkar:Say("we face monster")
          g.UmbaguPriest:Say("offer reinforcements")
          g.Ganthu:Say("thanks for reinforcements")
          local brutes = {}
          SpawnObjects("Brute = 3", BruteSpawnPoint, GetPlayerFaction(), brutes)
          RunAfter(1, function()
            for _, brute in ipairs(brutes) do
              brute:Execute("PrgMove", { pt = BruteWayPoint } )
            end
            RunAfter(2, function()
              HideAllObjectives()
              ShowObjective("KillBoss")
            end)  
          end)  
        else
          g.Denkar:Say("priest dead")
          HideAllObjectives()
          ShowObjective("Explore")
        end
      else
        sleep(0.5)
      end  
    else
      sleep(1)
    end
  end    
end

CreateThread(CheckVillageAttackers)

function InitObjectives()
  ShowObjective("Search")
end

