--
-- MessageBox
--

local okText = TEXT{"ok"}
local noText = TEXT{"no"}
local yesText = TEXT{"yes"}
local cancelText = TEXT{"cancel"}

local MessageBoxBtn = DefButton {
  virtual = true,
  size = {100,25},
}

MessageBox = uiwnd {
  size = {400,180},
  layer = 83000,--"HIGH",
  keyboard = 1,
  
  Frame = DefSmallBackImage { 
    layer = "-2",  
    
    back = uiimg {
      layer = "-2",
      texture = "data/textures/ui/small_menu_backgr.dds",
      tiled = {3,3,3,3},
      coords = {0, 0, 48, 50},
      anchors = { TOPLEFT = { "BOTTOMLEFT", "black_bar", 0,0}, BOTTOMRIGHT = {} },
      shader = "_Misc_IDBB",
    },    
  },
  
  uiwnd {
    mouse = 1,
    anchors = { 
      TOPLEFT = { "DESKTOP" } ,
      BOTTOMRIGHT = { "DESKTOP" } ,
    },
    --uiimg { color = 50,50,50,100 }, -- darken the background
    layer = "DIALOG",
  },
  
  OK = MessageBoxBtn { index = 1 },
  Cancel = MessageBoxBtn { index = 2 },
  Third = MessageBoxBtn { index = 3 },
  
  
  TextTitle = uitext {
    alert = TEXT{"ALERT"},
    prompt = TEXT{"PROMPT"},
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { 
      TOPLEFT  = { 2, 2, pix = true },
      TOPRIGHT = { -2, 2, pix = true },
      BOTTOM   = { "TOP", 0, 20 },
    },
  },
  
  Text = uitext {
    font = "Arial,12",
    --halign = LEFT; valign = TOP,
    anchors = { 
      TOPLEFT = { "BOTTOMLEFT", "TextTitle" },
      BOTTOMRIGHT = { 0, -24 },
    },
  },
}

function MessageBox:OnKeyDown(key)
  if key == "Escape" then
    this:Hide()
    if this.Cancel:IsHidden() then  -- Escape == Return when only OK button is visible
      this:OnClick(this.OK)
    end
    return 1  -- consume the key
  end
  if key == "Return" then
    this:OnClick(this.OK)
    return 1
  end
end

function MessageBox:Alert(msg, title, func)
  if not this:IsHidden() then return end
  this.TextTitle:SetStr(title or this.TextTitle.alert)
  this.Text:SetStr("<p>"..msg)
  this.OK:SetStr(okText)
  this.OK:SetAnchor("BOTTOM", this, "BOTTOM", {0,-5})
  
  this.Cancel:Hide()
  this.Third:Hide()

  this.callback = func
  this:Show()
end

function MessageBox:Prompt(msg, title, func)
  if not this:IsHidden() then return end
  this.TextTitle:SetStr(title or this.TextTitle.prompt)
  this.Text:SetStr("<p>"..msg)
  this.callback = func
  this.OK:SetStr(okText)
  this.OK:SetAnchor("BOTTOMLEFT", this, "BOTTOMLEFT", {10,-5})
  this.Cancel:SetStr(cancelText)
  this.Cancel:SetAnchor("BOTTOMRIGHT", this, "BOTTOMRIGHT", {-10,-5})
  this.Cancel:Show()
  
  this.Third:Hide()

  this:Show()
end

function MessageBox:Prompt3(msg, title, func1, func2)
  if not this:IsHidden() then return end
  this.TextTitle:SetStr(title or this.TextTitle.prompt)
  this.Text:SetStr("<p>"..msg)
  this.callback = func1
  this.callback2 = func2
  
  local width = (MessageBox:GetSize().x / 3) - 2

  local sz = this.OK:GetSize()
  
  this.OK:SetAnchor("BOTTOMLEFT", this, "BOTTOMLEFT", {10,-5})
  --this.OK:SetSize{width, sz.y}
  this.OK:SetStr(yesText)
  this.OK:Show()
  
  this.Cancel:SetAnchor("BOTTOM", this, "BOTTOM", {0,-5})
  --this.Cancel:SetSize{width-1, sz.y}
  this.Cancel:SetStr(noText)
  this.Cancel:Show()
  
  this.Third:SetAnchor("BOTTOMRIGHT", this, "BOTTOMRIGHT", {-10,-5})
  --this.Third:SetSize{width, sz.y}
  this.Third:SetStr(cancelText)
  this.Third:Show()
  
  this:Show()
end

function MessageBox:OnClick(btn)
  if not btn then btn = argBtn end
  this:Hide()
  if this.callback and btn.index == 1 then
    local func = this.callback;
    func(btn.index)
  end
  if this.callback2 and btn.index == 2 then
    local func = this.callback2;
    func(btn.index)
  end
  this.callback = nil
  this.callback2 = nil
end

--
-- MovieList
--

MovieList = uiwnd {
  mouse = true,
  keyboard = true,
  
  Title = uitext { 
    size = {300,50},
    font = "Agency FB,30",
    anchors = { BOTTOM = { "TOP", "FrameImg", 0, 0 } },
  },

  FrameImg = DefFrameImage {
    size = {200,250},
    anchors = { CENTER = { 0, 50 } },
  },

  ListBox = DefBtnListBox {
    anchors = { 
      TOPLEFT = { "FrameImg" },
      BOTTOMRIGHT = { "FrameImg", 26, -30 },
    },
  },
  
  CancelBtn = DefButton {
    str = "X",
    anchors = { RIGHT = { "BOTTOMRIGHT", "FrameImg", -10, 20 } },
  },

  ConfirmBtn = DefButton {
    str = "OK",
    anchors = { RIGHT = { "LEFT", "CancelBtn", -10, 0 } },
  },
  
  MovieName = uiedit {
    anchors = { 
      TOPLEFT = { "BOTTOMLEFT", "ListBox", 6, -4 },
      BOTTOMRIGHT = { "FrameImg" },
    },
  },
}

function MovieList.ConfirmBtn:OnClick()
  MovieList:OnConfirm()
end

function MovieList.CancelBtn:OnClick()
  MovieList:OnCancel()
end

function MovieList:OnShow()
  this.context = nil
end

function MovieList:OnLoad()
  this:RegisterEvent("MOVIE_LOAD")
  this:RegisterEvent("MOVIE_SAVE")
end

function MovieList:OnEvent(event)
  if (event == "MOVIE_LOAD") then
    this.Title:SetStr('LOAD MOVIE')
    this.MovieName:Hide()
    this.ListBox:SetList(game.GetCustomMoviesList())
    this:Show()
    this.context = event
  end
  if (event == "MOVIE_SAVE") then
    this.Title:SetStr('SAVE MOVIE')
    this.MovieName:SetStr('')
    this.MovieName:Show()
    this.ListBox:SetList(game.GetCustomMoviesList())
    this:Show()
    this.context = event
  end
end

function MovieList:OnConfirm()
  Transitions:Fade(this)
  local moviename = this.MovieName:GetStr()
  if not moviename or moviename == '' then return end
  if this.context == "MOVIE_LOAD" then game.LoadMovie(moviename) end
  if this.context == "MOVIE_SAVE" then game.SaveMovie(moviename) end
end

function MovieList:OnCancel()
  Transitions:Fade(this)
end

function MovieList:OnListItemClicked()
  local idx, data = this.ListBox:GetNextSelected()
  this.MovieName:SetStr(data)
end

function MovieList:OnListItemDoubleClicked()
  local idx, data = this.ListBox:GetNextSelected()
  this.MovieName:SetStr(data)
  this:OnConfirm()
end

--
-- game news
--

GameNews = uiwnd {
  hidden = true,
  size = {280,420},
  anchors = { LEFT = { 20,0 } },  

  Frame = DefSmallBackImage {layer = "-1"},
  
  FrameTitle = uitext {
    size = {1,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { 10,2 }, TOPRIGHT = { -10,2 } },
    str = TEXT("game_news"),
  },  

  ArticleTitle = uitext {
    size = {1,1},
    layer = "+1",
    halign = "LEFT",
    valign = "TOP",
    font = "Verdana,11b",
    color = {70, 153, 248},
    auto_adjust_height = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "FrameTitle", 0,10 }, TOPRIGHT = { "BOTTOMRIGHT", "FrameTitle", 0,10 } },
  },

  ArticleDate = uitext {
    size = {1,20},
    layer = "+1",
    halign = "LEFT",
    font = "Verdana,10",
    color = {118, 113, 93},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "ArticleTitle", 0,0 }, TOPRIGHT = { "BOTTOMRIGHT", "ArticleTitle", 0,0 } },
  },

  ArticleText = DefTextScrollArea {
    anchors = { TOPLEFT = { "BOTTOMLEFT", "ArticleDate", 0,10 }, BOTTOMRIGHT = { -10,-30 } },
    
    Text = uitext { 
      font = "Verdana,10", 
      halign = "LEFT", 
      valign = "TOP", 
      color = {162, 162, 162},
    },

    Scrollbar = DefVertScrollbar {
      hidden = true,
      anchors = { TOPRIGHT = { -5, 5 }, BOTTOMRIGHT = { -5, -5 } },
      OnScroll = function(this)
        this:GetParent():OnScroll(argPos)
      end,
    },

    OnMouseWheel = function (this, delta, mods)
      if mods.shift then
        if delta < 0 then
          this.Scrollbar:SetPos(0)
        else  
          this.Scrollbar:SetPos(9999999999)
        end  
      elseif mods.alt then
        local pagerows = this.Text:GetSize().y / this.Text:GetLineHeight()
        if delta < 0 then
          this.Scrollbar:SetPos(this.Scrollbar:GetPos() - ((pagerows - 1) * this.Text:GetLineHeight()))
        else  
          this.Scrollbar:SetPos(this.Scrollbar:GetPos() + ((pagerows - 1) * this.Text:GetLineHeight()))
        end  
      else
        this.Scrollbar:SetPos(this.Scrollbar:GetPos() + delta * this.Text:GetLineHeight())
      end  
    end,
  },
  
  Next = DefButton {
    size = {30,20},
    anchors = { BOTTOMRIGHT = { -10,-10 } }, 
    str = ">>",
    OnClick = function(this) GameNews:Set(GameNews.currid+1) end,
  },

  Close = DefButton {
    size = {130,20},
    anchors = { BOTTOM = { 0,-10 } }, 
    str = TEXT("delete_news"),
    OnClick = function(this) 
      local parent = this:GetParent()
      parent.unreadednews = nil
      parent:Hide() 
      game.DismissNews()
    end,
  },
  
  Prev = DefButton {
    size = {30,20},
    anchors = { BOTTOMLEFT = { 10,-10 } }, 
    str = "<<",
    OnClick = function(this) GameNews:Set(GameNews.currid-1) end,
  },
  
  OnLoad = function(this)
    this:RegisterEvent("NEWS_FOUND")
  end,

  OnEvent = function(this, event)
    if event == "NEWS_FOUND" then
      this.unreadednews = true
      this:Set(argNews)
    end
  end,

  Set = function(this, id)
    this.currid = id

    local tbl = game.GetNews(id)
    this.ArticleTitle:SetStr(tbl.title)
    this.ArticleDate:SetStr(tbl.date)
    this.ArticleText.Text:SetStr("<p>"..tbl.text)
    this.ArticleText:AdjustScrollbar(this.ArticleText.Scrollbar)
    
    this.Prev:Hide()
    if game.GetNews(id-1) then
      this.Prev:Show()
    end

    this.Next:Hide()
    if game.GetNews(id+1) then
      this.Next:Show()
    end

    if not Login:IsHidden() then
      this:Show()
    end
  end,
}

--
-- game news
--

LeaderDead = uiwnd {
  hidden = true,
  size = {600,80},
  anchors = { TOP = { 0,188 } },

  Frame = DefCornerFrameImage2 {layer = "-1"},
  
  Title = uitext {
    layer = "+1",
    font = "Verdana,11b",
    color = {255, 255, 255},
    size = {1,20},
    anchors = { TOPLEFT = { 10,10 }, TOPRIGHT = { -10,10 } },
    str = TEXT("leader_is_dead_title"),
  },  
  Text = uitext {
    layer = "+1",
    font = "Verdana,10",
    color = {192, 192, 192},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Title", 0, 2 }, BOTTOMRIGHT = { -10,-10 } },
    str = TEXT("leader_is_dead_text"),
  },  
  OnEvent = function(this, event)
    if event == "MAP_CLOSED" then
      this.visible = false
      this:Hide()
    end
  end,
  OnLoad = function(this)
    this:RegisterEvent("MAP_CLOSED")
    table.insert(GameUI.topWindows.any, this)
  end,
  CheckVisibility = function(this)
    if not this.visible then return false end
    return true
  end,
}

