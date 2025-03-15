--
-- DefFrameImage
--

DefBackInBlack = uiimg {
  virtual = true,
  texture = "data/textures/ui/back_in_black.dds",
  coords = {0, 0, 48, 29},
  --tiled = {14,12,14,12},
  tiled = {14,9,14,9},
}

DefFrameImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_frame.dds",
  coords = {0, 0, 64, 64},
  tiled = {8,8,8,8},
}

DefCornerFrameImage = uiimg {
  virtual = true,
  --texture = "data/textures/ui/def_cornerframe.dds",
  texture = "data/textures/ui/def_tooltip.dds",
  coords = {0, 0, 30, 30},
  tiled = {4,4,4,4},
}

DefCornerFrameImage2 = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_cornerframe_02.dds",
  coords = {0, 0, 32, 32},
  tiled = {5,5,5,5},
}

DefCornerFrameNoTranspImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_cornerframe_1.dds",
  coords = {0, 0, 30, 30},
  tiled = {4,4,4,4},
}

DefPlateImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_plate.dds",
  coords = {0, 0, 45, 45},
  tiled = {16,9,16,9},
}

DefBigBackImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/big_menu.dds",
  tiled = {23,61,23,61},
  coords = {0, 0, 69, 213},
  shader = "_Misc_IDBB",
  layer = "-3",
}

DefSmallBackImage = uiwnd {
  virtual = true,
  black_bar = uiimg {
    size = {1,24},
    layer = "-1",
    texture = "data/textures/ui/smal_menu_black_bar.dds",
    tiled = {5,5,5,5},
    coords = {0,0,12,24},
    anchors = { TOPLEFT = {}, TOPRIGHT = {} },
  },
  back = uiimg {
    layer = "-2",
    texture = "data/textures/ui/small_menu_backgr.dds",
    tiled = {3,3,3,3},
    coords = {0, 0, 48, 50},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "black_bar", 0,0}, BOTTOMRIGHT = {} },
    --shader = "_Misc_IDBB",
  },
  frame = uiimg {
    texture = "data/textures/ui/small_menu_frame.dds",
    tiled = {17,26,17,4},
    coords = {0,0,54,78},
  },
}

DefFrameNoTranspImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_frame_notransp.dds",
  coords = {0, 0, 64, 64},
  tiled = {8,8,8,8},
}

DefHRFrameImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_halfround_frame.dds",
  coords = {0, 0, 64, 64},
  tiled = {8,8,8,8},
}

DefHRFrameImage2 = uiimg {
  virtual = true,
  texture = "data/textures/ui/def_halfround_frame2.dds",
  coords = {0, 0, 64, 64},
  tiled = {8,8,8,8},
}

DefAvatarImage = uiimg {
  virtual = true,
  size = {128,128},
  texture = "data/textures/avatars/def.bmp",
}

--
DefButton1 = uibtn {
  virtual = true,
  size = {134,38},
  sound = "def_button",
  font = "Verdana,10b",

  selected = false,
  
  n_nc = {0, 0, 134, 38},
  n_hc = {0, 38, 134, 38+38},
  n_pc = {0, 76, 134, 76+38},
  
  n_nclr = {255,255,255},
  n_pclr = {0,0,0},

  NormalImage = uiimg { texture = "data/textures/ui/lobby exit.dds" },
  HighImage = uiimg { texture = "data/textures/ui/lobby exit.dds" },
  PushImage = uiimg { texture = "data/textures/ui/lobby exit.dds" },

  NormalText = uitext  { color = {255,255,255} },
  HighText  = uitext { color = {255,255,255} },
  PushText = uitext { color = {0,0,0} },
  
  OnShow = function(this) this:Select(this.selected) end,
  Select = function(this, doselect) 
    this.selected = doselect
    if doselect then
      this.NormalImage:SetTexture(nil, this.n_pc)
      this.HighImage:SetTexture(nil, this.n_pc)
      this.PushImage:SetTexture(nil, this.n_pc)
      this.NormalText:SetColor(this.n_pclr)
      this.HighText:SetColor(this.n_pclr)
      this.PushText:SetColor(this.n_pclr)
    else
      this.NormalImage:SetTexture(nil, this.n_nc)
      this.HighImage:SetTexture(nil, this.n_hc)
      this.PushImage:SetTexture(nil, this.n_pc)
      this.NormalText:SetColor(this.n_nclr)
      this.HighText:SetColor(this.n_nclr)
      this.PushText:SetColor(this.n_pclr)
    end  
  end,
  OnClickCallback = function(this) Tooltip:Hide() NTTooltip:Hide() end,
}

--
-- AnimImage
--
DefAnim = uiwnd {
  virtual = true,

  defazed = false,
  autoplay = true,
  fps = 20,
  --texture = "data/textures/ui/xxx.xxx",
  --coords = {0, 0, w, h},
  --frames = cnt,
  --looped = bool,
  
  Anim = uiimg { hidden = true },
}

function DefAnim:OnShow()
  --local tw,th = game.GetTextureInfo(this.texture)
  --if not tw or not th then return end
  --local fw,fh = this.coords[3],this.coords[4]
  --if not fw or not fh then return end
  
  --if tw > th then
  --  this.horizontal = true
  --  --this.frames = math.floor(tw / fw)
  --else
  --  this.horizontal = nil
  --  --this.frames = math.floor(th / fh)
  --end
  
  this.frame = 1
  if this.defazed then
    this.frame = math.random(this.frames)
  end
  
  this.stop = nil
  this.playing = nil
  if this.autoplay == nil or this.autoplay == true then
    this:Play()
  else
    this:animate(0)
  end
end

function DefAnim:OnHide()
  this:Stop()
end

function DefAnim:Play()
  if this.playing or this.stop then return end
  this.playing = true
  Transitions:CallRepeat(this.animate, 1/this.fps, this)
end

function DefAnim:Stop()
  if not this.playing then return end
  this.stop = true
end

function DefAnim.animate(this, elapsed)
  local fl,ft,fw,fh = this.coords[1],this.coords[2],this.coords[3],this.coords[4]
  if this.horizontal then
    this.Anim:SetTexture(this.texture, {(this.frame - 1) * fw, ft, this.frame*fw, ft+fh})
  else
    this.Anim:SetTexture(this.texture, {fl, (this.frame - 1) * fh, fl+fw, this.frame*fh})
  end
  if this.Anim:IsHidden() then this.Anim:Show() end

  this.frame = this.frame + 1
  if this.frame > this.frames then
    if this.looped then
      this.frame = 1
    else
      this.stop = true
    end  
  end
  
  if this.stop then
    this.stop = nil
    this.playing = nil
    if this.OnStop then
      this.OnStop(this)
    end
    return 0
  end
end

--
-- Buttons
--

modallayer = 100

Modal = uiwnd {
  hidden = true,
  mouse = true,
  anchors = { TOPLEFT = { "DESKTOP" } , BOTTOMRIGHT = { "DESKTOP" } , },
  layer = modallayer - 1,
  
  OnMouseDown = function(this)
    if this.nomouse then return end
    if this.func then this.func() end
    this.func = nil
    this:Hide()
  end,
}

--
-- Buttons
--

local DefButtonFont = "Verdana,10b"

DefButton = uibtn {
  virtual = true,
  size = {120,40},
  sound = "def_button",
  font = DefButtonFont,
  
  NormalImage = uiimg {
    texture = "data/textures/ui/default_button_1.dds",
    coords = {0, 0, 195, 26},
    tiled = {6,5,6,5},
  },
  
  HighImage = uiimg {
    texture = "data/textures/ui/default_button_1.dds",
    coords = {0, 26, 195, 26},
    tiled = {6,5,6,5},
  },

  PushImage = uiimg {
    texture = "data/textures/ui/default_button_1.dds",
    coords = {0, 52, 195, 26},
    tiled = {6,5,6,5},
  },

  NormalText = uitext  { color = {234,223,178,255} },
  HighText  = uitext { color = {248,236,189,255} },
  PushText = uitext { color = {248,236,189,255} },
  
  Disable = function(this, disable)
    if disable then
      this.disabled = true
      this:SetAlpha(0.5)
      this.NormalImage:SetShader("_Misc_InterfaceDrawBW")
      this.HighImage:SetShader("_Misc_InterfaceDrawBW")
      this.PushImage:SetShader("_Misc_InterfaceDrawBW")
    else
      this.disabled = nil
      this:SetAlpha(1)
      this.NormalImage:SetShader()
      this.HighImage:SetShader()
      this.PushImage:SetShader()
    end
  end,
  OnClickCallback = function(this) Tooltip:Hide() NTTooltip:Hide() end,
}

--
-- scrollbars
--

DefVertScrollbar = uiscroll {
  virtual = true,
  size = {12,14},

  UpBtn = DefButton {
    size = {12,14},
    anchors = { TOPRIGHT = {} },
    NormalImage = uiimg { texture = "data/textures/ui/scroll_arrow_up.dds", coords = {0,0,12,14} },
    HighImage   = uiimg { texture = "data/textures/ui/scroll_arrow_up.dds", coords = {0,14,12,14} },
    PushImage   = uiimg { texture = "data/textures/ui/scroll_arrow_up.dds", coords = {0,14,12,14} },
  },
  
  DownBtn = DefButton {
    size = {12,14},
    anchors = { BOTTOMRIGHT = {} },
    NormalImage = uiimg { texture = "data/textures/ui/scroll_arrow_down.dds", coords = {0,0,12,14} },
    HighImage   = uiimg { texture = "data/textures/ui/scroll_arrow_down.dds", coords = {0,14,12,14} },
    PushImage   = uiimg { texture = "data/textures/ui/scroll_arrow_down.dds", coords = {0,14,12,14} },
  },

  Slider = uislider {
    vertical = true,
    anchors = { 
      TOPLEFT = { "BOTTOMLEFT", "UpBtn" },
      BOTTOMRIGHT = { "TOPRIGHT", "DownBtn" },
    },

    uiimg {
      texture = "data/textures/ui/scroll_back.dds",
      coords = {0,0,12,221},
    },

    ThumbBtn = DefButton {
      size = {12,25},
      anchors = { TOP = {} },
      NormalImage = uiimg { texture = "data/textures/ui/scroll_slider.dds", coords = {0,0,12,25} },
      HighImage   = uiimg { texture = "data/textures/ui/scroll_slider.dds", coords = {0,25,12,25} },
      PushImage   = uiimg { texture = "data/textures/ui/scroll_slider.dds", coords = {0,25,12,25} },
    }
  }
}

--
-- DefBtnListBox
--

DefBtnListBox = uiwnd {
  virtual = true,
  font = "Arial,10",
  
  ncolor = {255, 255, 255},  -- normal color
  hcolor = {255, 255, 0},  -- high color
  pcolor = {0, 255, 0},  -- push color
  scolor = {0, 255, 0},  -- selected color
  textjustify = "LEFT",
  
  Scrollbar = DefVertScrollbar {
    layer = "+1",
    anchors = { 
      TOPRIGHT = { -2, 3 },
      BOTTOMRIGHT = { -2, -3 },
    },
  },

  ScrollArea = uiwnd {
    anchors = { 
      TOPLEFT = { 2, 3 },
      BOTTOMRIGHT = { "BOTTOMRIGHT", "Scrollbar" },
    },
    Back = uiimg { color = {80,80,80,100} },
  },
}

local lastClickTime = 0 

function DefBtnListBox:OnMouseWheel(delta)
  this.Scrollbar:SetPos(this.Scrollbar:GetPos() + delta * 5)
end

function DefBtnListBox:CreateItems(cellh, func)
  local slot;
  for i = 1, this.rows do
    if func then 
      slot = func(this, i, cellh) 
    else
      slot = uibtn {
        NormalText = uitext {
          font = this.font,
          color = this.ncolor,
          halign = this.textjustify,
        },
        
        HighText = uitext {
          font = this.font,
          color = this.hcolor,
          halign = this.textjustify,
        },

        PushText = uitext {
          font = this.font,
          color = this.pcolor,
          halign = this.textjustify,
        },

        size = { this.ScrollArea:GetSize()[1], cellh },
        
        OnMouseWheel = function(slot, delta, mods) this:OnMouseWheel(delta, mods) end,
        OnClick = function() this:OnListClicked(i) end,
        OnRClick = function() this:OnListRClicked(i) end,
      }
    end  
    
 
    if i == 1 then
      slot.anchors = { TOPLEFT = { "TOPLEFT", 4, 0 } }
    else
      slot.anchors = { TOPLEFT = { "Slot" .. (i-1), "BOTTOMLEFT" } }
    end
    
    this.ScrollArea["Slot" .. i] = slot
  end
end

function DefBtnListBox:GetNextSelected()
  if not this.list or not this.selected_item_index or this.selected_item_index > #this.list then return end
  return this.selected_item_index, this.selected_item
end

function DefBtnListBox:UpdateItem(item, data)
  item:SetStr(data)
  if this.selected_item == data then
    item.NormalText:SetColor(this.scolor)
    item.HighText:SetColor(this.scolor)
    item.PushText:SetColor(this.scolor)
  else  
    item.NormalText:SetColor(this.ncolor)
    item.HighText:SetColor(this.hcolor)
    item.PushText:SetColor(this.pcolor)
  end
end

function DefBtnListBox:SetList(list, cellh, func)
  local oldlist = this.list

  this.selected_item = nil
  this.selected_item_index = nil

  this.firstPos = 1
  this.Scrollbar:SetPos(this.firstPos)
  
  this.list = list
  if not cellh then cellh = 20 end
  
  if oldlist then 
    for i = 1, this.rows do
      this.ScrollArea["Slot" .. i]:Hide()
    end
  else
    this.rows = math.floor((this.ScrollArea:GetSize()[2] / cellh) + 0.5)
    this:CreateItems(cellh, func)
    this.ScrollArea:CreateChildren()
  end
  
  local max = #list - this.rows + 1
  if max < 1 then max = 1 end
  this.Scrollbar:SetMinMaxRange(1, max)
  this:UpdateList()
end
  
function DefBtnListBox.Scrollbar:OnScroll()
  this:GetParent():OnScroll(argPos)
end

function DefBtnListBox:OnListClicked(btnindex)
  if not this.list or #this.list < 1 then return end
  local time = game.GetAppTime() 
  local dblclk = time - lastClickTime < 0.3
  lastClickTime = time

  local btn = this.ScrollArea["Slot" .. btnindex]
  local index = this.firstPos + btnindex - 1

  this.selected_item = this.list[index]
  this.selected_item_index = index

  if this.SelectItem then
    this:SelectItem(btn, this.selected_item, true)
  end

  if dblclk and this:GetParent().OnListItemDoubleClicked then
    this:GetParent():OnListItemDoubleClicked(this)
  elseif this:GetParent().OnListItemClicked then
    this:GetParent():OnListItemClicked(this)
  end

  this:UpdateList()
end

function DefBtnListBox:OnScroll(newpos)
  this.firstPos = newpos
  this:UpdateList()
end

function DefBtnListBox:UpdateList()
  if not this.list then return end
  for i = 1, this.rows do
    local slot = this.ScrollArea["Slot" .. i]
    local idx = i + this.firstPos - 1
    while this.list[idx] and this.list[idx].hidden do idx = idx + 1 end
    if idx > #this.list then 
      slot:Hide()
    else
      this:UpdateItem(slot, this.list[idx])
      slot:Show()
    end  
  end
end

function DefBtnListBox:Reset()
  this.list = nil
  this.selected_item = nil
  this.selected_item_index = nil
  if this.rows then
    for i = 1, this.rows do 
      local slot = this.ScrollArea["Slot" .. i]
      slot:Hide() 
    end
  end
end
--
-- DEFCOLUMNSLIST
--

--THE SLOT MUST HAVE THESE FUNCS:
--  ShowData(data)  - visualize this data

DefColumnsList = uiwnd {
  virtual = true,
  mouse = true,
  
  --FILL THE NEXT MEMBERS FOR INSTANCING:
  --  rows      - number of rows
  --  cols      - number of columns
  --  col_dist  - distance between the columns
  --  row_dist  - distance between the rows
  --  func      - CreateSlotFunc template func(list, row, col, slotw, sloth)
  
  Scrollbar = DefVertScrollbar { hidden = true, anchors = { TOPLEFT = { "TOPRIGHT", 0, 0 }, BOTTOMLEFT = { "BOTTOMRIGHT", 0, 0 } } },
  ScrollArea = uiwnd { anchors = { TOPLEFT = { 0, 0 }, BOTTOMRIGHT = { 0, 0 } } },
  
  OnMouseWheel = function(this, delta, mods)
    if mods.shift then
      if delta < 0 then
        this.Scrollbar:SetPos(0)
      else  
        this.Scrollbar:SetPos(9999999999)
      end  
    elseif mods.alt then
      if delta < 0 then
        this.Scrollbar:SetPos(this.Scrollbar:GetPos() - (this.visiblerows - 1))
      else  
        this.Scrollbar:SetPos(this.Scrollbar:GetPos() + (this.visiblerows - 1))
      end  
    else
      this.Scrollbar:SetPos(this.Scrollbar:GetPos() + delta)
    end  
  end,
}

function DefColumnsList:CreateItems(cols, rows, col_dist, row_dist, func)
  if not cols or not rows or not col_dist or not row_dist or not func then return end
  
  local sz = this.ScrollArea:GetSize()
  local cw = (sz.x - ((cols - 1) * col_dist)) / cols
  local ch = (sz.y - ((rows - 1) * row_dist)) / rows
  local idx = 1
  for r = 1, rows do
    for c = 1, cols do
      local slot = func(this, r, c, cw, ch)
      
      slot.OnMouseWheel = function(slot, delta, mods) this:OnMouseWheel(delta, mods) end
      
      if r == 1 and c == 1 then
        slot.anchors = { TOPLEFT = { "TOPLEFT", 0, 0 } }
      elseif r == 1 then
        slot.anchors = { TOPLEFT = { "Slot"..(idx-1), "TOPRIGHT", col_dist, 0 } }
      else
        slot.anchors = { TOP = { "Slot"..(idx-cols), "BOTTOM", 0, row_dist } }
      end
      
      this.ScrollArea["Slot"..idx] = slot
      idx = idx + 1
    end
  end
  this.slotscount = idx - 1
  this.ScrollArea:CreateChildren()
end

function DefColumnsList:SetList(list, dontresetpos)
  if not this.ScrollArea.Slot1 then
    this:CreateItems(this.cols, this.rows, this.col_dist, this.row_dist, this.func)
  end
  
  if not dontresetpos or not this.firstrow then
    this.firstrow = 1
    this.Scrollbar:SetPos(this.firstrow)
  end
  this.list = list
  
  for i = 1, this.slotscount do 
    local slot = this.ScrollArea["Slot" .. i]
    slot.dataindex = nil
    slot:Hide()
  end
  
  this:UpdateScrollbar()  
  this:UpdateList()
end

function DefColumnsList:UpdateScrollbar()
  local max = (#this.list / this.cols) - this.rows + 1
  if max < 1 then max = 1 end
  this.Scrollbar:SetMinMaxRange(1, max)
end
  
function DefColumnsList.Scrollbar:OnScroll()
  this:GetParent():OnScroll(argPos)
end

function DefColumnsList:OnScroll(newrow)
  if this.firstrow == newrow then return end
  this.firstrow = newrow
  this:UpdateList()
end

function DefColumnsList:UpdateList()
  if not this.firstrow then return end
  local dataidx = (this.firstrow * this.cols) - (this.cols - 1)
  local idx = 1
  this.visiblerows = 0
  for r = 1, this.rows do
    for c = 1, this.cols do
      while this.list[dataidx] and this.list[dataidx].hidden do dataidx = dataidx + 1 end
      local slot = this.ScrollArea["Slot" .. idx]
      if dataidx > #this.list then
        slot.dataindex = nil
        slot:Hide()
      else
        slot.dataindex = dataidx
        local dontshow = slot:ShowData(this.list[dataidx])
        if not dontshow then
          slot:Show()
          this.visiblerows = this.visiblerows + 1
        end
      end  
      idx = idx + 1
      dataidx = dataidx + 1
    end
  end
end
  
--
-- DefTextScrollArea
--

function DefTextScrollArea_OnLoad(this)
  this.pos = 0
  this.texts = {}

  for k,v in pairs(this) do
    if type(v) == "table" and v.GetType and v:GetType() == "uitext" then
      table.insert(this.texts, v)
    end
  end
  
  this.OnScroll = function (this, pos)
    this.pos = pos
  	local h, v = this.Text:GetAlign()
  	if v == "BOTTOM" then
    	this.Text:SetStrOffset(this.Text:GetStrHeight() - pos)
    else	                                                 
    	this.Text:SetStrOffset(-pos)
    end	
  end
  
  this.AdjustScrollbar = function (self, scroll, setpos)
  	local h, v = this.Text:GetAlign()
    if v == "BOTTOM" then
    	scroll:SetMinMaxRange(this.Text:GetSize().y, this.Text:GetStrHeight())
      if setpos then
        scroll:SetPos(setpos)
      else
    	  scroll:SetPos(this.Text:GetStrHeight())
      end
    else 	
    	scroll:SetMinMaxRange(0, this.Text:GetStrHeight() - (2 * this.Text:GetLineHeight()))
    end	
  end
end

DefTextScrollArea = uiwnd {
  virtual = true,
  mouse = true,
  OnLoad = DefTextScrollArea_OnLoad,
}

--
-- STRIPES
--
stripeslayer = 2000

Stripes = uiwnd {
  layer = stripeslayer,
  hidden = true,
  anchors = { TOPLEFT = { "DESKTOP" } , BOTTOMRIGHT = { "DESKTOP" } },
      
  
  --Upper = uiimg { color = {0,0,0,255} },
  --Lower = uiimg { color = {0,0,0,255} },

  Upper = uiimg { 
    texture = "data/textures/ui/black_gradient_stripes.dds", 
    coords = {0,0,2,168},
  },
  
  Lower = uiimg { 
    texture = "data/textures/ui/black_gradient_stripes_down.dds", 
    coords = {0,0,2,168},
  },

  
  OnLoad = function(this)
    this.time = 0.5
    this.speed = 200
    this.sz_stripe = 0
  end,
  
  GetHeight = function(this)
    this.sz_stripe = 0
    local sz = this:GetSize()
    local wndh = sz.x * (9/16)
    local strh = (sz.y - wndh) / 2
    if this.GetHeightCustom then
      strh = this.GetHeightCustom()
    end
    if strh > 1 then
      this.sz_stripe = strh
      this.Upper:SetSize{sz.x, this.sz_stripe}
      this.Lower:SetSize{sz.x, this.sz_stripe}
    end
    return this.sz_stripe
  end,
  
  ShowOn = function(this)
    Stripes:GetHeight()
    this.Upper:SetAnchor("TOP", this, "TOP", {0,0})
    this.Lower:SetAnchor("BOTTOM", this, "BOTTOM", {0,0})

    this.Upper:Hide()
    this.Lower:Hide()
    this:Show()
  end,

  FadeIN = function(this, func) 
    if Stripes:GetHeight() == 0 then Stripes:OnFinish() return end
    this.func = func
    this.cury = 0
    this.desty = 0
    this.Upper:SetAnchor("TOP", this, "TOP", {0,this.cury})
    this.Lower:SetAnchor("BOTTOM", this, "BOTTOM", {0,this.cury})
    Transitions:Fade(nil, this, Stripes.OnFinish, this.time) 
  end,

  FadeOUT = function(this, func) 
    if Stripes:GetHeight() == 0 then Stripes:OnFinish() return end
    --this.func = func 
    --this.cury = this.sz_stripe
    --this.desty = this.sz_stripe
    --this.Upper:SetAnchor("TOP", this, "TOP", {0,this.cury})
    --this.Lower:SetAnchor("BOTTOM", this, "BOTTOM", {0,this.cury})
    Transitions:Fade(this, nil, Stripes.OnFinish, this.time) 
  end,

  SlideIN = function(this, func)
    if Stripes:GetHeight() == 0 then Stripes:OnFinish() return end
    if not this.cury then this.cury = this.sz_stripe end
    this.func = func
    this.desty = 0
    Transitions:CallRepeat(this.anim, 0)
  end,

  SlideOUT = function(this, func)
    if Stripes:GetHeight() == 0 then Stripes:OnFinish() return end
    if not this.cury then this.cury = 0 end
    this.func = func
    this.desty = this.sz_stripe
    Transitions:CallRepeat(this.anim, 0)
  end,

  OnFinish = function(this)
    if Stripes.func then Stripes.func() end
    Stripes.func = nil
  end,

  anim = function(param, elapsed)
    if Stripes.cury < Stripes.desty then
      local y = Stripes.cury + (elapsed * Stripes.speed)
      if y > Stripes.desty then y = Stripes.desty end
      Stripes.cury = y
    elseif Stripes.cury > Stripes.desty then
      local y = Stripes.cury - (elapsed * Stripes.speed)
      if y < Stripes.desty then y = Stripes.desty end
      Stripes.cury = y
    end
    Stripes.Upper:SetAnchor("TOP", Stripes, "TOP", {0,-Stripes.cury})
    Stripes.Lower:SetAnchor("BOTTOM", Stripes, "BOTTOM", {0,Stripes.cury})
    if Stripes:IsHidden() then Stripes:Show() end
    if Stripes.cury == Stripes.desty then
      Stripes:OnFinish()
      return 0 
    end 
  end,
}

--
-- DefComboBox
--

DefCombobox = uiwnd {
  virtual = true,

  --FILL THE NEXT MEMBERS FOR INSTANCING:
  --  btn_height  - button height

  Button = DefButton {
    OnClick = function(this)
      if this.disabled then return end
      if this:GetParent().Listbox:IsHidden() then
        this:GetParent().Listbox:Show()
        this.oldlayer = Modal:GetLayer()
        Modal.func = function() this:GetParent().Listbox:Hide() Modal:SetLayer(this.oldlayer) end
        Modal:SetLayer(this:GetParent().Listbox:GetLayer()-1)
        Modal:Show()
        this:GetParent().Listbox:UpdateList()
      else
        this:GetParent().Listbox:Hide()
        Modal:Hide()
        Modal:SetLayer(this.oldlayer)
        this.oldlayer = nil
      end
    end,
    
    SetText = function(this, idx)
      local data = this:GetParent().Listbox.list[idx]
      local str = this:GetParent().Listbox:GetItemText(idx)
      this.selected = idx
      this:SetStr(str)
      if this:GetParent().OnItemSelected then
        this:GetParent().OnItemSelected(this:GetParent().Listbox, idx)
      end  
    end,
  },
  
  Listbox = DefBtnListBox {
    hidden = true,
    textjustify = "CENTER",
    layer = 1000,
    
    Scrollbar = DefBtnListBox.Scrollbar { 
      hidden = true,
      anchors = { TOPRIGHT = { }, BOTTOMRIGHT = { } },
    },
    ScrollArea = DefBtnListBox.ScrollArea {
      anchors = { TOPLEFT = { 2, 3 }, BOTTOMRIGHT = { "BOTTOMRIGHT", "Scrollbar" } },
      back = uiimg { color = {20,20,20,255} },
    },
    --GetItemText = function(this, idx) 
    --end,
  },
  
  OnShow = function(this)
    if not this.customanchored then
      this.Button:SetAnchor("TOPLEFT", this, "TOPLEFT", {0,0})
      this.Button:AddAnchor("BOTTOMRIGHT", this, "TOPRIGHT", {0,this.btn_height})
      
      this.Listbox:SetAnchor("TOPLEFT", this.Button, "BOTTOMLEFT", {0,0})
      this.Listbox:AddAnchor("BOTTOMRIGHT", this, "BOTTOMRIGHT", {0,0})
    end
    
    
    if this.InitCombo then this.InitCombo(this) end
    
    this.initializing = true
    if this.Button.selected then
      this.Listbox:OnListClicked(this.Button.selected)
    else  
      this.Listbox:OnListClicked(1)
    end
    this.initializing = nil
  end,
  
  OnListItemClicked = function(this, listbox)
    if not listbox.list then return end
    local idx = listbox:GetNextSelected()
    if not idx or not listbox.list[idx] then return end
    if not this.initializing and listbox.list[idx].disabled then
      if this.OnDisabledClick then
        this.OnDisabledClick(idx)
      end
      return 
    end
    this.Button:SetText(idx)
    listbox:Hide()
    Modal:Hide()
  end,
}

--
-- DefPlayerLogo
--

DefPlayerLogo = uiwnd {
  virtual = true,
  
  Border = uiimg { size = {76,76}, layer = "+5", texture = "data/textures/ui/avatar_border.dds", coords = {0,0,76,76} },

  Back = uiimg {
    layer = "+1",
    Set = function(this, row, col, clr)
      this.clr = clr
      this:SetColor(this.clr)
    end,
  },
  
  Gradient = uiimg {
    layer = "+2",
    tex_w = 70,
    tex_h = 70,
    texture = "data/textures/ui/avatar_gradient.dds",
    Set = function(this, row, col, clr)
      this.row = row
      this.col = col
      this.clr = clr
      if not this.row or not this.col then
        this:Hide()
      else
        local top = (this.row-1)*this.tex_h
        local left = (this.col-1)*this.tex_w
        this:SetTexture(nil, {left, top, left+this.tex_w, top+this.tex_h})
        this:SetColor(this.clr)
        this:Show()
      end  
    end,
  },
  
  Frame = uiimg {
    layer = "+3",
    tex_w = 70,
    tex_h = 70,
    texture = "data/textures/ui/avatar_frame.dds",
    Set = function(this, row, col, clr)
      this.row = row
      this.col = col
      this.clr = clr
      if not this.row or not this.col then
        this:Hide()
      else  
        local top = (this.row-1)*this.tex_h
        local left = (this.col-1)*this.tex_w
        this:SetTexture(nil, {left, top, left+this.tex_w, top+this.tex_h})
        this:SetColor(this.clr)
        this:Show()
      end  
    end,
  },
  
  Symbol = uiimg {
    layer = "+4",
    tex_w = 70,
    tex_h = 70,
    texture = "data/textures/ui/avatar_symbol.dds",
    Set = function(this, row, col, clr)
      this.row = row
      this.col = col
      this.clr = clr
      if not this.row or not this.col then
        this:Hide()
      else  
        local top = (this.row-1)*this.tex_h
        local left = (this.col-1)*this.tex_w
        this:SetTexture(nil, {left, top, left+this.tex_w, top+this.tex_h})
        this:SetColor(this.clr)
        this:Show()
      end  
    end,
  },
  
  OnShow = function(this)
    this:Update()
  end,

  Update = function(this)
    local tbl = this:Load()
    this.Back:Set(0,0,tbl.back_clr)
    this.Gradient:Set(tbl.gradient_row, tbl.gradient_col, tbl.gradient_clr)
    this.Frame:Set(tbl.frame_row, tbl.frame_col, tbl.frame_clr)
    this.Symbol:Set(tbl.symbol_row, tbl.symbol_col, tbl.symbol_clr)
  end,

  Load = function(this)
    local tbl = game.LoadUserPrefs("player_logo")
    return tbl
  end,

  Save = function(this)
    if this.Back.clr then
      local tbl = {}
      tbl.back_clr = this.Back.clr
      tbl.gradient_row = this.Gradient.row
      tbl.gradient_col = this.Gradient.col
      tbl.gradient_clr = this.Gradient.clr
      tbl.frame_row = this.Frame.row
      tbl.frame_col = this.Frame.col
      tbl.frame_clr = this.Frame.clr
      tbl.symbol_row = this.Symbol.row
      tbl.symbol_col = this.Symbol.col
      tbl.symbol_clr = this.Symbol.clr
      game.SaveUserPrefs("player_logo", tbl)
      net.GLUserLogoChanged()
    end
  end,
}

--
-- Demo
--
local demolayer = 3000
local screentime = 10

Demo = uiwnd {
  hidden = true,
  keyboard = true,
  mouse = true,
  layer = demolayer,

  Back = uiimg {
    layer = demolayer,
    color = {0,0,0,255},
  },

  Image = uiimg {
    layer = demolayer + 1,
  },

	Close = DefButton1 { 
    layer = demolayer + 3,
    anchors = { BOTTOMRIGHT = { -10, -10 } },
  	str = TEXT{"close_caps"},
    
    OnClick = function(this)
      Demo:DoHide()
    end,
  },

  -- the start function
  Set = function(this, prefix, callback)
    this:Reset()
    this.index = 1
    this.prefix = prefix
    this.callback = callback
    this:Show_slide()
  end,
  
  DoHide = function(this)
    if this.callback then this.callback() this.callback = nil return end
    this:Hide()
  end,
  
  -- below - internal call only
  OnHide = function(this)
    this:Reset()
  end,

  OnMouseDown = function(this)
    this:Show_slide()
  end,

  Reset = function(this)
    if this.id then
      Transitions:CancelOnce(this.id)
      this.id = nil
    end
    this.index = nil
    this.prefix = nil
    this.callback = nil
  end,

  Show_slide = function(this)
    if Demo.id then
      Transitions:CancelOnce(Demo.id)
      Demo.id = nil
    end
    local filename = "data/demo/"..game.GetLang().."/"..game.GetLang().."_"..Demo.prefix.."_"..Demo.index..".dds"
    local pw,ph = game.GetTextureInfo(filename)
    if not pw or not ph then Demo:DoHide() return end

    Demo.index = Demo.index + 1
    Demo.Image:SetTexture(filename)
    local sz = DESKTOP:GetSize()
    local h = sz.x * (9/16)
    Demo.Image:SetSize{sz.x,h}
    Demo.id = Transitions:CallOnce(Demo.Show_slide, screentime)
    Demo:Show()
  end,
}
