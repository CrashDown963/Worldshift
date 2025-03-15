--
-- GameUI
--

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
end

function GameUI:OnKeyUp(key, mod)
  --Toggle Gauge  
  if mod.key == "Alt" then game.ToggleGlobalGauge(false) end
end 

function GameUI:OnKeyDown(key, mod)
  
  if key == "Escape" then game.StopAction() end
  if key == "F10" then GameUI:ShowMenu() end
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
  
  --Toggle Gauge  
  if mod.key == "Alt" then game.ToggleGlobalGauge(true) return end
  
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
  
end

function GameUI:OnEvent(event)
  if event == "MAP_LOADED" then
    if this.race then 
      this:Hide() 
    end
    this.race = game.GetPlayerRace()
    this:Show()
  end
  if event == "MAP_STARTED" then print("START")
    local map = game.GetMapName()
    if sounds.mis[map] and not this.ambSound then
      this.ambSound = game.PlaySnd(sounds.mis[map])
    end
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

