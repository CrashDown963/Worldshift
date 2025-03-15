--
-- LoadMap
--

local LoadStr = TEXT{"loading map"}

LoadingScreen = uiwnd {
  uiimg { color = {0,0,0,255} },
  Text = uitext { font = "Agency FB,30" },
  layer = "DIALOG",
}

LoadMap = uiwnd {
  mouse = true,
  keyboard = true,
  
  FrameImg = DefFrameImage {
    size = {260,350},
    anchors = { TOPLEFT = { 50, 150 } },
  },

  uitext { 
    size = {300,50},
    str = TEXT{"load map"},
    font = "Agency FB,30",
    anchors = { BOTTOM = { "TOP", "FrameImg", 0, 0 } },
  },

  ListBox = DefBtnListBox {
    anchors = { 
      TOPLEFT = { "FrameImg" },
      BOTTOMRIGHT = { "FrameImg", 0, -20 },
    },
  },
  
  ConfirmBtn = DefButton {
    str = "OK",
    anchors = { RIGHT = { "LEFT", "CancelBtn", -10, 0 } },
  },

  CancelBtn = DefButton {
    str = "X",
    anchors = { RIGHT = { "BOTTOMRIGHT", "FrameImg", -10, 0 } },
  },
  
  MapName = uitext {
    halign = "LEFT",
    color = {255,0,0,255},
    anchors = { 
      TOPLEFT = { "BOTTOMLEFT", "ListBox", 6, -4 },
      BOTTOMRIGHT = { "FrameImg" },
    },
  },

  -- play with that race buttons
  
  Humans = DefButton {
    str = TEXT{"humans"},
    anchors = { TOPLEFT = { "TOPRIGHT", "FrameImg", 10, 0 } },
  },

  Mutants = DefButton {
    str = TEXT{"tribes"},
    anchors = { TOP = { "BOTTOM", "Humans", 0, 10 } },
  },

  Aliens = DefButton {
    str = TEXT{"the cult"},
    anchors = { TOP = { "BOTTOM", "Mutants", 0, 10 } },
  },
}

function LoadMap.ConfirmBtn:OnClick()
  LoadMap:OnLoadMap()
end

function LoadMap.CancelBtn:OnClick()
  LoadMap:OnCancel()
end

function LoadMap.Humans:OnClick()
  LoadMap:SelectRace(this)
end

function LoadMap.Humans:OnClick()
  LoadMap:SelectRace(this)
end

function LoadMap.Mutants:OnClick()
  LoadMap:SelectRace(this)
end

function LoadMap.Aliens:OnClick()
  LoadMap:SelectRace(this)
end

function LoadMap:OnShow()
  this:RegisterEvent("EARTH_CLOSED")
  if not this.ListBox.list then
    local list = game.GetCustomMapList()
    table.sort(list) -- , function(a, b) return a < b end
    this.ListBox:SetList(list)
    this:SelectRace(this.Humans)
  end
end

function LoadMap:OnEvent(event)
  if (event == "EARTH_CLOSED") then this:Hide() end
end

function LoadMap:OnKeyDown(key)
  if argKey == "Escape" then 
    this:OnCancel() 
  end
end

function LoadMap:OnLoadMap()
  local idx, data = this.ListBox:GetNextSelected()
  if data then 
    this:StartMap(data)  
  end
end

function LoadMap:OnCancel()
  --Transitions:Fade(this, Login)
  Transitions:Fade(this)
end

function LoadMap:OnListItemClicked()
  local idx, data = this.ListBox:GetNextSelected()
  this.MapName:SetStr(data)
end

function LoadMap:OnListItemDoubleClicked()
  local idx, data = this.ListBox:GetNextSelected()
  this:StartMap(data)  
end

function LoadMap:StartMap(mapname)
  if not mapname or mapname == "" then return end
  LoadingScreen.Text:SetStr(LoadStr)
  Transitions:Fade(this, LoadingScreen, function() 
    GameUI.race = this.race
    game.LoadMap(mapname, this.race) 
    Transitions:Fade(LoadingScreen, nil, nil, 1.6)
  end)
end

function LoadMap:SelectRace(btn)
  this.Humans:GetImagePanel():SetColor(colors.white)
  this.Mutants:GetImagePanel():SetColor(colors.white)
  this.Aliens:GetImagePanel():SetColor(colors.white)
  if btn == this.Humans then
    this.race = "humans";
  elseif btn == this.Mutants then
    this.race = "mutants";
  elseif btn == this.Aliens then
    this.race = "aliens";
  end
  btn:GetImagePanel():SetColor(colors.green)
end
