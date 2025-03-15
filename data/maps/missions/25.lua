g_init.Denkar = function() return GetNamedObject("Denkar") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Eji = function() return GetNamedObject("Eji") end

g.EastGenDisabled = false
g.WestGenDisabled = false
g.GeneratorRestartedOnce = false
g.CheckGateAttackers = false

g_Objectives.FindGates = {
  Create = function() return ui.Objectives:Add("Find Esperanza gates", 1, " ", " ") end
}  
g_Objectives.Protect = {
  Create = function() return ui.Objectives:Add("Protect the entrance", 1, " ", " ") end
}  
g_Objectives.Enter = {
  Create = function() return ui.Objectives:Add("Enter Esperanza", 1, " ", " ") end
}  
g_Objectives.Generators = {
  Create = function() return ui.Objectives:Add("Disable the gate forcefield", 1, " ", " ") end
}  

function HideBaseObjectives()
  HideObjective("FindGates")
  HideObjective("Protect")
  HideObjective("Enter")
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  if value and xLastTrueTime < 0 then
    if "SpawnGateAttackers" == name then
      g.Denkar:Say("protect gates")
      HideBaseObjectives()
      ShowObjective("Protect")
      g.CheckGateAttackers = true;
    elseif "PlayerAtGateArea" == name then
      g.Ganthu:Say("esperanza gates")
      g.Denkar:Say("esperanza forcefield")
      g.Ganthu:Say("saw a device")
      HideBaseObjectives()
      ShowObjective("Generators")
    elseif "PlayerAtGenerator1Area" == name then
      if g_Objectives.Generators.Objective then
        g.Denkar:Say("power source")
        g.Ganthu:Say("we should try")
      else
        g.Denkar:Say("mechanism")
      end
    elseif "PlayerAtGenerator2Area" == name then
      if g_Objectives.Generators.Objective then
        g.Denkar:Say("power source")
        g.Ganthu:Say("we should try")
      else
        g.Denkar:Say("mechanism")
      end
    end
  end
  
  if "GeneratorsOffline" == name then
    if value then
      --DestroyObjectByName("ShieldWall")
      SetNamedObjectVar("ShieldWall", "hidden", 1)
      SetNamedObjectVar("ShieldWall", "passable", 1)
      g.Denkar:Say("forcefield down")
      g.Eji:Say("controls outside")
      g.Denkar:Say("keep smth in")
      g.Eji:Say("spooky")
      HideAllObjectives()
      ShowObjective("Enter")
      RunAfter(33, function()
        SetWeatherPreset(3)
        RunAfter(5, function()
          g.Denkar:Say("rain comment 1")
          g.Ganthu:Say("rain comment 2")
        end)
      end)
    else
      SetNamedObjectVar("ShieldWall", "hidden", 0)
      SetNamedObjectVar("ShieldWall", "passable", 0)
    end  
  elseif "EastGeneratorDisabled" == name and value then
    g.EastGenDisabled = true
    if g.WestGenDisabled then
      SetCondition("GeneratorsOffline", true)
    else
      RunAfter(5, function()
        if g.WestGenDisabled then return end
        SetCondition("EastGeneratorDisabled", false)
        g.EastGenDisabled = false
        if not g.GeneratorRestartedOnce then
          g.Denkar:Say("generator restarted")
          g.GeneratorRestartedOnce = true
        end
      end)
    end
  elseif "WestGeneratorDisabled" == name and value then
    g.WestGenDisabled = true
    if g.EastGenDisabled then
      SetCondition("GeneratorsOffline", true)
    else
      RunAfter(5, function()
        if g.EastGenDisabled then return end
        SetCondition("WestGeneratorDisabled", false)
        g.WestGenDisabled = false
        if not g.GeneratorRestartedOnce then
          g.Denkar:Say("generator restarted")
          g.GeneratorRestartedOnce = true
        end
      end)
    end
  end
end

function CheckGateAttackers()
  while true do
    if g.CheckGateAttackers then
      if IsGroupOfMobsDead("GateAttackers") then
        SetCondition("GateAttackersDead", true)
        g.Denkar:Say("no more aliens")
        g.Ganthu:Say("strange")
        g.Eji:Say("faint song")
        g.Ganthu:Say("prophecy")
        g.Eji:Say("can follow")
        g.Denkar:Say("enter")
        HideBaseObjectives()
        ShowObjective("Enter")
        g.CheckGateAttackers = false
      else
        sleep(1)
      end  
    else
      sleep(1)
    end
  end      
end

CreateThread(CheckGateAttackers)

local function OperateGenerators()
  while true do
    if not g.WestGenDisabled then
      CreateReactOnNamedObject("Generator1", "lightning")
    end
    if not g.EastGenDisabled then
      CreateReactOnNamedObject("Generator2", "lightning")
    end
    sleep(1)
  end
end

function InitObjectives()
  g.Denkar:Say("be careful-25")
  g.Denkar:Say("suspect everything")
  CreateThread(OperateGenerators)
  ShowObjective("FindGates")
end
