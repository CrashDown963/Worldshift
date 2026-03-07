local set_layer = modallayer-1
local chk_size = {20,20}
local settw = 645
local setth = 720

--

DefGSStat = uiwnd {
  virtual = true,
  size = {300, 45},

	Title = uitext {
	  layer = "+2",
	  size = {250,20},
	  halign = "LEFT",
	  anchors = { TOPLEFT = { 2,5 } },
    font = "Verdana,10",
	},

  StatPanel = uiwnd {
    size = {120,29},
	  anchors = { TOPLEFT = {150,2 } },
    Back = DefBackInBlack{ layer = "+1" },
    Text = uitext {
      layer = "+3",
      color = {255, 143, 51},
      font = "Verdana,11b",
      str = "N/A",
    },
	},
	
  Sepline = uiimg {
    layer = "+2",
    size = {290,30},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    anchors = { TOP = { -15, 43 } },
    tiled = {60, 3, 60, 3},
  },  	
}


--
DefSubTabButton = DefButton {
  virtual = true,
  size = {255,38},
  checked = 0,
  
  NormalImage = uiimg { texture = "data/textures/ui/settings_button.dds" },
  HighImage   = uiimg { texture = "data/textures/ui/settings_button.dds" },
  PushImage   = uiimg { texture = "data/textures/ui/settings_button.dds" },
  
  n_crd = {0, 0, 255, 38},
  h_crd = {0, 38, 255, 38+38},
  p_crd = {0, 76, 255, 38+76},
  
  n_clr = {255,255,255,255},
  h_clr = {255,255,255,255},
  p_clr = {0, 0, 0, 0},

  OnShow = function(this) this:updatetextures() end,

  updatetextures = function(this)
    if this.checked == 0 then
      this.NormalImage:SetTexture(nil, this.n_crd)
      this.HighImage:SetTexture(nil, this.h_crd)
      this.PushImage:SetTexture(nil, this.h_crd)
      
      this.NormalText:SetColor(this.n_clr)
      this.HighText:SetColor(this.h_clr)
      this.PushText:SetColor(this.h_clr)
    else
      this.NormalImage:SetTexture(nil, this.p_crd)
      this.HighImage:SetTexture(nil, this.p_crd)
      this.PushImage:SetTexture(nil, this.p_crd)
      
      this.NormalText:SetColor(this.p_clr)
      this.HighText:SetColor(this.p_clr)
      this.PushText:SetColor(this.p_clr)
    end
  end,
  
  OnClick = function(this)
    if this.checked == 1 then return end
    
    if Settings.lastsel then
      Settings.lastsel.checked = 0
      Settings.lastsel:updatetextures()
    end
    this.checked = 1
    this:updatetextures()
    Settings.lastsel = this
    
    if this == Settings.AudioSetBtn then
      Settings.GameSettingsTab.AudioFrame:Show() 
      Settings.GameSettingsTab.VideoFrame:Hide() 
      Settings.GameSettingsTab.PlayerFrame:Hide() 
    elseif this == Settings.VideoSetBtn then
      Settings.GameSettingsTab.AudioFrame:Hide() 
      Settings.GameSettingsTab.VideoFrame:Show() 
      Settings.GameSettingsTab.PlayerFrame:Hide() 
    else -- player settings
      Settings.GameSettingsTab.AudioFrame:Hide() 
      Settings.GameSettingsTab.VideoFrame:Hide() 
      Settings.GameSettingsTab.PlayerFrame:Show() 
    end
  end,
}

--
DefSndSlider = uiscroll {
  virtual = true,
  size = {200,10},
  
  clr_l = 0,
  clr_t = 0,
  clr_w = 183,
  clr_h = 10,

  Slider = uislider {
    vertical = false,
    Back = uiimg {
      size = {203,32},
      texture = "data/textures/ui/setting_bar_empty.dds",
      coords = {0, 0, 203, 32},
      anchors = { CENTER = {-1,3} },
    },
    
    Fore = uiimg {
      layer = "+1",
      size = {183,10},
      texture = "data/textures/ui/setting_bars.dds",
      coords = {0, 0, 183,10},
      anchors = { LEFT = {8,-1} },
    },

    ThumbBtn = uibtn {
      size = {24,22},
      layer = "+2",
      anchors = { LEFT = {0,-1} },
      NormalImage = uiimg { texture = "data/textures/ui/settings_slider.dds", coords = {0, 0, 24, 22} },
      HighImage   = uiimg { texture = "data/textures/ui/settings_slider.dds", coords = {0, 0, 24, 22} },
      PushImage   = uiimg { texture = "data/textures/ui/settings_slider.dds", coords = {0, 0, 24, 22} },
    },
  },
  
  InitPosition = function(this)
  --OnShow = function(this)
    this:SetMinMaxRange(0, 100)
    this:SetPos(this.initpos or 0)
  end,

  OnScroll = function(this)
    this:update(argPos)
  end,

  update = function(this, pos)
    if not pos then pos = this:GetPos() end
    local min, max, step = this:GetMinMaxRange()
    local w = this.clr_w * (pos/max)
    this.Slider.Fore:SetSize{w, this.clr_h}
    this.Slider.Fore:SetTexture(nil, {this.clr_l, this.clr_t, this.clr_l+w, this.clr_t+this.clr_h})
  end,
}

DefGfxSlider = DefSndSlider {
  max_range = 1,
  
  InitPosition = function(this)
  --OnShow = function(this)
    this:SetMinMaxRange(1, this.max_range)
    this:SetPos(this.initpos or 1)
  end,  
}

--
local DetailCombo = DefCombobox {
  btn_height = 16,
  layer = set_layer,

  Button = DefCombobox.Button {
    font = "Trebuchet MS,10b",
      
    NormalText = uitext  { color = {0, 0, 0} },
    HighText  = uitext { color = {255, 143, 51} },
    PushText = uitext { color = {255, 143, 51} },
      
    NormalImage = uiimg {
      texture = "data/textures/ui/game_back_text_plate2.dds",
      coords = {0, 0, 229, 16},
    },
      
    HighImage = uiimg {
      texture = "data/textures/ui/game_back_text_plate2.dds",
      coords = {0, 16, 229, 16},
    },	

    PushImage = uiimg {
      texture = "data/textures/ui/game_back_text_plate2.dds",
      coords = {0, 32, 229, 16},
    },
  },
    
  Listbox = DefCombobox.Listbox {
    font = "Trebuchet MS,10",
    layer = set_layer + 1,
    ncolor = {143, 153, 138},
    hcolor = {236, 254, 227},
    pcolor = {236, 254, 227},
    scolor = {255, 143, 51},
    
    ScrollArea = DefCombobox.Listbox.ScrollArea {
      layer = set_layer + 3,
      anchors = { TOPLEFT = { 0, 3 }, BOTTOMRIGHT = { "BOTTOMRIGHT", "Scrollbar" } },
      back = uiimg {
        layer = set_layer + 2,
        color = { 0,0,0,255 }, 
        --texture = "data/textures/ui/ui.tga",
        coords = {0, 199, 27, 27},
        tiled = 1,
        shader = "_Misc_InterfaceDraw",
      },
    },
    GetItemText = function(this, idx) return this.list[idx] end,
  },
      
  UpdateItem = function(this, item, data)
    item:SetStr(data)
  end,

  OnItemSelected = function(listbox, idx)
    listbox:GetItemText(idx)
  end,
}
--
local DefCheckButton = DefButton {
  virtual = true,
  size = {230,40},
  
  checked = 0,
  font = "Trebuchet MS,10b",

  NormalImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  HighImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  PushImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  
  NormalText = DefButton.NormalText { halign = "LEFT", color = {236,254,227}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  HighText = DefButton.HighText { halign = "LEFT", color = {236,254,227}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  PushText = DefButton.PushText { halign = "LEFT", color = {236,254,227}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  
  -- unchecked texture coordinates
  UN_coords = { 0, 0, 24, 24},
  UH_coords = {24, 0, 24+24, 24},
  UP_coords = {48, 0, 24+48, 24},
  -- checked texture coordinates
  CN_coords = { 0, 24, 24, 24+24},
  CH_coords = {24, 24, 24+24, 24+24},
  CP_coords = {48, 24, 24+48, 24+24},
  
  OnShow = function(this) this:updatetextures() end,

  updatetextures = function(this)
    if this.checked == 0 then
      this.NormalImage:SetTexture(nil, this.CH_coords)
      this.HighImage:SetTexture(nil, this.CH_coords)
      this.PushImage:SetTexture(nil, this.CH_coords)
    else
      this.NormalImage:SetTexture(nil, this.UP_coords)
      this.HighImage:SetTexture(nil, this.UP_coords)
      this.PushImage:SetTexture(nil, this.UP_coords)
    end  
  end,

  OnClick = function(this)
    if this.checked == 0 then this.checked = 1 else this.checked = 0 end  
    this:updatetextures()
  end,
}
--
local DefTab = DefButton {
  virtual = true,
	font = "Verdana,10b",
	
	selected = false,
  
  n_coords = {0,0,311,28},
  h_coords = {0,28,311,28+28},
  p_coords = {0,56,311,56+28},
  s_clr = {0, 0, 0, 0},
  n_clr = {100, 100, 100, 255},

	NormalImage = uiimg { texture = "data/textures/ui/tab2.dds" },
  HighImage = uiimg { texture = "data/textures/ui/tab2.dds" },
  PushImage = uiimg { texture = "data/textures/ui/tab2.dds" },
  
	SelectTab = function(this, select)
    this.selected = select
    if select then
      this.NormalImage:SetTexture(nil, this.p_coords)
      this.HighImage:SetTexture(nil, this.p_coords)
      this.PushImage:SetTexture(nil, this.h_coords)
      
      this.NormalText:SetColor(this.s_clr)
      this.HighText:SetColor(this.s_clr)
      this.PushText:SetColor(this.s_clr)
    else
      this.NormalImage:SetTexture(nil, this.n_coords)
      this.HighImage:SetTexture(nil, this.h_coords)
      this.PushImage:SetTexture(nil, this.h_coords)
      
      this.NormalText:SetColor(this.n_clr)
      this.HighText:SetColor(this.n_clr)
      this.PushText:SetColor(this.n_clr)
    end
  end,
  
  OnShow = function(this)
    this:SelectTab(this.selected) 
  end,

  OnClick = function(this) if this.disabled then return end this:GetParent():OnTabClick(this) end,
}
--
local DefLogoBtn = DefButton {
  virtual = true,
  size = {42,42},
  
  NormalImage = uiimg { layer = "+2", texture = "data/textures/ui/logo_setup_frame.dds", coords = {0,0,42,42} },
  HighImage = uiimg { layer = "+2", texture = "data/textures/ui/logo_setup_frame.dds", coords = {0,42,42,42} },
  PushImage = uiimg { layer = "+2", texture = "data/textures/ui/logo_setup_frame.dds", coords = {0,42,42,42} },

  Selected = uiimg {
    layer = "+3",
    hidden = true,
    size = {48,48},
    texture = "data/textures/ui/reward_chosen.dds",
    coords = {0,0,64,64},
  },

  Shape = uiimg {
    layer = "+1",
    size = {42-6, 42-6},
  },

  OnShow = function(this)
  end,

  Update = function(this)
    local logo = Settings.GameSettingsTab.PlayerFrame.Logo
    this.row = logo[this.present].row
    this.col = logo[this.present].col
    if this.row and this.col then
      local height = logo[this.present].tex_h
      local width = logo[this.present].tex_w
      local top = (this.row-1)*height
      local left = (this.col-1)*width
      this.Shape:SetTexture(logo[this.present].texture, {left, top, left+width, top+height})
    end
    
    this.clr = logo[this.present].clr
    if this.clr then
      this.Shape:SetColor(this.clr)
    end
  end,

  OnClick = function(this)
    this:GetParent():ChangeLogoLayer(this, "LEFT")
  end,

  OnRClick = function(this)
    this:GetParent():ChangeLogoLayer(this, "RIGHT")
  end,

  OnMouseEnter = function(this)
    Tooltip:AttachTo(this, "TOPRIGHT", this, "BOTTOMRIGHT", {0,10})
    Tooltip.Title:SetStr("<p>"..TEXT{this.ttkey_ttl})
    Tooltip.Text:SetStr("<p>"..TEXT{this.ttkey_txt})
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,

  OnMouseLeave = function(this)
    Tooltip:Hide()
  end,
}
--
local DefStat = uiwnd {
  virtual = true,
  size = {100,42},
  mouse = true,

  Icon = uiimg {
    layer = "+3",
    size = {42,42},
    texture = "data/textures/ui/status_icons.dds",
    anchors = { LEFT = { 0,0 } },
  },
  
  Value = uiwnd {
    layer = "+1",
    size = {60,32},
    anchors = { LEFT = { "RIGHT", "Icon", -10,0 } },  
    Back = uiimg {
      layer = "+1", 
      size = {90,32},
      texture = "data/textures/ui/stat_black_back.dds",
      coords = {139,0,90,32},
    },
    Text = uitext {
      layer = "+2", 
      font = "Verdana,11b",
      color = {255, 143, 51},
      halign = "RIGHT",
      str = "XX%",
    },
  },
  
  OnShow = function(this)
    local sz = this.Icon:GetSize()
    local left = (this.col-1)*sz.x
    this.Icon:SetTexture(nil, {left, 0, left+sz.x, sz.y})
  end,

  OnMouseEnter = function(this)
    Tooltip:AttachTo(this, "TOPRIGHT", this, "BOTTOMRIGHT", {0,0})
    Tooltip.Title:SetStr("<p>"..TEXT{this.ttkey.."_ttl"})
    Tooltip.Text:SetStr("<p>"..TEXT{this.ttkey.."_txt"})
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,

  OnMouseLeave = function(this)
    Tooltip:Hide()
  end,
}

--
local cell_w = 42
local cell_h = 42
local cell_cols = 6
local cell_rows = 3
local cell_dx = 2
local cell_dy = 2
local offs_x = 5
local offs_y = 5
local colors_w = (cell_cols * (cell_w + cell_dx)) + cell_dx
local colors_h = (cell_rows * (cell_h + cell_dy)) + cell_dy
local tex_w = 70
local tex_h = 70

ShapePicker = uiwnd {
  hidden = true,
  layer = modallayer+1,
  size = {colors_w + 6, colors_h + 6},
  
  DefCornerFrameImage2 {},
  
  OnShapeClicked = function(this, x, y)
    if this.func then this.func(x,y,this) end
    this:Hide()
  end,
  
  OnRollInColor = function(this, x, y)
    if this.rollinfunc then
      this.rollinfunc(x,y,this)
    end
  end,
  
  OnRollOutColor = function(this)
    if this.rolloutfunc then
      this.rolloutfunc(this)
    end
  end,
    
  OnShow = function(this)
    if not ShapePicker.Cell_1 then
      local i = 1
      for y = 1, cell_rows do
        for x = 1, cell_cols do
          local cell = DefButton {
            size = {cell_w,cell_h},
            col = x,
            row = y,

            NormalImage = uiimg { layer = "+2", texture = "data/textures/ui/logo_setup_frame.dds", coords = {0,0,42,42} },
            HighImage = uiimg { layer = "+2", texture = "data/textures/ui/logo_setup_frame.dds", coords = {0,42,42,42} },
            PushImage = uiimg { layer = "+2", texture = "data/textures/ui/logo_setup_frame.dds", coords = {0,42,42,42} },

            Shape = uiimg {
              layer = "+1",
              size = {cell_w-6,cell_h-6},
            },

            OnClick = function(this)
              this:GetParent():OnShapeClicked(this.col, this.row) 
            end,
            OnMouseEnter = function(this)
              this:GetParent():OnRollInColor(this.col, this.row) 
            end,
            OnMouseLeave = function(this)
              this:GetParent():OnRollOutColor() 
            end,
          }
          
          if x == 1 and y == 1 then
            cell.anchors = { TOPLEFT = { "TOPLEFT", offs_x, offs_y } }
          elseif y == 1 then
            cell.anchors = { LEFT = { "Cell_" .. (i-1), "RIGHT", cell_dx,0 } }
          else
            cell.anchors = { TOP = { "Cell_" .. (i-cell_cols), "BOTTOM", 0,cell_dy } }
          end
          
          ShapePicker["Cell_" .. i] = cell
          i = i + 1
        end
      end
      ShapePicker:CreateChildren()
    end

    local i = 1
    for y = 1, cell_rows do
      for x = 1, cell_cols do
        local cell = ShapePicker["Cell_" .. i]
        local top = (y-1)*tex_h
        local left = (x-1)*tex_w
        cell.Shape:SetTexture(this.texture, {left, top, left+tex_w, top+tex_h})
        i = i + 1
      end
    end

    Modal.func = function() ShapePicker:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide()
	  this.func = nil
	  this.rollinfunc = nil
	  this.rolloutfunc = nil
	  if this.execonhide then this.execonhide(this) end
	  this.execonhide = nil
	end,
}

--
--
--

Settings = uiwnd {
  hidden = true,
  mouse = true,
  keyboard = true,
  layer = set_layer,
  size = {settw,setth},
  anchors = { TOPRIGHT = { "TOPRIGHT", "Lobby", -10, 60 } },

  Frame = DefBigBackImage{layer = set_layer-2},

  BlackPlate = uiwnd {
    --hidden = true,
    layer = set_layer-1,
    size = {1,25},
    anchors = { TOPLEFT =  { "Frame", 5,5 }, TOPRIGHT = { "Frame", -5,5 } },
    back = uiimg { color = {0,0,0,255} },
    text = uitext {
      layer = "+1",
      font = "Verdana,10b",
      color = {255, 143, 51},
      str = TEXT("game_settings"),
    },
  },

  TabGameSettings = DefTab {
    hidden = true,
    size = {1,28},
    anchors = { TOPLEFT = { "Frame", 10, 10 }, TOPRIGHT = { "TOP", "Frame", -1,10 } },
    str = TEXT{"game_settings"},
  },

  TabPlayerSettings = DefTab {
    hidden = true,
    size = {1,28},
    anchors = { TOPRIGHT = { "TOPRIGHT", "Frame", -10,10 }, TOPLEFT = { "TOP", "Frame", 1,10 } },
    str = TEXT{"player_profile"},
  },

  GameSettingsTab = uiwnd {
    hidden = true,
    mouse = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TabGameSettings", 0,1 }, BOTTOMRIGHT = { "Frame", -10,-55 } },
    
    SelectionFrame = uiwnd {
      --anchors = { TOPLEFT = { "TOP", 1,0 }, BOTTOMRIGHT = { 0,0 } }, 
      anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "BOTTOM", -1,0 } },
      Frame = DefSmallBackImage { layer = "-1" },
      --Title = uitext {
        --size = {1,25},
        --font = "Verdana,10b",
        --color = {255, 143, 51},
        --anchors = { TOPLEFT = { "Frame", 0,2 }, TOPRIGHT = { "Frame", 0,2 } },
        --str = TEXT("video_settings"),
      --},
    },    

    PlayerFrame = uiwnd {
      hidden = true,
      anchors = { TOPLEFT = { "TOP", 1,0 }, BOTTOMRIGHT = { 0,0 } }, 
      
      Frame = DefSmallBackImage {layer = "-1"},
      
      Title = uitext {
        size = {1,25},
        font = "Verdana,10b",
        color = {255, 143, 51},
        anchors = { TOPLEFT = { "Frame", 0,2 }, TOPRIGHT = { "Frame", 0,2 } },
        str = TEXT("player_frame"),
      },
      
    
      Logo = DefPlayerLogo {
        size = {70,70},
        anchors = { TOPLEFT = { "Frame", 20,40 } },
        
        OnShow = function(this)
          --DefPlayerLogo.OnShow(this)
          this:GetParent().LogoBack:Update()
          this:GetParent().LogoGradient:Update()
          this:GetParent().LogoFrame:Update()
          this:GetParent().LogoSymbol:Update()
        end,
      },
      
      Name = uitext {
        size = {1,20},
        layer = "+1",
        halign = "LEFT",
        font = "Verdana,11",
        anchors = { TOPLEFT = { "TOPRIGHT", "Logo", 10,0 }, TOPRIGHT = { "TOPRIGHT", "Frame", -10,40 } },
      },
      
      LogoBack = DefLogoBtn { 
        present = "Back", 
        anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,10 } },
        ttkey_ttl = "logo_background_ttl",
        ttkey_txt = "logo_background_txt",
      },

      LogoGradient = DefLogoBtn {
        present = "Gradient",
        anchors = { LEFT = { "RIGHT", "LogoBack", 10,0 } },
        ttkey_ttl = "logo_gradient_ttl",
        ttkey_txt = "logo_click_txt",
      },

      LogoFrame = DefLogoBtn {
        present = "Frame",
        anchors = { LEFT = { "RIGHT", "LogoGradient", 10,0 } },
        ttkey_ttl = "logo_frame_ttl",
        ttkey_txt = "logo_click_txt",
      },

      LogoSymbol = DefLogoBtn {
        present = "Symbol",
        anchors = { LEFT = { "RIGHT", "LogoFrame", 10,0 } },
        ttkey_ttl = "logo_symbol_ttl",
        ttkey_txt = "logo_click_txt",
      },
      
      SettingsText = uitext {
        layer = "+1",
        size = {1,20},
        halign = "LEFT",
        font = "Verdana,11b",
        anchors = { TOPLEFT = { "LEFT", "Frame", 20,-33 }, TOPRIGHT = { "CENTER", "Frame", -20,-33 } },
        str = TEXT{"settings"},
      },
      
      IgnoreAllInvitations = DefCheckButton {
        font = "Verdana,10",
        anchors = { TOPLEFT = { "BOTTOMLEFT", "SettingsText", 10, 10 } },
        str = "<p>"..TEXT{"ignore_all_invitations"},
        OnClick = function(this)
          DefCheckButton.OnClick(this)
          this:GetParent():OnCheckClicked(this) 
        end,
      },
      
      ShowFriendsInvitations = DefCheckButton {
        font = "Verdana,10",
        anchors = { TOPLEFT = { "BOTTOMLEFT", "IgnoreAllInvitations", 10, 5 } },
        str = "<p>"..TEXT{"show_friends_invitations"},
        OnClick = function(this)
          DefCheckButton.OnClick(this)
          this:GetParent():OnCheckClicked(this) 
        end,
      },      
      
      OnShow = function(this)
        local pname = net.Lobby_GetPlayerName()
        this.Name:SetStr(TEXT{"logo_name", pname})
        --[[
        local ps = game.LoadUserPrefs("PlayerSettings")
        if not ps then -- default player settings
          ps = {}
          ps.ignore_invits = 0
          ps.friends_invits = 0
          ps.allow_inspected = 1
          game.SaveUserPrefs("PlayerSettings", ps)
        end
        this.IgnoreAllInvitations.checked = ps.ignore_invits
        this.IgnoreAllInvitations:updatetextures()
        this.ShowFriendsInvitations.checked = ps.friends_invits
        this.ShowFriendsInvitations:updatetextures()
        --]]
        
        --this.AllowInspected.checked = ps.allow_inspected
        --this.AllowInspected:updatetextures()
      end,
      
      OnCheckClicked = function(this, check)
        if check == this.IgnoreAllInvitations then
          if check.checked then
            this.ShowFriendsInvitations.checked = 0
            this.ShowFriendsInvitations:updatetextures()
          end  
        end
        if check == this.ShowFriendsInvitations then
          if check.checked then
            this.IgnoreAllInvitations.checked = 0
            this.IgnoreAllInvitations:updatetextures()
          end  
        end
      end,
      
      ChangeLogoLayer = function(this, btn, mousebtn)
        this.org_row = this.Logo[btn.present].row
        this.org_col = this.Logo[btn.present].col
        this.org_clr = this.Logo[btn.present].clr
        btn.Selected:Show()

        if btn == this.LogoBack then mousebtn = "RIGHT" end

        if mousebtn == "LEFT" then
          ShapePicker:SetAnchor("TOPLEFT", this.Logo, "BOTTOMLEFT", {0,20})
          
          if btn == this.LogoGradient then
            ShapePicker.texture = "data/textures/ui/avatar_gradient.dds"
          end
          if btn == this.LogoFrame then
            ShapePicker.texture = "data/textures/ui/avatar_frame.dds"
          end
          if btn == this.LogoSymbol then
            ShapePicker.texture = "data/textures/ui/avatar_symbol.dds"
          end

          ShapePicker.func = function(col, row, picker)
            this.Logo[btn.present]:Set(row, col, this.org_clr)
            btn:Update()
          end
          ShapePicker.rollinfunc = function(col, row, picker)
            this.Logo[btn.present]:Set(row, col, this.org_clr)
          end
          ShapePicker.rolloutfunc = function(picker)
            this.Logo[btn.present]:Set(this.org_row, this.org_col, this.org_clr)
          end
          ShapePicker.execonhide = function(picker)
            this.org_row = nil
            this.org_col = nil
            this.org_clr = nil
            btn.Selected:Hide()
          end
          ShapePicker:Show()
        else
          ColorPicker:SetAnchor("TOPLEFT", this.Logo, "BOTTOMLEFT", {0,20})
          ColorPicker.func = function(clr, picker)
            this.Logo[btn.present]:Set(this.org_row, this.org_col, clr)
            btn:Update()
          end
          ColorPicker.rollinfunc = function(clr, picker)
            this.Logo[btn.present]:Set(this.org_row, this.org_col, clr)
          end
          ColorPicker.rolloutfunc = function(picker)
            this.Logo[btn.present]:Set(this.org_row, this.org_col, this.org_clr)
          end
          ColorPicker.execonhide = function(picker)
            this.org_row = nil
            this.org_col = nil
            this.org_clr = nil
            btn.Selected:Hide()
          end
          ColorPicker:Show()
        end
      end,
      
      
    },
    
    VideoFrame = uiwnd {
      anchors = { TOPLEFT = { "TOP", 1,0 }, BOTTOMRIGHT = { 0,0 } }, 
      --anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "BOTTOM", -1,0 } },
      Frame = DefSmallBackImage {layer = "-1"},
      Title = uitext {
        size = {1,25},
        font = "Verdana,10b",
        color = {255, 143, 51},
        anchors = { TOPLEFT = { "Frame", 0,2 }, TOPRIGHT = { "Frame", 0,2 } },
        str = TEXT("video_settings"),
      },
      
      
      ScrResTitle = uitext {
        layer = set_layer+1,
        size = {270, 20},
        color = {236, 254, 227},
        font = "Trebuchet MS,10b",
        anchors = { TOPLEFT = { 20,35 } },
        str = TEXT{"screen resolution"},
      },

      ScrResList = DefBtnListBox {
        size = {270, 100},
        anchors = { TOPLEFT = { "BOTTOMLEFT", "ScrResTitle", 0,2 } },
        ScrollArea = DefBtnListBox.ScrollArea { Back = uiimg { color = {10,10,10,180} } },
      
        UpdateItem = function(this, item, data)
          item:SetStr(data.width .. "x" .. data.height)
          item.data = data
          if this.selected_item == data then
            item.NormalText:SetColor(this.scolor)
            item.HighText:SetColor(this.scolor)
            item.PushText:SetColor(this.scolor)
          else  
            item.NormalText:SetColor(this.ncolor)
            item.HighText:SetColor(this.hcolor)
            item.PushText:SetColor(this.pcolor)
          end
        end,
      },

      CheckFullscreenMode = DefCheckButton {
        anchors = { TOPLEFT = { "BOTTOMLEFT", "ScrResList", 0,10 } },
        str = TEXT{"fullscreen mode"},
      },
    
---------- VSync check box

      CheckVSync = DefCheckButton {
        anchors = { TOPLEFT = { "BOTTOMLEFT", "CheckFullscreenMode", 0, 10 } },
        str = TEXT{"vsync_check"},
      },
  
---------------------------------------------------------------------     
   
---------- Antialiasing combo box & text description    

	    AntialiasingCombo = DetailCombo {
		    size = {120,100},
		    thelist = nil,
  	    anchors = { TOPLEFT = { "BOTTOMLEFT", "CheckVSync", 0, 20 } },
  	    
		    InitCombo = function(this)
		      if not this.Listbox.list or #this.Listbox.list < 1 then
			      local temp = {}
  			    this.Listbox:SetList(temp)
		      end
		    end,
		  
		    InitComboFromList = function(this, lst)
		      local temp = {}
		      table.insert(temp, TEXT{"shadow_detail_off"})
        
          for i = 2,16 do
            if lst[i] then
              table.insert(temp, i.."x")
            end
          end
        		    
		      this.Listbox:SetList(temp)
		    
		      this.thelist = lst
		    end,
		  
		    GetItemIndex = function(this, val)
		      if val == 0 then return 1 end
		      local ind = 1
          for i = 2,16 do
            if this.thelist[i] then
              ind = ind + 1
            end
          
            if i == val then
              return ind
            end
          end
		    end,			  		  
		  
		    GetMSbyIndex = function(this, val)
		      if val == 1 then return 0 end
		      local ind = 1
          for i = 2,16 do
            if this.thelist[i] then
              ind = ind + 1
            end
          
            if ind == val then
              return i
            end
          end
		    end,			  		  
	    },    
	  
      AntialiasingComboText = uitext {
        size = {170, 20},
        anchors = { TOPLEFT = { "TOPRIGHT", "AntialiasingCombo", 10,-2 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        halign = "LEFT",
        str = TEXT{"antialiasing"},
      },

---------------------------------------------------------------------    
    
---------- Texture Detail combo box & text description    

	    TextureDetailCombo = DetailCombo {
		    size = {120,100},
  	    --anchors = { TOPLEFT = { "BOTTOMLEFT", "CheckVSync", 0, 30 } },
  	    anchors = { TOPRIGHT = { "BOTTOMLEFT", "AntialiasingComboText", -10, 10 } },
  	    
		    InitCombo = function(this)
		      if not this.Listbox.list or #this.Listbox.list < 1 then
			      local temp = {}
			      table.insert(temp, TEXT{"tex_detail_vhigh"})
			      table.insert(temp, TEXT{"tex_detail_high"})
			      table.insert(temp, TEXT{"tex_detail_med"})
			      table.insert(temp, TEXT{"tex_detail_low"})
			      --table.insert(temp, TEXT{"tex_detail_vlow"})
			      this.Listbox:SetList(temp)
		      end
		    end,
	    },    
	  
      TextureDetailComboText = uitext {
        size = {170, 20},
        anchors = { TOPLEFT = { "TOPRIGHT", "TextureDetailCombo", 10,-2 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        halign = "LEFT",
        str = TEXT{"tex_detail"},
      },

---------------------------------------------------------------------    

---------- Shader Detail combo box & text description    

	    ShaderDetailCombo = DetailCombo {
		    size = {120,80},
  	    anchors = { TOPRIGHT = { "BOTTOMLEFT", "TextureDetailComboText", -10, 10 } },

		    InitCombo = function(this)
		      if not this.Listbox.list or #this.Listbox.list < 1 then
			      local temp = {}
			      table.insert(temp, TEXT{"shader_detail_high"})
			      table.insert(temp, TEXT{"shader_detail_med"})
			      table.insert(temp, TEXT{"shader_detail_low"})
			      this.Listbox:SetList(temp)
		      end
		    end,
	    },    
	  
      ShaderDetailComboText = uitext {
        size = {170, 20},
        anchors = { TOPLEFT = { "TOPRIGHT", "ShaderDetailCombo", 10,-2 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        halign = "LEFT",
        str = TEXT{"shader_detail"},
      },

---------------------------------------------------------------------    

---------- Models Detail combo box & text description    

	    ModelsDetailCombo = DetailCombo {
		    size = {120,80},
  	    anchors = { TOPRIGHT = { "BOTTOMLEFT", "ShaderDetailComboText", -10, 10 } },
  	    
		    InitCombo = function(this)
		      if not this.Listbox.list or #this.Listbox.list < 1 then
			      local temp = {}
			      table.insert(temp, TEXT{"models_detail_high"})
			      table.insert(temp, TEXT{"models_detail_med"})
			      table.insert(temp, TEXT{"models_detail_low"})
			      this.Listbox:SetList(temp)
		      end
		    end,
	    },    
	  
      ModelsDetailComboText = uitext {
        size = {170, 20},
        anchors = { TOPLEFT = { "TOPRIGHT", "ModelsDetailCombo", 10,-2 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        halign = "LEFT",
        str = TEXT{"models_detail"},
      },

---------------------------------------------------------------------    

---------- Shadows Detail combo box & text description    

	    ShadowDetailCombo = DetailCombo {
		    size = {120,80},
  	    anchors = { TOPRIGHT = { "BOTTOMLEFT", "ModelsDetailComboText", -10, 10 } },
  	    
		    InitCombo = function(this)
		      if not this.Listbox.list or #this.Listbox.list < 1 then
			      local temp = {}
			      table.insert(temp, TEXT{"shadow_detail_normal"})
			      table.insert(temp, TEXT{"shadow_detail_low"})
			      table.insert(temp, TEXT{"shadow_detail_off"})
			      this.Listbox:SetList(temp)
		      end
		    end,
	    },    
	  
      ShadowDetailComboText = uitext {
        size = {170, 20},
        anchors = { TOPLEFT = { "TOPRIGHT", "ShadowDetailCombo", 10,-2 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        halign = "LEFT",
        str = TEXT{"shadow_detail"},
      },

--------------------------------------------------------------------- 

---------- Effects combo box & text description    

	    EffectsCombo = DetailCombo {
		    size = {120,80},
  	    anchors = { TOPRIGHT = { "BOTTOMLEFT", "ShadowDetailComboText", -10, 10 } },
  	    
		    InitCombo = function(this)
		      if not this.Listbox.list or #this.Listbox.list < 1 then
			      local temp = {}
			      table.insert(temp, TEXT{"effects_all"})
			      table.insert(temp, TEXT{"effects_med"})
			      table.insert(temp, TEXT{"effects_low"})
			      this.Listbox:SetList(temp)
		      end
		    end,
	    },    
	  
      EffectsComboText = uitext {
        size = {170, 20},
        anchors = { TOPLEFT = { "TOPRIGHT", "EffectsCombo", 10,-2 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        halign = "LEFT",
        str = TEXT{"effects_scale"},
      },

--------------------------------------------------------------------- 


---------- Reflections check box

      CheckReflections = DefCheckButton {
        anchors = { TOPLEFT = { "TOPLEFT", "EffectsCombo", 0, 40 } },
        str = TEXT{"reflections_check"},
      },
  
--------------------------------------------------------------------- 

---------- Post-process effects check box

      CheckPostprocess = DefCheckButton {
        anchors = { TOPLEFT = { "BOTTOMLEFT", "CheckReflections", 0, 10 } },
        str = TEXT{"postprocess_check"},
      },
    
---------- Anisotropic
    
      AnisotropicText = uitext {
        size = {200,20},
        anchors = { TOP = { "BOTTOM", "CheckPostprocess", 0, 15 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        str = TEXT{"aniso_slider"},
      },

      Anisotropy = DefGfxSlider {
        anchors = { TOP = { "BOTTOM", "AnisotropicText", 0,10 } },
        initpos = 1,
      },          
    },
 
---------------------------------------------------------------------    
    AudioFrame = uiwnd {
      hidden = true,
      anchors = { TOPLEFT = { "TOP", 1,0 }, BOTTOMRIGHT = { 0,0 } },  
      Frame = DefSmallBackImage {layer = "-1"},
      Title = uitext {
        size = {1,25},
        font = "Verdana,10b",
        color = {255, 143, 51},
        anchors = { TOPLEFT = { "Frame", 0,2 }, TOPRIGHT = { "Frame", 0,2 } },
        str = TEXT("audio_settings"),
      },

      CheckSoundsEnabled = DefCheckButton {
        anchors = { TOPLEFT = { 20,35 } },
        str = TEXT{"sounds_enabled"},
      },

      MasterVolumeText = uitext {
        size = {200,20},
        anchors = { TOP = { 0,85 } },
        color = {236,254,227},
        font = "Trebuchet MS,10b",
        str = TEXT{"master_volume"},
      },

      MasterVolume = DefSndSlider {
        anchors = { TOP = { "BOTTOM", "MasterVolumeText", 0,10 } },
        initpos = 50,
      },

      MusicVolumeText = uitext {
        size = {200,20},
        anchors = { TOP = { "BOTTOM", "MasterVolume", 0,30 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        str = TEXT{"music_volume"},
      },

      MusicVolume = DefSndSlider {
        clr_t = 10,
        anchors = { TOP = { "BOTTOM", "MusicVolumeText", 0,10 } },
        initpos = 60,
      },

      SoundEffectsVolumeText = uitext {
        size = {200,20},
        anchors = { TOP = { "BOTTOM", "MusicVolume", 0,30 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        str = TEXT{"sound_effects_volume"},
      },

      SoundEffectsVolume = DefSndSlider {
        clr_t = 20,
        anchors = { TOP = { "BOTTOM", "SoundEffectsVolumeText", 0,10 } },
        initpos = 40,
      },

      SpeechVolumeText = uitext {
        size = {200,20},
        anchors = { TOP = { "BOTTOM", "SoundEffectsVolume", 0,30 } },
        font = "Trebuchet MS,10b",
        color = {236,254,227},
        str = TEXT{"speech_volume"},
      },

      SpeechEffectsVolume = DefSndSlider {
        clr_t = 30,
        anchors = { TOP = { "BOTTOM", "SpeechVolumeText", 0,10 } },
        initpos = 80,
      },

      CheckUnitsAknl = DefCheckButton {
        anchors = { TOP = { "BOTTOM", "SpeechEffectsVolume", -20, 35 } },
        str = TEXT{"units_aknowlegments"},
      },

      CheckSubtitles = DefCheckButton {
        anchors = { TOPLEFT = { "BOTTOMLEFT", "CheckUnitsAknl", 0, 10 } },
        str = TEXT{"subtitles_cutscenes"},
      },
    },

---------------------------------------------------------------------    
    InfoText = uitext {
      hidden = true,
      size = {380, 40},
      anchors = { BOTTOMLEFT = {10, -50}},
      font = "Arial,12",
      halign = "LEFT",
      str = TEXT{"sett_temp_info"},
    },    
  },
  
--------------------------------------------------------------------- 

---------- Close button    
  CloseBtn = DefButton { 
    size = {120,30},
    anchors = { BOTTOMLEFT = { "BOTTOM", 20, -15 } },
    str = TEXT{"cancel"},
    OnClick = function() Settings:Hide() end,
  },    
  
---------- Accept button    
  AcceptBtn = DefButton { 
    size = {120,30},
    anchors = { BOTTOMRIGHT = { "BOTTOM", -20, -15 } },
    str = TEXT{"accept_cap"},
    OnClick = function() Settings:OnApplySettings() end,
  },    
  
  VideoSetBtn = DefSubTabButton {
    layer = "+1",
    anchors = { LEFT = { "LEFT", 40, -110 } },
    str = TEXT{"video_sett"},
  },
  
  AudioSetBtn = DefSubTabButton {
    layer = "+1",
    anchors = { TOP = { "BOTTOM", "VideoSetBtn", 0, 30 } },
    str = TEXT{"audio_sett"},
  },
  
  PlayerSetBtn = DefSubTabButton {
    layer = "+1",
    anchors = { TOP = { "BOTTOM", "AudioSetBtn", 0, 30 } },
    str = TEXT{"player_sett"},
  },    

--  
  PlayerSettingsTab = uiwnd {
    hidden = true,
    mouse = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TabGameSettings", 0, 0 }, BOTTOMRIGHT = { "Frame", -10,-55 } },

    Frame = DefHRFrameImage2{},

    --AllowInspected = DefCheckButton {
      --font = "Verdana,10",
      --anchors = { TOPLEFT = { "BOTTOMLEFT", "ShowFriendsInvitations", -10, 5 } },
      --str = "<p>"..TEXT{"allow_inspected"},
      --OnClick = function(this)
        --DefCheckButton.OnClick(this)
        --this:GetParent():OnCheckClicked(this) 
      --end,
    --},
    
    StatisticsText = uitext {
      layer = "+1",
      size = {1,40},
      valign = "TOP",
      halign = "LEFT",
      font = "Verdana,11b",
      anchors = { TOPLEFT = { "TOP", "Frame", 30,20 }, TOPRIGHT = { "Frame", -20,20 } },
    },
    
	  DamageStat = DefStat { ttkey = "avdamage", col = 1, anchors = { TOPLEFT = { "BOTTOMLEFT", "StatisticsText", 10,20 } } },
	  HealingStat = DefStat { ttkey = "avhealing", col = 2, anchors = { LEFT = { "RIGHT", "DamageStat", 20,0 } } },
	  KillsStat = DefStat { ttkey = "avkills", col = 3, anchors = { TOP = { "BOTTOM", "DamageStat", 0,20 } } },
	  DeathsStat = DefStat { ttkey = "avdeaths", col = 4, anchors = { LEFT = { "RIGHT", "KillsStat", 20,0 } } },
	  CommandsStat = DefStat { ttkey = "avcommand", col = 5, anchors = { TOP = { "BOTTOM", "KillsStat", 0,20 } } },
	  DamageTakenStat = DefStat { ttkey = "avdamagetaken", col = 6, anchors = { LEFT = { "RIGHT", "CommandsStat", 20,0 } } },
	  
    MutantsStat = uiwnd {
      mouse = true,
      size = {85,90},
      anchors = { TOP = { "BOTTOMLEFT", "DamageTakenStat", -8,30 } },

      ttkey = "avracemutants", 

      Frame = DefCornerFrameImage2{
        size = {55,55},
        anchors = { TOP = { 0,0 } },
      },
      
      Icon = uiimg {
        size = {49,49},
        texture = "data/textures/ui/player info race icons.dds",
        coords = {49,98,49,49},
        anchors = { TOP = { "Frame", 0,3 } },
      },
      
      TextBack = DefBackInBlack {
        size = {85,29},
        anchors = { TOP = { "BOTTOM",  "Frame", 0,5 } },
      },

      Text = uitext {
        size = {75,29},
        layer = "+1",
        color = {255, 143, 51},
        font = "Verdana,11b",
        anchors = { TOP = { "BOTTOM",  "Frame", 1,5 } },
        str = "XXX%",
      },

      OnMouseEnter = function(this)
        Tooltip:AttachTo(this, "TOP", this, "BOTTOM", {0,0})
        Tooltip.Title:SetStr("<p>"..TEXT{this.ttkey.."_ttl"})
        Tooltip.Text:SetStr("<p>"..TEXT{this.ttkey.."_txt"})
        local sz = Tooltip:GetSize()
        Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
        Tooltip:Show()
      end,

      OnMouseLeave = function(this)
        Tooltip:Hide()
      end,
    },

    HumansStat = uiwnd {
      mouse = true,
      size = {85,90},
      anchors = { RIGHT = { "LEFT", "MutantsStat", -20,0 } },

      ttkey = "avracehumans", 

      Frame = DefCornerFrameImage2 {
        size = {55,55},
        anchors = { TOP = { 0,0 } },
      },

      Icon = uiimg {
        size = {49,49},
        texture = "data/textures/ui/player info race icons.dds",
        coords = {49,0,49,49},
        anchors = { TOP = { "Frame", 0,3 } },
      },
      
      TextBack = DefBackInBlack {
        size = {85,29},
        anchors = { TOP = { "BOTTOM",  "Frame", 0,5 } },
      },

      Text = uitext {
        size = {75,29},
        layer = "+1",
        color = {255, 143, 51},
        font = "Verdana,11b",
        anchors = { TOP = { "BOTTOM",  "Frame", 1,5 } },
        str = "XXX%",
      },

      OnMouseEnter = function(this)
        Tooltip:AttachTo(this:GetParent().MutantsStat, "TOP", this:GetParent().MutantsStat, "BOTTOM", {0,0})
        Tooltip.Title:SetStr("<p>"..TEXT{this.ttkey.."_ttl"})
        Tooltip.Text:SetStr("<p>"..TEXT{this.ttkey.."_txt"})
        local sz = Tooltip:GetSize()
        Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
        Tooltip:Show()
      end,

      OnMouseLeave = function(this)
        Tooltip:Hide()
      end,
    },

    AliensStat = uiwnd {
      mouse = true,
      size = {85,90},
      anchors = { LEFT = { "RIGHT", "MutantsStat", 20,0 } },

      ttkey = "avracealiens",

      Frame = DefCornerFrameImage2 {
        size = {55,55},
        anchors = { TOP = { 0,0 } },
      },
      
      Icon = uiimg {
        size = {49,49},
        texture = "data/textures/ui/player info race icons.dds",
        coords = {49,49,49,49},
        anchors = { TOP = { "Frame", 0,3 } },
      },
      
      TextBack = DefBackInBlack {
        size = {85,29},
        anchors = { TOP = { "BOTTOM",  "Frame", 0,5 } },
      },

      Text = uitext {
        size = {75,29},
        layer = "+1",
        color = {255, 143, 51},
        font = "Verdana,11b",
        anchors = { TOP = { "BOTTOM",  "Frame", 1,5 } },
        str = "XXX%",
      },

      OnMouseEnter = function(this)
        Tooltip:AttachTo(this:GetParent().MutantsStat, "TOP", this:GetParent().MutantsStat, "BOTTOM", {0,0})
        Tooltip.Title:SetStr("<p>"..TEXT{this.ttkey.."_ttl"})
        Tooltip.Text:SetStr("<p>"..TEXT{this.ttkey.."_txt"})
        local sz = Tooltip:GetSize()
        Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
        Tooltip:Show()
      end,

      OnMouseLeave = function(this)
        Tooltip:Hide()
      end,
    },

	  GameDuration = uiwnd {
	    size = {200,29},
	    anchors = { TOP = { "BOTTOM", "MutantsStat", 0,30 } },
      Back = DefBackInBlack{ layer = "+1" },
      Text = uitext {
        layer = "+2",
        font = "Verdana,11b",
        color = {255, 143, 51},
        str = "XXm XXs",
      },
	  },
	  
	  GameDurationText = uitext {
	    layer = "+1",
	    size = {250,1},
	    --halign = "LEFT",
	    anchors = { TOP = { "BOTTOM", "GameDuration", 0,5 } },
      font = "Verdana,10",
	  },

	  BattlePoints = uiwnd {
	    size = {200,29},
	    anchors = { TOP = { "BOTTOM", "GameDurationText", 0,20 } },
      Back = DefBackInBlack{ layer = "+1" },
      Text = uitext {
        layer = "+2",
        color = {255, 143, 51},
        font = "Verdana,11b",
        str = "XX of 99",
      },
	  },
	  
	  BattlePointsText = uitext {
	    layer = "+1",
	    size = {250,1},
	    --halign = "LEFT",
	    anchors = { TOP = { "BOTTOM", "BattlePoints", 0,5 } },
      font = "Verdana,10",
	  },
	  
	  
    Rank1v1DM = DefGSStat {
      anchors = { TOPLEFT = { 20,20 } },
    },
	  
    Rating1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Rank1v1DM", 0,15 } },
    },	  

    Wins1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Rating1v1DM", 0,15 } },
    },	  

    Losses1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Wins1v1DM", 0,15 } },
    },	  

    Streak1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Losses1v1DM", 0,15 } },
    },	  

    LocPlayed = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Streak1v1DM", 0,15 } },
    },	  
    
    BossesKilled = DefGSStat {
      anchors = { TOP = { "BOTTOM", "LocPlayed", 0,15 } },
    },	      	  
	  
	  
    OnShow = function(this)
      --local pname = net.Lobby_GetPlayerName()
      --this.Name:SetStr(TEXT{"logo_name", pname})
      this.StatisticsText:SetStr("<p>"..TEXT("statistics_average"))
      
      this.GameDurationText:SetStr("<p>"..TEXT("gamedurationtext"))
      local h = this.GameDurationText:GetStrHeight()
      this.GameDurationText:SetSize{this.GameDurationText:GetSize().x, h}

      this.BattlePointsText:SetStr("<p>"..TEXT("battlepointstext"))
      h = this.BattlePointsText:GetStrHeight()
      this.BattlePointsText:SetSize{this.BattlePointsText:GetSize().x, h}
      
      this.BattlePoints.Text:SetStr(TEXT{"battlepointsvalue", game.GetPlayerBattlePoints(), 600})
      
      local durm, durs = game.GetPlayerAveragePVPDuration()
      if durs < 10 then durs = "0" .. durs end
      this.GameDuration.Text:SetStr(TEXT{"gamedurationvalue", durm, durs})
      
      
      this.Rank1v1DM.Title:SetStr("<p>"..TEXT("rank1v1txt"))
      this.Rating1v1DM.Title:SetStr("<p>"..TEXT("rating1v1txt"))
      this.Wins1v1DM.Title:SetStr("<p>"..TEXT("wins1v1txt"))
      this.Losses1v1DM.Title:SetStr("<p>"..TEXT("losses1v1txt"))
      this.Streak1v1DM.Title:SetStr("<p>"..TEXT("streak1v1txt"))
      this.LocPlayed.Title:SetStr("<p>"..TEXT("player_loc_played"))
      this.BossesKilled.Title:SetStr("<p>"..TEXT("player_bosses"))
      
      this.Rank1v1DM.StatPanel.Text:SetStr("N/A")
      this.Rating1v1DM.StatPanel.Text:SetStr("N/A")
      this.Wins1v1DM.StatPanel.Text:SetStr("N/A")
      this.Losses1v1DM.StatPanel.Text:SetStr("N/A")
      this.Streak1v1DM.StatPanel.Text:SetStr("N/A")      
      this.LocPlayed.StatPanel.Text:SetStr("N/A") 
      this.BossesKilled.StatPanel.Text:SetStr("N/A") 
      
      local stats = game.LoadUserData("stats")
      local count = stats.count and stats.count > 0 and stats.count or 1
      this.DamageStat.Value.Text:SetStr(math.floor(((stats[1] or 0)/count)).."%")
      this.HealingStat.Value.Text:SetStr(math.floor(((stats[2] or 0)/count)).."%")
      this.KillsStat.Value.Text:SetStr(math.floor(((stats[3] or 0)/count)).."%")
      this.DeathsStat.Value.Text:SetStr(math.floor(((stats[4] or 0)/count)).."%")
      this.CommandsStat.Value.Text:SetStr(math.floor(((stats[5] or 0)/count)).."%")
      this.DamageTakenStat.Value.Text:SetStr(math.floor(((stats[6] or 0)/count)).."%")
      
      count = (stats.humans or 0) + (stats.aliens or 0) + (stats.mutants or 0)
      if count == 0 then count = 1 end
      local humans = math.floor((stats.humans or 0) * 100 / count)
      local mutants = math.floor((stats.mutants or 0) * 100 / count)
      local aliens = math.floor((stats.aliens or 0) * 100 / count)
      if humans > 0 or mutants > 0 or aliens > 0 and humans + mutants + aliens ~= 100 then humans = 100 - mutants - aliens end
      this.HumansStat.Text:SetStr(humans.. "%")
      this.AliensStat.Text:SetStr(aliens .. "%")
      this.MutantsStat.Text:SetStr(mutants .. "%")

      
      --net.Competition_GetPlayerStats(net.Lobby_GetPlayerName())
      net.Competition_GetPlayerRankings(net.Lobby_GetPlayerName(), 0, 1, "ARENA_ELO_RATING_1V1")
      this:RegisterEvent("PLAYER_STATS")
    end,
    
    OnEvent = function(this, event)
      if event == "PLAYER_STATS" then
        for kk, vv in pairs(argPlayers) do
          if kk and string.lower(kk) == string.lower(net.Lobby_GetPlayerName()) then
            for k,v in pairs(vv) do
              if k == "row" then
                this.Rank1v1DM.StatPanel.Text:SetStr(v)
              elseif k == "ARENA_ELO_RATING_1V1" then
                this.Rating1v1DM.StatPanel.Text:SetStr(v)
              elseif k == "STAT_PLAYER_1V1_WINS" then
                this.Wins1v1DM.StatPanel.Text:SetStr(v)
              elseif k == "STAT_PLAYER_1V1_LOSSES" then
                this.Losses1v1DM.StatPanel.Text:SetStr(v)
              elseif k == "STAT_PLAYER_1V1_WINSTREAK" then
                this.Streak1v1DM.StatPanel.Text:SetStr(v)
              elseif k == "STAT_PLAYER_LOC_PLAYED" then
                this.LocPlayed.StatPanel.Text:SetStr(v)
              elseif k == "STAT_PLAYER_BOSSESKILLED" then
                this.BossesKilled.StatPanel.Text:SetStr(v)
              end
            end
          end
          
          break
        end
      end
    end,
  },
}

function Settings:OnShow()
  this.PlayerSetBtn.checked = 0
  this.AudioSetBtn.checked = 0
  this.VideoSetBtn.checked = 1
  this.lastsel = this.VideoSetBtn
  this.VideoSetBtn:updatetextures()
  this.PlayerSetBtn:updatetextures()
  this.AudioSetBtn:updatetextures()
  this.GameSettingsTab.PlayerFrame:Hide()
  this.GameSettingsTab.AudioFrame:Hide()
  this.GameSettingsTab.VideoFrame:Show()
  
  local pname = net.Lobby_GetPlayerName()
  if not pname then
    this.curr_tab = nil
    --this.PlayerSettingsTab:Hide()
    --this.TabPlayerSettings:Disable(true)

    --this.BlackPlate:Show()
    --this.TabGameSettings:Hide()
    --this.TabPlayerSettings:Hide()
    
    this.PlayerSetBtn:Hide()
  else
    --this.TabPlayerSettings:Disable(false)

    --this.BlackPlate:Hide()
    --this.TabGameSettings:Show()
    --this.TabPlayerSettings:Show()
    
    if this.PlayerSettingsTab:IsHidden() then
      this.PlayerSetBtn:Show()
    end
  end  
  
  -- player
  if pname then
    Settings.GameSettingsTab.PlayerFrame.Logo:Update()
    
    local ps = game.LoadUserPrefs("PlayerSettings")
    if not ps then -- default player settings
      ps = {}
      ps.ignore_invits = 0
      ps.friends_invits = 0
      ps.allow_inspected = 1
      game.SaveUserPrefs("PlayerSettings", ps)
    end
    Settings.GameSettingsTab.PlayerFrame.IgnoreAllInvitations.checked = ps.ignore_invits
    Settings.GameSettingsTab.PlayerFrame.IgnoreAllInvitations:updatetextures()
    Settings.GameSettingsTab.PlayerFrame.ShowFriendsInvitations.checked = ps.friends_invits
    Settings.GameSettingsTab.PlayerFrame.ShowFriendsInvitations:updatetextures()  
  end
  
  local tbl = game.GetSettings()

  -- video
  if tbl and tbl.stratfullscreen > 0 then
    Settings.GameSettingsTab.VideoFrame.CheckFullscreenMode.checked = tbl.stratfullscreen
  else
    Settings.GameSettingsTab.VideoFrame.CheckFullscreenMode.checked = 0
  end  
  Settings.GameSettingsTab.VideoFrame.CheckFullscreenMode:updatetextures()
  
  if tbl and tbl.window then Settings.GameSettingsTab.window_mode = tbl.window end
  if tbl and tbl.fullscreen then Settings.GameSettingsTab.fullscreen_mode = tbl.fullscreen end

  local list = game.EnumDisplaySettings() 
  this.GameSettingsTab.VideoFrame.ScrResList:SetList(list)
  if #list > 5 then
    this.GameSettingsTab.VideoFrame.ScrResList.Scrollbar:Show()
  else
    this.GameSettingsTab.VideoFrame.ScrResList.Scrollbar:Hide()
  end
  Settings.GameSettingsTab:updateresolution()

  Settings.GameSettingsTab.VideoFrame.CheckVSync.checked = tbl.vsync
  Settings.GameSettingsTab.VideoFrame.CheckVSync:updatetextures()

  -- graphics
  local multisamplinglist = game.GetMultisamplingList(true)
  Settings.GameSettingsTab.VideoFrame.AntialiasingCombo:InitComboFromList(multisamplinglist)
  Settings.GameSettingsTab.VideoFrame.TextureDetailCombo:InitCombo()
  Settings.GameSettingsTab.VideoFrame.ShaderDetailCombo:InitCombo()
  Settings.GameSettingsTab.VideoFrame.ModelsDetailCombo:InitCombo()
  Settings.GameSettingsTab.VideoFrame.ShadowDetailCombo:InitCombo()
  Settings.GameSettingsTab.VideoFrame.EffectsCombo:InitCombo()
  Settings.GameSettingsTab.VideoFrame.AntialiasingCombo.Listbox:OnListClicked(Settings.GameSettingsTab.VideoFrame.AntialiasingCombo:GetItemIndex(tbl.multi_sample))
  Settings.GameSettingsTab.VideoFrame.TextureDetailCombo.Listbox:OnListClicked(tbl.tex_lod + 1)
  Settings.GameSettingsTab.VideoFrame.ShaderDetailCombo.Listbox:OnListClicked(tbl.shader_detail + 1)
  Settings.GameSettingsTab.VideoFrame.ModelsDetailCombo.Listbox:OnListClicked(tbl.models_lod + 1)
  Settings.GameSettingsTab.VideoFrame.ShadowDetailCombo.Listbox:OnListClicked(tbl.shadow_lod + 1)
  Settings.GameSettingsTab.VideoFrame.EffectsCombo.Listbox:OnListClicked(tbl.effects_lod + 1)
  
  Settings.GameSettingsTab.VideoFrame.CheckReflections.checked = tbl.reflections
  Settings.GameSettingsTab.VideoFrame.CheckReflections:updatetextures()

  Settings.GameSettingsTab.VideoFrame.CheckPostprocess.checked = tbl.postprocess
  Settings.GameSettingsTab.VideoFrame.CheckPostprocess:updatetextures()

  if tbl.anisotropy > tbl.maxanisotropy then
    tbl.anisotropy = tbl.maxanisotropy
  end
  Settings.GameSettingsTab.VideoFrame.Anisotropy.initpos = tbl.anisotropy
  Settings.GameSettingsTab.VideoFrame.Anisotropy.max_range = tbl.maxanisotropy
  
  if tbl.maxanisotropy <= 1 then
    Settings.GameSettingsTab.VideoFrame.AnisotropicText:Hide()
    Settings.GameSettingsTab.VideoFrame.Anisotropy:Hide()
  end
  
  Settings.GameSettingsTab.VideoFrame.Anisotropy:InitPosition()

  Settings.GameSettingsTab.AudioFrame.MasterVolume.initpos = tbl.audiovolume
  Settings.GameSettingsTab.AudioFrame.MasterVolume.max_range = 100
  --Settings.GameSettingsTab.AudioFrame.MasterVolume:OnShow()
  Settings.GameSettingsTab.AudioFrame.MasterVolume:InitPosition()

  Settings.GameSettingsTab.AudioFrame.SoundEffectsVolume.initpos = tbl.audioeffects
  Settings.GameSettingsTab.AudioFrame.SoundEffectsVolume.max_range = 100
  Settings.GameSettingsTab.AudioFrame.SoundEffectsVolume:InitPosition()
  
  Settings.GameSettingsTab.AudioFrame.MusicVolume.initpos = tbl.audiomusic
  Settings.GameSettingsTab.AudioFrame.MusicVolume.max_range = 100
  Settings.GameSettingsTab.AudioFrame.MusicVolume:InitPosition()
  
  Settings.GameSettingsTab.AudioFrame.SpeechEffectsVolume.initpos = tbl.audiospeech
  Settings.GameSettingsTab.AudioFrame.SpeechEffectsVolume.max_range = 100
  Settings.GameSettingsTab.AudioFrame.SpeechEffectsVolume:InitPosition()

  Settings.GameSettingsTab.AudioFrame.CheckSoundsEnabled.checked = tbl.audioenabled
  Settings.GameSettingsTab.AudioFrame.CheckSoundsEnabled:updatetextures()
  
  Settings.GameSettingsTab.AudioFrame.CheckUnitsAknl.checked = tbl.audiounitack
  Settings.GameSettingsTab.AudioFrame.CheckUnitsAknl:updatetextures()
  
  Settings.GameSettingsTab.AudioFrame.CheckSubtitles.checked = tbl.audiosubs
  Settings.GameSettingsTab.AudioFrame.CheckSubtitles:updatetextures()
  
  this.TabGameSettings.wnd = this.GameSettingsTab
  this.TabPlayerSettings.wnd = this.PlayerSettingsTab
  
  if not this.curr_tab then
    this:OnTabClick(this.TabGameSettings)
  end
  Lobby.SettingsBtn.checked = 1
  Lobby.SettingsBtn:updatetextures()
end

function Settings:OnHide()
  Lobby.SettingsBtn.checked = 0
  Lobby.SettingsBtn:updatetextures()

  local gametype = net.GLGetGameType()
  if gametype == "mission" then
    game.Pause(false)
  end
end

function Settings:OnTabClick(tab)
  if this.curr_tab then
    this.curr_tab:SelectTab(false)
    this.curr_tab.wnd:Hide()
  end
  
  if tab == this.TabPlayerSettings then
    this.PlayerSetBtn:Hide()
    this.VideoSetBtn:Hide()
    this.AudioSetBtn:Hide()
  else
    if net.Lobby_GetPlayerName() then
      this.PlayerSetBtn:Show()
    end
    this.VideoSetBtn:Show()
    this.AudioSetBtn:Show()
  end
  
  this.curr_tab = tab
  this.curr_tab:SelectTab(true)
  this.curr_tab.wnd:Show()
end

function Settings:OnApplySettings()
  -- player settings
  if net.Lobby_GetPlayerName() then
    Settings.GameSettingsTab.PlayerFrame.Logo:Save()
  end
   
  local ps = {}
  ps.ignore_invits = this.GameSettingsTab.PlayerFrame.IgnoreAllInvitations.checked
  ps.friends_invits = this.GameSettingsTab.PlayerFrame.ShowFriendsInvitations.checked
  --ps.allow_inspected = this.GameSettingsTab.PlayerFrame.AllowInspected.checked
  game.SaveUserPrefs("PlayerSettings", ps)  

  -- video
  local tbl = {}
  tbl.start_fullscreen = Settings.GameSettingsTab.VideoFrame.CheckFullscreenMode.checked
  tbl.rect_fullscreen = "0,0,"..Settings.GameSettingsTab.fullscreen_mode.width..","..Settings.GameSettingsTab.fullscreen_mode.height
  tbl.rect_windowed = "0,0,"..Settings.GameSettingsTab.window_mode.width..","..Settings.GameSettingsTab.window_mode.height
  tbl.vsync = Settings.GameSettingsTab.VideoFrame.CheckVSync.checked

  tbl.reflections = Settings.GameSettingsTab.VideoFrame.CheckReflections.checked
  tbl.postprocess = Settings.GameSettingsTab.VideoFrame.CheckPostprocess.checked
  tbl.anisotropy = Settings.GameSettingsTab.VideoFrame.Anisotropy:GetPos()

  tbl.tex_lod = Settings.GameSettingsTab.VideoFrame.TextureDetailCombo.Button.selected - 1
  tbl.shader_detail = Settings.GameSettingsTab.VideoFrame.ShaderDetailCombo.Button.selected - 1
  tbl.models_lod = Settings.GameSettingsTab.VideoFrame.ModelsDetailCombo.Button.selected - 1
  tbl.shadow_lod = Settings.GameSettingsTab.VideoFrame.ShadowDetailCombo.Button.selected - 1
  tbl.effects_lod = Settings.GameSettingsTab.VideoFrame.EffectsCombo.Button.selected - 1
  tbl.multi_sample = Settings.GameSettingsTab.VideoFrame.AntialiasingCombo:GetMSbyIndex(Settings.GameSettingsTab.VideoFrame.AntialiasingCombo.Button.selected)

  tbl.audiovolume = Settings.GameSettingsTab.AudioFrame.MasterVolume:GetPos()
  tbl.audioeffects = Settings.GameSettingsTab.AudioFrame.SoundEffectsVolume:GetPos()
  tbl.audiomusic = Settings.GameSettingsTab.AudioFrame.MusicVolume:GetPos()
  tbl.audiospeech = Settings.GameSettingsTab.AudioFrame.SpeechEffectsVolume:GetPos()
  tbl.audioenabled = Settings.GameSettingsTab.AudioFrame.CheckSoundsEnabled.checked
  tbl.audiounitack = Settings.GameSettingsTab.AudioFrame.CheckUnitsAknl.checked
  tbl.audiosubs = Settings.GameSettingsTab.AudioFrame.CheckSubtitles.checked
  
  local rect = tbl.rect_windowed
  if tbl.start_fullscreen == 1 then rect = tbl.rect_fullscreen end  
  tbl.fulscreen = tbl.start_fullscreen
  tbl.rc = rect
  game.ApplyVideoSettings(tbl)
  
  Settings:Hide()
  game.SaveSettings(tbl)
end

-- Video tab
function Settings.GameSettingsTab:updateresolution()
  local tbl
  if this.VideoFrame.CheckFullscreenMode.checked == 1 and this.fullscreen_mode then
    tbl = this.fullscreen_mode
  end
  if this.VideoFrame.CheckFullscreenMode.checked == 0 and this.window_mode then
    tbl = this.window_mode
  end
  for i,v in ipairs(this.VideoFrame.ScrResList.list) do
    if v and v.width == tbl.width and v.height == tbl.height then
      this.VideoFrame.ScrResList.selected_item = v
      this.VideoFrame.ScrResList.selected_item_index = i
    end
  end
  this.VideoFrame.ScrResList:OnScroll(this.VideoFrame.ScrResList.firstPos)
end

function Settings.GameSettingsTab.VideoFrame.CheckFullscreenMode:OnClick()
  if this.checked == 0 then this.checked = 1 else this.checked = 0 end  
  this:updatetextures()
  Settings.GameSettingsTab:updateresolution()
end

function Settings.GameSettingsTab.VideoFrame:OnListItemClicked()
  local idx, data = this.ScrResList:GetNextSelected()
--  if this.CheckFullscreenMode.checked == 1 then
    Settings.GameSettingsTab.fullscreen_mode = data
--  else
    Settings.GameSettingsTab.window_mode = data
--  end
end

