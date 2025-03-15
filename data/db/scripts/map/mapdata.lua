g = {}             -- global variables
g_init = {}        -- global variable initializations (will be called for each var in g if not nil)
g_load = {}        -- global variable loaders (if nil initialization will be checked)
g_Objectives = {}  -- objectives data

CheckpointData = {
  name = "",
  loading = false,
  session = 0,
  g = {},
  g_Objectives = {},
}

function Copy(var)
  if not var then return nil end
  if type(var) ~= "table" then return var end
  --print("Using table copy")
  c = {}
  for k,v in pairs(var) do
    --print("  Copying " .. k .. " = " .. tostring(v));
    c[k] = Copy(v)
  end
  return c
end

function InitAllVars()
  for k,v in pairs(g_init) do
    g[k] = v()
  end
end

function SaveVars()
  CheckpointData.g = {}
  for k,v in pairs(g) do
    CheckpointData.g[k] = Copy(v)
  end
end

function LoadVars()
  g = {}
  for k,v in pairs(CheckpointData.g) do
    local fn = g_load[k] or g_init[k]
    if fn then 
      g[k] = fn()
    else  
      g[k] = Copy(v)
    end  
  end
end

function UpdateAllObjectives()
  for k,v in pairs(g_Objectives) do
    if v.Objective and v.Update then
      v.Update(v.Objective)
    end
  end
end

function ShowObjective(name)
  if not g_Objectives[name] then
    print("Objective " .. name .. " is not defined")
    return
  end
  if g_Objectives[name].Objective then
    return
  end
  if not g_Objectives[name].Create then
    print("Objective " .. name .. " has not Create method")
    return
  end
  g_Objectives[name].Objective = g_Objectives[name].Create()
  if g_Objectives[name].Update then
    g_Objectives[name].Update(g_Objectives[name].Objective)
  end
end

function HideObjective(name)
  if not g_Objectives[name] then
    print("Objective " .. name .. " is not defined")
    return
  end
  if not g_Objectives[name].Objective then
   return
  end
  ui.Objectives:Del(g_Objectives[name].Objective)
  g_Objectives[name].Objective = nil
end

function HideAllObjectives()
  for k,v in pairs(g_Objectives) do
    if v.Objective then
      ui.Objectives:Del(v.Objective)
      v.Objective = nil
    end
  end
end

function SaveObjectives()
  CheckpointData.g_Objectives = {}
  for k,v in pairs(g_Objectives) do
    CheckpointData.g_Objectives[k] = {}
    if v.Objective then
      CheckpointData.g_Objectives[k].Objective = true
    end  
  end
end

function LoadObjectives()
  for k,v in pairs(CheckpointData.g_Objectives) do
    if g_Objectives[k] and g_Objectives[k].Objective then
      ui.Objectives:Del(g_Objectives[k].Objective)
      g_Objectives[k].Objective = nil
    end
    if v.Objective and g_Objectives[k] and g_Objectives[k].Create then
      g_Objectives[k].Objective = g_Objectives[k].Create()
    end
  end
  UpdateAllObjectives()
end

function onCheckpointSwitchUse(Switch, User)
  local Name = Switch:GetVar("obj_name", "str")
  CheckpointData.pos = Switch:GetPos()
  CreateThread(
    function()
      ui.ErrText:ShowText(ui.TEXT("checkpoint marked"))
      CheckpointData.name = Name
      if not onCheckpointSave or not onCheckpointSave(Name) then
        FullRestoreAllUnits(User)
        CheckpointSave(Name)
        SaveVars()
        SaveObjectives()
      end  
      return "SUCCESS"
    end
  )
end

function onCheckpointLoad(name)
  CheckpointData.loading = true
  CheckpointData.session = CheckpointData.session + 1
  ui.Conversation:Reset()
  CheckpointLoad()
  LoadVars()
  LoadObjectives()
  if CheckpointData.pos then
    game.SetCameraPos(CheckpointData.pos)
  end
  CheckpointData.loading = false
end

function MapDataUpdateThread()
  local Denkar = GetNamedObject("Denkar") or GetNamedObject("NiVarra") or GetNamedObject("Ni'Varra")
  if Denkar then
    Denkar:SetVar("icon", "1,2")
    Denkar:SetVar("conv_icon_row", 1)
    Denkar:SetVar("conv_icon_col", 1)
  end
  local Ganthu = GetNamedObject("Ganthu")
  if Ganthu then
    Ganthu:SetVar("icon", "3,2")
    Ganthu:SetVar("conv_icon_row", 1)
    Ganthu:SetVar("conv_icon_col", 5)
  end
  local Tharksh = GetNamedObject("Tharksh")
  if Tharksh then
    Tharksh:SetVar("icon", "2,3")
    Tharksh:SetVar("conv_icon_row", 2)
    Tharksh:SetVar("conv_icon_col", 3)
  end
  local Arna = GetNamedObject("Arna")
  if Arna then
    Arna:SetVar("icon", "3,3")
    Arna:SetVar("conv_icon_row", 1)
    Arna:SetVar("conv_icon_col", 3)
  end
  local Kuna = GetNamedObject("Kuna")
  if Kuna then
    Kuna:SetVar("icon", "4,2")
    Kuna:SetVar("conv_icon_row", 2)
    Kuna:SetVar("conv_icon_col", 2)
  end  

  local Commander = GetCommander(GetPlayerFaction())
  if actors.Actor.IsValid(Commander) then
    ui.Commander.Info.Icon:Set(Commander.h)
    ui.Commander.Officers:UpdateIcons()
    CheckpointData.pos = Commander:GetPos()
  end
  if InitVars then InitVars() end
  InitAllVars()
  sleep(0.5)
  if InitObjectives then InitObjectives() end
  CheckpointSave("Start")
  SaveVars()
  SaveObjectives()
  while true do
    UpdateAllObjectives()
    sleep(1)
  end
end

CreateThread(MapDataUpdateThread)
