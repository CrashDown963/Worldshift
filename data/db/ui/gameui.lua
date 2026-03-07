--
-- GameUI
--

-- Ultrawide Support
local ultrawideZoomMultiplier = 1.0
local ultrawideZoomApplied = false
local isExtraZoomOutActive = false
local testOutputLines = {}
local maxTestOutputLines = 20
local MIN_SAFE_ZOOM = 30
local MAX_SAFE_ZOOM = 300
local DEFAULT_SAFE_ZOOM = 200

-- On-screen message display
local TestOutputWindow = uiwnd {
  hidden = false,
  size = {600, 400},
  anchors = { TOPLEFT = { 10, 10 } },
  layer = 9000,
  
  Background = uiimg {
    color = {0, 0, 0, 200},
    size = {600, 400},
  },
  
  Title = uitext {
    font = "Arial,12b",
    color = {0, 255, 0, 255},
    str = "Camera Test Results (Press Delete to close)",
    anchors = { TOPLEFT = { 10, 5 } },
  },
  
  Content = uitext {
    font = "Courier,9",
    color = {0, 255, 0, 255},
    str = "",
    halign = "LEFT",
    valign = "TOP",
    anchors = { TOPLEFT = { 10, 25 }, BOTTOMRIGHT = { -10, -10 } },
  },
}

local function AddTestOutput(message)
  -- push into our on-screen buffer
  table.insert(testOutputLines, message)
  if #testOutputLines > maxTestOutputLines then
    table.remove(testOutputLines, 1)
  end
  
  local fullText = ""
  for _, line in ipairs(testOutputLines) do
    fullText = fullText .. line .. "\n"
  end
  TestOutputWindow.Content:SetStr(fullText)
  
  -- also send to chat window so you can review it there
  if Chat and Chat.AddLine then
    Chat:AddLine(message)
  end
end

local function ShowTestResults()
  print("[Ultrawide] ShowTestResults invoked")
  TestOutputWindow.hidden = false
  uiwnd.Show(TestOutputWindow)
end

local function HideTestResults()
  uiwnd.Hide(TestOutputWindow)
end

local function GetAspectRatio()
  local width = 1920
  local height = 1080
  if game and game.GetResolution then
    local res = game.GetResolution()
    if res then
      width = res[1] or 1920
      height = res[2] or 1080
    end
  end
  return width / height
end

local function ApplyUltrawideZoom()
  if ultrawideZoomApplied then return end
  
  local aspect = GetAspectRatio()
  
  print("[Ultrawide] Detected aspect ratio: " .. aspect)
  
  -- For ultrawide displays, we need to zoom out
  -- The game calculates zoom based on screen resolution
  -- We can only warn the user to manually adjust
  if aspect > 2.2 then
    print("[Ultrawide] 21:9 ultrawide detected!")
    print("[Ultrawide] ZOOM CONTROLS:")
    print("[Ultrawide] - Use MOUSE WHEEL to zoom in/out (scroll DOWN to zoom out)")
    print("[Ultrawide] - Press INSERT key while scrolling to potentially zoom further")
    print("[Ultrawide] Note: Game engine has a hard-coded zoom limit")
    ultrawideZoomMultiplier = 1.3
  elseif aspect > 1.9 then
    print("[Ultrawide] 2.0:1+ ultrawide aspect detected!")
    print("[Ultrawide] ZOOM CONTROLS:")
    print("[Ultrawide] - Use MOUSE WHEEL to zoom in/out (scroll DOWN to zoom out)")
    print("[Ultrawide] - Press INSERT key while scrolling to potentially zoom further")
    print("[Ultrawide] Note: Game engine has a hard-coded zoom limit")
    ultrawideZoomMultiplier = 1.2
  end
  
  ultrawideZoomApplied = true
end

-- Camera test functions
function TestAllCameraFunctions()
  testOutputLines = {}
  AddTestOutput("\n" .. string.rep("=", 60))
  AddTestOutput("CAMERA FUNCTION DISCOVERY TEST")
  AddTestOutput(string.rep("=", 60) .. "\n")
  
  -- List of functions to try
  local functionsToTry = {
    "camera", "GetCamera", "SetCamera", "GetCameraDistance", "SetCameraDistance",
    "GetCameraZoom", "SetCameraZoom", "CameraZoom", "ZoomCamera",
    "GetViewDistance", "SetViewDistance", "GetViewZoom", "SetViewZoom",
    "GetOrthoCam", "SetOrthoCam", "GetCamDistance", "SetCamDistance",
    "GetCamZoom", "SetCamZoom", "AdjustZoom", "AdjustCamera", "AdjustCameraDistance",
    "GetWorldCamera", "GetGameCamera", "GetMainCamera", "ModifyZoom", "ZoomOut", "ZoomIn"
  }
  
  -- diagnostic: ensure globals exist
  if not game then
    AddTestOutput("ERROR: global 'game' is nil!")
    ShowTestResults()
    return
  end
  if not map then
    AddTestOutput("NOTE: global 'map' is nil (map not loaded?)")
  end
  if not ui then
    AddTestOutput("NOTE: global 'ui' is nil")
  end
  
  -- helper to dump first few keys of a table
  local function DumpKeys(tbl, name)
    if not tbl then return end
    AddTestOutput("Keys in " .. name .. ":")
    local count = 0
    for k,v in pairs(tbl) do
      AddTestOutput("  " .. tostring(k) .. " = " .. type(v))
      count = count + 1
      if count >= 20 then break end
    end
    if count == 0 then
      AddTestOutput("  (no keys)")
    end
  end
  DumpKeys(game, "game")
  DumpKeys(map, "map")
  DumpKeys(ui, "ui")
  
  local foundCount = 0
  
  -- Test game object functions
  AddTestOutput("Checking game object functions:")
  for _, funcName in ipairs(functionsToTry) do
    if game[funcName] then
      AddTestOutput("  [FOUND] game." .. funcName .. " = " .. tostring(type(game[funcName])))
      foundCount = foundCount + 1
    end
  end
  if foundCount == 0 then
    AddTestOutput("  (none found in game object)")
  end
  
  foundCount = 0
  
  -- Test map object functions
  AddTestOutput("\nChecking map object functions:")
  if map then
    for _, funcName in ipairs(functionsToTry) do
      if map[funcName] then
        AddTestOutput("  [FOUND] map." .. funcName .. " = " .. tostring(type(map[funcName])))
        foundCount = foundCount + 1
      end
    end
  else
    AddTestOutput("  (map object not available)")
  end
  if foundCount == 0 then
    AddTestOutput("  (none found in map object)")
  end
  
  foundCount = 0
  
  -- Test ui object functions
  AddTestOutput("\nChecking ui object functions:")
  if ui then
    for _, funcName in ipairs(functionsToTry) do
      if ui[funcName] then
        AddTestOutput("  [FOUND] ui." .. funcName .. " = " .. tostring(type(ui[funcName])))
        foundCount = foundCount + 1
      end
    end
  else
    AddTestOutput("  (ui object not available)")
  end
  if foundCount == 0 then
    AddTestOutput("  (none found in ui object)")
  end
  
  -- Try to enumerate all game object members for camera-related ones
  AddTestOutput("\nScanning game object for camera-related members:")
  local cameraRelatedFound = 0
  if game then
    for key, value in pairs(game) do
      local keyLower = string.lower(key)
      if string.find(keyLower, "cam") or string.find(keyLower, "zoom") or 
         string.find(keyLower, "view") or string.find(keyLower, "distance") then
        AddTestOutput("  [CAMERA-RELATED] game." .. key .. " = " .. tostring(type(value)))
        cameraRelatedFound = cameraRelatedFound + 1
      end
    end
  end
  
  if cameraRelatedFound == 0 then
    print("  (no camera-related members found)")
  end
  
  AddTestOutput("\n" .. string.rep("=", 60))
  AddTestOutput("TEST COMPLETE")
  AddTestOutput(string.rep("=", 60) .. "\n")
  ShowTestResults()
end

-- Try to adjust zoom with different methods
function TryZoomMethods(zoomValue)
  if zoomValue < MIN_SAFE_ZOOM then
    zoomValue = MIN_SAFE_ZOOM
  elseif zoomValue > MAX_SAFE_ZOOM then
    zoomValue = MAX_SAFE_ZOOM
  end

  AddTestOutput("\n" .. string.rep("-", 60))
  AddTestOutput("ZOOM ADJUSTMENT TEST - Value: " .. zoomValue)
  AddTestOutput(string.rep("-", 60) .. "\n")
  
  local successCount = 0
  
  -- Method 1: Direct function calls
  if game.SetCameraDistance then
    game.SetCameraDistance(zoomValue)
    AddTestOutput("[SUCCESS] Called: game.SetCameraDistance(" .. zoomValue .. ")")
    successCount = successCount + 1
  else
    AddTestOutput("[FAILED] game.SetCameraDistance does not exist")
  end
  
  if game.SetCameraZoom then
    game.SetCameraZoom(zoomValue)
    AddTestOutput("[SUCCESS] Called: game.SetCameraZoom(" .. zoomValue .. ")")
    successCount = successCount + 1
  else
    AddTestOutput("[FAILED] game.SetCameraZoom does not exist")
  end
  
  if game.SetZoom then
    game.SetZoom(zoomValue)
    AddTestOutput("[SUCCESS] Called: game.SetZoom(" .. zoomValue .. ")")
    successCount = successCount + 1
  else
    AddTestOutput("[FAILED] game.SetZoom does not exist")
  end
  
  if game.ZoomOut then
    game.ZoomOut()
    AddTestOutput("[SUCCESS] Called: game.ZoomOut()")
    successCount = successCount + 1
  else
    AddTestOutput("[FAILED] game.ZoomOut does not exist")
  end
  
  -- Method 2: Table assignment
  if game.camera then
    AddTestOutput("[INFO] game.camera exists")
    if game.camera.distance ~= nil then
      game.camera.distance = zoomValue
      AddTestOutput("[SUCCESS] Set: game.camera.distance = " .. zoomValue)
      successCount = successCount + 1
    else
      AddTestOutput("[FAILED] game.camera.distance is nil or doesn't exist")
    end
    
    if game.camera.zoom ~= nil then
      game.camera.zoom = zoomValue
      AddTestOutput("[SUCCESS] Set: game.camera.zoom = " .. zoomValue)
      successCount = successCount + 1
    else
      AddTestOutput("[FAILED] game.camera.zoom is nil or doesn't exist")
    end
  else
    AddTestOutput("[INFO] game.camera does not exist")
  end
  
  -- Method 3: Map object
  if map and map.camera then
    map.camera = zoomValue
    AddTestOutput("[SUCCESS] Set: map.camera = " .. zoomValue)
    successCount = successCount + 1
  else
    AddTestOutput("[INFO] map.camera does not exist or map is not available")
  end
  
  AddTestOutput("\n[RESULT] " .. successCount .. " zoom methods were executed")
  AddTestOutput(string.rep("-", 60) .. "\n")
  ShowTestResults()
end

local function ApplySafeZoomReset()
  if game and game.SetCameraDistance then
    game.SetCameraDistance(DEFAULT_SAFE_ZOOM)
  end
  if game and game.SetCameraZoom then
    game.SetCameraZoom(DEFAULT_SAFE_ZOOM)
  end
  if game and game.SetZoom then
    game.SetZoom(DEFAULT_SAFE_ZOOM)
  end
  if game and game.camera and game.camera.distance ~= nil then
    game.camera.distance = DEFAULT_SAFE_ZOOM
  end
  if game and game.camera and game.camera.zoom ~= nil then
    game.camera.zoom = DEFAULT_SAFE_ZOOM
  end
end

local QuitStr = TEXT{"exiting"}

GameUI = uiwnd {
  keyboard = 1,
  topWindows = { humans = {}, mutants = {}, aliens = {}, any = {} },
  race = "humans",
}

function GameUI:OnLoad()
  this:RegisterEvent("MAP_LOADED") 
  this:RegisterEvent("MAP_STARTED") 
  this:RegisterEvent("MAP_CLOSED")
  this:RegisterEvent("QUIT_STARTING")
  this:RegisterEvent("QUIT_CONFIRMED")
  this:RegisterEvent("DEMO_SHOWSLIDES")
  this.lastClickTime = 0
  this.altGaugeToggleHeld = false
  this.altGaugeFallbackState = false
  this.isGaugeActive = false -- Track Alt toggle state like minimap
  
  -- Initialize ultrawide support
  ApplyUltrawideZoom()
  
  print("[Ultrawide] camera test functions available")
  print("[Ultrawide] Press F9 to run discovery and F7/F8 to test zoom")
  print("[Ultrawide] Safe zoom clamp active: " .. MIN_SAFE_ZOOM .. "-" .. MAX_SAFE_ZOOM)
  print("[Ultrawide] Press Delete to toggle the test results window")
end

function GameUI:OnKeyUp(key, mod)
  -- Alt now behaves as a true toggle (one action per press).
  if key == "Alt" or mod.key == "Alt" then
    this.altGaugeToggleHeld = false
    return
  end
  
  -- Ultrawide zoom control - release Insert to disable extra zoom
  if key == "Insert" then
    isExtraZoomOutActive = false
    print("[Ultrawide] Extra zoom-out disabled")
  end
end 

function GameUI:OnKeyDown(key, mod)

  -- Toggle global bars on Alt key press, matching minimap toggle logic.
  if key == "Alt" or mod.key == "Alt" then
    if this.altGaugeToggleHeld then return end
    this.altGaugeToggleHeld = true
    this.isGaugeActive = not this.isGaugeActive
    game.ToggleGlobalGauge(this.isGaugeActive)
    return
  end
  
  if key == "Escape" then game.StopAction() end
  if key == "F10" then GameUI:ShowMenu() end
  if key == "F9" then 
    -- Run camera function discovery test
    if TestAllCameraFunctions then
      TestAllCameraFunctions()
      ShowTestResults()
    end
  end
  if key == "Delete" then
    if TestOutputWindow.visible then
      HideTestResults()
    else
      ShowTestResults()
    end
  end
  if key == "F6" then
    if TechGrid and not TechGrid:IsHidden() and StashUI and StashUI.Toggle then
      local wasOpen = StashUI and not StashUI:IsHidden()
      StashUI:Toggle(TechGrid and TechGrid.race or nil)
      if Victory and Victory.ModeBtn then
        if wasOpen then
          Victory.ModeBtn:Show()
        else
          Victory.ModeBtn:Hide()
        end
      end
    end
    return
  end
  if key == "F7" then
    -- Try to zoom out (test zoom adjustment)
    print("\n[F7] Attempting zoom out with multiple method attempts...")
    if TryZoomMethods then TryZoomMethods(200) end
  end
  if key == "F8" then
    -- Try to zoom in (test zoom adjustment)
    print("\n[F8] Attempting zoom in with multiple method attempts...")
    if TryZoomMethods then TryZoomMethods(30) end
  end
  if key == "Add" then game.SetSpeed(game.GetSpeed() * 1.25) end
  if key == "Subtract" then game.SetSpeed(game.GetSpeed() / 1.25) end
  if key == "Multiply" then game.SetSpeed(1) end
  
  -- select all
  if key == "C+Space" then
    game.SelectAll()
    return
  end
  
  -- walk selection
  if key == "Space" then 
    local sel = game.GetSelection()
    if not sel then return end
    local prev
    for k,v in pairs(sel) do
      if type(k) == "number" then
        if prev == this.lastSelObj then
          this.lastSelObj = k
          game.SetCameraPos(k)
          return
        end
        prev = k
      end
    end
    this.lastSelObj = sel.active
    game.SetCameraPos(sel.active)
  end
  
  if mod.key >= '0' and mod.key <= '9' then
    if mod.alt then return end

    local idx = mod.key - '0'    
    if mod.ctrl then
      local sel = game.GetSelection()
      if sel then
        game.SetSelectionGroup(idx, sel)
      end
      return
    end  
    
    if mod.shift then
      local sel = game.GetSelection(1) if not sel then sel = {} end
      local group = game.GetSelectionGroup(idx,1) if not group then return end
      local allselected = true

      for h,_ in pairs(group) do 
        if type(h) == "number" and not game.IsSelected(h) then
          allselected = false
          break
        end
      end

      if allselected == true then
        for h,_ in pairs(group) do sel[h] = nil end
      else
        for h,_ in pairs(group) do sel[h] = true end
      end
      
      local pf = game.GetPlayerFaction()
      for h,_ in pairs(sel) do
        if type(h) == "number" and game.GetUnitFaction(h) ~= pf then
          sel[h] = nil
        end
      end
  
      game.SetSelection(sel)
      return
    end
    
    local sel = game.GetSelectionGroup(idx)
    game.SetSelection(sel)
    
    local time = game.GetAppTime() 
    local dblclk = time - this.lastClickTime < 0.3
    this.lastClickTime = time
    if sel and dblclk and this.fKey and this.fKey == mod.key then
      for k,_ in pairs(sel) do game.SetCameraPos(k) break end
    end
    this.fKey = mod.key
  end
  
  -- Disabled unsafe extended zoom override to avoid breaking world-space UI
  if key == "Insert" then
    isExtraZoomOutActive = false
    print("[Ultrawide] Extra zoom override is disabled for UI stability")
  end
  
end

function GameUI:OnEvent(event)
  if event == "MAP_LOADED" then
    if this.race then 
      this:Hide() 
    end
    this.race = game.GetPlayerRace()
    this:Show()
    -- Reapply ultrawide zoom when map is loaded
    ApplyUltrawideZoom()
    ApplySafeZoomReset()
    -- Keep map load clean; avoid camera test actions here.
  end
  if event == "MAP_STARTED" then print("START")
    local map = game.GetMapName()
    if sounds.mis[map] and not this.ambSound then
      this.ambSound = game.PlaySnd(sounds.mis[map])
    end
    -- Apply ultrawide zoom when map starts
    ApplyUltrawideZoom()
    ApplySafeZoomReset()
  end
  if event == "MAP_CLOSED" then
    this:Hide()
    if this.ambSound then
      game.StopSnd(this.ambSound)
      this.ambSound = nil
    end
  end
  if event == "QUIT_CONFIRMED" then
    if this.onQuit then 
      this.onQuit() 
      this.onQuit = nil 
    end
  end
  if event == "DEMO_SHOWSLIDES" then
    Demo:Set("end", function() game.Quit(true) end)
  end
end

function GameUI:OnShow()
  this.hiddeninterface = nil
  for i,v in ipairs(this.topWindows.any) do 
    if not v.CheckVisibility or v:CheckVisibility() then v:Show() end
  end
  for i,v in ipairs(this.topWindows[this.race]) do 
    if not v.CheckVisibility or v:CheckVisibility() then v:Show() end
  end
end

function GameUI:OnHide()
  this.hiddeninterface = true
  for i,v in ipairs(this.topWindows.any) do v:Hide() end
  for i,v in ipairs(this.topWindows[this.race]) do v:Hide() end
end

function GameUI:ShowMenu()
  if this:IsHidden() then return end
  InGameMenu:Toggle()
end

function GameUI:QuitToMenu()
  Victory.race = game.GetPlayerRace()
  this.onQuit = function()
    Transitions:Fade(InGameMenu)
    Transitions:Fade(nil, Victory)
    PauseWnd:Hide()
  end
  game.ConfirmQuit()
end

--
-- ErrText
--

local ErrTexts = {
  strNER = TEXT{"strner"},
  strPLR = TEXT{"strplr"},
  strItemReject = TEXT{"stritemreject"},
  strReqNotMet = TEXT{"strreqnotmet"},
}
  
ErrText = uiwnd {
  hidden = true,
  size = {400,50},
  anchors = { CENTER = { 0, -200 } },
  
  Text = uitext {
    color = {255,0,0,255},
    font = "Agency FB,18",
    layer = 90,
  },
}

function ErrText:OnLoad()
  this:RegisterEvent("ERR_NOTENOUGHRES")
  this:RegisterEvent("ERR_NOTENOUGHPOP")
  this:RegisterEvent("ERR_REQNOTMET")
  this:RegisterEvent("ERR_SHOWMESSAGE")
end

function ErrText:ShowText(text)  -- localized text
  if GameUI:IsHidden() and game.IsInMap() then return end
  local text = ErrTexts[text] or text
  this.Text:SetStr(text)
  this:Show()
  this.timeToStay = 3
end

function ErrText:OnEvent(event)
  if event == "ERR_NOTENOUGHPOP" then
    game.PlaySnd("data/speech/advisor/pop limit.wav")
    this:ShowText("strPLR")
  end
  
  if event == "ERR_NOTENOUGHRES" then
    game.PlaySnd("data/speech/advisor/no resources.wav")
    this:ShowText("strNER")
  end

  if event == "ERR_REQNOTMET" then
    game.PlaySnd("data/speech/advisor/req not met.wav")
    this:ShowText("strReqNotMet")
  end

  if event == "ERR_SHOWMESSAGE" and argMessage then
    this:ShowText(TEXT(argMessage))
  end
end

function ErrText:OnUpdate()
  if this.timeToStay < 0 then
    return
  end
  this.timeToStay = this.timeToStay - argElapsed
  if this.timeToStay < 0 then
    Transitions:Fade(this)
  end
end

--
-- PAUSE WND
--

PauseWnd = uiwnd {
	hidden = true,
	mouse = true,
	shown = 0,
	stop = 0,
	time = 0,
	--size = {300,150},
  layer = modallayer-5,
  --anchors = { CENTER = { 0, -300 } },

  Back = uiimg {
    texture = "data/textures/ui/def_tooltip.dds",
    coords = {0, 0, 30, 30},
    shader = "_Misc_IDBW",
  },
  
  Frame = DefCornerFrameImage {
    layer = "+1",
    size = {300,150},
    anchors = { CENTER = { 0, -200 } },
  },
  
  Text = uitext { 
    layer = "+2",
    size = {300,30},
    font = "Trbuchet MS,20",
    color = {190,190,190,255},
    anchors = {TOP = {"TP{", "Frame", 0, 20}},
		str = TEXT{"paused"},
	},
	
  Name = uitext { 
    layer = "+2",
    size = {300,30},
    font = "Tahoma,14",
    color = {255,255,255,255},
    anchors = {TOP = {"BOTTOM", "Text", 0, 2}},
		str = TEXT{""},
	},

  TimeStr = uitext { 
    layer = "+2",
    size = {300,30},
    font = "Tahoma,18",
    color = {190,190,190,255},
    anchors = {TOP = {"BOTTOM", "Name", 0, 15}},
		str = TEXT{""},
	},
}

function PauseWnd:OnShow()
  MenuBtn:SetLayer(modallayer-1)
end

function PauseWnd:OnHide()
  MenuBtn:SetLayer(1)
end

function PauseWnd:OnLoad()
  this:RegisterEvent("GAME_PAUSED") 
end

function PauseWnd:OnEvent(event)
	if event == "GAME_PAUSED" then 
	  if argName then
      this.Name:SetStr("("..argName..")")
	  end
		if argPaused then 
			this:Show() 
			if this.shown == 0 then
			  Transitions:CallRepeat(function() PauseWnd:SetTimeStr() end, 1)
			  this.shown = 1
			end
			this.stop = 0
			this.time = 0
			this.TimeStr:SetStr("0:00")
			
			local clr = game.GetPlayerColorByName(argName)
			this.Name:SetColor(clr)
			game.EnableSelection(false)
		else 
		  this.stop = 1
			this:Hide() 
			Stripes:FadeOUT()
			game.EnableSelection(true)
		end 
	end
end  	

function PauseWnd:SetTimeStr()
  if this.stop == 1 then 
    return 0
  end

  this.time = this.time + 1
  
  local sec = this.time % 60
  local min = (this.time  - sec )/ 60
  
  if sec < 10 then
    this.TimeStr:SetStr("<p>"..min..":0"..sec)
  else
    this.TimeStr:SetStr("<p>"..min..":"..sec)
  end
end

--
-- InGameMenu
--

local MenuBtnTempl = DefButton{ size={140,40} }

InGameMenu = uiwnd {
  mouse = true,
  layer = 120,
  
  Frame = DefFrameImage {
    size = {220,220}
  },
  
  ResumeBtn = MenuBtnTempl {
    str = TEXT{"resume"},
    anchors = { TOP = { "Frame", 0, 30 } },
    OnClick = function(this) InGameMenu:Hide() end,
  },

  SettingsBtn = MenuBtnTempl {
    str = TEXT{"settings"},
    anchors = { TOP = { "BOTTOM", "ResumeBtn", 0, 16 } },
    OnClick = function(this) Settings:Show() InGameMenu:Hide() end,
  },
  
   QuitBtn = MenuBtnTempl {
    str = TEXT{"quit"},
    anchors = { TOP = { "BOTTOM", "SettingsBtn", 0, 16 } },
    OnClick = function(this) 
      game.Pause(false)
      GameUI:QuitToMenu() 
    end,
  },
  
  Toggle = function(this)
    if this:IsHidden() then 
      this:Show()
    else
      this:Hide()
    end  
  end,

  OnShow = function(this)
    local gametype = net.GLGetGameType()
    if gametype == "mission" then
      game.Pause(true)
    end
  end,

  OnHide = function(this)
    local gametype = net.GLGetGameType()
    if gametype == "mission" and Settings:IsHidden() then
      game.Pause(false)
    end
  end,
}

--
-- UnitSpeedWnd
--

UnitSpeedWnd = uiwnd {
  size = {100,20},
  anchors = { TOPLEFT = {} },
  Text = uitext { halign = "LEFT" },
}

function UnitSpeedWnd:OnLoad()
  this:RegisterEvent("SEL_CHANGE")
  this:RegisterEvent("SEL_SELECT")
  this:RegisterEvent("MAP_LOADED")
end
    
function UnitSpeedWnd:OnEvent(event)
  if event == "MAP_LOADED" then
    --this:Show()
  end
  
  if event == "SEL_CHANGE" or event == "SEL_SELECT" then
    if argSel then this.lastUnit = argSel.active
    else this.lastUnit = nil end
  end
end

function UnitSpeedWnd:OnUpdate()
  if this.lastUnit then
    this.Text:SetStr(math.floor(this.lastUnit:GetCurSpeed()))
  else
    this.Text:SetStr("*")
  end
end

--
-- FPSWnd
--

FPSWnd = uiwnd {
  size = {150,20},
  --layer = "TOPMOST",
  layer = 50000,
  anchors = { TOP = {} },
  
  Text = uitext {
    halign = "LEFT",
    str = "[#]:[#] [[#]]",
  },

  timeAccum = 0
}

function FPSWnd:Toggle()
  if this:IsHidden() then this:Show() else this:Hide() end
end

function FPSWnd:OnShow()
	local t = game.GetMapTime()                                     
	local h = math.floor(t/3600) if h < 10 then h = "0" .. h end
	local m = math.floor(t/60) if m < 10 then m = "0" .. m end
	local s = math.floor(math.fmod(t,60)) if s < 10 then s = "0" .. s end
	local time = h .. ":" .. m .. ":" .. s
	this.Text:SetStrVals{game.GetFrameRate(), GetWaterBasinsCount(), time }
end

function FPSWnd:OnUpdate()
  this.timeAccum = this.timeAccum + argElapsed
  if this.timeAccum > 0.25 then
  	local t = game.GetMapTime() 
  	local h = math.floor(t/3600) if h < 10 then h = "0" .. h end
  	local m = math.floor(t/60) if m < 10 then m = "0" .. m end
  	local s = math.floor(math.fmod(t,60)) if s < 10 then s = "0" .. s end
  	local time = h .. ":" .. m .. ":" .. s
  	this.Text:SetStrVals{game.GetFrameRate(), GetWaterBasinsCount(), time }
    this.timeAccum = 0
  end
end

----
-- Debug window
----

InfoWnd = uiwnd {
	hidden = true,
	size = {700,500},
  layer = "TOPMOST",
  anchors = { TOPRIGHT = { -100, 0 } },
  
  Text = uitext { 
    valign = "TOP",
    halign = "LEFT",
    color = {0,255,0,255},
		str = "",
	},
  lastUpdate = -1,
  updateRate = 0.15,
  gameInfo = game.GetGameInfo(),
  userInfo = {},
}

function InfoWnd:OnLoad()
  this:RegisterEvent("DEBUG_WND") 
  this:RegisterEvent("MAP_LOADED") 
  this:RegisterEvent("DEBUG_SET_INFO")
  this.lastUpdate = -1
end

function InfoWnd:OnEvent(event)
	if event == "DEBUG_WND" then 
    if this:IsHidden() then this:Show() else this:Hide() end
  elseif event == "MAP_LOADED" then
    this.lastUpdate = -1   
  elseif event == "DEBUG_SET_INFO" then
    this.userInfo[argKey] = argValue
	end
end 

function InfoWnd:OnUpdate()
  local time = game.GetAppTime()
  if this.lastUpdate + this.updateRate > time then return end
  local txt = ""

  -- Game info
  txt = txt .. string.format("%s (%s) %s\n", this.gameInfo.name, this.gameInfo.version, this.gameInfo.conf)

  -- Map info
  local mapInfo = game.GetMapInfo()
  txt = txt .. string.format("Map: %s (%s, %s)\n",
    mapInfo.name or "Unknown", mapInfo.terrain or "Unknown", mapInfo.type or "Unknown")

  -- Time
  local ti = game.GetTimeInfo()
  txt = txt .. string.format("%.2f (%02d:%02d:%02d) FPS: %.2f LUPS: %d/%.2f speed: %.2f\n\n",
    ti.time, ti.h, ti.m, ti.s, ti.fps, ti.lups, ti.lui, ti.speed)

  for k, v in pairs(this.userInfo) do
    txt = txt .. tostring(k) .. " : " .. tostring(v) .. "\n"
  end

  this.Text:SetStr(txt)
  this.lastUpdate = time
end

