g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Eji = function() return GetNamedObject("Eji") end
g_init.Zeus = function() return GetNamedObject("EffectsSource") end
g_init.Robco386 = function() return GetNamedObject("Robco386") end

g.GatesOpened = false
local GatesOpened = false

g.LoadGatesOpened = true
g_load.LoadGatesOpened = function()
  if GatesOpened and not CheckpointData.g.GatesOpened then
    SetNamedObjectVar("Gate1", "hidden", 0)
    SetNamedObjectVar("Gate1", "passable", 0)
    SetNamedObjectVar("Gate2", "hidden", 0)
    SetNamedObjectVar("Gate2", "passable", 0)
  end
  GatesOpened = CheckpointData.g.GatesOpened
  return true
end

g.RobcoActiveted = false
g.TrapsActivated = 0
g.CheckFinalAttackers = false

g_Objectives.FindAD = {
  Create = function() return ui.Objectives:Add("Find the ancient device", 1, " ", " ") end
}  
g_Objectives.KillAliens = {
  Create = function() return ui.Objectives:Add("Eliminate the aliens", 1, " ", " ") end
}  

g_Objectives.SecondaryObjective = {
  Create = function() return ui.Objectives:Add("Open the gates", 1, " ", " ") end
}  

local Traps = { "E_freeze_trap", "E_lava_trap", "E_boom_trap" } 

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if not value then return end
  
  local _, e = string.find(name, "PlayerAtTrap")
  if e then
    ActivateTrap(actor)
    return
  end
  
  if xLastTrueTime >= 0 then return end

  if "SpawnFinalAttackers" == name then
    HideObjective("FindAD")
    HideObjective("KillAliens")
    g.Eji:Say("the source")
    RunAfter(5, function () g.CheckFinalAttackers = true end)
  elseif "PursuersLeader1InCombat" == name then
    g.Denkar:Say("aliens")
    g.Ganthu:Say("hurry-26")
    if g.TrapsActivated > 0 then
      g.Denkar:Say("look for traps")
    end
  elseif "PlayerInFrontOfResonatorGate" == name then
    if not g.GatesOpened then
      g.Eji:Say("getting closer")
      g.Ganthu:Say("open gate")
      ShowObjective("SecondaryObjective")
    end
  elseif "PlayerAtControlRoom" == name then
    g.Denkar:Say("control room")
    g.Ganthu:Say("it is dead")
    g.Denkar:Say("i wouldnt bet")
  elseif "FinalAttackersInCombat" == name then
    g.Ganthu:Say("aliens2")
    g.Denkar:Say("kill them all")
    HideObjective("FindAD")
    ShowObjective("KillAliens")
  end
end

function ActivateTrap(actor)
  local trap = Traps[SIRND(1, table.getn(Traps))]
  g.Zeus:SpawnEffect(trap, actor)
  if g.TrapsActivated < 3 then
    if 0 == g.TrapsActivated then
      g.Denkar:Say("a trap")
      g.Ganthu:Say("only one trap")
      g.Denkar:Say("detour")
    elseif 1 == g.TrapsActivated then
      g.Denkar:Say("second trap")
      g.Ganthu:Say("why traps")
      g.Denkar:Say("guess about traps")
    elseif 2 == g.TrapsActivated then
      g.Denkar:Say("third trap")
      g.Ganthu:Say("spot traps")
      g.Denkar:Say("activate traps")
    end
    g.TrapsActivated = g.TrapsActivated + 1
  end
end

function OpenGates(switch, actor)
  if g_Objectives.SecondaryObjective.Objective then  
    HideObjective("SecondaryObjective")
    g.Denkar:Say("gates opened")
  else
    g.Denkar:Say("switch operated")
    g.Ganthu:Say("we will see")
  end
  
  --DestroyObjectByName("Gate1")
  SetNamedObjectVar("Gate1", "hidden", 1)
  SetNamedObjectVar("Gate1", "passable", 1)
  --DestroyObjectByName("Gate2")
  SetNamedObjectVar("Gate2", "hidden", 1)
  SetNamedObjectVar("Gate2", "passable", 1)
  g.GatesOpened = true
  GatesOpened = true
end

function ActivateRobco(switch, actor)
  if g.RobcoActiveted then return end
  g.RobcoActiveted = true
  RunAfter(3, function()
    local startAnimLength = g.Robco386:GetAnimLength("on")
    g.Robco386:SetAnim()
    g.Robco386:SetAnim("on", startAnimLength)
    RunAfter(startAnimLength, function()
      g.Robco386:SetAnim()
      g.Robco386:SetVar("hold_fire", 0)
      g.Robco386:SetVar("attackable", 1)
      g.Robco386:SetVar("selectable", 1)
      g.Robco386:SetVar("no_mouse_targetable", 0)
      g.Denkar:Say("robot awake")
    end)  
  end)
end

function CheckFinalAttackers()
  while true do
    if g.CheckFinalAttackers then
      if IsGroupOfMobsDead("FinalAttackers") then
        g.CheckFinalAttackers = false;
        HideObjective("FindAD")
        HideObjective("KillAliens")
        g.Denkar:Say("transport device")
        g.Ganthu:Say("be careful-26")
        g.Denkar:Say("what was that")
        g.Eji:Say("someone coming")
        RunAfter(15, function()
          WinMission()
        end)  
      else
        sleep(1)
      end  
    else
      sleep(1)
    end
  end      
end

CreateThread(CheckFinalAttackers)

function InitObjectives()
  ShowObjective("FindAD")
  g.Eji:SayTo(g.Ganthu, "song north")
  g.Ganthu:Say("go north")
  g.Denkar:SayTo(g.Ganthu, "trouble ahead")
  g.Robco386:SetAnim("off")
  g.Robco386:SetVar("hold_fire", 1)
  g.Robco386:SetVar("attackable", 0)
  g.Robco386:SetVar("selectable", 0)
  g.Robco386:SetVar("no_mouse_targetable", 1)
end
