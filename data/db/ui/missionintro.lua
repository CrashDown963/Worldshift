--
-- MISSION INTRO
--

MissionIntroWnd = uiwnd {
  layer = 2100,
  hidden = true,
  keyboard = true,
  mouse = true,
  anchors = { TOPLEFT = { "DESKTOP" } , BOTTOMRIGHT = { "DESKTOP" } },
  
  Image = uiimg {
    layer = 1900,
    texture = "data/textures/ui/on_startmap.tga",
    coords = {0, 0, 1024, 768},
  },
  
  Start = DefButton {
    size = {120,30},
    anchors = { BOTTOMRIGHT = { -30, -30 } },
    str = TEXT{"start"},
    OnClick = function(this) this:GetParent():OnStartMap() end,
  },

  Cancel = DefButton {
    size = {120,30},
    anchors = { RIGHT = { "LEFT", "Start", -20, 0 } },
    str = TEXT{"cancel"},
    OnClick = function(this) this:GetParent():OnCancel() end,
  },
}

function MissionIntroWnd:OnLoad()
  --this:RegisterEvent("MAP_LOADED") 
  --this:RegisterEvent("QUIT_STARTING")
  --this:RegisterEvent("QUIT_CONFIRMED")
end

function MissionIntroWnd:OnKeyDown(key, mod)
  --if this.quiting then return end
  --if key == "Escape" then this:OnCancel() return end
  --this:OnStartMap()
end

function MissionIntroWnd:OnEvent(event)
  if this.quiting then return end
  if event == "MAP_LOADED" and game.GetMapType() == "mission" then
    game.Pause(true)
    Stripes:Show()
    this:Show()
  end
end

function MissionIntroWnd:OnStartMap()
  game.Pause(false)
  Stripes:FadeOUT()
  this:Hide()
end

function MissionIntroWnd:OnCancel()
  this.quiting = true
  InGameMenu:Hide()
  PauseWnd:Hide()
  game.CloseMap() 
  game.LoadEarth()
  Stripes:FadeOUT()
  Login:Show()
  Transitions:Fade(MissionIntroWnd, nil, function() game.Pause(false) MissionIntroWnd.quiting = nil end)
end

