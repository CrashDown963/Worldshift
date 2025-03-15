g_init.Denkar = function() return GetNamedObject("Ni'Varra") end
g_init.Eji = function() return GetNamedObject("Eji") end
g_init.Ganthu = function() return GetNamedObject("Ganthu") end
g_init.Messenger = function() return GetNamedObject("Messenger") end
g_init.SalingCommander = function() return GetNamedObject("SalingCommander") end

g.P2Started = false
g.ObjText = "Find your way to Saling"

g_Objectives.EnterObjective = {
  Create = function() return ui.Objectives:Add("Approach Saling", 1, g.ObjText, " ") end
}

function SetSubObjective(txt)
  g.ObjText = txt
  g_Objectives.EnterObjective.Objective.Row11:Set(txt)
end

function onConditionChanging(actor, name, value, xTimeNow, xLastTrueTime, xLastFalseTime, xLastChangedTime, xLastCalcTime)
  local cname
  if actors.Actor.IsValid(actor) then
    local cactor = actor:GetVar("obj_name", "str") or actor:GetVar("handle", "int") or "???"
    cname = cactor .. ":" .. name
  else
	  cname = name;
  end	
  print("[" .. xTimeNow .. "] Condition " .. cname .. ": " .. tostring(value))
  
  if value and (xLastTrueTime < 0) then
    if (name == "AllMadeIt") then
      if not g.P2Started then
        g.Denkar:Say("made through lava")
        g.Ganthu:Say("respect nature")
        SetSubObjective(" ")
      end  
    elseif (name == "RevealP2Area") then
      g.Denkar:Say("found saling base")
    elseif (name == "P2Start") then
      SetGroupVar("P2Mobs", "attackable", 1)
      g.Denkar:Say("what the")
      g.Denkar:Say("treason")
      g.Ganthu:Say("cannot defeat")
      g.Eji:Say("passage")
      SetSubObjective("Make your way past the camp")
      g.P2Started = true
    elseif (name == "P2End") then
      g.Denkar:Say("past saling base")
      SetSubObjective(" ")
    elseif (name == "MessengerSeen") then
      g.Messenger:Say("message")
      g.SalingCommander:Say("no chance")
      g.SalingCommander:Say("offer")
      g.Ganthu:Say("trap")
      g.Denkar:Say("men of honor")
      g.Messenger:Say("follow me")
    elseif (name == "NiVarraAtMessenger") then
      if actors.Actor.IsValid(g.Messenger) then
        g.Messenger:SetVar("path", "MessengerPath")
        g.Messenger:SetVar("hull", 100)
      end
    elseif (name == "RevealP3Area") then
      g.Denkar:Say("lets dance")
      SetSubObjective("Defeat the Salingian Commander")
      --ShowBossInfo(g.SalingCommander)
    elseif (name == "P3End") then
      --ShowBossInfo(nil)
      ExploreArea("ExitArea", 1)
      RevealArea("ExitArea", true)
      SetGroupVar("PlayerUnits", "reset_prg", 0)
      SetGroupVar("P3Mobs", "sight", 0)
      SetGroupVar("P3Mobs", "attackable", 0)
      SetGroupVar("P3Mobs", "reset_prg", 0)
      SetGroupVar("DoorGuards", "sight", 0)
      SetGroupVar("DoorGuards", "attackable", 0)
      SetGroupVar("DoorGuards", "reset_prg", 0)
      SetGroupVar("DoorGuards", "aim_at", "Ni'Varra")
      g.SalingCommander:Say("incredible")
      g.Denkar:Say("fought well")
      g.SalingCommander:Say("keep promise")
      g.Ganthu:Say("humans")
      g.Denkar:Say("respect honor")
      g.SalingCommander:SetVar("indestructible", 0)
      g.SalingCommander:Die()
      SetSubObjective("Continue to Saling")
    end
  end 
  if name == "RevealBridge1" then
    if value then
      if xLastTrueTime < 0 then
        ExploreArea("BridgeArea1", 1)
        g.Denkar:Say("careful-15")
        SetSubObjective("Avoid the fire bursts")
      end
      RevealArea("BridgeArea1", true)
    else
      RevealArea("BridgeArea1", false)
    end
  elseif name == "RevealBridge2" then
    if value then
      if xLastTrueTime < 0 then
        ExploreArea("BridgeArea2", 1)
      end
      RevealArea("BridgeArea2", true)
    else
      RevealArea("BridgeArea2", false)
    end
  elseif name == "RevealBridge3" then
    if value then
      if xLastTrueTime < 0 then
        ExploreArea("BridgeArea3", 1)
      end
      RevealArea("BridgeArea3", true)
    else
      RevealArea("BridgeArea3", false)
    end
  elseif name == "RevealBridge4" then
    if value then
      if xLastTrueTime < 0 then
        ExploreArea("BridgeArea4", 1)
      end
      RevealArea("BridgeArea4", true)
    else
      RevealArea("BridgeArea4", false)
    end
  elseif name == "RevealStart" then
    if value then
      RevealArea("StartArea", true)
    else
      RevealArea("AtartArea", false)
    end
  elseif name == "RevealP2Area" then
    if xLastTrueTime < 0 then
      ExploreArea("P2Area", 1)
    end
    if value then
      RevealArea("P2Area", true)
    else
      RevealArea("P2Area", false)
    end
  elseif name == "RevealO1" then
    if xLastTrueTime < 0 then
      ExploreArea("O1Area", 1)
    end
    if value then
      RevealArea("O1Area", true)
    else
      RevealArea("O1Area", false)
    end
  elseif name == "RevealO2" then
    if xLastTrueTime < 0 then
      ExploreArea("O2Area", 1)
    end
    if value then
      RevealArea("O2Area", true)
    else
      RevealArea("O2Area", false)
    end
  elseif name == "RevealO3" then
    if xLastTrueTime < 0 then
      ExploreArea("O3Area", 1)
    end
    if value then
      RevealArea("O3Area", true)
    else
      RevealArea("O3Area", false)
    end
  elseif name == "RevealP3Area" then
    if value then
      if xLastTrueTime < 0 then
        ExploreArea("P3Area", 1)
      end
      RevealArea("P3Area", true)
    else
      RevealArea("P3Area", false)
    end
  end
end

function UpdateFires()
  local numBridges = 6
  local interval = 10
  local Fires = {}
  for i = 0, numBridges do
    for j = 1, 100 do
      local pt = GetNamedObjectPos("Fire" .. i .. j)
      if not pt then break end
      --print("Found Fire" .. i .. j)
      if not Fires[i + 1] then Fires[i + 1] = {} end
      Fires[i + 1][j] = {}
      Fires[i + 1][j].pt = pt
      if i > 0 and j == 2 then
        Fires[i + 1][j][1] = Fires[i + 1][1][1] + SIRND(1, 3)
      else
        Fires[i + 1][j][1] = SIRND(1, 10)
      end  
      Fires[i + 1][j][2] = Fires[i + 1][j][1] + 1
      Fires[i + 1][j][3] = Fires[i + 1][j][1] + 2
    end
  end
  local time = 0
  while true do
    sleep(1)
    time = time + 1
    for i = 0, numBridges do
      if not Fires[i + 1] then break end
      for j = 1, 100 do
        if not Fires[i + 1][j] then break end
        if time >= Fires[i + 1][j][1] then
          --print("Boom Fire" .. i .. j .. " small")
          SpawnObjects("ExplosionBig_05", Fires[i + 1][j].pt)
          Fires[i + 1][j][1] = Fires[i + 1][j][1] + interval
        end
        if time >= Fires[i + 1][j][2] then
          --print("Boom Fire" .. i .. j .. " medium")
          SpawnObjects("ExplosionBig_05 { scale = 1.5 }", Fires[i + 1][j].pt)
          Fires[i + 1][j][2] = Fires[i + 1][j][2] + interval
        end
        if time >= Fires[i + 1][j][3] then
          --print("Boom Fire" .. i .. j .. " big")
          SpawnObjects("ExplosionBig_05 { scale = 3 }", Fires[i + 1][j].pt)
          if i > 0 then
            DamageUnitsInArea("Bridge" .. i, 2000, 0, "fire")
          end  
          Fires[i + 1][j][3] = Fires[i + 1][j][3] + interval
        end
      end
    end
  end
end

CreateThread(UpdateFires)

function InitObjectives()
  g.Messenger:SetVar("conv_icon_row", 4)
  g.Messenger:SetVar("conv_icon_col", 4)
  ExploreArea("StartArea", 1)
  SetGroupVar("P2Mobs", "attackable", 0)
  g.Denkar:Say("here we come")
  ShowObjective("EnterObjective")
end
