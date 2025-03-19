--
-- Lobby Screen
--

local StartStr = TEXT{"startstr"}
local StartGame_WaitForParty = TEXT{"startgame_waitforparty"}
local StartGame_WaitForJoin = TEXT{"startgame_waitforjoin"}
local StartGame_EstablishingConnection = TEXT{"startgame_establishingconnection"}
local StartGame_WaitingForStart = TEXT{"startgame_waitingforstart"}

local Auto_FindTeam = TEXT{"auto_findteam"}
local Auto_FindGame = TEXT{"auto_findgame"}
local StartGame_WaitForPlayers = TEXT{"startgame_waitforplayers"}
local ERR_TOOBIGTEAM = TEXT{"err_toobigteam"}
local ERR_ONLYSINGLE = TEXT{"err_onlysingle"}
local TEXT_TYPE_PLAYER_NAME = TEXT{"text_type_player_name"}
local TEXT_NO_SP_LOCATIONS = TEXT{"text_no_sp_locations"}

local TTIME = 0.25
local lobbylayer = 50


function leaveLobby()
  Lobby:OnLeave()
  Login:Show()
  game.LeaveLobby()
  net.DeleteLobby()
  Transitions:Fade(BlackScreen, nil, nil, TTIME)
end

local chk_size = {20,20}
local DefCheckButton = DefButton {
  virtual = true,
  size = {200,30},
  
  checked = 0,
  
  NormalImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  HighImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  PushImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  
  NormalText = DefButton.NormalText { halign = "LEFT", color = {225,225,225,255}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  HighText = DefButton.HighText { halign = "LEFT", color = {255,255,255,255}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  PushText = DefButton.PushText { halign = "LEFT", color = {255,255,255,255}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  
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
      this.NormalImage:SetTexture(nil, this.UN_coords)
      this.HighImage:SetTexture(nil, this.UN_coords)
      this.PushImage:SetTexture(nil, this.UN_coords)
    else
      this.NormalImage:SetTexture(nil, this.UP_coords)
      this.HighImage:SetTexture(nil, this.UP_coords)
      this.PushImage:SetTexture(nil, this.UP_coords)
    end  
  end,
}

DMMeters = uiwnd {
  hidden = true,
  virtual = true,
  size = {310, 230},
  
  Frame = uiimg {
    layer= "-1",
    texture = "data/textures/ui/briefing_back.dds",
    coords = {0, 0, 324, 478},      
  },      
  
  Sepline1 = uiimg {
    layer = "+1",
    size = {240,30},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    anchors = { TOP = { 0, 160 } },
    tiled = {60, 3, 60, 3},
  },  
  
  
  Sepline2 = uiimg {
    hidden = true,
    layer = "+1",
    size = {240,30},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    anchors = { TOP = { 0, 210 } },
    tiled = {60, 3, 60, 3},
  },    
  
  Title = uitext {
    layer = "+1",
    size = {300, 20},
    color = {255,204,0},
    font = "Tahoma,17",
    shadow_ofs = {1,1},
    anchors = { TOP = {0, 15} },
    str = TEXT{"dmmeters_ttl"}
  },  

  SubTitle = uitext {
    layer = "+1",
    size = {300, 45},
    color = {197,197,197},
    font = "Tahoma,13",
    anchors = { TOP = {0, 40} },
    str = TEXT{"dmmeters_stl1"}
  },  

  
  Random = uitext {
    layer = "+1",
    size = {100, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "RIGHT",
    anchors = { TOPLEFT = {"TOPLEFT", 0, 90} },
    str = TEXT{"dmmeters_rnd"}  
  },
  
  Random1v1 = uitext {
    layer = "+1",
    size = {300, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 120, 90} },
    str = TEXT{"1v1"}  
  },
  
  Prep1v1 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {52, 157, 255},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 180, 90} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},  
  },

  Playing1v1 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {183,94,216},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 225, 90} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},
  },

  Searching1v1 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {241,182,1},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 270, 90} },
    font = "Tahoma,13",
    str = TEXT{"0"},
  },

  
  Random2v2 = uitext {
    layer = "+1",
    size = {300, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 120, 110} },
    str = TEXT{"2v2"}  
  },
  
  Prep2v2 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {52, 157, 255},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 180, 110} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},  
  },

  Playing2v2 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {183,94,216},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 225, 110} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},
  },
  
  Searching2v2 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {241,182,1},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 270, 110} },
    font = "Tahoma,13",
    str = TEXT{"0"},
  },  
  
  
  Random3v3 = uitext {
    layer = "+1",
    size = {300, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 120, 130} },
    str = TEXT{"3v3"}  
  },
  
  Prep3v3 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {52, 157, 255},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 180, 130} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},  
  },

  Playing3v3 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {183,94,216},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 225, 130} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},
  },  

  Searching3v3 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {241,182,1},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 270, 130} },
    font = "Tahoma,13",
    str = TEXT{"0"},
  }, 


  Arranged = uitext {
    layer = "+1",
    size = {100, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "RIGHT",
    anchors = { TOPLEFT = {"TOPLEFT", 0, 170} },
    str = TEXT{"dmmeters_arn"}  
  },
  
  Ar2v2 = uitext {
    layer = "+1",
    size = {300, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 120, 170} },
    str = TEXT{"2v2"}  
  },
  
  ArPrep2v2 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {52, 157, 255},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 180, 170} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},  
  },

  ArPlaying2v2 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {183,94,216},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 225, 170} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},
  },

  ArSearching2v2 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {241,182,1},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 270, 170} },
    font = "Tahoma,13",
    str = TEXT{"0"},
  },


  Ar3v3 = uitext {
    layer = "+1",
    size = {300, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 120, 190} },
    str = TEXT{"3v3"}  
  },
  
  ArPrep3v3 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {52, 157, 255},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 180, 190} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},  
  },

  ArPlaying3v3 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {183,94,216},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 225, 190} },
    font = "Tahoma,13",
    str = TEXT{"n/a"},
  },

  ArSearching3v3 = uitext {
    layer = "+1",
    size = {60, 20},
    color = {241,182,1},
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 270, 190} },
    font = "Tahoma,13",
    str = TEXT{"0"},
  },



  Searching = uitext {
    hidden = true,
    layer = "+1",
    size = {100, 20},
    color = {141,141,141},
    font = "Tahoma,13",
    halign = "RIGHT",
    anchors = { TOPLEFT = {"TOPLEFT", 0, 220} },
    str = TEXT{"dmmeters_src"}  
  },
  
  
  SearchingNum = uitext {
    hidden = true,
    layer = "+1",
    size = {300, 20},
    color = {241,182,1},
    font = "Tahoma,13",
    halign = "LEFT",
    anchors = { TOPLEFT = {"TOPLEFT", 120, 220} },
    str = TEXT{"n/a"}  
  },  
  
  
  OnShow = function(this) 
    this:RegisterEvent("AUTOFINDGAME_STATS_CHANGED")
    this:RegisterEvent("AUTOFINDGAME_SEARCHINGPLAYERS_CHANGED")
  end,
  
  
  OnHide = function(this) 
    this:UnregisterEvent("AUTOFINDGAME_SEARCHINGPLAYERS_CHANGED")
    this:UnregisterEvent("AUTOFINDGAME_STATS_CHANGED")
  end,
  
  
  OnEvent = function(this, event)
    if event == "AUTOFINDGAME_STATS_CHANGED" then
      this.Prep1v1:SetStr(argPlayers[1][1][1])
      this.Playing1v1:SetStr(argPlayers[1][1][2])
      this.Prep2v2:SetStr(argPlayers[2][1][1])
      this.Playing2v2:SetStr(argPlayers[2][1][2])
      this.Prep3v3:SetStr(argPlayers[3][1][1])
      this.Playing3v3:SetStr(argPlayers[3][1][2])
      
      this.ArPrep2v2:SetStr(argPlayers[2][2][1])      
      this.ArPlaying2v2:SetStr(argPlayers[2][2][2])
      this.ArPrep3v3:SetStr(argPlayers[3][2][1])      
      this.ArPlaying3v3:SetStr(argPlayers[3][2][2])
    end
    
    if event == "AUTOFINDGAME_SEARCHINGPLAYERS_CHANGED" then
      --this.SearchingNum:SetStr(argPlayers)
      
      if argPlayers[1][1] ~= -1 then
        this.Searching1v1:SetStr(argPlayers[1][1])
      end
      if argPlayers[2][1] ~= -1 then
        this.Searching2v2:SetStr(argPlayers[2][1])
      end
      if argPlayers[3][1] ~= -1 then
        this.Searching3v3:SetStr(argPlayers[3][1])
      end
      
      if argPlayers[2][2] ~= -1 then
        this.ArSearching2v2:SetStr(argPlayers[2][2])
      end
      if argPlayers[3][2] ~= -1 then
        this.ArSearching3v3:SetStr(argPlayers[3][2])      
      end
    end
  end,
}


DMPlayerFrame = uiwnd {                                          
  size = {227,30},
  virtual = true,
  layer = lobbylayer + 8,

	  
  --Icon = uiimg {
  --  texture = "data/textures/ui/status_icons.dds",
  --  anchors = {LEFT = { 0, 0 }},
  --  coords = {0, 0, 42, 42},    
  --  size = {42, 42}, 
  --},	  
	  
  Frame = uiimg {
    layer = "+3",
    texture = "data/textures/ui/stat_black_back.dds",
    --anchors = {LEFT = {"RIGHT", "Icon", -2, 0}},
    coords = {0, 0, 227, 29},
    size = {227, 29},
  },
    
  Title = uitext {
    layer = "+4",
    size = {270,30},
    anchors = { CENTER = { "CENTER", "Frame", 10,0 } },
    --anchors = { LEFT = { "RIGHT", "Icon", 4 ,0 } },
    color = {255, 143, 51},
	  font = "Tahoma,12",
  },
}

DMPlayerLogo = DefPlayerLogo {
  virtual = true,
  mouse = true,
  layer = lobbylayer + 10,
  size = {50,50},
  --anchors = { LEFT = { 7,0 } },
  
  type = 1,
  n_coords = {0, 0, 70, 70},
  h_coords = {0, 70, 70, 70+70},
  types = {
    "data/textures/ui/slot_type_open.dds", 
    "data/textures/ui/slot_type_ai.dds",
    "data/textures/ui/slot_type_closed.dds",
    "data/textures/ui/slot_type_player.dds"
  },
  
  Border = DefPlayerLogo.Border {
    layer = lobbylayer + 12,
    size = {50,50},
  },
   

  ImageType = uiimg { layer = "+4" },    

  OnShow = function(this) this:SetType(this.type) end,

  SetType = function(this, idx, tbl) 
    this.type = idx 
    this.ImageType:SetTexture(this.types[this.type], this.n_coords)
    if idx == 4 then
      if tbl then
        this.Back:Set(0,0,tbl.back_clr)
        this.Gradient:Set(tbl.gradient_row, tbl.gradient_col, tbl.gradient_clr)
        this.Frame:Set(tbl.frame_row, tbl.frame_col, tbl.frame_clr)
        this.Symbol:Set(tbl.symbol_row, tbl.symbol_col, tbl.symbol_clr)
      end
      this.ImageType:Hide()
      this.Symbol:Show()
      this.Frame:Show()
      this.Gradient:Show()
      this.Back:Show()
    else
      this.Symbol:Hide()
      this.Frame:Hide()
      this.Gradient:Hide()
      this.Back:Hide()
      this.ImageType:Show()
    end
  end,
}

BlackScreen = uiwnd {
  layer = "TOPMOST",
  uiimg { color = {0,0,0,255} },
  Fake = uiwnd {},
}

StartingGame = uiwnd {
  hidden = true,
  layer = stripeslayer+100,
  size = { 400, 90 },
  anchors = { TOP = {"TOP", 0, -10} },
  
  Modal = uiwnd {
    mouse = true,
    anchors = { TOPLEFT = { "DESKTOP" } , BOTTOMRIGHT = { "DESKTOP" } , },
    layer = modallayer - 1,
  },

  DefCornerFrameImage2 {},
  
  Text = uitext {
    layer = "+1",
    font = "Agency FB,20",
    str = TEXT{"starting game"}
  },
  
  Cancel = DefButton {
    layer = stripeslayer+101,
    hidden = true,
    anchors = { TOP = {"BOTTOM", 0, 5} },
    OnClick = function(this)
      net.GLStatusClicked(this.key)
    end,
  },
  
  OnLoad = function(this) 
    this:RegisterEvent("GL_START") 
    this:RegisterEvent("GL_STARTING")
    this:RegisterEvent("GL_SHOWSTATUS")
  end,

  OnEvent = function(this, event) 
    if event == "GL_SHOWSTATUS" then
      if argStatus == "StartGame_WaitForParty" then 
        this.Text:SetStr(StartGame_WaitForParty)
      elseif argStatus == "StartGame_WaitForJoin" then 
        this.Text:SetStr(StartGame_WaitForJoin)
      elseif argStatus == "Auto_FindTeam" then 
        this.Text:SetStr(Auto_FindTeam)
      elseif argStatus == "Auto_FindGame" then 
        this.Text:SetStr(Auto_FindGame)
      elseif argStatus == "StartGame_WaitForPlayers" then
        this.Text:SetStr(StartGame_WaitForPlayers)
      elseif argStatus == "StartGame_EstablishingConnection" then
        this.Text:SetStr(StartGame_EstablishingConnection)
      elseif argStatus == "StartGame_WaitingForStart" then
        this.Text:SetStr(StartGame_WaitingForStart)
      end 
      
      if argButton then
        this.Cancel.key = argButton
        this.Cancel:SetStr(TEXT{argButton})
        this.Cancel:Show()
      else
        this.Cancel:Hide()
      end
      
      if argStatus then
        this:Show()
      else
        this:Hide()
      end  
    end
    
    if event == "GL_STARTING" then
      Lobby:OnLeave()
      this.Text:SetStr(StartStr)
      Story:OnBegin()
      this:Show()
      net.GLLoadMap()
      game.GameIsReadyToStart()
    end
    
    if event == "GL_START" then 
      this:Hide()
    end 
  end,
}

BlackScreen = uiwnd {
  layer = "TOPMOST",
  uiimg { color = {0,0,0,255} },
}

local DefLobbyBtn = DefButton {
  virtual = true,
  size = {137,44},
  font = "Verdana,8b",
  click_on_mouse_down = true,
  
  checked = 0,
  
  NormalText = uitext { anchors = { CENTER = { 0,-4 } } },
  HighText  = uitext { anchors = { CENTER = { 0,-4 } } },
  PushText = uitext { anchors = { CENTER = { 0,-4 } } },
  
  NormalImage = uiimg { texture = "data/textures/ui/Main_buttons.dds" },
  HighImage = uiimg { texture = "data/textures/ui/Main_buttons.dds" },
  PushImage = uiimg { texture = "data/textures/ui/Main_buttons.dds" },
  
  n_crd = {0, 0, 137, 44},
  h_crd = {0, 44, 137, 44+44},
  p_crd = {0, 88, 137, 44+88},
  
  n_clr = {255,255,255,255},
  h_clr = {255,255,255,255},
  p_clr = {0, 0, 0, 0},
  d_clr = {100, 100, 100},
    
  OnShow = function(this) this:updatetextures() end,

  updatetextures = function(this)
    if this.demodisabled then
      this.NormalImage:SetTexture(nil, this.n_crd)
      this.HighImage:SetTexture(nil, this.h_crd)
      this.PushImage:SetTexture(nil, this.h_crd)

      this.NormalText:SetColor(this.d_clr)
      this.HighText:SetColor(this.d_clr)
      this.PushText:SetColor(this.d_clr)
    else
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
        this.PushImage:SetTexture(nil, this.h_crd)
        
        this.NormalText:SetColor(this.p_clr)
        this.HighText:SetColor(this.p_clr)
        this.PushText:SetColor(this.h_clr)
      end  
    end
  end,
  OnClick = function(this)
    if Login.demo and (this == Lobby.MissionsBtn) then
      Demo:Set("mis")
      return
    end
    if Login.demo and (this == Lobby.PVPBtn) then
      Demo:Set("dm")
      return
    end
    this:GetParent():OnLobbyBtnClicked(this)
  end,
}

local DefRadioBtn = DefButton {
  virtual = true,
  font = "Tahoma,10b",
  
  NormalImage = uiimg { texture = "data/textures/ui/filter_count.dds" },
  HighImage = uiimg { texture = "data/textures/ui/filter_count.dds" },
  PushImage = uiimg { texture = "data/textures/ui/filter_count.dds" },
        
  --normal
  nn_coord = {0,0,64,22},
  nh_coord = {0,22,64,22+22},
  np_coord = {0,22,64,22+22},
  
  n_clr = {217,222,186},
  --selected
  sn_coord = {0,44,64,44+22},
  sh_coord = {0,44,64,44+22},
  sp_coord = {0,44,64,44+22},
  
  s_clr = {0,0,0},
  --disabled
  dn_coord = {0,66,64,66+22},
  dh_coord = {0,66,64,66+22},
  dp_coord = {0,66,64,66+22},

  d_clr_n = {70,70,70},
  d_clr_s = {140,145,120},
  --
  
  OnShow = function(this) this:SetSelected(this.selected) end,
  
  SetSelected = function(this, selected)
    if this.disabled then
      this.NormalImage:SetTexture(nil, this.dn_coord)
      this.HighImage:SetTexture(nil, this.dh_coord)
      this.PushImage:SetTexture(nil, this.dp_coord)
      if this.selected then
        this.NormalText:SetColor(this.d_clr_s)
        this.HighText:SetColor(this.d_clr_s)
        this.PushText:SetColor(this.d_clr_s)
      else
        this.NormalText:SetColor(this.d_clr_n)
        this.HighText:SetColor(this.d_clr_n)
        this.PushText:SetColor(this.d_clr_n)
      end  
    else
      if selected then
        this.selected = true
        this.NormalImage:SetTexture(nil, this.sn_coord)
        this.HighImage:SetTexture(nil, this.sh_coord)
        this.PushImage:SetTexture(nil, this.sp_coord)
        this.NormalText:SetColor(this.s_clr)
        this.HighText:SetColor(this.s_clr)
        this.PushText:SetColor(this.s_clr)
      else
        this.selected = nil
        this.NormalImage:SetTexture(nil, this.nn_coord)
        this.HighImage:SetTexture(nil, this.nh_coord)
        this.PushImage:SetTexture(nil, this.np_coord)
        this.NormalText:SetColor(this.n_clr)
        this.HighText:SetColor(this.n_clr)
        this.PushText:SetColor(this.n_clr)
      end
    end
  end,
  
  Disable = function(this, disable)
    if disable then
      this.disabled = true
    else
      this.disabled = nil
    end  
    this:SetSelected(this.selected)
  end,
}

local DefSortBtn = DefButton {
  virtual = true,
  layer = lobbylayer + 10,
  
  NormalImage = uiimg { color = {0,0,0,255} },
  HighImage = uiimg { color = {0,0,0,255} },
  PushImage = uiimg { color = {0,0,0,255} },

  NormalText = uitext  { color = {255,141,50,255} },
  HighText  = uitext { color = {255,141,50,255} },
  PushText = uitext { color = {255,141,50,255} },
  
  OnClick = function(this) Lobby.PracticeView.ListGames:OnSortClicked(this) end,
}

local	DefRewardSlot = Inventory.DefItemSlot { 
  virtual = true,
  repo = "MISSION",
	size = {50,50},
	layer = lobbylayer,

  Empty = Inventory.DefItemSlot.Empty { 
  	size = {67,67},
    layer = lobbylayer-1,
 	},
  
  Level = Inventory.DefItemSlot.Level { 
    size = {67,67},
    layer = lobbylayer+1,
 	},

  Frame = Inventory.DefItemSlot.Frame { 
    size = {67,67},
    layer = lobbylayer+2,
 	},
}

local pingwidth
local countwidth
local gamenamewidth

local function CreateListGamesSlot(list, idx, cellh)
  local slot
  slot = uiwnd {
    mouse = true,
    layer = lobbylayer+10,
    size = { list.ScrollArea:GetSize()[1], cellh },

    Ping = uiwnd {
      size = {pingwidth, cellh},
      anchors = { LEFT = {} },
      selected = uiimg {hidden = true,color = {0,0,0,80}},
      text = uitext{font = "Verdana,9", color = {136,136,136}},
    },
    Players = uiwnd {
      size = {countwidth, cellh},
      anchors = { LEFT = { "RIGHT", "Ping", 12,0 } },
      selected = uiimg{hidden = true,color = {0,0,0,80}},
      text = uitext{font = "Verdana,9", color = {136,136,136}},
    },
    GameName = uiwnd {
      size = {gamenamewidth-20, cellh},
      anchors = { LEFT = { "RIGHT", "Players", 12,0 } },
      selected = uiimg{hidden = true,color = {0,0,0,80}},
      text = uitext{
        anchors = {LEFT = {3,0}},
        halign = "LEFT",
        font = "Verdana,9", 
        color = {136,136,136}
      },
    },
    OnMouseWheel = function(slot, delta, mods) list:OnMouseWheel(delta, mods) end,
    OnMouseDown = function(slot) list:OnListClicked(idx) end,
  }
  return slot
end

PlayerColorMenu = DefColumnsList {
  hidden = true,
  layer = modallayer + 1,
  size = {104,104},

  rows = 4,
  cols = 4,
  col_dist = 0,
  row_dist = 0,
  
  OnShow = function(this)
    Modal.func = function() this:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide() 
	end,
	  
  Reset = function(this)
    for i = 1,#PlayerColors do
      local slot = this.ScrollArea["Slot"..i]
      if slot then
        slot.disabled = nil
      end  
    end  
  end,
  
  GetColorEnable = function(this)
    for i = 1,#PlayerColors do
      if not this.ScrollArea["Slot"..i].disabled then return i end
    end  
  end,
  
  SetColorEnable = function(this, index, enable)
    if not index or index < 1 then return end
    if enable then
      this.ScrollArea["Slot"..index].disabled = nil
    else
      this.ScrollArea["Slot"..index].disabled = true
    end  
  end,
  
  func = function(listbox, row, col, slotw, sloth)
    local slot
    slot = uibtn {
      size = {slotw,sloth},
      
      list = listbox,
      
      ColorBar = uiimg {
        layer = lobbylayer + 6,
        size = {slotw,sloth},
        texture = "data/textures/ui/player_colour_plate.dds",
        coords = {0, 0, 26, 26},
      },
      
      ImageDisabled = uitext {
        hidden = true,
        layer = lobbylayer + 7,
        size = {slotw,sloth},
        font = "Arial,20",
        color = {0,0,0,255},
        str = TEXT{"x"},
      },
      
      OnShow = function(this)
        if this.disabled then this.ImageDisabled:Show() else this.ImageDisabled:Hide() end
      end,
      
      ShowData = function(this, data)
        this.ColorBar:SetColor(data)
      end,
      
      OnClick = function(this) 
        if this.disabled then return end
        Lobby.PlayersView:OnColorChanged(this.list.slot, this.dataindex)
        this.list:Hide()
      end,
    }
    return slot
  end,
}

SlotTypeMenu = uiwnd {
  hidden = true,
  layer = modallayer + 1,
  size = {78,26},

  Open = DefButton {
    size = {26,26},
    anchors = { LEFT = {0,0} },

    NormalImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {52, 0, 26, 26},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {52, 26, 26, 26},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {52, 52, 26, 26},
    },

    OnClick = function(this) 
      Lobby.PlayersView:OnSlotTypeChanged(this:GetParent().slot, 1)
      this:GetParent():Hide()
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_slot_open_tip", this, "TOPLEFT", "BOTTOMLEFT", {0,-10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  AI = DefButton {
    size = {26,26},
    anchors = { LEFT = { "RIGHT", "Open", 0,0} },

    NormalImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {26, 0, 26, 26},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {26, 26, 26, 26},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {26, 52, 26, 26},
    },

    OnClick = function(this) 
      Lobby.PlayersView:OnSlotTypeChanged(this:GetParent().slot, 2)
      this:GetParent():Hide()
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_slot_ai_tip", this, "TOPLEFT", "BOTTOMLEFT", {0,-10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Close = DefButton {
    size = {26,26},
    anchors = { LEFT = { "RIGHT", "AI", 0,0} },

    NormalImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {0, 0, 26, 26},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {0, 26, 26, 26},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/player_icons.dds",
      coords = {0, 52, 26, 26},
    },

    OnClick = function(this) 
      Lobby.PlayersView:OnSlotTypeChanged(this:GetParent().slot, 3)
      this:GetParent():Hide()
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_slot_close_tip", this, "TOPLEFT", "BOTTOMLEFT", {0,-10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  OnShow = function(this)
    Modal.func = function() this:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide() 
	end,
}

local ctrl_h = 20

InvitePlayerMenu = uiwnd {
  hidden = true,
  layer = modallayer + 1,
  size = {270,30},

  DefFrameNoTranspImage{},

  Text = uitext {
    size = {100,ctrl_h},
    font = "Verdana,9",
    color = {234,223,178},
    anchors = { LEFT = {5,0} },
    str = TEXT{"invite player:"},
    OnShow = function(this)
      local sz = this:GetSize()
      local w = this:GetStrWidth()
      this:SetSize{w, sz.y}
    end,
  },

  Edit = uiedit {
    parsing = false,
    font = "Verdana,9",
    color = {234,223,178},
    anchors = { TOPLEFT = { "TOPRIGHT", "Text", 0,0}, BOTTOMRIGHT = { "TOPRIGHT", -5, ctrl_h + 5 } },
    OnShow = function(this)
      this:SetStr(TEXT_TYPE_PLAYER_NAME)
      this:SetFocus()
    end,
    OnKeyEnter = function(this) 
      this:RemoveFocus() this:GetParent():Hide()
      local player = this:GetStr()
      if player ~= TEXT_TYPE_PLAYER_NAME then
        Lobby.PlayersView:OnInviteRequest(this:GetParent().slot, player)
      end  
    end,
    OnKeyEscape = function(this) this:RemoveFocus() this:GetParent():Hide() end,
  },

  OnShow = function(this)
    Modal.func = function() this:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide() 
	end,
}

local btn_space = 5

local DefPlayetSlot = uiwnd {
  virtual = true,
  size = {240,82},
  
  Frame = uiimg {
    texture = "data/textures/ui/player_slot.dds",
    coords = {0, 0, 54, 54},
    tiled = {18,18,18,18},
  },
  
  Type = DefPlayerLogo {
    mouse = true,
    layer = lobbylayer + 1,
    size = {70,70},
    anchors = { LEFT = { 7,0 } },
    
    type = 1,
    n_coords = {0, 0, 70, 70},
    h_coords = {0, 70, 70, 70+70},
    types = {
      "data/textures/ui/slot_type_open.dds", 
      "data/textures/ui/slot_type_ai.dds",
      "data/textures/ui/slot_type_closed.dds",
      "data/textures/ui/slot_type_player.dds"
    },

    ImageType = uiimg { layer = "+4" },    

    OnShow = function(this) this:SetType(this.type) end,
    OnMouseDown = function(this)
      if Login.demo and this:GetParent().demodisabled then return end
      if this.readonly or this:GetParent().Ready.ready then return end
      if SlotTypeMenu:IsHidden() then
        SlotTypeMenu:SetAnchor("TOPLEFT", this, "BOTTOMLEFT", {-3,0})
        SlotTypeMenu.slot = this:GetParent()
        SlotTypeMenu:Show()
      else
        SlotTypeMenu:Hide()
      end  
    end,
    SetType = function(this, idx, tbl) 
      this.type = idx 
      this.ImageType:SetTexture(this.types[this.type], this.n_coords)
      if idx == 4 then
        if tbl then
          this.Back:Set(0,0,tbl.back_clr)
          this.Gradient:Set(tbl.gradient_row, tbl.gradient_col, tbl.gradient_clr)
          this.Frame:Set(tbl.frame_row, tbl.frame_col, tbl.frame_clr)
          this.Symbol:Set(tbl.symbol_row, tbl.symbol_col, tbl.symbol_clr)
        end
        this.ImageType:Hide()
        this.Symbol:Show()
        this.Frame:Show()
        this.Gradient:Show()
        this.Back:Show()
      else
        this.Symbol:Hide()
        this.Frame:Hide()
        this.Gradient:Hide()
        this.Back:Hide()
        this.ImageType:Show()
      end
    end,

    OnMouseEnter = function(this)
      local gametype = net.GLGetGameType()
      local slot = this:GetParent()
      if net.GLIsHost() and gametype ~= "speciallocation" and slot.type ~= "myslot" and slot.type ~= "player" then
        if Login.demo and this:GetParent().demodisabled then
          NTTooltip:DoShow("demo_slot", this, "TOPLEFT", "BOTTOMLEFT", {0,-10}) 
        else
          NTTooltip:DoShow("change_slot_tip", this, "TOPLEFT", "BOTTOMLEFT", {0,-10}) 
        end
      end
    end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  Name = uibtn {
    size = {165, 34},
    font = "Tahoma,9",
    NormalText = uitext { color = {255,199,77,255} },
    HighText  = uitext { color = {255,215,77,255} },
    PushText = uitext { color = {255,215,77,255} },
    types = {TEXT{"easy ai"}, TEXT{"hard ai"}},
    type = 1,
    anchors = { TOPLEFT = { "TOPRIGHT", "Type", 0,0 } },
    
    OnShow = function(this) if this.ai then this:SetAI(this.type) end end,
    OnClick = function(this)
      if this.readonly then return end
      this.OnMouseEnter = nil
      this.OnMouseLeave = nil
      if this.ai then
        this.type = this.type + 1 if this.type > 2 then this.type = 1 end
        Lobby.PlayersView:OnAITypeChanged(this:GetParent(), this.type)
        this.OnMouseEnter = function(this) NTTooltip:DoShow("change_ai_tip", this, "TOP", "BOTTOM", {0,-10}) end
        this.OnMouseLeave = function(this) NTTooltip:Hide() end
      end
    end,
    SetAI = function(this, idx) if this.ai then this.type = idx this:SetStr(this.types[this.type]) end end,
  },
  
  Sepline = uiimg {
    size = {139,2},
    layer = lobbylayer + 1,
    texture = "data/textures/ui/sep_line_horizontal.dds", 
    coords = {0,0,139,2},
    anchors = { TOP = { "BOTTOM", "Name", 0,-3 } },
  },

  Kick = DefButton {
    hidden = true,
    size = {24,24},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 10,10 } },
    
    NormalImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 48, 24, 24},
    },
    
    OnClick = function(this)
      if this.readonly then return end
      Lobby.PlayersView:OnKickPlayer(this:GetParent())
    end,
  },

  Invite = DefButton {
    hidden = true,
    size = {24,24},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 10,10 } },
    
    NormalImage = uiimg {
      texture = "data/textures/ui/slot_invite.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_invite.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_invite.dds",
      coords = {0, 48, 24, 24},
    },
    
    OnClick = function(this) 
      if this.readonly then return end
      if InvitePlayerMenu:IsHidden() then
        InvitePlayerMenu:SetAnchor("TOPLEFT", this:GetParent(), "BOTTOMLEFT", {0,-20})
        InvitePlayerMenu.slot = this:GetParent()
        InvitePlayerMenu:Show()
      else
        InvitePlayerMenu:Hide()
      end  
    end,
    OnMouseEnter = function(this) NTTooltip:DoShow("invite_player_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Race = DefButton {
    hidden = true,
    size = {24,24},
    race = 1,
    anchors = { LEFT = { "RIGHT", "Kick", btn_space,0 } },
    
    NormalImage = uiimg { texture = "data/textures/ui/player_race.dds", coords = {0,0,24,24} },
    PushImage = uiimg { texture = "data/textures/ui/player_race.dds", coords = {0,0,24,24} },
    HighImage = uiimg { texture = "data/textures/ui/player_race.dds", coords = {0,0,24,24} },
    
    OnLoad = function(this)
      if Login.demo then
        this.races = {"humans", "mutants"}
      else
        this.races = {"humans", "mutants", "aliens"}
      end
    end,

    OnShow = function(this) this:SetRace(this.race) end,
    SetRace = function(this, idx) 
      this.race = idx
      local top = (this.race-1)*24
      this.NormalImage:SetTexture(nil, {0, top, 24, top+24})
      this.HighImage:SetTexture(nil, {0, top, 24, top+24})
      this.PushImage:SetTexture(nil, {0, top, 24, top+24})
      if this:GetParent().type == "myslot" then
        game.SaveUserPrefs("last_race", { index = idx })
      end
    end,
    OnClick = function(this) 
      if this.readonly or this:GetParent().Ready.ready then return end
      this.race = this.race + 1 if this.race > #this.races then this.race = 1 end
      Lobby.PlayersView:OnRaceChanged(this:GetParent(), this.race)
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_faction_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Color = uibtn {
    hidden = true,
    size = {24,24},
    Clrbar = uiimg {
      layer = lobbylayer + 1,
      texture = "data/textures/ui/player_colour_plate.dds",
      coords = {0, 0, 26, 26},
    },
    anchors = { LEFT = { "RIGHT", "Race", btn_space,0 } },
    color = 0,
    
    OnShow = function(this)
      this:SetColor(this.color) 
    end,
    
    SetColor = function(this, idx) 
      this.color = idx 
      this.Clrbar:SetColor(PlayerColors[this.color]) 
      if this:GetParent().type == "myslot" then
        game.SaveUserPrefs("last_color", { index = idx })
      end
    end,

    OnClick = function(this)
      if this.readonly or this:GetParent().Ready.ready then return end
      if PlayerColorMenu:IsHidden() then
        PlayerColorMenu:SetAnchor("TOPLEFT", this, "BOTTOMLEFT", {0,0})
        PlayerColorMenu.slot = this:GetParent()
        PlayerColorMenu:Show()
      else
        PlayerColorMenu:Hide()
      end  
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_player_color_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Swap = DefButton {
    hidden = true,
    size = {24,24},
    
    wonnaswap = false,
    
    NormalImage = uiimg {
      texture = "data/textures/ui/slot_swap.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_swap.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_swap.dds",
      coords = {0, 48, 24, 24},
    },
    
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 10,10 } },
    
    OnClick = function(this)
      if this.readonly or this:GetParent().Ready.ready then return end
      this.wonnaswap = not this.wonnaswap
      Lobby.PlayersView:OnSwapRequest(this:GetParent(), this.wonnaswap)
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_sides_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  SwapIndicator = DefButton {
    hidden = true,
    size = {24,24},
    layer = lobbylayer + 2,

    NormalImage = uiimg {
      texture = "data/textures/ui/slot_swap.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_swap.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_swap.dds",
      coords = {0, 48, 24, 24},
    },

    OnShow = function(this)
      if this:GetParent().index < 4 then
        this:SetAnchor("LEFT", this:GetParent(), "RIGHT", {-5,0} )
        this:SetStr("")
      else
        this:SetAnchor("RIGHT", this:GetParent(), "LEFT", {5,0} )
        this:SetStr("")
      end
    end,
    OnClick = function(this)
      Lobby.PlayersView:OnSwapWith(this:GetParent())
    end,
  },

  Ready = DefButton {
    hidden = true,
    size = {24,24},
    anchors = { LEFT = { "RIGHT", "Units", btn_space,0 } },
    ready = false,

    texture = "data/textures/ui/slot_ready.dds",
    u_n = { 0, 0, 24, 24},
    u_h = {24, 0, 24+24, 24},
    u_p = {48, 0, 24+48, 24},

    s_n = { 0, 24, 24, 24+24},
    s_h = {24, 24, 24+24, 24+24},
    s_p = {48, 24, 24+48, 24+24},

    OnShow = function(this) this:SetReady(this.ready) end,
    OnClick = function(this)
      if this.readonly then return end
      this.ready = not this.ready
      Lobby.PlayersView:OnReadyChanged(this:GetParent(), this.ready)
    end,
    SetReady = function(this, ready) 
      this.ready = ready 
      if this.ready then 
        this.NormalImage:SetTexture(this.texture, this.u_p)
        this.HighImage:SetTexture(this.texture, this.u_p)
        this.PushImage:SetTexture(this.texture, this.u_p)
      else 
        this.NormalImage:SetTexture(this.texture, this.u_n)
        this.HighImage:SetTexture(this.texture, this.u_n)
        this.PushImage:SetTexture(this.texture, this.u_n)
      end 
    end,
    OnMouseEnter = function(this) NTTooltip:DoShow("player_ready_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  Units = DefButton {
    hidden = true,
    size = {24,24},
    anchors = { LEFT = { "RIGHT", "Color", btn_space,0 } },

    NormalImage = uiimg { texture = "data/textures/ui/buy_army.dds", coords = {0,0,24,24} },
    HighImage = uiimg { texture = "data/textures/ui/buy_army.dds", coords = {0,48,24,24} },
    PushImage = uiimg { texture = "data/textures/ui/buy_army.dds", coords = {0,24,24,24} },
    
    OnClick = function(this)
      if this.readonly then return end
      Lobby.PlayersView:OnUnitsShopping(this:GetParent())
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("select_units_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,

    OnShow = function(this) this.NormalImage:Show() end,
    OnHide = function(this) this:CancelFlash() end,

    CancelFlash = function(this)
      if this.flashID then
        Transitions:CancelRepeat(this.flashID)
        this.flashID = nil
      end
      this.NormalImage:Show()
    end,

    Flash = function(this)
      if this:GetParent().type ~= "myslot" then this:CancelFlash() return end

      if not this.flashID then
        this.flashID = Transitions:CallRepeat(this.Flash, 0.4, this)
      end

      if this.NormalImage:IsHidden() then
        this.NormalImage:Show()
      else
        this.NormalImage:Hide()
      end
    end,
  },

  SetState = function(this, state)
    this.id = state.id
    this.type = state.type
    this.unitskey = state.unitskey
    this.units = state.units
    this.userlogo = state.userlogo

    local gametype = net.GLGetGameType()
    if state.type == "myslot" then
      this.Frame:Show()
      this.Type.readonly = true   this.Type:SetType(4, this.userlogo) 
      this.Name.readonly = true   this.Name.ai = nil this.Name:SetStr(net.Lobby_GetPlayerName()) this.Name:Show()
      this.Race.readonly = false  this.Race:SetRace(state.race or 1) this.Race:Show() this.Invite:Hide()
      this.Color.readonly = false this.Color:SetColor(state.color) this.Color:Show()
      
      if gametype == "speciallocation" then
        this.Swap.readonly = true  this.Swap:Hide() this.Kick:Hide()
      else
        this.Swap.readonly = false  this.Swap:Show() this.Kick:Hide()
      end
      
      this.Ready.readonly = false this.Ready:SetReady(state.ready) this.Ready:Show()
      if state.swapindicator then
        this.Swap.wonnaswap = true
        this.SwapIndicator:Show() 
      else 
        this.Swap.wonnaswap = false
        this.SwapIndicator:Hide() 
      end

      if this.unitskey then
        this.Units.readonly = false this.Units:Show()
        ShoppingUnits:Set(this)
        ShoppingUnits:Save()
      else
        this.Units.readonly = true this.Units:Hide()
      end

    elseif state.type == "ai" then
      this.Frame:Show()
      this.Type.readonly = not net.GLIsHost()   this.Type:SetType(2)
      this.Name.readonly = not net.GLIsHost()   this.Name.ai = 1 this.Name:SetAI(state.ai) this.Name:Show()
      this.Race.readonly = not net.GLIsHost()   this.Race:SetRace(state.race or 1) this.Race:Show() this.Invite:Hide()
      this.Color.readonly = not net.GLIsHost()  this.Color:SetColor(state.color) this.Color:Show()
      this.Ready.readonly = false               this.Ready.ready = false this.Ready:Hide()
      if net.GLIsHost() then
        this.Swap.readonly = false 
        this.Swap:Show()
      else
        this.Swap:Hide()
      end
      this.Kick:Hide()
      if state.swapindicator then
        this.Swap.wonnaswap = true
        this.SwapIndicator:Show() 
      else 
        this.Swap.wonnaswap = false
        this.SwapIndicator:Hide() 
      end
      this.Units.readonly = true this.Units:Hide()
    elseif state.type == "open" then
      this.Frame:Show()

      if gametype == "speciallocation" then
        this.Type.readonly = true this.Type:SetType(1)
      else
        this.Type.readonly = not net.GLIsHost() this.Type:SetType(1)
      end

      this.Name.readonly = true               this.Name.ai = nil this.Name:SetStr(TEXT{"<open>"}) this.Name:Show()
      this.Race.readonly = true               this.Invite:Show() this.Race:Hide()
      this.Color.readonly = true              this.Color.color = 0 this.Color:Hide()
      this.Swap.readonly = true               this.Swap:Hide() this.Kick:Hide()
      this.Ready.readonly = true              this.Ready.ready = false this.Ready:Hide()
      this.SwapIndicator:Hide() this.Swap.wonnaswap = false
      this.Units.readonly = true this.Units:Hide()
    elseif state.type == "closed" then
      this.Frame:Hide()
      this.Type.readonly = not net.GLIsHost() this.Type:SetType(3)
      this.Name.readonly = true               this.Name:Hide() this.Name.ai = nil this.Name:SetStr(TEXT{"<closed>"})
      this.Race.readonly = true               this.Invite:Hide() this.Race:Hide()
      this.Color.readonly = true              this.Color.color = 0 this.Color:Hide()
      this.Swap.readonly = true               this.Swap:Hide() this.Kick:Hide()
      this.Ready.readonly = true              this.Ready.ready = false this.Ready:Hide()
      this.SwapIndicator:Hide() this.Swap.wonnaswap = false
      this.Units.readonly = true this.Units:Hide()
    elseif state.type == "player" then
      this.Frame:Show()
      this.Type.readonly = true this.Type:SetType(4, this.userlogo)
      this.Name.readonly = true               this.Name.ai = nil this.Name:SetStr(state.name) this.Name:Show()
      this.Race.readonly = true               this.Race:SetRace(state.race or 1) this.Race:Show() this.Invite:Hide()
      this.Color.readonly = true              this.Color:SetColor(state.color) this.Color:Show() 
      this.Swap.readonly = true               this.Swap:Hide() 
      this.Kick.readonly = not net.GLIsHost() if net.GLIsHost() then this.Kick:Show() else this.Kick:Hide() end
      this.Ready.readonly = true              this.Ready:SetReady(state.ready) this.Ready:Show()
      if state.swapindicator then
        this.Swap.wonnaswap = true
        this.SwapIndicator:Show() 
      else 
        this.Swap.wonnaswap = false
        this.SwapIndicator:Hide() 
      end
      
      this.Units:CancelFlash()
      if this.unitskey then
        this.Units.readonly = false this.Units:Show()
      else
        this.Units.readonly = true this.Units:Hide()
      end
      
    end
  end,
  
  GetState = function(this)
    local state = {}
    state.id = this.id
    state.type = this.type
    state.userlogo = this.userlogo

    if state.type ~= "open" and state.type ~= "closed" then
      state.race = this.Race.race
      state.color = this.Color.color
    end
    if state.type == "ai" then
      state.ai = this.Name.type
    end
    if state.type == "player" or state.type == "myslot"  then
      state.name = this.Name:GetStr()
      state.units = this.units
      state.unitskey = this.unitskey
      state.ready = this.Ready.ready
    end
    return state
  end,
}

local DefAutoPlayetSlot = uiwnd {
  virtual = true,
  size = {240,82},
  
  Frame = uiimg {
    texture = "data/textures/ui/player_slot.dds",
    coords = {0, 0, 54, 54},
    tiled = {18,18,18,18},
    layer = lobbylayer,
  },
  
  Type = DefPlayerLogo {
    hidden = true,
    layer = lobbylayer + 1,
    size = {70,70},
    anchors = { LEFT = { 7,0 } },
    
    n_coords = {0, 0, 70, 70},

    type = 1,
    types = {
      "data/textures/ui/slot_type_open.dds", 
      "data/textures/ui/slot_type_player.dds"
    },
    
    ImageType = uiimg { layer = "+4" },    

    OnShow = function(this) this:SetType(this.type) end,
    SetType = function(this, idx, tbl) 
      this.type = idx 
      this.ImageType:SetTexture(this.types[this.type], this.n_coords)
      if idx == 2 then
        if tbl then
          this.Back:Set(0,0,tbl.back_clr)
          this.Gradient:Set(tbl.gradient_row, tbl.gradient_col, tbl.gradient_clr)
          this.Frame:Set(tbl.frame_row, tbl.frame_col, tbl.frame_clr)
          this.Symbol:Set(tbl.symbol_row, tbl.symbol_col, tbl.symbol_clr)
        end
        this.ImageType:Hide()
        this.Symbol:Show()
        this.Frame:Show()
        this.Gradient:Show()
        this.Back:Show()
      else
        this.Symbol:Hide()
        this.Frame:Hide()
        this.Gradient:Hide()
        this.Back:Hide()
        this.ImageType:Show()
      end
    end,
  },
  
  Name = uitext {
    hidden = true,
    layer = lobbylayer + 1,      
    size = {165, 34},
    font = "Tahoma,9",
    color = {255,199,77},
    anchors = { TOPLEFT = { "TOPRIGHT", "Type", 0,0 } },
  },
  
  Sepline = uiimg {
    size = {139,2},
    layer = lobbylayer + 1,
    texture = "data/textures/ui/sep_line_horizontal.dds", 
    coords = {0,0,139,2},
    anchors = { TOP = { "BOTTOM", "Name", 0,-3 } },
  },
  
  Kick = DefButton {
    hidden = true,
    size = {24,24},
    layer = lobbylayer + 1,      

    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 10,10 } },
    
    NormalImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 48, 24, 24},
    },
    
    OnClick = function(this)
      if this.readonly then return end
      Lobby.PlayersView:OnKickPlayer(this:GetParent())
    end,
  },

  Invite = DefButton {
    hidden = true,
    size = {24,24},
    layer = lobbylayer + 1,      

    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 10,10 } },
    
    NormalImage = uiimg {
      texture = "data/textures/ui/slot_invite.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_invite.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_invite.dds",
      coords = {0, 48, 24, 24},
    },
    
    OnClick = function(this) 
      if this.readonly then return end
      if InvitePlayerMenu:IsHidden() then
        InvitePlayerMenu:SetAnchor("TOPLEFT", this:GetParent(), "BOTTOMLEFT", {0,-20})
        InvitePlayerMenu.slot = this:GetParent()
        InvitePlayerMenu:Show()
      else
        InvitePlayerMenu:Hide()
      end  
    end,
    OnMouseEnter = function(this) NTTooltip:DoShow("invite_player_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Race = DefButton {
    hidden = true,
    size = {24,24},
    race = 1,
    layer = lobbylayer + 1,      

    anchors = { LEFT = { "RIGHT", "Kick", btn_space,0 } },
    
    NormalImage = uiimg { texture = "data/textures/ui/player_race.dds", coords = {0,0,24,24} },
    PushImage = uiimg { texture = "data/textures/ui/player_race.dds", coords = {0,0,24,24} },
    HighImage = uiimg { texture = "data/textures/ui/player_race.dds", coords = {0,0,24,24} },
    
    OnLoad = function(this)
      if Login.demo then
        this.races = {"humans", "mutants"}
      else
        this.races = {"humans", "mutants", "aliens"}
      end
    end,
    OnShow = function(this) this:SetRace(this.race) end,
    SetRace = function(this, idx) 
      this.race = idx
      local top = (this.race-1)*24
      this.NormalImage:SetTexture(nil, {0, top, 24, top+24})
      this.HighImage:SetTexture(nil, {0, top, 24, top+24})
      this.PushImage:SetTexture(nil, {0, top, 24, top+24})
      if this:GetParent().type == "myslot" then
        game.SaveUserPrefs("last_race", { index = idx })
      end
    end,
    OnClick = function(this) 
      if this.readonly or this:GetParent().Ready.ready then return end
      this.race = this.race + 1 if this.race > #this.races then this.race = 1 end
      Lobby.PlayersView:OnRaceChanged(this:GetParent(), this.race)
    end,
    OnMouseEnter = function(this) NTTooltip:DoShow("change_faction_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Color = uibtn {
    hidden = true,
    size = {24,24},
    Clrbar = uiimg {
      layer = lobbylayer + 1,
      texture = "data/textures/ui/player_colour_plate.dds",
      coords = {0, 0, 26, 26},
    },
    anchors = { LEFT = { "RIGHT", "Race", btn_space,0 } },
    color = 0,
    
    OnShow = function(this)
      this:SetColor(this.color) 
    end,
    
    SetColor = function(this, idx) 
      this.color = idx 
      this.Clrbar:SetColor(PlayerColors[this.color]) 
      if this:GetParent().type == "myslot" then
        game.SaveUserPrefs("last_color", { index = idx })
      end
    end,

    OnClick = function(this)
      if this.readonly or this:GetParent().Ready.ready then return end
      if PlayerColorMenu:IsHidden() then
        PlayerColorMenu:SetAnchor("TOPLEFT", this, "BOTTOMLEFT", {0,0})
        PlayerColorMenu.slot = this:GetParent()
        PlayerColorMenu:Show()
      else
        PlayerColorMenu:Hide()
      end  
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("change_player_color_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  Units = DefButton {
    hidden = true,
    size = {24,24},
    anchors = { LEFT = { "RIGHT", "Color", btn_space,0 } },
    layer = lobbylayer + 1,      

    NormalImage = uiimg { texture = "data/textures/ui/buy_army.dds", coords = {0,0,24,24} },
    HighImage = uiimg { texture = "data/textures/ui/buy_army.dds", coords = {0,48,24,24} },
    PushImage = uiimg { texture = "data/textures/ui/buy_army.dds", coords = {0,24,24,24} },
    
    OnClick = function(this)
      if this.readonly then return end
      Lobby.AutoPlayersView:OnUnitsShopping(this:GetParent())
    end,

    OnMouseEnter = function(this) NTTooltip:DoShow("select_units_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,

    OnShow = function(this) this.NormalImage:Show() end,
    OnHide = function(this) this:CancelFlash() end,

    CancelFlash = function(this)
      if this.flashID then
        Transitions:CancelRepeat(this.flashID)
        this.flashID = nil
      end
      this.NormalImage:Show()
    end,

    Flash = function(this)
      if this:GetParent().type ~= "myslot" then this:CancelFlash() return end

      if not this.flashID then
        this.flashID = Transitions:CallRepeat(this.Flash, 0.4, this)
      end

      if this.NormalImage:IsHidden() then
        this.NormalImage:Show()
      else
        this.NormalImage:Hide()
      end
    end,
  },

  Ready = DefButton {
    hidden = true,
    size = {24,24},
    layer = lobbylayer + 1,      
    anchors = { LEFT = { "RIGHT", "Units", btn_space,0 } },
    ready = false,

    texture = "data/textures/ui/slot_ready.dds",
    u_n = { 0, 0, 24, 24},
    u_h = {24, 0, 24+24, 24},
    u_p = {48, 0, 24+48, 24},

    s_n = { 0, 24, 24, 24+24},
    s_h = {24, 24, 24+24, 24+24},
    s_p = {48, 24, 24+48, 24+24},

    OnShow = function(this) this:SetReady(this.ready) end,
    OnClick = function(this)
      if this.readonly then return end
      this.ready = not this.ready
      Lobby.PlayersView:OnReadyChanged(this:GetParent(), this.ready)
    end,
    SetReady = function(this, ready) 
      this.ready = ready 
      if this.ready then 
        this.NormalImage:SetTexture(this.texture, this.u_p)
        this.HighImage:SetTexture(this.texture, this.u_p)
        this.PushImage:SetTexture(this.texture, this.u_p)
      else 
        this.NormalImage:SetTexture(this.texture, this.u_n)
        this.HighImage:SetTexture(this.texture, this.u_n)
        this.PushImage:SetTexture(this.texture, this.u_n)
      end 
    end,
    OnMouseEnter = function(this) NTTooltip:DoShow("player_ready_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  Random = uiwnd {
    hidden = true,

    Image = uiimg { 
      layer = lobbylayer + 5,
      texture = "data/textures/ui/random_player_slot.dds", 
      coords = {0,0,240,82},
    },
    
    Text = uitext {
      layer = lobbylayer + 6,
      halign = "RIGHT",
      size = {220,20},
      anchors = { TOPRIGHT = { -10,5} },
      str = TEXT{"random_player"},
    }
  },
  
  SetState = function(this, state)
    this.id = state.id
    this.type = state.type
    this.unitskey = state.unitskey
    this.units = state.units
    this.userlogo = state.userlogo

    local gametype = net.GLGetGameType()
    
    if state.type == "myslot" then
      this.Frame:SetAlpha(1) this.Frame:Show()
      this.Type:SetType(2, this.userlogo) this.Type:Show()
      this.Name:SetStr(net.Lobby_GetPlayerName()) this.Name:Show()
      this.Race.readonly = false  this.Race:SetRace(state.race or 1) this.Race:Show() this.Invite:Hide()
      this.Color.readonly = false this.Color:SetColor(state.color) this.Color:Show()
      this.Ready.readonly = false this.Ready:SetReady(state.ready) this.Ready:Show()
      this.Kick.readonly = true   this.Kick:Hide()
      this.Units.readonly = false this.Units:Show()
      this.Random:Hide()
      this.Sepline:Show()

      if this.unitskey then
        this.Units.readonly = false this.Units:Show()
        ShoppingUnits:Set(this)
        ShoppingUnits:Save()
      else
        this.Units.readonly = true this.Units:Hide()
      end

    elseif state.type == "open" then
      this.Frame:SetAlpha(1) this.Frame:Show()
      this.Type:SetType(1) this.Type:Show()
      this.Name.readonly = true   this.Name:SetStr(TEXT{"<open>"}) this.Name:Show()
      this.Race.readonly = true   this.Invite:Show() this.Race:Hide()
      this.Color.readonly = true  this.Color.color = 0 this.Color:Hide()
      this.Kick.readonly = true   this.Kick:Hide()
      this.Ready.readonly = true  this.Ready:Hide()
      this.Units.readonly = true  this.Units:Hide()
      this.Random:Hide()
      this.Sepline:Hide()
    elseif state.type == "closed" then
      this.Frame:SetAlpha(0.3) this.Frame:Show()
      this.Type:Hide()
      this.Name.readonly = true   this.Name:Hide()
      this.Race.readonly = true   this.Invite:Hide() this.Race:Hide()
      this.Color.readonly = true  this.Color:Hide()
      this.Ready.readonly = true  this.Ready:Hide()
      this.Kick.readonly = true   this.Kick:Hide()
      this.Units.readonly = true  this.Units:Hide()
      this.Random:Hide()
      this.Sepline:Hide()
    elseif state.type == "random" then
      this.Frame:Hide() 
      this.Type:Hide()
      this.Name.readonly = true   this.Name:Hide()
      this.Race.readonly = true   this.Invite:Hide() this.Race:Hide()
      this.Color.readonly = true  this.Color:Hide()
      this.Ready.readonly = true  this.Ready:Hide()
      this.Kick.readonly = true   this.Kick:Hide()
      this.Units.readonly = true  this.Units:Hide()
      this.Random:Show()
      this.Sepline:Hide()
    elseif state.type == "player" then
      this.Frame:SetAlpha(1) this.Frame:Show()
      this.Type:SetType(2, this.userlogo) this.Type:Show()
      this.Name.readonly = true   this.Name:SetStr(state.name) this.Name:Show()
      this.Race.readonly = true   this.Race:SetRace(state.race or 1) this.Race:Show() this.Invite:Hide()
      this.Color.readonly = true  this.Color:SetColor(state.color) this.Color:Show() 
      this.Kick.readonly = not net.GLIsHost() if net.GLIsHost() then this.Kick:Show() else this.Kick:Hide() end
      this.Ready.readonly = true  this.Ready:SetReady(state.ready) this.Ready:Show()
      this.Units:CancelFlash()
      if this.unitskey then
        this.Units.readonly = false this.Units:Show()
      else
        this.Units.readonly = true this.Units:Hide()
      end
      this.Random:Hide()
      this.Sepline:Show()
    end
  end,
  
  GetState = function(this)
    local state = {}
    state.id = this.id
    state.type = this.type
    state.userlogo = this.userlogo

    if state.type ~= "open" and state.type ~= "closed" then
      state.race = this.Race.race
      state.color = this.Color.color
    end
    if state.type == "player" or state.type == "myslot"  then
      state.name = this.Name:GetStr()
      state.units = this.units
      state.unitskey = this.unitskey
      state.ready = this.Ready.ready
    end
    return state
  end,
}

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
        OnClick = function(slot) 
          if not slot.disabled then 
            this:OnListClicked(i)
          else
            local parent = this:GetParent()
            if Login.demo and parent.OnDisabledClick then 
              parent.OnDisabledClick(parent, i)
            end
          end 
        end,
        OnRClick = function(slot) end,
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

local MAX_STARS = 40
local DefStarControl = uiwnd {
  virtual = true,
  text = uitext {},
  DefFrameImage {},
  
  OnLoad = function(this)
    for i = 1, MAX_STARS do
      slot = uiimg {
        hidden = true,
        size = this.star_size,
        texture = this.texture,
        coords = this.texture_coords,
      }
      this["Star" .. i] = slot
    end
    this:CreateChildren()
  end,
  
  Update = function(this)
    if not this.max_cnt then return end
    local cnt = this.cnt
    for i = 1,this.max_cnt do
      if cnt > 0 then 
        this["Star"..i]:SetColor(colors.white)
        cnt = cnt - 1
      else
        this["Star"..i]:SetColor({110,110,110})
      end
    end
  end,
  
  ShowPrice = function(this, bshow, price)
    if not bshow then this:Update() return end
    local possible = true
    local start = this.cnt
    if start < price then start = price possible = false end
    for i = 1,price do
      if possible then
        this["Star"..start]:SetColor(colors.green)
      else
        this["Star"..start]:SetColor(colors.red)
      end
      start = start - 1
    end
  end,
  
  Set = function(this, cnt)
    this.cnt = cnt
    this.max_cnt = cnt
    this.stars_created = nil
    this:ShowStars()
    this:Update()
  end,
    
  Add = function(this, cnt)
    if this.cnt + cnt <= this.max_cnt then
      this.cnt = this.cnt + cnt
      this:Update()
      return true
    end
    return false
  end,

  Sub = function(this, cnt)
    if this.cnt - cnt >= 0 then
      this.cnt = this.cnt - cnt
      this:Update()
      return true
    end
    return false
  end,
  
  ShowStars = function(this)
    for i = 1, MAX_STARS do
      local slot = this["Star"..i]
      if not this.max_cnt or i > this.max_cnt then
        slot:Hide()
      else
        if i == 1 then
          local sz = this:GetSize()
          local leftdist = (sz.x - ((this.max_cnt * this.star_size[1]) + ((this.max_cnt - 1) * this.stars_dist))) / 2
          slot:SetAnchor("LEFT", this, "LEFT", { leftdist,0 } )
        else
          slot:SetAnchor("LEFT", this["Star"..i-1], "RIGHT", { this.stars_dist,0 } )
        end
        slot:Show()
      end  
    end
  end,
}

local MAX_STACKICONS = 40
local DefShoppingButton = uibtn {
  virtual = true,
  size = {48,48},
  
  stack_height = 40,
  stack_dist_max = 5,
  
  DefCornerFrameImage2 {
    size = {52,52},
    layer = "+1",
  },
  
  Icon = uiimg {
  	size = {48,48},
  	layer = "+2",
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
      else
        this:Hide()
      end  
  	end,
  },

  Count = uiwnd {
    size = {20,20},
    layer = "+3",
    anchors = { BOTTOMRIGHT = { 0,0 } },
    
    Back = uiimg {
      layer = "-1",
      texture = "data/textures/ui/reward_quantity_number_plate.dds",
      coords = {0, 0, 20, 21},
    },
    
    Text = uitext { 
      font = "Trebuchet MS,10b", 
      color = {138, 163, 255}, 
      anchors = { CENTER = { -1,-1 } },
    },
  },
  
  OnLoad = function(this)
    for i = 1,MAX_STACKICONS do
      this[i] = uiwnd {
        hidden = true,
        mouse = true,
        size = {52,52},
        layer = "-1",
        DefCornerFrameImage2 {}
      }
    end
    this:CreateChildren()
  end,
  
  Set = function(this, id, cur, max, cost)
    if max and cur > max then cur = max end
    this.id = id
    this.cur = 0
    this.max = max
    this.cost = cost
    if this.ui_cost:Sub(cur*cost) then
      this.cur = cur
    end
    
    --game.GetActorName(this.id)
    this.icn,this.cls = game.GetActorIcon(this.id)
    this.Icon:Set({icon = this.icn, class = this.cls})
    
    this:Update()
  end,
  
  ShowSatckIcons = function(this, count)
    local distance = this.stack_height / count
    if distance > this.stack_dist_max then distance = this.stack_dist_max end

    local showed = 1
    local idx = MAX_STACKICONS
    while idx >= 1 do
      if showed > count then
        this[idx]:Hide()
      else
        if idx == MAX_STACKICONS then
          this[idx]:SetAnchor("BOTTOM", this, "BOTTOM", { 0,distance })
        else
          this[idx]:SetAnchor("BOTTOM", this[idx+1], "BOTTOM", { 0,distance })
        end
        this[idx]:Show()
      end
      idx = idx - 1
      showed = showed + 1
    end
    
  end,  
  
  Update = function(this)
    if this.cur > 0 then
      this.Count.Text:SetStr(this.cur)
      this.Count:Show()
    else  
      this.Count:Hide()
    end
    
    local stack = this.cur - 1 if stack < 0 then stack = 0 end
    this:ShowSatckIcons(stack)
  end,

  OnClick = function(this)
    if not this.ui_cost:Sub(this.cost) then
      -- ErrText:ShowText(TEXT{""}) -- We have no written text for this message?
      game.PlaySnd("data/speech/advisor/no unit points.wav")
      return
    end
    if not this.cur then this.cur = 0 end
    this.cur = this.cur + 1
    if this.max and this.cur > this.max then this.cur = this.max end
    this:Update()
    this.ui_cost:ShowPrice(true, this.cost)
  end,

  OnRClick = function(this)
    if not this.cur then this.cur = 0 end
    if this.cur < 1 then return end
    if not this.ui_cost:Add(this.cost) then return end
    this.cur = this.cur - 1
    if this.cur < 0 then this.cur = 0 end
    this:Update()
    this.ui_cost:ShowPrice(true, this.cost)
  end,

  OnMouseEnter = function(this)
    this.ui_cost:ShowPrice(true, this.cost)
    this:GetParent():ShowTooltip(this)
  end,

  OnMouseLeave = function(this)
    this.ui_cost:ShowPrice(false)
    this:GetParent():ShowTooltip()
  end,
}

ShoppingUnits = uiwnd {
  hidden = true,
  layer = modallayer + 3,
  size = {270,310},
  
  Frame = DefSmallBackImage {layer = "-5"},
  
  Title = uitext {
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "TOPRIGHT", 0,25 } },
  },
  
  BigStars = DefStarControl {
    layer = "+1",
    stars_dist = 0,
    star_size = {24,24},
    texture = "data/textures/ui/star_big.dds",
    texture_coords = {0,0,24,24},
  
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Title", 10,15 }, BOTTOMRIGHT = { "Title", -10,30+15 } },
  },
  
  Officer_1 = DefShoppingButton { officer = 1 ,index = 1, layer = "+1", anchors = { TOPLEFT = { "BOTTOMLEFT", "BigStars", -1,3 } } },
  Officer_2 = DefShoppingButton { officer = 1 ,index = 2, layer = "+1", anchors = { LEFT = { "RIGHT", "Officer_1", 3,0 } } },
  Officer_3 = DefShoppingButton { officer = 1 ,index = 3, layer = "+1", anchors = { LEFT = { "RIGHT", "Officer_2", 3,0 } } },
  Officer_4 = DefShoppingButton { officer = 1 ,index = 4, layer = "+1", anchors = { LEFT = { "RIGHT", "Officer_3", 3,0 } } },
  Officer_5 = DefShoppingButton { officer = 1 ,index = 5, layer = "+1", anchors = { LEFT = { "RIGHT", "Officer_4", 3,0 } } },
  
  SmallStars = DefStarControl {
    layer = "+1",
    stars_dist = -2,
    star_size = {12,12},
    texture = "data/textures/ui/star_small.dds",
    texture_coords = {0,2,12,12},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "BigStars", 0,90 }, BOTTOMRIGHT = { "BigStars", 0,30+90 } },
  },
  
  Unit_1 = DefShoppingButton { index = 1, stack_height = 50, stack_dist_max = 10, layer = "+1", anchors = { TOPLEFT = { "BOTTOMLEFT", "SmallStars", -1,3 } } },
  Unit_2 = DefShoppingButton { index = 2, stack_height = 50, stack_dist_max = 10, layer = "+1", anchors = { LEFT = { "RIGHT", "Unit_1", 3,0 } } },
  Unit_3 = DefShoppingButton { index = 3, stack_height = 50, stack_dist_max = 10, layer = "+1", anchors = { LEFT = { "RIGHT", "Unit_2", 3,0 } } },
  Unit_4 = DefShoppingButton { index = 4, stack_height = 50, stack_dist_max = 10, layer = "+1", anchors = { LEFT = { "RIGHT", "Unit_3", 3,0 } } },
  Unit_5 = DefShoppingButton { index = 5, stack_height = 50, stack_dist_max = 10, layer = "+1", anchors = { LEFT = { "RIGHT", "Unit_4", 3,0 } } },
  
  OnLoad = function(this)
    this.Officer_1.ui_cost = this.BigStars
    this.Officer_2.ui_cost = this.BigStars
    this.Officer_3.ui_cost = this.BigStars
    this.Officer_4.ui_cost = this.BigStars
    this.Officer_5.ui_cost = this.BigStars

    this.Unit_1.ui_cost = this.SmallStars
    this.Unit_2.ui_cost = this.SmallStars
    this.Unit_3.ui_cost = this.SmallStars
    this.Unit_4.ui_cost = this.SmallStars
    this.Unit_5.ui_cost = this.SmallStars
    this:RegisterEvent("MAP_LOADED")
  end,
  
  OnEvent = function(this, event)
    if event == "MAP_LOADED" then this:Hide() end
  end,

  OnShow = function(this)
    Modal.func = function() this:Hide() end
    if this.slot and this.slot.type == "myslot" and not this.slot.Ready.ready then
      Modal:SetLayer(modallayer)
    else
      Modal:SetLayer(modallayer + 30)
    end
    if this.slot and this.slot.type == "myslot" and this.slot.Units.CancelFlash then
      this.slot.Units:CancelFlash()
    end
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide() 
	  this:Save()
	end,

  Save = function(this)
    local total = 0
	  if this.slot and this.slot.type == "myslot" then
	    this.slot.units = {}
	    local idx = 1
	    while 1 do
	      local oslot = this["Officer_" .. idx]
	      if oslot then this.slot.units[oslot.id] = oslot.cur total = total + oslot.cur end
	      local uslot = this["Unit_" .. idx]
	      if uslot then this.slot.units[uslot.id] = uslot.cur total = total + uslot.cur end
	      idx = idx + 1
	      if not oslot and not uslot then break end
	    end
	  
	    game.SaveUserPrefs(this.slot.unitskey, this.slot.units)
	    net.GLUserPrefsChanged()

      if this.slot.type == "myslot" and this.slot.Units.Flash then
        if total > 0 then
          this.slot.Units:CancelFlash()
          this.slot.Ready.readonly = false
          this.slot.Ready:SetAlpha(1)
          this.slot.Ready.NormalImage:SetShader()
          this.slot.Ready.HighImage:SetShader()
          this.slot.Ready.PushImage:SetShader()
        else
          if not this.slot.Units.flashID then
            this.slot.Units:Flash()
          end
          this.slot.Ready.readonly = true
          this.slot.Ready:SetAlpha(0.5)
          this.slot.Ready.NormalImage:SetShader("_Misc_InterfaceDrawBW")
          this.slot.Ready.HighImage:SetShader("_Misc_InterfaceDrawBW")
          this.slot.Ready.PushImage:SetShader("_Misc_InterfaceDrawBW")
        end
      end
	  end  
  end,

  Set = function(this, slot)
    if (not net.GLGetGameType()) then return end
    this.location = net.GetMapName()
    this.slot = slot
    this.Title:SetStr(TEXT{"s line up", slot.Name:GetStr()})
  
    local info = game.GetLocationInfo(this.location)
    if not info then
      info = game.GetGameModeInfo("gt_"..net.GLGetGameType())
    end
    
    --info.num_players
    this.BigStars:Set(info.max_officers)
    this.SmallStars:Set(info.recr_points)
    
    local unit_idx = 1
    local officer_idx = 1
    for i,unit in ipairs(info[slot.Race.races[slot.Race.race]]) do
      if unit.max > 0 or unit.max < 0 then
        if unit.officer then
          local bslot = this["Officer_" .. officer_idx]
          if bslot then
            local max if unit.max > 0 then max = unit.max end
            local cur = slot.units[unit.id] or 0
            bslot:Set(unit.id, cur, max, 1)
            officer_idx = officer_idx + 1
          end
        else
          local bslot = this["Unit_" .. unit_idx]
          if bslot then
            local max if unit.max > 0 then max = unit.max end
            local cur = slot.units[unit.id] or 0
            bslot:Set(unit.id, cur, max, unit.recruitment_cost)
            unit_idx = unit_idx + 1
          end
        end
      end
    end
  end,
  
  ShowTooltip = function(this, btn)
    if not btn then
      Tooltip:Hide()
      return 
    end
    local name = game.GetActorName(btn.id)
    if btn.officer then
      Tooltip:AttachTo(this.BigStars, "BOTTOM", this.BigStars, "TOP", {0,0})
    else
      Tooltip:AttachTo(this.SmallStars, "BOTTOM", this.SmallStars, "TOP", {0,0})
    end
    Tooltip.Title:SetStr(name)
    Tooltip.Text:SetStr("<p>"..TEXT{btn.id..".descr"})
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,
}

-- UserMenu
local um_w = 200
local um_h = 170

local DefMenuButton = DefButton {
  virtual = true,
  size = {um_w-15,20},

  disabled = false,

  n_iclr = {0,0,0,0},
  h_iclr = {100,100,100,200},
  p_iclr = {100,100,100,200},

  n_tclr = {150,150,150,255},
  h_tclr = {200,200,200,255},
  p_tclr = {200,200,200,255},
  d_tclr = {90,90,90,255},

  NormalImage = uiimg {},
  HighImage = uiimg {},
  PushImage = uiimg {},
  
  NormalText = uitext  { halign = "LEFT" },
  HighText  = uitext { halign = "LEFT" },
  PushText = uitext { halign = "LEFT" },
  
  OnShow = function(this) this:updatestate() end,
  updatestate = function(this)
    if this.disabled then
      this.NormalImage:SetColor(this.n_iclr)
      this.HighImage:SetColor(this.n_iclr)
      this.PushImage:SetColor(this.n_iclr)
      
      this.NormalText:SetColor(this.d_tclr)
      this.HighText:SetColor(this.d_tclr)
      this.PushText:SetColor(this.d_tclr)
    else
      this.NormalImage:SetColor(this.n_iclr)
      this.HighImage:SetColor(this.h_iclr)
      this.PushImage:SetColor(this.p_iclr)
      
      this.NormalText:SetColor(this.n_tclr)
      this.HighText:SetColor(this.h_tclr)
      this.PushText:SetColor(this.p_tclr)
    end    
  end,
  
  OnClick = function(this) this:GetParent():OnItemClick(this) end,
}

local menuitem_space = 5

UserMenu = uiwnd {
  hidden = true,
  size = {um_w,um_h},
  layer = modallayer + 1,

  DefCornerFrameImage{},
  black_bar = uiimg {
    size = {um_w-6,24},
    color = {0,0,0,255},
    anchors = { TOP = {1,4} },
  },


  Name = uitext {
    layer = modallayer + 2,
    size = {um_w,20},
    font = "Verdana,11b",
    color = {234,223,178},
    anchors = { TOP = { "TOP", 0,5 } },
  },

  AddToFriends = DefMenuButton { 
    anchors = { TOP = { "BOTTOM", "Name", 0,10 } },
    str = TEXT{"addtofriends"},
  },

  InviteTeam = DefMenuButton { 
    anchors = { TOP = { "BOTTOM", "AddToFriends", 0,menuitem_space } },
    str = TEXT{"invitetoteam"},
  },

  InviteOpponent = DefMenuButton { 
    anchors = { TOP = { "BOTTOM", "InviteTeam", 0,menuitem_space } },
    str = TEXT{"inviteasopponent"},
  },

  ViewInfo = DefMenuButton { 
    anchors = { TOP = { "BOTTOM", "InviteOpponent", 0,menuitem_space } },
    str = TEXT{"viewinfo"},
  },

  --Ignore = DefMenuButton { 
    --anchors = { TOP = { "BOTTOM", "ViewInfo", 0,menuitem_space } },
    --str = TEXT{"ignore"},
  --},

  -- "practice" "pvp" "pvpat" "speciallocation" "mission"
  SetUser = function(this, user)
    this.Name:SetStr(user)
    local gtype = net.GLGetGameType()
    if net.GLIsHost() and gtype ~= "pvp" then
      if gtype == "speciallocation" or gtype == "pvpat" then
        this.InviteOpponent.disabled = true
      else
        this.InviteOpponent.disabled = false
      end
      this.InviteTeam.disabled = false
    else
      this.InviteTeam.disabled = true
      this.InviteOpponent.disabled = true
    end

    if UserContacts.FriendsList:GetUser(user) then
      this.AddToFriends.disabled = true
    else
      this.AddToFriends.disabled = false
    end

    this:Show()
  end,

  OnItemClick = function(this, item)
    local player = this.Name:GetStr()
    
    if item == this.AddToFriends then
      LobbyChat:AddLine(nil, nil, TEXT{"auth_request", player})
      net.BuddyList_SendRequest(player)
    end

    if item == this.InviteOpponent then
      net.SendGameInvitation(player, 2)
      LobbyChat:AddLine(nil, nil, TEXT{"invitation_sent", player})
    end
    
    if item == this.InviteTeam then
      net.SendGameInvitation(player, 1)
      LobbyChat:AddLine(nil, nil, TEXT{"invitation_sent", player})
    end

    this:Hide()

    if item == this.ViewInfo then
      PlayerInfo:SetPlayer(player)
    end
  end,

  OnShow = function(this)
    Modal.func = function() this:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide() 
	end,
}

local function sortbytypegames(tbl)
  table.sort(tbl, function(a,b)
                    if not b then return true end
                    if not a then return false end
                    
                    local av = 1
                    if a.version == Lobby.version then
                      av = 0
                    end

                    local bv = 1
                    if b.version == Lobby.version then
                      bv = 0
                    end
                    
                    if av ~= bv then 
                      return av < bv
                    end
                    
                    if a.private ~= b.private then
                      return not a.private
                    end
                    
                    if a.playing == b.playing then
                      return a.name < b.name
                    end
                    
                    return b.playing
                  end)
end

local view_w = 600
local view_h = 720

Lobby = uiwnd {
  hidden = true,
  keyboard = true,
  
	Dim = uiimg { -- to dim dragged item
		layer = -1, hidden = true,
		size = {44,44},
		color = {255,255,255,100},
	},

	DragCatch = uiwnd {
	  mouse = true,
	  layer = -5,
	  hidden = true,
	  OnMouseDown = function() game.CancelItemDrag() end,
	},

  MissionsBtn = DefLobbyBtn {
    anchors = { TOPLEFT = { 10, 10 } },
    str = TEXT{"missions"},
    OnMouseEnter = function(this) NTTooltip:DoShow("missions_btn_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
    OnLoad = function(this) if Login.demo then this.demodisabled = true end 
    end,
  },
  
  SLocationBtn = DefLobbyBtn {
    anchors = { LEFT = { "RIGHT", "MissionsBtn", 2, 0 } },
    str = TEXT{"locations"},
    OnMouseEnter = function(this) NTTooltip:DoShow("locations_btn_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  PVPBtn = DefLobbyBtn {
    anchors = { LEFT = { "RIGHT", "SLocationBtn", 2, 0 } },
    str = TEXT{"pvp_caps"},
    OnMouseEnter = function(this) NTTooltip:DoShow("deathmatch_btn_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
    OnLoad = function(this) if Login.demo then this.demodisabled = true end end,
  },

  PracticeBtn = DefLobbyBtn {
    anchors = { LEFT = { "RIGHT", "PVPBtn", 2, 0 } },
    str = TEXT{"prac_caps"},
  },
  
  SettingsBtn = DefLobbyBtn {
    anchors = { TOPRIGHT = { -10, 10 } },
    str = TEXT{"settings"},
    OnMouseEnter = function(this) NTTooltip:DoShow("settings_btn_tip", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  StatsBtn = DefLobbyBtn {
    anchors = { RIGHT = { "LEFT", "SettingsBtn", -2, 0 } },
    str = TEXT{"stats_btn"},
    OnMouseEnter = function(this) NTTooltip:DoShow("stats_btn_tip", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  FriendsBtn = DefLobbyBtn {
    anchors = { RIGHT = { "LEFT", "StatsBtn", -2, 0 } },
    str = TEXT{"chat btn lobby"},
    OnMouseEnter = function(this) NTTooltip:DoShow("chat_btn_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  AbilityBtn = DefLobbyBtn {
    anchors = { RIGHT = { "LEFT", "FriendsBtn", -2, 0 } },
    str = TEXT{"abilities btn"},
    OnMouseEnter = function(this) NTTooltip:DoShow("ability_grid_btn_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  ExitBtn = DefButton1 {
    anchors = { BOTTOMRIGHT = { -10, -10 } },
    str = TEXT{"exit"},
    OnClick = function(this) Lobby:Leave() end,
    OnMouseEnter = function(this) NTTooltip:DoShow("exit_btn_tip", this, "TOPRIGHT", "BOTTOMRIGHT", {0,-10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  UpdateBtn = DefButton1 {
    anchors = { BOTTOM = { "TOP", "ExitBtn", 0, -10 } },
    str = TEXT{"update"},
    OnClick = function(this) leaveLobby() AutoPatchWnd:Start() end,
  },
  
  Gamespy = uiimg {
    hidden = true,
    size = {100,23},
    texture = "data/textures/ui/logo_gamespy.dds",
    texture_auto_coords = true,
    anchors = { BOTTOMRIGHT = {-200,-10} },
  },

  Version = Login.Version {
    anchors = { RIGHT = { "LEFT", "Gamespy", -20,7 } },
  },
  -- misiions
    
	MissionsView = uiwnd {
    size = {view_w, view_h},
    hidden = true,
    anchors = { TOPLEFT = { 10, 60 } },
  	
	  DefBigBackImage {},
	  
    ListTitle = uiwnd {
      layer = lobbylayer + 1,
      anchors = { TOPLEFT = { 15,15 }, BOTTOMRIGHT = { "TOP", -25,40 } },
      uitext {font = "Verdana,10b", color = {255, 143, 51}, str = TEXT{"missions"}},
    },
    
	  ListBox = DefBtnListBox {
      layer = lobbylayer,
      font = "Verdana,9",
      ncolor = {46, 46, 46},
      hcolor = {200, 200, 200},
      pcolor = {255, 143, 51},
      scolor = {255, 143, 51},
      ocolor = {255, 255, 255},
      
      anchors = { TOPLEFT = { "TOPLEFT", "ListTitle", 0,0 }, BOTTOMRIGHT = { "BOTTOM", -25,-15 } },
      
      DefSmallBackImage {},
      
      Scrollbar = DefBtnListBox.Scrollbar {
        hidden = true,
        layer = lobbylayer + 2,
      },
      
      --ShowScrollbarArea = uiwnd {
        --mouse = true,
        --layer = lobbylayer + 1,
        --anchors = { TOPLEFT = { "Scrollbar" }, BOTTOMRIGHT = { "Scrollbar" } },
        --OnShow = function(this) this:RegisterMouseEvents(true) end,
        --OnHide = function(this) this:RegisterMouseEvents(false) end,
        --OnMouseInside = function(this) this:GetParent().Scrollbar:Show() end,
        --OnMouseOutside = function(this) this:GetParent().Scrollbar:Hide() end,
      --},

      ScrollArea = uiwnd {
        anchors = { TOPLEFT = { 10, 30 }, BOTTOMRIGHT = { -10,-15 } },
      },
      
      UpdateItem = function(this, item, data)
        item.data = data
        item:SetStr(TEXT("earth_spots.#"..data.map:sub(-2)..".title"))
        this:UpdateItemColor(item, data)
      end,
      
      UpdateItemColor = function(this, item, data)
        if not item or not item.data then return end
        if this.selected_item == data then
          item:GetTextPanel():SetColor(this.scolor)
          item:GetTextPanel("HIGH"):SetColor(this.scolor)
        else
          if item.data.state == "disabled" then
            item:GetTextPanel():SetColor(this.ncolor)
            item:GetTextPanel("HIGH"):SetColor(this.ncolor)
          elseif item.data.state == "open" then
            item:GetTextPanel():SetColor(this.ocolor)
            item:GetTextPanel("HIGH"):SetColor(this.ocolor)
          else
            item:GetTextPanel():SetColor(this.hcolor)
            item:GetTextPanel("HIGH"):SetColor(this.hcolor)
          end
        end
      end,
      
      SelectItem = function(this, item, data, selected)
        if not data or not selected then return end
        Lobby.MissionsView:OnSelectMission(data)
      end,
    },
    
    ClickToViewInfo = uiwnd {
      anchors = { TOPLEFT = { "TOPRIGHT", "ListTitle", 5,0 }, BOTTOMRIGHT = { "BOTTOMRIGHT", -5,-5} },
      text = uitext {
        size = {300,300},
        font = "Verdana,12",
        str = TEXT{"clicktoviewinfo"},
      }
    },

    Info = uiwnd {
      hidden = true,
      anchors = { TOPLEFT = { "TOPRIGHT", "ListTitle", 5,0 }, BOTTOMRIGHT = { "BOTTOMRIGHT", -15,-15} },
      
      DefSmallBackImage {},
      
      Title = uiwnd {
        layer = "+1",
        anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "TOPRIGHT", 0,25 } },
        text = uitext {
          font = "Verdana,10b",
          color = {255, 143, 51}, 
        },
      },
      
      Image = uiwnd {
        size = {289,220},
        anchors = { TOP = { "BOTTOM", "Title", 2,5 } },
        
        Pic = uiimg {
          size = {289,220},
          texture = "data/textures/ui/mission_picture_01.dds",
        },
        
        Completed = uitext {
          hidden = true,
          layer = lobbylayer,
          size = {289, 30},
          font = "Trebuchet MS,18",
          color = {255, 143, 51}, 
          shadow_ofs = {1,1},
          str = "<p>"..TEXT{"completed"},
        },
        
        Time = uitext {
          hidden = true,
          size = {289, 30},
          font = "Trebuchet MS,10",
          color = {255, 143, 51}, 
          shadow_ofs = {1,1},
          anchors = { TOP = { "BOTTOM", "Completed", 0,0 } },
          str = TEXT{"fastest time"},
        },
      },
      
      Description = uitext {
        layer = "+1",
        font = "Verdana,9",
        color = {136,136,136},
        valign = "TOP",
        halign = "LEFT",
        anchors = { TOPLEFT = { "BOTTOMLEFT", "Image", 10,5 }, BOTTOMRIGHT = { "BOTTOMRIGHT", "Image", -10,170 } },
      },
      
      RewardsTitle = uitext {
        font = "Arial,10",
        color = {183,183,183},
        anchors = { TOPLEFT = { "BOTTOMLEFT", "Description", 0,5 }, BOTTOMRIGHT = { "BOTTOMRIGHT", "Description", 0,25 } },
        halign = "LEFT",
        str = TEXT{"rewards:"},
      },
      
      Rew_1 = DefRewardSlot { index = 1, anchors = { TOPLEFT = { "BOTTOMLEFT", "RewardsTitle", 0,5 } } },
      Rew_2 = DefRewardSlot { index = 2, anchors = { LEFT = { "RIGHT", "Rew_1", 15,0 } } },
      Rew_3 = DefRewardSlot { index = 3, anchors = { LEFT = { "RIGHT", "Rew_2", 15,0 } } },
      
      StartBtn = DefButton {
        size = {195, 26},
        font = "Veradana,10b",
        anchors = { BOTTOM = { 0,-15} },
        
        NormalText = uitext  { color = {234, 223, 178} },
        HighText  = uitext { color = {234, 234, 234} },
        PushText = uitext { color = {234, 234, 234} },
        
        NormalImage = uiimg {
          size = {195, 26},
          texture = "data/textures/ui/mission_button.dds",
          coords = {0, 0, 195, 26},
        },
        
        HighImage = uiimg {
          size = {195, 26},
          texture = "data/textures/ui/mission_button.dds",
          coords = {0, 26, 195, 26},
        },

        PushImage = uiimg {
          size = {195, 26},
          texture = "data/textures/ui/mission_button.dds",
          coords = {0, 52, 195, 26},
        },

        OnClick = function(this) if not this.map then return end Lobby:StartMission(this.map) end,
      },
    },
	},
	
	-- practice
	PracticeView = uiwnd {
    size = {view_w, view_h},
    hidden = true,
    anchors = { TOPLEFT = { 10, 60 } },
  	
	  Frame = DefBigBackImage {},
    
    Title = uiwnd {
      layer = lobbylayer+1,
      size = {view_w, 25},
      anchors = { TOP = { 0,17 } },
      uitext {font = "Verdana,10b", color = {255, 143, 51}, str = TEXT{"practice"}},
    },
    
    Setup = uiwnd {
      size = {view_w-30, view_h-62},
      anchors = { TOPLEFT = { 15,15 } },
      
      Frame = DefSmallBackImage {layer = lobbylayer-2},
      
      TemplateImage = uiimg {
        layer = lobbylayer,
        texture = "data/textures/ui/practice_picture_01_small.dds",
        coords = {0,0,270,220},
        anchors = { TOPLEFT = { "Frame", 5,25 }, BOTTOMRIGHT = { "TOPRIGHT", "Frame", -5,240 } }, 
      },
      
      Template = DefCombobox {
        layer = lobbylayer + 2,
        size = {229,220},
        anchors = { TOPRIGHT = { "Frame", -10,35 } },
        btn_height = 16,
        
        Button = DefCombobox.Button {
          font = "Trebuchet MS,10b",
          
          NormalText = uitext { color = {0, 0, 0} },
          HighText  = uitext { color = {0, 0, 0} },
          PushText = uitext { color = {0, 0, 0} },
          
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

          OnMouseEnter = function(this) NTTooltip:DoShow("location_list_tip", this, "TOP", "BOTTOM", {0,-10}) end,
          OnMouseLeave = function(this) NTTooltip:Hide() end,
        },
        
        Listbox = DefCombobox.Listbox {
          layer = lobbylayer + 10,
          font = "Trebuchet MS,10",

          ncolor = {143, 153, 138},
          hcolor = {236, 254, 227},
          pcolor = {236, 254, 227},
          scolor = {255, 143, 51},
          dcolor = {100, 100, 100},

          ScrollArea = DefCombobox.Listbox.ScrollArea {
            back = uiimg { 
              texture = "data/textures/ui/ui.tga",
              coords = {0, 199, 27, 27},
              tiled = 1,
              shader = "_Misc_IDBB",
            },
          },
          
          GetItemText = function(this, idx) return this.list[idx].name end,
          
          UpdateItem = function(this, item, data)
            item.data = data
            item:SetStr(data.name)
            if item.data and item.data.disabled then
              item.disabled = true
              item.NormalText:SetColor(this.dcolor)
              item.HighText:SetColor(this.dcolor)
              item.PushText:SetColor(this.dcolor)
              return
            end
            item.disabled = nil
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

        InitCombo = function(this)
          if not this.Listbox.list or #this.Listbox.list < 1 then
            local templates = game.EnumMapTemplates()
            table.insert(templates, 1, {template = "RANDOM", name = TEXT{"random_loc"}} )
            if Login.demo then
              local cnt = #templates
              for i = 1,cnt do
                if i ~= 1 and i ~= 8 and i ~= 9 then
                  templates[i].disabled = true
                end
              end
            end
            this.Listbox:SetList(templates)
          end
        end,
        
        OnItemSelected = function(listbox, idx)
          Lobby.PracticeView:OnTemplateChanged(listbox, idx)
        end,
        
        OnDisabledClick = function(this, idx)
          if Login.demo then
            MessageBox:Alert(TEXT("demo_practice"))  
            this.Listbox:Hide()
            Modal:Hide()
          end
        end,
      },
      
      All = DefRadioBtn {
        layer = lobbylayer + 1,
        size = {85,22},
        
        anchors = { BOTTOMLEFT = { "TOP", "Plrs_2", 15,-15 } },
        str = TEXT{"all"},
        
        OnClick = function(this) Lobby.PracticeView:OnFilterChanged(this) end,

        OnMouseEnter = function(this) NTTooltip:DoShow("all_games_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Plrs_2 = DefRadioBtn {
        size = {64,22},
        layer = lobbylayer + 1,
        anchors = { CENTER = { "RIGHT", "TemplateImage", -120,-5 } },
        str = TEXT{"2v2"},
        
        OnClick = function(this) Lobby.PracticeView:OnFilterChanged(this) end,

        OnMouseEnter = function(this) NTTooltip:DoShow("2v2_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Plrs_1 = DefRadioBtn {
        size = {64,22},
        layer = lobbylayer + 1,
        anchors = { RIGHT = { "LEFT", "Plrs_2", -2,0 } },
        str = TEXT{"1v1"},
        
        OnClick = function(this) Lobby.PracticeView:OnFilterChanged(this) end,

        OnMouseEnter = function(this) NTTooltip:DoShow("1v1_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Plrs_3 = DefRadioBtn {
        size = {64,22},
        layer = lobbylayer + 1,
        anchors = { LEFT = { "RIGHT", "Plrs_2", 2,0 } },
        str = TEXT{"3v3"},
        
        OnClick = function(this) Lobby.PracticeView:OnFilterChanged(this) end,

        OnMouseEnter = function(this) NTTooltip:DoShow("3v3_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Small = DefRadioBtn {
        layer = lobbylayer + 1,
        size = {85,22},
        
        anchors = { BOTTOM = { "TOPLEFT", "Plrs_2", 0,-2 } },
        str = TEXT{"small"},
        
        OnClick = function(this) Lobby.PracticeView:OnFilterChanged(this) end,

        OnMouseEnter = function(this) NTTooltip:DoShow("small_games_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Big = DefRadioBtn {
        layer = lobbylayer + 1,
        size = {85,22},
        
        anchors = { TOP = { "BOTTOMRIGHT", "Plrs_2", 0,2 } },
        str = TEXT{"big"},
        
        OnClick = function(this) Lobby.PracticeView:OnFilterChanged(this) end,

        OnMouseEnter = function(this) NTTooltip:DoShow("big_games_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      QuickJoin = DefButton {
        size = {195, 26},
        font = "Verdana,10b",
        layer = lobbylayer + 1,
        anchors = { BOTTOMRIGHT = { "TemplateImage", -10,-10 } },
        str = TEXT{"quick join"},
        OnMouseEnter = function(this) NTTooltip:DoShow("quick_join_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
        OnClick = function(this) Lobby.PracticeView:OnQuickJoin() end,
      },
      
      Create = DefButton {
        size = {195, 26},
        font = "Verdana,10b",
        layer = lobbylayer + 1,
        anchors = { RIGHT = { "LEFT", "QuickJoin", -20,0 } },
        str = TEXT{"create"},
        OnClick = function(this) 
          Lobby.PracticeView:OnCreateGame(argMods.shift)
        end,
        OnMouseEnter = function(this) NTTooltip:DoShow("create_gamebtn", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },

    },
    
    ListGames = uiwnd {
      layer = lobbylayer,
      anchors = { TOPLEFT = { "BOTTOMLEFT",  "Lobby.PracticeView.Setup.TemplateImage", 0, 10 }, 
                  TOPRIGHT = { "BOTTOMRIGHT", "Lobby.PracticeView.Setup.TemplateImage", 0,10 },
                  BOTTOM = { "BOTTOM",  "Lobby.PracticeView.Setup"} },

      Ping = DefSortBtn {
        size = {66,20},
        font = "Verdana,10",
        anchors = { TOPLEFT = { 2,0 } },
        str = TEXT{"ping"},
      },
      Count = DefSortBtn {
        size = {46,20},
        font = "Verdana,10",
        anchors = { LEFT = { "RIGHT", "Ping", 1,0 } },
        str = "#",
      },
      Name = DefSortBtn {
        font = "Verdana,10",
        anchors = { TOPLEFT = { "TOPRIGHT", "Count", 1,0 }, BOTTOMRIGHT = { "TOPRIGHT", -2,20 } },
        str = TEXT{"name"},
      },
      
      Vert_1 = uiwnd {
        size = {2,1},
        layer = lobbylayer + 10,
        anchors = { TOPLEFT = { "BOTTOMRIGHT", "Ping", 0,-2 } },
        lt = uiimg { color = {0,0,0,255}, anchors = { TOPLEFT = {0,0}, BOTTOMRIGHT = {-1,0} } },
        rt = uiimg { color = {41,41,42,255}, anchors = { TOPLEFT = {1,0}, BOTTOMRIGHT = {0,0} } },
        OnShow = function(this)
          local sz = this:GetSize()
          this:SetSize{sz.x, this:GetParent():GetSize().y - 25 }
        end,
      },
      
      Vert_2 = uiwnd {
        size = {2,1},
        layer = lobbylayer + 10,
        anchors = { TOPLEFT = { "BOTTOMRIGHT", "Count", 0,-2 } },
        lt = uiimg { color = {0,0,0,255}, anchors = { TOPLEFT = {0,0}, BOTTOMRIGHT = {-1,0} } },
        rt = uiimg { color = {41,41,42,255}, anchors = { TOPLEFT = {1,0}, BOTTOMRIGHT = {0,0} } },
        OnShow = function(this)
          local sz = this:GetSize()
          this:SetSize{sz.x, this:GetParent():GetSize().y - 25 }
        end,
      },

	    Listbox = DefBtnListBox {
        layer = lobbylayer,
        ncolor = {143, 153, 138},
        hcolor = {236, 254, 227},
        pcolor = {236, 254, 227},
        scolor = {255, 143, 51},
        anchors = { TOPLEFT = { "BOTTOMLEFT", "Ping", -2,-3 }, BOTTOMRIGHT = { "BOTTOMRIGHT", -20,0 } },
        
        Scrollbar = DefBtnListBox.Scrollbar {
          --hidden = true,
          anchors = { TOPLEFT = { "TOPRIGHT", 0, 5 }, BOTTOMLEFT = { "BOTTOMRIGHT", 0, -5 } },
          layer = lobbylayer + 2,
        },
        
        --ShowScrollbarArea = uiwnd {
          --mouse = true,
          --layer = lobbylayer + 1,
          --anchors = { TOPLEFT = { "Scrollbar" }, BOTTOMRIGHT = { "Scrollbar" } },
          --OnShow = function(this) this:RegisterMouseEvents(true) end,
          --OnHide = function(this) this:RegisterMouseEvents(false) end,
          --OnMouseInside = function(this) this:GetParent().Scrollbar:Show() end,
          --OnMouseOutside = function(this) this:GetParent().Scrollbar:Hide() end,
        --},

        ScrollArea = DefBtnListBox.ScrollArea {
          anchors = { TOPLEFT = { 2, 3 }, BOTTOMRIGHT = { -2,-3 } },
          Back = uiimg { color = {0,0,0,0} },
        },
        
        UpdateItem = function(this, item, data)
          item.data = data
          item.Ping.text:SetStr(data.ping)
          item.Players.text:SetStr(data.players..'/<color=242,135,49>'..data.maxPlayers)
          if data.private then
            item.GameName.text:SetStr('<color=193,135,154>'..data.name.." "..TEXT("game_is_private")..'</>')
          elseif data.version ~= Lobby.version then
            item.GameName.text:SetStr('<color=255,0,0>'..'! '..data.name..'</>')
          else
            if data.playing then
              item.GameName.text:SetStr('<color=183,94,216>'..data.name.." "..TEXT("game_is_playing")..'</>')
            else
              item.GameName.text:SetStr(data.name)
            end
          end
          if this.selected_item == data then
            item.Ping.selected:Show()
            item.Players.selected:Show()
            item.GameName.selected:Show()
          else
            item.Ping.selected:Hide()
            item.Players.selected:Hide()
            item.GameName.selected:Hide()
          end
        end,
      },
      
      Join = DefButton {
        size = {200, 27},
        layer = lobbylayer + 1,
        font = "Verdana,10b",
        anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Lobby.PracticeView.Setup", 0,6 } },
        str = TEXT{"join"},
        OnClick = function(this) Lobby.PracticeView:OnJoinGameGame() end,
        OnMouseEnter = function(this) NTTooltip:DoShow("join_game_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
    },
	},

	-- special locations
	SpecialLocView = uiwnd {
    size = {view_w, view_h},
    hidden = true,
    anchors = { TOPLEFT = { 10, 60 } },
  	
	  Frame = DefBigBackImage {},
    
    Title = uiwnd {
      layer = lobbylayer+1,
      size = {view_w, 25},
      anchors = { TOP = { 0,17 } },
      uitext {font = "Verdana,10b", color = {255, 143, 51}, str = TEXT{"special locations"}},
    },
    
    Setup = uiwnd {
      size = {view_w - 30, view_h-62},
      anchors = { TOPLEFT = { 15,15 } },
      
      Frame = DefSmallBackImage {layer = lobbylayer-2},
      
      TemplateImage = uiimg {
        layer = lobbylayer,
        texture = "data/textures/ui/practice_picture_01_small.dds",
        coords = {0,0,270,220},
        anchors = { TOPLEFT = { "Frame", 5,25 }, BOTTOMRIGHT = { "TOPRIGHT", "Frame", -5,240 } }, 
      },
      
      Template = DefCombobox {
        layer = lobbylayer + 1,
        size = {229,220},
        anchors = { TOPRIGHT = { "Frame", -10,35 } },
        btn_height = 16,
        
        Button = DefCombobox.Button {
          font = "Trebuchet MS,10b",
          
          NormalText = uitext  { color = {0, 0, 0} },
          HighText  = uitext { color = {0, 0, 0} },
          PushText = uitext { color = {0, 0, 0} },
          
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

          OnMouseEnter = function(this) NTTooltip:DoShow("location_list_tip", this, "TOP", "BOTTOM", {0,-10}) end,
          OnMouseLeave = function(this) NTTooltip:Hide() end,
        },
        
        Listbox = DefCombobox.Listbox {
          layer = lobbylayer + 10,
          font = "Trebuchet MS,10",
          ncolor = {143, 153, 138},
          hcolor = {236, 254, 227},
          pcolor = {236, 254, 227},
          scolor = {255, 143, 51},

          ScrollArea = DefCombobox.Listbox.ScrollArea {
            back = uiimg { 
              texture = "data/textures/ui/ui.tga",
              coords = {0, 199, 27, 27},
              tiled = 1,
              shader = "_Misc_IDBB",
            },
          },
          
          GetItemText = function(this, idx) 
            return this.list[idx].title 
          end,
          
          UpdateItem = function(this, item, data)
            item.data = data
            if data.disabled then
              item:SetStr("<color=100,100,100>"..data.title.."</>")
              item.disabled = true
            else
              item:SetStr(data.title)
              item.disabled = nil
            end
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

        InitCombo = function(this)
          local locations = game.LoadLocationsList()
          for i,v in ipairs(locations) do
            v.title = game.GetMapTitle(v.map)
            v.num_players = game.GetMapNumPlayers(v.map)
            v.disabled = true
          end
          local unlocked = game.LoadUserData("SpecialLocations")
          if unlocked and #unlocked then
            for i,v in ipairs(unlocked) do
              for ia,va in ipairs(locations) do
                if v.map == va.map then
                  va.disabled = nil
                end
              end
            end
          end
          this.Listbox:SetList(locations)
          Lobby.SpecialLocView.Setup:Show()
          Lobby.SpecialLocView.Setup.Create:Show()
        end,
        
        OnItemSelected = function(listbox, idx)
          if listbox.list[idx].disabled then return end
          Lobby.SpecialLocView:OnTemplateChanged(listbox, idx)
        end,

        OnDisabledClick = function(this, idx)
          if Login.demo then
            MessageBox:Alert(TEXT("demo_splocation"))  
            this.Listbox:Hide()
            Modal:Hide()
          end
        end,
      },
      
      QuickJoin = DefButton {
        size = {195, 26},
        font = "Verdana,10b",
        layer = lobbylayer + 1,
        anchors = { BOTTOMRIGHT = { "TemplateImage", -10,-10 } },
        str = TEXT{"quick join"},
        OnClick = function(this) Lobby.SpecialLocView:OnQuickJoin() end,
      },

      Create = DefButton {
        size = {195, 26},
        font = "Verdana,10b",
        layer = lobbylayer + 1,
        anchors = { RIGHT = { "LEFT", "QuickJoin", -20,0 } },
        str = TEXT{"create"},
        OnClick = function(this) 
          Lobby.SpecialLocView:OnCreateGame(argMods.shift) 
        end,
        OnMouseEnter = function(this) NTTooltip:DoShow("create_gamebtn", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
    },
    
    ListGames = uiwnd {
      layer = lobbylayer,
      anchors = { TOPLEFT = { "BOTTOMLEFT",  "Lobby.SpecialLocView.Setup.TemplateImage", 0, 10 }, 
                  TOPRIGHT = { "BOTTOMRIGHT", "Lobby.SpecialLocView.Setup.TemplateImage", 0,10 },
                  BOTTOM = { "BOTTOM",  "Lobby.SpecialLocView.Setup"} },

      Ping = DefSortBtn {
        size = {66,20},
        font = "Verdana,10",
        anchors = { TOPLEFT = { 2,0 } },
        str = TEXT{"ping"},
      },
      Count = DefSortBtn {
        size = {46,20},
        font = "Verdana,10",
        anchors = { LEFT = { "RIGHT", "Ping", 1,0 } },
        str = "#",
      },
      Name = DefSortBtn {
        font = "Verdana,10",
        anchors = { TOPLEFT = { "TOPRIGHT", "Count", 1,0 }, BOTTOMRIGHT = { "TOPRIGHT", -2,20 } },
        str = TEXT{"name"},
      },
      
      Vert_1 = uiwnd {
        size = {2,1},
        layer = lobbylayer + 10,
        anchors = { TOPLEFT = { "BOTTOMRIGHT", "Ping", 0,-2 } },
        lt = uiimg { color = {0,0,0,255}, anchors = { TOPLEFT = {0,0}, BOTTOMRIGHT = {-1,0} } },
        rt = uiimg { color = {41,41,42,255}, anchors = { TOPLEFT = {1,0}, BOTTOMRIGHT = {0,0} } },
        OnShow = function(this)
          local sz = this:GetSize()
          this:SetSize{sz.x, this:GetParent():GetSize().y - 25 }
        end,
      },
      
      Vert_2 = uiwnd {
        size = {2,1},
        layer = lobbylayer + 10,
        anchors = { TOPLEFT = { "BOTTOMRIGHT", "Count", 0,-2 } },
        lt = uiimg { color = {0,0,0,255}, anchors = { TOPLEFT = {0,0}, BOTTOMRIGHT = {-1,0} } },
        rt = uiimg { color = {41,41,42,255}, anchors = { TOPLEFT = {1,0}, BOTTOMRIGHT = {0,0} } },
        OnShow = function(this)
          local sz = this:GetSize()
          this:SetSize{sz.x, this:GetParent():GetSize().y - 25 }
        end,
      },

	    Listbox = DefBtnListBox {
        layer = lobbylayer,
        ncolor = {143, 153, 138},
        hcolor = {236, 254, 227},
        pcolor = {236, 254, 227},
        scolor = {255, 143, 51},
        anchors = { TOPLEFT = { "BOTTOMLEFT", "Ping", -2,-3 }, BOTTOMRIGHT = { "BOTTOMRIGHT", -20,0 } },
        
        Scrollbar = DefBtnListBox.Scrollbar {
          --hidden = true,
          anchors = { TOPLEFT = { "TOPRIGHT", 0, 5 }, BOTTOMLEFT = { "BOTTOMRIGHT", 0, -5 } },
          layer = lobbylayer + 2,
        },
        
        --ShowScrollbarArea = uiwnd {
          --mouse = true,
          --layer = lobbylayer + 1,
          --anchors = { TOPLEFT = { "Scrollbar" }, BOTTOMRIGHT = { "Scrollbar" } },
          --OnShow = function(this) this:RegisterMouseEvents(true) end,
          --OnHide = function(this) this:RegisterMouseEvents(false) end,
          --OnMouseInside = function(this) this:GetParent().Scrollbar:Show() end,
          --OnMouseOutside = function(this) this:GetParent().Scrollbar:Hide() end,
        --},

        ScrollArea = DefBtnListBox.ScrollArea {
          anchors = { TOPLEFT = { 2, 3 }, BOTTOMRIGHT = { -2,-3 } },
          Back = uiimg { color = {0,0,0,0} },
        },
        
        UpdateItem = function(this, item, data)
          item.data = data
          item.Ping.text:SetStr(data.ping)
          item.Players.text:SetStr(data.players..'/<color=242,135,49>'..data.maxPlayers)
          if data.private then
            item.GameName.text:SetStr('<color=193,135,154>'..data.name.." "..TEXT("game_is_private")..'</>')
          elseif data.version ~= Lobby.version then
            item.GameName.text:SetStr('<color=255,0,0>'..'! '..data.name..'</>')
          else
            if data.playing then
              item.GameName.text:SetStr('<color=183,94,216>'..data.name.." "..TEXT("game_is_playing")..'</>')
            else
              item.GameName.text:SetStr(data.name)
            end
          end  
          if this.selected_item == data then
            item.Ping.selected:Show()
            item.Players.selected:Show()
            item.GameName.selected:Show()
          else
            item.Ping.selected:Hide()
            item.Players.selected:Hide()
            item.GameName.selected:Hide()
          end
        end,
      },
      
      Join = DefButton {
        size = {200, 27},
        layer = lobbylayer + 1,
        font = "Verdana,10b",
        anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Lobby.SpecialLocView.Setup", 0,6 } },
        str = TEXT{"join"},
        OnClick = function(this) Lobby.SpecialLocView:OnJoinGameGame() end,
      },
    },
	},

  -- players
	PlayersView = uiwnd {
    size = {view_w, view_h},
    hidden = true,
    anchors = { TOPLEFT = { 10, 60 } },
  	
	  DefBigBackImage {},
	  
	  Frame = DefSmallBackImage {
	    anchors = { TOPLEFT = { 15,15 }, BOTTOMRIGHT = { -15,-15 } },
	  },

    ViewTitle = uiwnd {
      layer = "+1",
      size = {200, 25},
      anchors = { TOPLEFT = { "Frame", 0,2 } },
      Text = uitext {font = "Verdana,10b", color = {255, 143, 51}},
    },
    
    HideGame = DefButton {
      hidden = true,
      layer = "+2",
      size = {19, 8},
      anchors = { TOPRIGHT = { "Frame", -8,10 } },
      
      NormalImage = uiimg { texture = "data/textures/ui/eye.dds" },
      HighImage = uiimg { texture = "data/textures/ui/eye.dds" },
      PushImage = uiimg { texture = "data/textures/ui/eye.dds" },
      
      showed_n = {0,8,19,16},
      showed_h = {19,8,38,16},
      showed_p = {19,8,38,16},
      
      hidden_n = {0,0,19,8},
      hidden_h = {19,0,38,8},
      hidden_p = {19,0,38,8},
      
      hidegame = false,
      
      OnShow = function(this) this:Set(this.hidegame) end,
      
      OnClick = function(this) 
        this:GetParent():OnHideGame(not this.hidegame) 
      end,
      
      Set = function(this, dohide)
        this.hidegame = dohide
        if this.hidegame then
          this.NormalImage:SetTexture(nil, this.hidden_n)
          this.HighImage:SetTexture(nil, this.hidden_h)
          this.PushImage:SetTexture(nil, this.hidden_p)
        else
          this.NormalImage:SetTexture(nil, this.showed_n)
          this.HighImage:SetTexture(nil, this.showed_h)
          this.PushImage:SetTexture(nil, this.showed_p)
        end
      end
    },

    GameTitle = uiwnd {
      layer = "+1",
      anchors = { TOPLEFT = { "TOPRIGHT", "ViewTitle", 0,0 }, BOTTOMRIGHT = { "TOPRIGHT", "Frame", -33,25 } },
      uiimg { color = {130,130,130, 70} },
      Edit = uiedit {
        anchors = { TOPLEFT = { 5,0 }, BOTTOMRIGHT = { -5,0 } },
        font = "Verdana,9b",
        color = {255,199,77},
        readonly = true,

        --OnShow = function(this)
          --if net.GLIsHost() then
            --this:SetReadOnly(false)
          --else
            --this:SetReadOnly(true)
          --end
        --end,
        OnKeyEnter = function(this) 
          this:RemoveFocus()
          local gamename = this:GetStr()
          Lobby.PlayersView:OnGameNameChanged(gamename)
        end,
        OnKeyEscape = function(this) this:RemoveFocus() end,
      },
    },
    
    TemplateImage = uiimg {
      layer = lobbylayer,
      texture = "data/textures/ui/practice_picture_01.dds",
      coords = {0,0,560,279},
      anchors = { TOPLEFT = { "Frame", 5,30 }, BOTTOMRIGHT = { "TOPRIGHT", "Frame", -5,309 } }, 
    },
    
    Template = DefCombobox {
      layer = lobbylayer + 1,
      size = {229,220},
      anchors = { TOPRIGHT = { "Frame", -10,35 } },
      btn_height = 16,

      Button = DefCombobox.Button {
        font = "Trebuchet MS,10b",
        
        NormalText = uitext  { color = {0, 0, 0} },
        HighText  = uitext { color = {0, 0, 0} },
        PushText = uitext { color = {0, 0, 0} },
        
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

        OnMouseEnter = function(this) NTTooltip:DoShow("location_list_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Listbox = DefCombobox.Listbox {
        font = "Trebuchet MS,10",

        dcolor = {100, 100, 100},
        ncolor = {143, 153, 138},
        hcolor = {236, 254, 227},
        pcolor = {236, 254, 227},
        scolor = {255, 143, 51},
        
        ScrollArea = DefCombobox.Listbox.ScrollArea {
          back = uiimg { 
            texture = "data/textures/ui/ui.tga",
            coords = {0, 199, 27, 27},
            tiled = 1,
            shader = "_Misc_IDBB",
          },
        },

        UpdateItem = function(this, item, data)
          if item.data and item.data.disabled then
            item.NormalText:SetColor(this.dcolor)
            item.HighText:SetColor(this.dcolor)
            item.PushText:SetColor(this.dcolor)
            return
          end
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
      
      OnItemSelected = function(listbox, idx)
        Lobby.PlayersView:OnTemplateChanged(listbox, idx)
      end,

      Disable = function(this, disable)
        if disable then
          this.Button.NormalImage:SetTexture(nil, {0,16,229,16+16})
          this.Button.HighImage:SetTexture(nil, {0,16,229,16+16})
          this.Button.PushImage:SetTexture(nil, {0,16,229,16+16})
          this.Button.disabled = true
        else
          this.Button.NormalImage:SetTexture(nil, {0,0,229,16})
          this.Button.HighImage:SetTexture(nil, {0,0,229,16})
          this.Button.PushImage:SetTexture(nil, {0,0,229,16})
          this.Button.disabled = nil
        end  
      end,
    },
    
    Team1 = uitext {
      size = {200, 20},
      layer = lobbylayer + 1,
      font = "Trebuchet MS,12b",              
      anchors = { BOTTOM = { "TOP", "Slot_1", 0,-11 } },
    },
    
    Team2 = uitext {
      size = {200, 20},
      layer = lobbylayer + 1,
      font = "Trebuchet MS,12b",
      str = TEXT("team").."<color=255,143,51> 2</>",
      anchors = { BOTTOM = { "TOP", "Slot_4", 0,-11 } },
    },

    Slot_1 = DefPlayetSlot { index = 1, anchors = { TOPLEFT = { "BOTTOMLEFT", "TemplateImage", 20,40 } } },
    Slot_2 = DefPlayetSlot { demodisabled = true, index = 2, anchors = { TOPLEFT = { "BOTTOMLEFT", "Slot_1", 0,20 } } },
    Slot_3 = DefPlayetSlot { demodisabled = true, index = 3, anchors = { TOPLEFT = { "BOTTOMLEFT", "Slot_2", 0,20 } } },
    
    Sepline = uiimg {
      size = {2,279},
      layer = lobbylayer + 1,
      texture = "data/textures/ui/sep_line_vertical.dds", 
      coords = {0,0,2,279},
      anchors = { TOP = { "BOTTOM", "TemplateImage", 0,30 } },
    },

    Slot_4 = DefPlayetSlot { 
      index = 4, 
      anchors = { TOPRIGHT = { "BOTTOMRIGHT", "TemplateImage", -20,40 } },
      
      Swap = DefPlayetSlot.Swap {
        NormalImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 0, 24, 24}, },
        HighImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 24, 24, 24}, },
        PushImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 48, 24, 24}, },
      },

      SwapIndicator = DefPlayetSlot.SwapIndicator {
        NormalImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 0, 24, 24}, },
        HighImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 24, 24, 24}, },
        PushImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 48, 24, 24}, },
      },
    },

    Slot_5 = DefPlayetSlot { 
      demodisabled = true, 
      index = 5,
      anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Slot_4", 0,20 } },
      
      Swap = DefPlayetSlot.Swap {
        NormalImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 0, 24, 24}, },
        HighImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 24, 24, 24}, },
        PushImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 48, 24, 24}, },
      },

      SwapIndicator = DefPlayetSlot.SwapIndicator {
        NormalImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 0, 24, 24}, },
        HighImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 24, 24, 24}, },
        PushImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 48, 24, 24}, },
      },
    },

    Slot_6 = DefPlayetSlot {
      demodisabled = true, 
      index = 6,
      anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Slot_5", 0,20 } },
      
      Swap = DefPlayetSlot.Swap {
        NormalImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 0, 24, 24}, },
        HighImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 24, 24, 24}, },
        PushImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 48, 24, 24}, },
      },

      SwapIndicator = DefPlayetSlot.SwapIndicator {
        NormalImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 0, 24, 24}, },
        HighImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 24, 24, 24}, },
        PushImage = uiimg { texture = "data/textures/ui/slot_swap_01.dds", coords = {0, 48, 24, 24}, },
      },
    },
    
    Start = DefButton {
      hidden = true,
      layer = "+1",
      size = {195,25},
      anchors = { BOTTOMRIGHT = { "Frame", -10,-10 } }, 
      str = TEXT{"start"},
      OnClick = function(this) if this.enabled then this:GetParent():OnStartGameBtn() end end,

      OnMouseEnter = function(this) 
        local key = "start_game_tip"
        if not this.enabled then key = "start_game_tip_disabled" end
        NTTooltip:DoShow(key, this, "BOTTOM", "TOP", {0,10}) 
      end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },
    
    Leave = DefButton {
      layer = "+1",
      size = {195,25},
      anchors = { BOTTOMLEFT = { "Frame", 10,-10 } }, 
      str = TEXT{"leave"},
      OnClick = function(this) this:GetParent():OnLeaveGameBtn() end,
      OnMouseEnter = function(this) NTTooltip:DoShow("leave_game_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },
	},

  -- automatc players
	AutoPlayersView = uiwnd {
    size = {view_w, view_h},
    hidden = true,
    anchors = { TOPLEFT = { 10, 60 } },
  	
	  DefBigBackImage {},
	  
	  Frame = DefSmallBackImage {
	    anchors = { TOPLEFT = { 15,15 }, BOTTOMRIGHT = { -15,-15 } },
	  },

    ViewTitle = uiwnd {
      layer = "+1",
      size = {1, 25},
      anchors = { TOPLEFT = { "Frame", 0,2 }, TOPRIGHT = { "Frame", 0,2 } },
      Text = uitext {font = "Verdana,10b", color = {255, 143, 51}, str = TEXT{"pvp_caps"} },
    },
    
    TemplateImage = uiimg {
      layer = lobbylayer,
      texture = "data/textures/ui/practice_picture_01.dds",
      coords = {0,0,560,300},
      anchors = { TOPLEFT = { "Frame", 5,30 }, BOTTOMRIGHT = { "TOPRIGHT", "Frame", -5,330 } },
    },
    
    DMStats = DMMeters {
      hidden = false,
      layer = lobbylayer+5,
      
      anchors = {TOPLEFT = {"TOPLEFT", 40, 80}},
    },
    
    Template = DefCombobox {
      layer = lobbylayer + 3,
      size = {229,220},
      anchors = { TOPRIGHT = { "Frame", -10,35 } },
      btn_height = 16,
      
      Button = DefCombobox.Button {
        size = {229,16},
        font = "Trebuchet MS,10b",
        
        NormalText = uitext  { color = {0, 0, 0} },
        HighText  = uitext { color = {0, 0, 0} },
        PushText = uitext { color = {0, 0, 0} },
        
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

        OnMouseEnter = function(this) NTTooltip:DoShow("location_list_tip", this, "TOP", "BOTTOM", {0,-10}) end,
        OnMouseLeave = function(this) NTTooltip:Hide() end,
      },
      
      Listbox = DefCombobox.Listbox {
        font = "Trebuchet MS,10",

        dcolor = {100, 100, 100},
        ncolor = {143, 153, 138},
        hcolor = {236, 254, 227},
        pcolor = {236, 254, 227},
        scolor = {255, 143, 51},
        
        ScrollArea = DefCombobox.Listbox.ScrollArea {
          back = uiimg { 
            texture = "data/textures/ui/ui.tga",
            coords = {0, 199, 27, 27},
            tiled = 1,
            shader = "_Misc_IDBB",
          },
        },

        GetItemText = function(listbox, idx) 
          return listbox.list[idx].name 
        end,

        UpdateItem = function(this, item, data)
          item.data = data
          item:SetStr(data.name)
          if item.data and item.data.disabled then
            item.NormalText:SetColor(this.dcolor)
            item.HighText:SetColor(this.dcolor)
            item.PushText:SetColor(this.dcolor)
            return
          end
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
      
      OnItemSelected = function(listbox, idx)
        Lobby.AutoPlayersView:OnChangeTemplate(listbox, idx)
      end,
      
      InitCombo = function(this)
        this.Button.selected = 1  
        if not this.Listbox.list or #this.Listbox.list < 1 then
          local templates = game.EnumMapTemplates()
          this.Listbox:SetList(templates)
        end
      end,
      
      Disable = function(this, disable)
        if disable then
          this.Button.NormalImage:SetTexture(nil, {0,16,229,16+16})
          this.Button.HighImage:SetTexture(nil, {0,16,229,16+16})
          this.Button.PushImage:SetTexture(nil, {0,16,229,16+16})
          this.Button.disabled = true
        else
          this.Button.NormalImage:SetTexture(nil, {0,0,229,16})
          this.Button.HighImage:SetTexture(nil, {0,0,229,16})
          this.Button.PushImage:SetTexture(nil, {0,0,229,16})
          this.Button.disabled = nil
        end  
      end,
    },
    
    Plrs_2 = DefRadioBtn {
      size = {64,22},
      layer = lobbylayer + 1,
      count = 2,
      anchors = { TOP = { "Template", 0,35 } },
      str = TEXT{"2v2"},
      
      OnClick = function(this) 
        if this.disabled then return end
        Lobby.AutoPlayersView:OnChangePlayersCount(this) 
      end,

      OnMouseEnter = function(this) NTTooltip:DoShow("deathmatch_2v2_tip", this, "TOP", "BOTTOM", {0,-10}) end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },
    
    Plrs_1 = DefRadioBtn {
      size = {64,22},
      layer = lobbylayer + 1,
      count = 1,
      anchors = { RIGHT = { "LEFT", "Plrs_2", -2,0 } },
      str = TEXT{"1v1"},
      
      OnClick = function(this) 
        if this.disabled then return end
        Lobby.AutoPlayersView:OnChangePlayersCount(this) 
      end,

      OnMouseEnter = function(this) NTTooltip:DoShow("deathmatch_1v1_tip", this, "TOP", "BOTTOM", {0,-10}) end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },
    
    Plrs_3 = DefRadioBtn {
      size = {64,22},
      layer = lobbylayer + 1,
      count = 3,
      anchors = { LEFT = { "RIGHT", "Plrs_2", 2,0 } },
      str = TEXT{"3v3"},
      
      OnClick = function(this) 
        if this.disabled then return end
        Lobby.AutoPlayersView:OnChangePlayersCount(this) 
      end,

      OnMouseEnter = function(this) NTTooltip:DoShow("deathmatch_3v3_tip", this, "TOP", "BOTTOM", {0,-10}) end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },

    Gametype = DefRadioBtn {
      size = {122,22},
      layer = lobbylayer + 1,
      
      types = {["pvpat"] = TEXT{"team"}, ["pvp"] = TEXT{"random"}},

      anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Plrs_3", 0,15 } },
      
      OnShow = function(this) this:Set(this.type) end,
      
      Set = function(this, type)
        this.type = type
        this:SetStr(this.types[this.type])
      end,
      
      OnClick = function(this)
        if this.disabled == true then return end
        Lobby.AutoPlayersView:OnChangeGameType(this) 
      end,

      OnMouseEnter = function(this) NTTooltip:DoShow("deathmatch_team_tip", this, "TOP", "BOTTOM", {0,-10}) end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },

    Slot_1 = DefAutoPlayetSlot { index = 1, anchors = { TOPLEFT = { "BOTTOMLEFT", "TemplateImage", 20,20 } } },
    Slot_2 = DefAutoPlayetSlot { index = 2, anchors = { TOPLEFT = { "BOTTOMLEFT", "Slot_1", 0,20 } } },
    Slot_3 = DefAutoPlayetSlot { index = 3, anchors = { TOPLEFT = { "BOTTOMLEFT", "Slot_2", 0,20 } } },
    
    Sepline = uiimg {
      size = {2,279},
      layer = lobbylayer + 1,
      texture = "data/textures/ui/sep_line_vertical.dds", 
      coords = {0,0,2,279},
      anchors = { TOP = { "BOTTOM", "TemplateImage", 0,30 } },
    },
    
    Helptext = uiwnd {
      layer = lobbylayer + 1,
      anchors = { TOPLEFT = { "Sepline", 20,-10 }, BOTTOMRIGHT = { "Frame", -20,-40 } }, 
      text = uitext {
        anchors = { TOPLEFT = {  }, BOTTOMRIGHT = {  } }, 
        layer = lobbylayer + 1,
        font = "Tahoma,10",
        color = {192,197,158},
      },
      OnShow = function(this)
        this.text:SetAnchor("TOPLEFT", this, "TOPLEFT", {0,0})
        this.text:AddAnchor("BOTTOMRIGHT", this, "BOTTOMRIGHT", {0,0})
        this.text:SetStr("<p>"..TEXT{"pvp_help"})
        if game.GetDistro() == 505 then
          this.text:SetAlign("LEFT", "TOP") -- Chinese texts should not be center-aligned
        end
      end,
    },

    Start = DefButton {
      hidden = true,
      size = {195,25},
      anchors = { BOTTOMRIGHT = { "Frame", -10,-10 } }, 
      str = TEXT{"start"},
      OnClick = function(this) if this.enabled then this:GetParent():OnStartGameBtn() end end,

      OnMouseEnter = function(this) 
        local key = "start_game_tip"
        if not this.enabled then key = "start_game_tip_disabled" end
        NTTooltip:DoShow(key, this, "BOTTOM", "TOP", {0,10}) 
      end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },
    
    Leave = DefButton {
      size = {195,25},
      anchors = { BOTTOMLEFT = { "Frame", 10,-10 } }, 
      str = TEXT{"leave"},
      OnClick = function(this) this:GetParent():OnLeaveGameBtn() end,
      OnMouseEnter = function(this) NTTooltip:DoShow("leave_game_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) NTTooltip:Hide() end,
    },
    
	},


  -- automatc players
	DeathMatchSearchView = uiwnd {
    size = {view_w, view_h},
    hidden = true,
    anchors = { TOPLEFT = { 10, 60 } },
    layer = lobbylayer + 1,
    searchingplayers1 = 0,
    searchingplayers2 = 0,
    searchingplayers3 = 0,
    searchingplayers4 = 0,
    searchingplayers5 = 0,
  	
	  DefBigBackImage {},
	  
	  Frame = DefSmallBackImage {
	    anchors = { TOPLEFT = { 15,15 }, BOTTOMRIGHT = { -15,-15 } },
	  },

    ViewTitle = uiwnd {
      layer = "+1",
      size = {1, 25},
      anchors = { TOPLEFT = { "Frame", 0,2 }, TOPRIGHT = { "Frame", 0,2 } },
      Text = uitext {font = "Verdana,10b", color = {255, 143, 51}, str = TEXT{"pvp_caps"} },
    },
    
    
    LFGText = uitext {
      layer = "+1",
      size = {500, 40},
      font = "Tahoma,20", 
      color = {241, 241, 241}, 
      anchors = {TOP = {"TOP", 0, 65}},
      str = TEXT{"dm_lfg"}, 
    },
    
    Anim = DefAnim {
      size = {473,23},
      --hidden = true,
      layer = "+1",
      texture = "data/textures/ui/loading_bar_anim.dds",
      coords = {0, 0, 473, 23},
      frames = 7,
      looped = true,
      defazed = false,
      autoplay = true,
      horizontal = false,
      
      anchors = {TOP = {"BOTTOM", "LFGText", 0, 10}},
    },

    MatchAttemptsText = uitext {
      hidden = true,
      layer = "+1",
      size = {500, 25},
      font = "Tahoma,12", 
      color = {241, 241, 241}, 
      anchors = {TOP = {"BOTTOM", "Anim", 0, 5}},
      str = TEXT{"dm_match_att"}, 
    },

    WaitingText = uitext {
      layer = "+1",
      size = {500, 25},
      font = "Tahoma,12", 
      color = {241, 241, 241},
      anchors = {TOP = {"BOTTOM", "MatchAttemptsText", 0, 0}},
      str = TEXT{"dm_players"}, 
    },
    
    --Sepline = uiimg {
    --  size = {30,300},
    --  layer = "+1",
    --  texture = "data/textures/ui/stats_vertical_line_6.dds", 
    --  coords = {0,0,6,256},
    --  anchors = { TOP = {"BOTTOM", "WaitingText", 3, 20 } },
    --  tiled = {3, 60, 3, 60},
    --},    
    
    Team1Text = uitext {
      layer = "+1",
      size = {200, 25},
      font = "Tahoma,12", 
      color = {241, 241, 241},
      anchors = {TOP = {"BOTTOM", "WaitingText", -140, 20}},
      str = TEXT{"dm_team1"}, 
    },    
    
    Team2Text = uitext {
      layer = "+1",
      size = {200, 25},
      font = "Tahoma,12", 
      color = {241, 241, 241},
      anchors = {LEFT = {"RIGHT", "Team1Text", 100, 0}},
      str = TEXT{"dm_team2"}, 
    },    
    
    Player1 = DMPlayerFrame {
      layer = "+3",
      --layer = lobbylayer+8,
      anchors = {TOP = {"BOTTOM", "Team1Text", 0, 20}},
    },
    
    Player2 = DMPlayerFrame {
      layer = "+3",
      --layer = lobbylayer+8,
      anchors = {TOP = {"BOTTOM", "Player1", 0, 27}},
    },

    Player3 = DMPlayerFrame {
      layer = "+3",
      --layer = lobbylayer+8,
      anchors = {TOP = {"BOTTOM", "Player2", 0, 27}},
    },

    Player4 = DMPlayerFrame {
      layer = "+3",
      --layer = lobbylayer+8, 
      anchors = {TOP = {"BOTTOM", "Team2Text", 0, 20}},    
    },

    Player5 = DMPlayerFrame {
      layer = "+3",
      --layer = lobbylayer+8,
      anchors = {TOP = {"BOTTOM", "Player4", 0, 27}},    
    },

    Player6 = DMPlayerFrame {
      layer = "+3",
      --layer = lobbylayer+8,
      anchors = {TOP = {"BOTTOM", "Player5", 0, 27}},    
    },

    Logo1 = DMPlayerLogo {
      anchors = {LEFT = {"LEFT", "Player1", -15, 0}},     
    },
    
    Logo2 = DMPlayerLogo {
      anchors = {LEFT = {"LEFT", "Player2", -15, 0}},     
    },    
    
    Logo3 = DMPlayerLogo {
      anchors = {LEFT = {"LEFT", "Player3", -15, 0}},     
    },
    
    Logo4 = DMPlayerLogo {
      anchors = {LEFT = {"LEFT", "Player4", -15, 0}},     
    },
    
    Logo5 = DMPlayerLogo {
      anchors = {LEFT = {"LEFT", "Player5", -15, 0}},     
    },
    
    Logo6 = DMPlayerLogo {
      anchors = {LEFT = {"LEFT", "Player6", -15, 0}},     
    },                

    
    DMStats = DMMeters {
      hidden = false,
      layer = lobbylayer+5,
      anchors = {BOTTOMLEFT = {"BOTTOMLEFT", 30, -30}}, 
    },
    
    Cancel = DefButton {
      --hidden = true,
      layer = "+1",
      size = {195,25},
      anchors = { BOTTOMRIGHT = { "Frame", -10,-10 } }, 
      str = TEXT{"cancel"},
      OnClick = function(this)
        this:GetParent():Hide()
        net.GLAutoMatchCanceled()
      end,
    },
    
    
    OnShow = function(this) 
      this:RegisterEvent("AUTOFINDGAME_SEARCHINGPLAYERS_CHANGED") 
      this:RegisterEvent("GL_EXIT") 
      this:RegisterEvent("MAP_LOADED")
      this:RegisterEvent("AUTOFINDGAME_PLAYERSCHANGED")
      this:RegisterEvent("AUTOFINDGAME_PLAYERLOGOCHANGED")
      --this:RegisterEvent("GL_HIDEPLAYERSVIEW")
      
      for i = 1,6 do
        this["Player"..i].Title:SetStr("")
        this["Logo"..i]:SetType(1)
      end
      
      this.Player2:Hide()
      this.Player3:Hide()
      this.Player5:Hide()
      this.Player6:Hide()

      this.Logo2:Hide()
      this.Logo3:Hide()
      this.Logo5:Hide()
      this.Logo6:Hide()

      
      local maptype = net.GLGetGameType()
      local maxplayers = net.GLGetMaxPlayers()
      
      --local gametype = "Random, "
      local gametype = TEXT("dmmeters_rnd")..", "
      if maptype == "pvpat" then 
        --gametype = "Arranged, "
        gametype = TEXT("dmmeters_arn")..", "
      end
      
      local players = TEXT("1v1")
      
      if maxplayers == 4 then
        players = TEXT("2v2")
        this.Player2:Show()
        this.Player5:Show()
        this.Logo2:Show()
        this.Logo5:Show()
      elseif maxplayers == 6 then
        players = TEXT("3v3")
        
        this.Player2:Show()
        this.Player5:Show()
        this.Player3:Show()
        this.Player6:Show()
        this.Logo2:Show()
        this.Logo5:Show()
        this.Logo3:Show()
        this.Logo6:Show()
      end
      
      this.ViewTitle.Text:SetStr("<p>"..TEXT("pvp_caps").." ("..gametype..players..")")
              
    end,
    
    OnHide = function(this)
      this:UnregisterEvent("AUTOFINDGAME_SEARCHINGPLAYERS_CHANGED") 
    end,
    
    OnEvent = function(this, event)
      if event == "GL_EXIT" or event == "MAP_LOADED" then
        if this:IsHidden() then return end
        this:Hide()
        return
      end
    
      if event == "AUTOFINDGAME_SEARCHINGPLAYERS_CHANGED" then
        --this.WaitingText:SetStr("<p>"..TEXT{"dm_players"}.." ("..argPlayers..")")
        --this.DMStats.SearchingNum:SetStr(argPlayers)
      
        if argPlayers[1][1] ~= -1 then
          this.searchingplayers1 = argPlayers[1][1]
        end
        if argPlayers[2][1] ~= -1 then
          this.searchingplayers2 = argPlayers[2][1]
        end
        if argPlayers[3][1] ~= -1 then
          this.searchingplayers3 = argPlayers[3][1]
        end
      
        if argPlayers[2][2] ~= -1 then
          this.searchingplayers4 = argPlayers[2][2]
        end
        if argPlayers[3][2] ~= -1 then
          this.searchingplayers5 = argPlayers[3][2]     
        end        
        
        local pl = this.searchingplayers1 + this.searchingplayers2 + this.searchingplayers3 + this.searchingplayers4 + this.searchingplayers5
        this.WaitingText:SetStr("<p>"..TEXT{"dm_players"}.." ("..pl..")")
        
        return
      end

      if event == "AUTOFINDGAME_PLAYERSCHANGED" then
        
        for i = 1,6 do
          this["Player"..i].Title:SetStr(TEXT("dm_search"))
          this["Player"..i].Title:SetColor({141, 141, 141, 255})
          this["Logo"..i]:SetType(1, nil)
        end
        
        local idx1 = 1
        local idx2 = 1
        for name,team in pairs(argPlayers) do
          if team == 1 then
            this["Player"..idx1].Title:SetStr(name)
            this["Player"..idx1].Title:SetColor({255, 143, 51, 255})
            idx1 = idx1 + 1
          end
          
          if team == 2 then
            this["Player"..(idx2+3)].Title:SetStr(name)
            this["Player"..(idx2+3)].Title:SetColor({255, 143, 51, 255})
            idx2 = idx2 + 1
          end
        end
        return
      end
      
      if event == "AUTOFINDGAME_PLAYERLOGOCHANGED" then
        
        for i = 1,6 do
          if this["Player"..i].Title:GetStr() == argData.name then
            this["Logo"..i]:SetType(4, argData.userlogo)
            return
          end
        end        
        return
      end
    end,
	},

}

--
-- Lobby
--

function Lobby:Reset()
  UserContacts.FriendsList.Listbox:SetList({})
  LobbyChat:ClearChat()
  LobbyChat:ClearUsers()
  Lobby.SpecialLocView.ListGames.Listbox.list = nil
  Lobby.PracticeView.ListGames.Listbox.list = nil
end

function Lobby:OnLoad()
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("GL_INCORRECTVERSION")
  this:RegisterEvent("GL_GAMEISINPROGRESS")
  this:RegisterEvent("GL_WRONGPASSWORD")
  this:RegisterEvent("GL_GAMEFULL")
  this:RegisterEvent("GL_TIMEDOUT")
  this:RegisterEvent("GL_CANNOTESTABLISHCONNECTION")
  this:RegisterEvent("GL_SHOWLOBBY")
  this:RegisterEvent("GL_GAMEFAILED")
  this:RegisterEvent("GS_DISCONNECTED")
  this:RegisterEvent("GS_QRERROR")
  this:RegisterEvent("UPDATE_FOUND")
  this:RegisterEvent("INSPECT_NOTALLOWED")
  this:RegisterEvent("GL_INVITEONLYGAME")
end

function Lobby:OnShow()
  PauseWnd:Hide()
  this.UpdateBtn:Hide()
  this.ExitBtn:Show()
  Transitions:Fade(EnterLobby)
  
  game.EnterLobby()
  
  if net.GLIsGameSpyLobby() then
    this.PVPBtn:Show()
    this.PracticeBtn:SetStr(TEXT{"prac_caps"})
    this.PracticeBtn:SetAnchor("LEFT", this.PVPBtn, "RIGHT",  {2,0})
    this.PracticeBtn.OnMouseEnter = function(this) NTTooltip:DoShow("practice_btn_tip", this, "BOTTOM", "TOP", {0,10}) end
    this.PracticeBtn.OnMouseLeave = function(this) NTTooltip:Hide() end
    this.Gamespy:Show()
  else
    this.PVPBtn:Hide()
    this.PracticeBtn:SetStr(TEXT{"skirmish"})
    this.PracticeBtn:SetAnchor("LEFT", this.SLocationBtn, "RIGHT",  {2,0})
    this.PracticeBtn.OnMouseEnter = function(this) NTTooltip:DoShow("skirmish_btn_tip", this, "BOTTOM", "TOP", {0,10}) end
    this.PracticeBtn.OnMouseLeave = function(this) NTTooltip:Hide() end
    this.Gamespy:Hide()
  end
  
  -- chat stuff
  -- load user views data
  UserContacts.ChatStuff.ChannelsSetup.data = {}
  for i = 1,CHAT_VIEWS do
    local data = game.LoadUserPrefs("LobbyChatView_"..i)
    if not data then
      data = {}
      data.game = 1
      data.tells = 1
      data.general = 1
      data.default = 1
      for c = 1,6 do
        data["userch_"..c] = 0
      end
    end
    UserContacts.ChatStuff.ChannelsSetup.data[i] = data
  end
  -- load user channels
  UserContacts.ChatStuff.ChannelsSetup.userchannels = game.LoadUserPrefs("LobbyUserChannels")
  if not UserContacts.ChatStuff.ChannelsSetup.userchannels then
    UserContacts.ChatStuff.ChannelsSetup.userchannels = {}
    for i = 1,6 do
      UserContacts.ChatStuff.ChannelsSetup.userchannels["userch_"..i] = TEXT_UNASSIGNEDKEY
    end  
  end
  -- load channel colors
  local clrs = game.LoadUserPrefs("ChatChanelColors")
  for k,v in pairs(UserContacts.ChatStuff.ChannelsSetup) do
    if type(v) == "table" and v.channel_color then
      --v.channel_color = colors.white
      if clrs then
        v.channel_color = clrs[v:GetName()]
      end
      if not v.channel_color or not v.channel_color[1] then
        v.channel_color = colors.white
      end
    end
  end
  -- load channel shortkeys
  local keys = game.LoadUserPrefs("ChatChanelShortkeys")
  for k,v in pairs(UserContacts.ChatStuff.ChannelsSetup) do
    if type(v) == "table" and v.Shortcut then
      if keys then
        v.shortcutkey = keys[v:GetName()]
      end  
    end
  end
  
  LobbyChat:Show()

  this.Version:SetStr(Login.Version:GetStr())

  -- create logo if not exist
  local tbl = game.LoadUserPrefs("player_logo")
  if not tbl then
    tbl = {}
    tbl.back_clr = {0,23,150,255}
    tbl.gradient_row = 1
    tbl.gradient_col = 1
    tbl.gradient_clr = {0,0,0,255}
    tbl.frame_row = 1
    tbl.frame_col = 1
    tbl.frame_clr = {0,0,0,255}
    tbl.symbol_row = math.random(1,3)
    tbl.symbol_col = math.random(1,6)
    tbl.symbol_clr = {255,198,0,255}
    game.SaveUserPrefs("player_logo", tbl)
  end

  -- default player settings
  local ps = game.LoadUserPrefs("PlayerSettings")
  if not ps then 
    ps = {}
    ps.ignore_invits = 0
    ps.friends_invits = 0
    --ps.allow_inspected = 1
    game.SaveUserPrefs("PlayerSettings", ps)
  end
end

function Lobby:OnHide()
  LinkItemTooltip:Hide()
  if not Invitation:IsHidden() then
    Invitation.Decline:OnClick()
  end
  PlayerInfo:Hide()
end

function Lobby:Leave()
  Settings:Hide()
  Stats:Hide()
  this.ExitBtn:Hide()
  Transitions:Fade(nil, BlackScreen, leaveLobby)
end

function Lobby:OnLeave()
  Lobby:Hide()
  LobbyChat:Hide()
  TechGrid:Hide()
  Settings:Hide()
  Stats:Hide()
  UserContacts:Hide()
  if Lobby.currview then
    Lobby.currview:Hide()
    Lobby.currview = nil
  end
  Lobby.PlayersView:Hide()
  Lobby.AutoPlayersView:Hide()
end

function Lobby:OnEvent(event)
  if event == "GL_INVITEONLYGAME" then
    MessageBox:Alert(TEXT("privategame_msg"))
    return
  end
  
  if event == "INSPECT_NOTALLOWED" then
    MessageBox:Alert(TEXT("inspect_forbidden_txt"), TEXT("inspect_forbidden_ttl"))
    return
  end

  if event == "UPDATE_FOUND" then
    LobbyChat:AddLine(nil, nil, TEXT{"update_found"})
    if this.UpdateBtn:IsHidden() then
      Transitions:Fade(nil, this.UpdateBtn, nil, 0.5)
    else
      Transitions:Fade(this.UpdateBtn, nil, function() Transitions:Fade(nil, this.UpdateBtn, nil) end)
    end
  end
  
  if event == "GS_QRERROR" then
    if argError then
      MessageBox:Alert(TEXT{argError}, TEXT{"gamespy_ttl"})  
    end
    return
  end
  
  if event == "GS_DISCONNECTED" then
    local LaterCall = function() 
      Lobby:Leave()
    end
    
    if argReason then
      MessageBox:Alert(TEXT{"gs_disconnect", argReason}, TEXT{"gamespy_ttl"})  
    end
    
    Transitions:CallOnce(LaterCall, 0)
    return
  end
  
  if event == "GL_GAMEFAILED" then
    if argError then
      LobbyChat:AddLine(nil, nil, TEXT{argError, argPlayer})
    end
  end
  
  if event == "GL_SHOWLOBBY" then
    if argShow ~= nil and not argShow then
      if this.currview then
        Lobby.currview:Hide()
      end       
      this.currview = nil

      TechGrid:Hide()
      Settings:Hide()
      UserContacts:Hide()
      this:Hide()
    else 
      this:Show()
    end
  end
  
  if event == "MAP_LOADED" then
    Lobby:OnLeave()
    this:Hide()
  end
  
  if event == "GL_INCORRECTVERSION" then
    MessageBox:Alert(TEXT{"differs from the server"}, TEXT{"version conflict"})
    return
  end

  if event == "GL_WRONGPASSWORD" then
    MessageBox:Alert(TEXT{"incorrect password"}, TEXT{"error joining"})
    return
  end

  if event == "GL_GAMEFULL" then
    MessageBox:Alert(TEXT{"the game is full"}, TEXT{"error joining"})
    return
  end

  if event == "GL_CANNOTESTABLISHCONNECTION" then
    MessageBox:Alert(TEXT{"lobby_error_cannotestablishconnection"}, TEXT{"error joining"})
    return
  end
  
  if event == "GL_GAMEISINPROGRESS" then
    MessageBox:Alert(TEXT{"lobby_error_gameisinprogress"}, TEXT{"error joining"})
    return
  end
  
 
end

function Lobby:OnRightButton(btn)
  if this.rcurrbtn then
    this.rcurrbtn.checked = 0
    this.rcurrbtn:updatetextures()
  end
  this.rcurrbtn = btn
  this.rcurrbtn.checked = 1
  this.rcurrbtn:updatetextures()
end

function Lobby:OnLobbyBtnClicked(btn)
  --Lobby.PlayersView:Hide()
  --Lobby.AutoPlayersView:Hide()

  local view
  if btn == this.MissionsBtn then
    view = this.MissionsView 
    net.ExitLobby()
  elseif btn == this.SLocationBtn then
    local splocations = game.LoadUserData("SpecialLocations")
    if not splocations then
      MessageBox:Alert(TEXT_NO_SP_LOCATIONS, TEXT{"special locations"})
      return
    end
    view = this.SpecialLocView
    net.ExitLobby()
  elseif btn == this.PVPBtn then
    view = this.AutoPlayersView
    this.AutoPlayersView.creategame = this.AutoPlayersView:IsHidden()
    net.ExitLobby()
  elseif btn == this.PracticeBtn then
    view = this.PracticeView 
    net.ExitLobby()
  elseif btn == this.AbilityBtn then
    this:OnRightButton(btn)
    Settings:Hide()
    UserContacts:Hide()
    Stats:Hide()
    if TechGrid:IsHidden() then
      TechGrid:SetAnchor("TOPRIGHT", this, "TOPRIGHT", {-10, 60 })
      TechGrid:Show()
    else
      TechGrid:Hide()
    end
    return
  elseif btn == this.FriendsBtn then
    this:OnRightButton(btn)
    Settings:Hide()
    TechGrid:Hide()
    Stats:Hide()
    if UserContacts:IsHidden() then
      UserContacts:Show()
    else
      UserContacts:Hide()
    end
    return
  elseif btn == this.SettingsBtn then
    this:OnRightButton(btn)
    TechGrid:Hide()
    UserContacts:Hide()
    Stats:Hide()
    if Settings:IsHidden() then
      Settings:Show()
    else
      Settings:Hide()
    end
    return
  elseif btn == this.StatsBtn then
    this:OnRightButton(btn)
    TechGrid:Hide()
    UserContacts:Hide()
    Settings:Hide()
    if Stats:IsHidden() then
      Stats:Show()
    else
      Stats:Hide()
    end
    return
  end
  
  if this.lcurrbtn then
    this.lcurrbtn.checked = 0
    this.lcurrbtn:updatetextures()
  end

  if this.currview then
    this.currview:Hide()
    if view == this.currview then 
      this.currview = nil
      return    
    end  
  end
  
  this.lcurrbtn = btn
  this.lcurrbtn.checked = 1
  this.lcurrbtn:updatetextures()

  this.currview = view
  this.currview:Show()
end

function Lobby:StartMission(map)
  if map == "missions/11" then
    local file = "campaign_intro_" .. game.GetLang() .. ".bm"
    if Login.openbeta then 
      file = "data/movies/campaign_intro.bm" 
    else
      local q = game.GetMoviePreferredQuality()
      if q and q == 1 then
        file = "data/movies/hi/" .. file
      else
        file = "data/movies/" .. file
      end
    end
    MovieFS:Play(file, function() BlackScreen:Show() net.StartGame("mission", map) end, true)
    return
  end
  BlackScreen:Show()
  net.StartGame("mission", map)
end

--
-- Lobby.Missions
--

function Lobby.MissionsView:OnShow()
  this:LoadList()
  
  local selindex
  for i,v in ipairs(this.ListBox.list) do
    if v.state ~= "disabled" then
      selindex = i
    end
  end
  if selindex then this.ListBox:OnListClicked(selindex) end
end

function Lobby.MissionsView:OnHide()
  Lobby.MissionsBtn.checked = 0
  Lobby.MissionsBtn:updatetextures()
end

function Lobby.MissionsView:LoadList()
  local lst = game.LoadUserData("Missions")
  for i,v in ipairs(lst) do
    v.title = game.GetMapTitle(v.map)
  end
  this.ListBox:SetList(lst)
end

function Lobby.MissionsView:OnSelectMission(data)
  local info = game.GetLocationInfo(data.map) if not info then return end
  this.Info.Title.text:SetStr(info.title)
  
  if data.state == "disabled" then
    local fname = "data/textures/ui/maps/locked.bmp"
    this.Info.Image.Pic:SetTexture(fname)
    this.Info.Description:SetStr(TEXT{"locked_mission"})
    this.Info.StartBtn.map = nil
    this.Info.StartBtn:Hide()
    this.Info.Image.Completed:Hide()
    this.Info.Image.Time:Hide()
    this.Info.RewardsTitle:Hide()
    this.Info.Rew_1:Hide()
    this.Info.Rew_2:Hide()
    this.Info.Rew_3:Hide()
  else
    game.LoadMissionRewards(data.map)
    local fname = "data/textures/ui/maps/"..data.map..".bmp"
    this.Info.Image.Pic:SetTexture(fname) 
    this.Info.Description:SetStr("<p>" .. info.descr)
    this.Info.StartBtn.map = data.map
    this.Info.RewardsTitle:Show()
    this.Info.Rew_1:Show()
    this.Info.Rew_2:Show()
    this.Info.Rew_3:Show()
    if data.state == "open" then
      this.Info.StartBtn:SetStr(TEXT{"start"})
      this.Info.StartBtn:Show()
      this.Info.Image.Completed:Hide()
      this.Info.Image.Time:Hide()
    else
      this.Info.StartBtn:SetStr(TEXT{"replay"})
      this.Info.StartBtn:Show()
      this.Info.Image.Completed:Show()
      this.Info.Image.Time:Show()
    end
  end
  
  this.ClickToViewInfo:Hide()
  this.Info:Show()
end

--
-- Lobby.Practice
--

function Lobby.PracticeView:OnShow()
  this.ListGames.Listbox:Reset()

  net.BrowseGames()

  this:RegisterEvent("GAMEADDED")
  this:RegisterEvent("GAMEREMOVED")
  this:RegisterEvent("GAMEUPDATED")
  this:RegisterEvent("GL_EXIT")
  
  if not this.filter then
    this:OnFilterChanged(this.Setup.All)
  else  
    this:OnFilterChanged(this.filter)
  end
  this:UpdateQuickJoin()
end

function Lobby.PracticeView:OnHide()
  Lobby.PracticeBtn.checked = 0
  Lobby.PracticeBtn:updatetextures()
end

function Lobby.PracticeView.ListGames:OnListItemDoubleClicked(list)
  Lobby.PracticeView:OnJoinGameGame()
end

function Lobby.PracticeView.ListGames:OnSortClicked(sort)
  if sort == this.Ping then
  elseif sort == this.count then
  else -- this.name
  end
end

function Lobby.PracticeView:OnEvent(event)
  if event == "GL_EXIT" and not this:IsHidden() then
    Transitions:CallOnce(net.BrowseGames)
  end

  if event == "GAMEADDED" and argGame.type == "practice" then
    this:AddGame(argGame)
    this:UpdateQuickJoin()
  elseif event == "GAMEUPDATED" and argGame.type == "practice" then
    local idx = this:GetGame(argGame.id)
    if idx then
      this.ListGames.Listbox.list[idx] = argGame
      sortbytypegames(this.ListGames.Listbox.list)
      this.ListGames.Listbox:UpdateList()
    end
    this:UpdateQuickJoin()
  elseif event == "GAMEREMOVED" then
    this:DelGame(argGameID)
    this:UpdateQuickJoin()
  end
end

function Lobby.PracticeView:OnFilterChanged(btn)
  if Login.demo then
    if this.filter and btn ~= this.Setup.Plrs_1 then
      MessageBox:Alert(TEXT("demo_1v1"))
    end
    btn = this.Setup.Plrs_1
  end

  if this.filter then
    this.filter:SetSelected(false)
  end
  this.filter = btn
  this.filter:SetSelected(true)

  this.players_count = 6
  if this.Setup.Plrs_1.selected then 
    this.players_count = 2 
  end
  if this.Setup.Plrs_2.selected or this.Setup.Small.selected then
    this.players_count = 4
  end

  if not this.ListGames.Listbox.list then return end
  for i,v in ipairs(this.ListGames.Listbox.list) do
    v.hidden = true
    if this.Setup.Plrs_1.selected then
      if v.maxPlayers == 2 then v.hidden = nil end  
    elseif this.Setup.Plrs_2.selected then
      if v.maxPlayers == 4 then v.hidden = nil end  
    elseif this.Setup.Plrs_3.selected then
      if v.maxPlayers == 6 then v.hidden = nil end  
    elseif this.Setup.Small.selected then
      if v.maxPlayers <= 4 then v.hidden = nil end    
    elseif this.Setup.Big.selected then
      if v.maxPlayers >= 4 then v.hidden = nil end    
    else
      v.hidden = nil
    end
  end
  this.ListGames.Listbox:UpdateList()
end

function Lobby.PracticeView:OnTemplateChanged(listbox, idx)
  this.idx_selected = idx
  this.zonetemplate = listbox.list[idx].template
  this.zonename = listbox.list[idx].name
  local picture = this.zonetemplate
  if this.zonetemplate == "RANDOM" then
    picture = listbox.list[2].template
  end
  local fname = "data/textures/ui/maps/"..picture.."_small.bmp"
  this.Setup.TemplateImage:SetTexture(fname)
end

function Lobby.PracticeView:OnCreateGame(private)
  if this.zonetemplate == "RANDOM" then
    if Login.demo then
      this.idx_selected = math.random(8, 9)
    else
      this.idx_selected = math.random(2, #this.Setup.Template.Listbox.list)
    end
    this.zonetemplate = this.Setup.Template.Listbox.list[this.idx_selected].template
    this.zonename = this.Setup.Template.Listbox.list[this.idx_selected].name
  end
  Lobby.PlayersView.Template.Button.selected = this.idx_selected-1

  local last_clr = -1
  local tmp = game.LoadUserPrefs("last_color")
  if tmp and tmp.index then
    last_clr = tmp.index
  end

  local last_race = -1
  local tmp = game.LoadUserPrefs("last_race")
  if tmp and tmp.index then
    last_race = tmp.index
  end
  net.CreateGame("practice", gamename, this.zonetemplate, 6, last_race, last_clr, private)
end

function Lobby.PracticeView:UpdateQuickJoin()
  if not this.ListGames.Listbox.list then
    this.Setup.QuickJoin:Disable(true)
    return 
  end
  local games = 0
  for i,v in ipairs(this.ListGames.Listbox.list) do
  	if not v.hidden and not v.playing and v.version == Lobby.version then
      games = games + 1 
    end
  end
  if games == 0 then
    this.Setup.QuickJoin:Disable(true)
  else
    this.Setup.QuickJoin:Disable(false)
  end
end

function Lobby.PracticeView:OnQuickJoin()
  if not this.ListGames.Listbox.list then return end
  local games = 0
  for i,v in ipairs(this.ListGames.Listbox.list) do
  	if not v.hidden and not v.playing and v.version == Lobby.version then
      games = games + 1 
    end
  end
  if games == 0 then return end
  local rnd_idx = math.random(1, games)
  net.JoinGame(this.ListGames.Listbox.list[rnd_idx].id)
end

function Lobby.PracticeView:GetGame(gameid)
	if not this.ListGames.Listbox.list then return end
  for i,v in ipairs(this.ListGames.Listbox.list) do
  	if v.id == gameid then return i end
  end
end

--argGame -> id, name, ping, players, maxPlayers, location, zone, version
function Lobby.PracticeView:AddGame(game)
  if this:GetGame(game.id) then return end

  game.hidden = true
  if this.Setup.Plrs_1.selected then
    if game.maxPlayers == 2 then game.hidden = nil end  
  elseif this.Setup.Plrs_2.selected then
    if game.maxPlayers == 4 then game.hidden = nil end  
  elseif this.Setup.Plrs_3.selected then
    if game.maxPlayers == 6 then game.hidden = nil end  
  elseif this.Setup.Small.selected then
    if game.maxPlayers <= 4 then game.hidden = nil end    
  elseif this.Setup.Big.selected then
    if game.maxPlayers >= 4 then game.hidden = nil end    
  else
    game.hidden = nil
  end

  if not this.ListGames.Listbox.ScrollArea.Slot1 then
    pingwidth = this.ListGames.Ping:GetSize().x - 10
    countwidth = this.ListGames.Count:GetSize().x - 10
    gamenamewidth = this.ListGames.Name:GetSize().x - 10
    
    local tbl = {} table.insert(tbl, game)
    this.ListGames.Listbox:SetList(tbl, 20, CreateListGamesSlot)
  else
    if not this.ListGames.Listbox.list then this.ListGames.Listbox.list = {} end
    table.insert(this.ListGames.Listbox.list, game)
    sortbytypegames(this.ListGames.Listbox.list)
    local max = #this.ListGames.Listbox.list - this.ListGames.Listbox.rows + 1
    if max < 1 then max = 1 end
    this.ListGames.Listbox.Scrollbar:SetMinMaxRange(1, max)
    this.ListGames.Listbox:UpdateList()
  end  

end 

function Lobby.PracticeView:DelGame(gameid)
  local i = this:GetGame(gameid) if not i then return end

  table.remove(this.ListGames.Listbox.list, i)

  local max = #this.ListGames.Listbox.list - this.ListGames.Listbox.rows + 1
  if max < 1 then max = 1 end
  this.ListGames.Listbox.Scrollbar:SetMinMaxRange(1, max)
  this.ListGames.Listbox:UpdateList()
end

function Lobby.PracticeView:OnJoinGameGame()
  local idx, data = this.ListGames.Listbox:GetNextSelected()
  if data and data.id then
    net.JoinGame(data.id)
  end  
end


--
-- Lobby.SpecialLocView
--

function Lobby.SpecialLocView:OnShow()
  this.ListGames.Listbox:Reset()

  net.BrowseGames()

  this:RegisterEvent("GAMEADDED")
  this:RegisterEvent("GAMEREMOVED")
  this:RegisterEvent("GAMEUPDATED")
  
  this:RegisterEvent("GL_EXIT")
  this:UpdateQuickJoin()
end

function Lobby.SpecialLocView:OnHide()
  Lobby.SLocationBtn.checked = 0
  Lobby.SLocationBtn:updatetextures()
end

function Lobby.SpecialLocView.ListGames:OnListItemDoubleClicked(list)
  Lobby.SpecialLocView:OnJoinGameGame()
end

function Lobby.SpecialLocView.ListGames:OnSortClicked(sort)
  if sort == this.Ping then
  elseif sort == this.count then
  else -- this.name
  end
end

function Lobby.SpecialLocView:OnEvent(event)
  if event == "GL_EXIT" and not this:IsHidden() then
    Transitions:CallOnce(net.BrowseGames)
  end

  if event == "GAMEADDED" and argGame.type == "speciallocation" then
    this:AddGame(argGame)
    this:UpdateQuickJoin()
  elseif event == "GAMEUPDATED" and argGame.type == "speciallocation" then
    local idx = this:GetGame(argGame.id)
    if idx then
      this.ListGames.Listbox.list[idx] = argGame
      sortbytypegames(this.ListGames.Listbox.list)
      this.ListGames.Listbox:UpdateList()
    end
    this:UpdateQuickJoin()
  elseif event == "GAMEREMOVED" then
    this:DelGame(argGameID)
    this:UpdateQuickJoin()
  end
end

function Lobby.SpecialLocView:OnTemplateChanged(listbox, idx)
  this.idx_selected = idx
  this.zonetemplate = listbox.list[idx].map
  this.zonetitle = listbox.list[idx].title
  this.num_players = listbox.list[idx].num_players
  local fname = "data/textures/ui/maps/"..this.zonetemplate.."_small.bmp"
  this.Setup.TemplateImage:SetTexture(fname)
end

function Lobby.SpecialLocView:OnCreateGame(private)
  Lobby.PlayersView.Template.Button.selected = this.idx_selected

  local last_clr = -1
  local tmp = game.LoadUserPrefs("last_color")
  if tmp and tmp.index then
    last_clr = tmp.index
  end

  local last_race = -1
  local tmp = game.LoadUserPrefs("last_race")
  if tmp and tmp.index then
    last_race = tmp.index
  end

  net.CreateGame("speciallocation", gamename, this.zonetemplate, this.num_players, last_race, last_clr, private)
end

function Lobby.SpecialLocView:UpdateQuickJoin()
  if not this.ListGames.Listbox.list then
    this.Setup.QuickJoin:Disable(true)
    return 
  end
  local games = 0
  for i,v in ipairs(this.ListGames.Listbox.list) do
  	if not v.hidden and not v.playing and v.version == Lobby.version then
      games = games + 1 
    end
  end
  if games == 0 then
    this.Setup.QuickJoin:Disable(true)
  else
    this.Setup.QuickJoin:Disable(false)
  end
end

function Lobby.SpecialLocView:OnQuickJoin()
  if not this.ListGames.Listbox.list then return end
  local games = 0
  for i,v in ipairs(this.ListGames.Listbox.list) do
  	if not v.hidden and not v.playing and v.version == Lobby.version then
      games = games + 1 
    end
  end
  if games == 0 then return end
  local rnd_idx = math.random(1, games)
  net.JoinGame(this.ListGames.Listbox.list[rnd_idx].id)
end

function Lobby.SpecialLocView:GetGame(gameid)
	if not this.ListGames.Listbox.list then return end
  for i,v in ipairs(this.ListGames.Listbox.list) do
  	if v.id == gameid then return i end
  end
end

-- argGame -> id, name, ping, players, maxPlayers, location, zone, type, version
function Lobby.SpecialLocView:AddGame(tblgame)
  local splocations = game.LoadUserData("SpecialLocations")
  if not splocations then return end

  if not tblgame.playing then
    local finded = false
    for i,v in ipairs(splocations) do
      if v.map == tblgame.zone then
        finded = true
        break
      end
    end

    if not finded or this:GetGame(tblgame.id) then return end
  end
  
  if not this.ListGames.Listbox.ScrollArea.Slot1 then
    pingwidth = this.ListGames.Ping:GetSize().x - 10
    countwidth = this.ListGames.Count:GetSize().x - 10
    gamenamewidth = this.ListGames.Name:GetSize().x - 10
    
    local tbl = {} table.insert(tbl, tblgame)
    this.ListGames.Listbox:SetList(tbl, 20, CreateListGamesSlot)
  else
    if not this.ListGames.Listbox.list then this.ListGames.Listbox.list = {} end
    table.insert(this.ListGames.Listbox.list, tblgame)
    sortbytypegames(this.ListGames.Listbox.list)
    local max = #this.ListGames.Listbox.list - this.ListGames.Listbox.rows + 1
    if max < 1 then max = 1 end
    this.ListGames.Listbox.Scrollbar:SetMinMaxRange(1, max)
    this.ListGames.Listbox:UpdateList()
  end  
end 

function Lobby.SpecialLocView:DelGame(gameid)
  local i = this:GetGame(gameid) if not i then return end

  table.remove(this.ListGames.Listbox.list, i)

  local max = #this.ListGames.Listbox.list - this.ListGames.Listbox.rows + 1
  if max < 1 then max = 1 end
  this.ListGames.Listbox.Scrollbar:SetMinMaxRange(1, max)
  this.ListGames.Listbox:UpdateList()
end

function Lobby.SpecialLocView:OnJoinGameGame()
  local idx, data = this.ListGames.Listbox:GetNextSelected()
  if data and data.id then
    net.JoinGame(data.id)
  end  
end


--
-- Lobby.AutoPlayersView
--

function Lobby.AutoPlayersView:OnLoad()
  this:RegisterEvent("GL_EXIT")
  this:RegisterEvent("GL_SLOTCHANGED")
  this:RegisterEvent("GL_SHOWSTARTBUTTON")
  this:RegisterEvent("GL_GAMECHANGED")
  this:RegisterEvent("GL_HIDEPLAYERSVIEW")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("AUTOFINDGAME_INPROGRESS")
end

function Lobby.AutoPlayersView:OnShow()
  PlayerColorMenu:SetList(PlayerColors)
  PlayerColorMenu:Reset()
  
  this.Plrs_1:SetSelected(false)
  this.Plrs_1:Disable(false)
  this.Plrs_2:SetSelected(false)
  this.Plrs_2:Disable(false)
  this.Plrs_3:SetSelected(false)
  this.Plrs_3:Disable(false)
  this.Template:Disable(false)
  
  if this.players then
    this.players:SetSelected(false)
  end

  if this.creategame then
    this.creategame = nil
    
    local plrs = 3
    this.players = this["Plrs_"..plrs]
    this.gametype = "pvp"
    
    -- temporary code !
    local idx = math.random(1, #this.Template.Listbox.list)
    this.zonetemplate = this.Template.Listbox.list[idx].template

    this.gamename = net.Lobby_GetPlayerName()

    local last_clr = -1
    local tmp = game.LoadUserPrefs("last_color")
    if tmp and tmp.index then
      last_clr = tmp.index
    end

    local last_race = -1
    local tmp = game.LoadUserPrefs("last_race")
    if tmp and tmp.index then
      last_race = tmp.index
    end

    net.CreateGame(this.gametype, this.gamename, this.zonetemplate, this.players.count, last_race, last_clr)
    net.GLSetPVPPlayers(1)    
  end
  
  this:UpdateSlotStates()
end

function Lobby.AutoPlayersView:OnHide()
  Lobby.PVPBtn.checked = 0
  Lobby.PVPBtn:updatetextures()
  ShoppingUnits:Hide()
end

function Lobby.AutoPlayersView:OnEvent(event)
  if event == "AUTOFINDGAME_INPROGRESS" then
    Lobby.AutoPlayersView:Hide()
    Lobby.DeathMatchSearchView:Show()
    return
  end

  if event == "GL_EXIT" or event == "GL_HIDEPLAYERSVIEW" or event == "MAP_LOADED" then
    if this:IsHidden() then return end
    if Lobby.currview then
      Lobby.currview:Hide()
    end       
    Lobby.currview = nil
    this:Hide()
    return
  end

  if event == "GL_SHOWSTARTBUTTON" then
    if this:IsHidden() then return end
    if argShow then
      this.Start.enabled = true
      this.Start:SetAlpha(1)
      this.Start.NormalImage:SetShader()
      this.Start.HighImage:SetShader()
      this.Start.PushImage:SetShader()
      this.Start:Show()
    else
      this.Start.enabled = nil
      this.Start:SetAlpha(0.5)
      this.Start.NormalImage:SetShader("_Misc_InterfaceDrawBW")
      this.Start.HighImage:SetShader("_Misc_InterfaceDrawBW")
      this.Start.PushImage:SetShader("_Misc_InterfaceDrawBW")
      this.Start:Show()
    end
    this:UpdateButtonStates()
    return
  end
  
  if event == "GL_GAMECHANGED" then
    if this:IsHidden() then return end
    --argGameData - >tablica
    --mapname, zonename, gamename, gametype, pvpplayers -> fieldove v tablicata
    if argGameData.pvpplayers then
      local btn = this["Plrs_"..argGameData.pvpplayers]
      if this.players then
        this.players:SetSelected(false)
      end
      this.players = btn
      this.players:SetSelected(true)
      this:UpdateSlotStates()
    end
    if argGameData.gametype then
      this.gametype = argGameData.gametype
      this.Gametype:Set(argGameData.gametype)
      this:UpdateSlotStates()
    end
    if argGameData.zonename and this.Template.Listbox.list then
      for i = 1,#this.Template.Listbox.list do
        local l1 
        l1 = this.Template.Listbox.list[i].template
        if string.lower(l1) == string.lower(argGameData.zonename) then
          this.Template.Listbox:OnListClicked(i)
        end
      end
    end
  end

  if event == "GL_SLOTCHANGED" then
    if this:IsHidden() then 
      local gametype = net.GLGetGameType()
      if not gametype or not net.GLIsStaging() or (gametype ~= "pvp" and gametype ~= "pvpat") then
        return
      end
      if Lobby.currview then
        Lobby.currview:Hide()
      end       
      Lobby.currview = this
      this:Show()
      --return 
    end
    
    if not argData then return end

    local slot = this["Slot_"..argData.slot]
    if not slot or not slot.GetState then return end
    
    local state = slot:GetState() 
    local newstate = { id = state.id, type = state.type }
    
    if argData.id then
      newstate.id = argData.id
    end
      
    if argData.localplayer then
      newstate.type = "myslot"
    elseif argData.type then
      newstate.type = argData.type
    end  
    
    -- reset state if slot type is changed
    local slotchanged = false

    if state.id ~= newstate.id or state.type ~= newstate.type then 
      state = newstate 
      slotchanged = true
    end

    if argData.userprefsnil then 
      state.unitskey = nil
      state.units = nil 
      slotchanged = true
    end

    if argData.name then state.name = argData.name end
    if argData.color then state.color = argData.color end
    if argData.race then state.race = argData.race end
    if argData.ready ~= nil then state.ready = argData.ready end
    if argData.userprefskey ~= nil then state.unitskey = argData.userprefskey end
    if argData.userprefs ~= nil then state.units = argData.userprefs end
    if argData.userlogo ~= nil then state.userlogo = argData.userlogo end

    slot:SetState(state)

    if not ShoppingUnits:IsHidden() and ShoppingUnits.slot == slot and slotchanged then
      ShoppingUnits:Hide()  
    end
    this:UpdateButtonStates()
  end
end

function Lobby.AutoPlayersView:UpdateButtonStates()
  this.Template:Hide()

  if not this.players then return end
  if not net.GLIsHost() or net.GLIsPlayerReady() then
    this.Template:Disable(true)
    this.Plrs_1:Disable(true)
    this.Plrs_2:Disable(true)
    this.Plrs_3:Disable(true)
    this.Gametype:Disable(true)
    return
  end
  
  this.Template:Disable(false)
  
  local hplayers = 0
  for i = 1,3 do 
    local slot = this["Slot_"..i]
    if slot.type == "player" or slot.type == "myslot" then 
      hplayers = hplayers + 1 
    end
  end
  
  for i = 1,3 do
    local slot = this["Plrs_"..i]
    if slot.count < hplayers then 
      slot:Disable(true)
    else
      slot:Disable(false)
    end
  end
  
  if hplayers > 1 then
    this.Gametype:Disable(true)
  elseif this.players.count == 1 then
    this.Gametype:Disable(true)
  else  
    this.Gametype:Disable(false)
  end
  
end

function Lobby.AutoPlayersView:UpdateSlotStates()
  if not this.players then return end
  
  if this.gametype == "pvpat" then -- team
    for i = 1,3 do
      local slot = this["Slot_"..i]
      if slot.type ~= "player" and slot.type ~= "myslot" then
        if i > this.players.count then
          net.GLSetSlotType(slot.id or -1, slot.index, "closed")    
        else
          net.GLSetSlotType(slot.id or -1, slot.index, "open")    
        end
      end
    end
  else  -- random
    for i = 1,3 do
      local slot = this["Slot_"..i]
      if slot.type ~= "player" and slot.type ~= "myslot" then
        if i > this.players.count then
          net.GLSetSlotType(slot.id or -1, slot.index, "closed")    
        else
          net.GLSetSlotType(slot.id or -1, slot.index, "random")    
        end
      end
    end
  end  
  this:UpdateButtonStates()
end

function Lobby.AutoPlayersView:OnChangePlayersCount(btn)
  net.GLSetPVPPlayers(btn.count)
end

function Lobby.AutoPlayersView:OnChangeGameType(btn)
  if this.gametype == "pvp" then
    net.GLSetGameType("pvpat")
    btn:SetSelected(true)
  else
    net.GLSetGameType("pvp")
    btn:SetSelected(false)
  end 
end

function Lobby.AutoPlayersView:OnChangeTemplate(listbox, idx)
  idx = 1
  this.zonetemplate = listbox.list[idx].template
  --temporary code !
  --net.GLSetGameZoneName(this.zonetemplate)
  local fname = "data/textures/ui/maps/"..this.zonetemplate..".bmp"
  this.TemplateImage:SetTexture(fname)
end

function Lobby.AutoPlayersView:OnStartGameBtn()
  --Lobby:OnLeave()
  --StartingGame.Text:SetStr(StartStr)
  --StartingGame:Show()
  net.GLStartGame()
end

function Lobby.AutoPlayersView:OnLeaveGameBtn()
  net.ExitLobby()
end

function Lobby.AutoPlayersView:OnUnitsShopping(slot)
  if not ShoppingUnits:IsHidden() and ShoppingUnits.slot == slot then
    ShoppingUnits.slot = nil
    ShoppingUnits:Hide()
    return
  end
  
  ShoppingUnits:SetAnchor("TOPLEFT", this.Slot_1, "TOPRIGHT", {10,0})
  
  ShoppingUnits:Set(slot)
  ShoppingUnits:Show()
end

--
-- Lobby players
--

function Lobby.PlayersView:OnLoad()
  this:RegisterEvent("GL_EXIT")
  this:RegisterEvent("GL_SLOTCHANGED")
  this:RegisterEvent("GL_SHOWSTARTBUTTON")
  this:RegisterEvent("GL_GAMECHANGED")
  this:RegisterEvent("GL_HIDEPLAYERSVIEW")
end

function Lobby.PlayersView:OnHide()
  ShoppingUnits:Hide()
end

function Lobby.PlayersView:OnEvent(event)
  if event == "GL_HIDEPLAYERSVIEW" then
    if Lobby.currview then
      Lobby.currview:Hide()
    end       
    Lobby.currview = nil
    this:Hide()
    return
  end

  if event == "GL_EXIT" and not this:IsHidden() then
    this:Hide()
    if this.clickonhide then
      Lobby:OnLobbyBtnClicked(this.clickonhide)
    end
  end
  
  if event == "GL_SHOWSTARTBUTTON" then
    if this:IsHidden() then return end

    local nteam1 = 0
    for i = 1,3 do
      local slot = this["Slot_"..i]
      if slot.type == "player" or slot.type == "myslot" or slot.type == "ai" then 
        nteam1 = nteam1 + 1 
      end
    end

    local nteam2 = 0
    for i = 4,6 do
      local slot = this["Slot_"..i]
      if slot.type == "player" or slot.type == "myslot" or slot.type == "ai" then 
        nteam2 = nteam2 + 1 
      end
    end
    
    local gametype = net.GLGetGameType()
    if gametype == "speciallocation" then
      nteam2 = 1
      nteam1 = nteam1 - 1
    end

    if argShow and nteam1 > 0 or nteam2 > 0 then
      this.Start.enabled = true
      this.Start:SetAlpha(1)
      this.Start.NormalImage:SetShader()
      this.Start.HighImage:SetShader()
      this.Start.PushImage:SetShader()
      this.Start:Show()
    else
      this.Start.enabled = nil
      this.Start:SetAlpha(0.5)
      this.Start.NormalImage:SetShader("_Misc_InterfaceDrawBW")
      this.Start.HighImage:SetShader("_Misc_InterfaceDrawBW")
      this.Start.PushImage:SetShader("_Misc_InterfaceDrawBW")
      this.Start:Show()
    end

    this:UpdateButtonStates()
  end
  
  if event == "GL_GAMECHANGED" then
    if this:IsHidden() then return end
    --argGameData - >tablica
    --mapname, zonename, gamename -> fieldove v tablicata
    local zonename = argGameData.zonename
    local gamename = argGameData.gamename
    local gamevisibility = argGameData.gamevisibility

    if gamevisibility ~= nil then
      this.HideGame:Set(not gamevisibility)
    end
    if gamename then
      this.GameTitle.Edit:SetStr(gamename)
    end
    if zonename and this.Template.Listbox.list then
      for i = 1,#this.Template.Listbox.list do
        local l1 
        local gametype = net.GLGetGameType()
        if gametype == "speciallocation" then
          l1 = this.Template.Listbox.list[i].map
        elseif gametype == "practice" then
          l1 = this.Template.Listbox.list[i].template
        end
        if l1 and string.lower(l1) == string.lower(zonename) then
          this.Template.Listbox:OnListClicked(i)
        end
      end
    end
  end

  if event == "GL_SLOTCHANGED" then
    local gametype = net.GLGetGameType()
    if not gametype or gametype == "pvp" or gametype == "pvpat" then
      return
    end
    if this:IsHidden() then
      for i = 1,6 do this["Slot_"..i]:SetState({type = "open"}) end

      if gametype == "mission" then return end
      if gametype == "speciallocation" then
        this.Team1:SetStr(TEXT("team")) this.Team1:Show()
        this.Team2:Hide()

        local num_players = net.GLGetMaxPlayers() or 3
        this.Template.Listbox.GetItemText = function(listbox, idx) 
          return listbox.list[idx].title 
        end
        this.Template.Listbox.UpdateItem = function(listbox, item, data)
          item.data = data
          item:SetStr(data.title)
          if item.data and item.data.disabled then
            item.disabled = true
            item.NormalText:SetColor(listbox.dcolor)
            item.HighText:SetColor(listbox.dcolor)
            item.PushText:SetColor(listbox.dcolor)
            return
          end
          item.disabled = nil
          if listbox.selected_item == data then
            item.NormalText:SetColor(listbox.scolor)
            item.HighText:SetColor(listbox.scolor)
            item.PushText:SetColor(listbox.scolor)
          else  
            item.NormalText:SetColor(listbox.ncolor)
            item.HighText:SetColor(listbox.hcolor)
            item.PushText:SetColor(listbox.pcolor)
          end
        end
        this.Template.InitCombo = function(template)
          local splocations = game.LoadUserData("SpecialLocations")
          if splocations and #splocations then
            for i,v in ipairs(splocations) do
              v.title = game.GetMapTitle(v.map)
              v.num_players = game.GetMapNumPlayers(v.map)
            end
            for i = 1,#splocations do
              if not splocations[i].num_players or splocations[i].num_players > num_players then
                splocations[i].disabled = true
              else
                splocations[i].disabled = nil
              end
            end
            template.Listbox:SetList(splocations)
            this.Template:Show()
          else
            this.Template:Hide()
          end  
        end
        for i = 1,6 do
          if i > num_players then
            this["Slot_"..i]:Hide()
          else
            this["Slot_"..i]:Show()
          end  
        end
        this.ViewTitle.Text:SetStr(TEXT{"special location"})
      elseif gametype == "practice" then
        this.Team1:SetStr(TEXT("team").."<color=255,143,51> 1</>") this.Team1:Show()
        this.Team2:Show()

        this.Template.Listbox.GetItemText = function(listbox, idx) 
          return listbox.list[idx].name 
        end
        this.Template.Listbox.UpdateItem = function(listbox, item, data)
          item.data = data
          item:SetStr(data.name)
          if item.data and item.data.disabled then
            item.disabled = true
            item.NormalText:SetColor(listbox.dcolor)
            item.HighText:SetColor(listbox.dcolor)
            item.PushText:SetColor(listbox.dcolor)
            return
          end
          item.disabled = nil
          if listbox.selected_item == data then
            item.NormalText:SetColor(listbox.scolor)
            item.HighText:SetColor(listbox.scolor)
            item.PushText:SetColor(listbox.scolor)
          else  
            item.NormalText:SetColor(listbox.ncolor)
            item.HighText:SetColor(listbox.hcolor)
            item.PushText:SetColor(listbox.pcolor)
          end
        end
        this.Template.InitCombo = function(template)
          local templates = game.EnumMapTemplates()
          if Login.demo then
            local cnt = #templates
            for i = 1,cnt do
              if i ~= 7 and i ~= 8 then
                templates[i].disabled = true
              end
            end
          end
          template.Listbox:SetList(templates)
        end
        this.Template.OnDisabledClick = function(template, idx)
          if Login.demo then
            MessageBox:Alert(TEXT("demo_practice"))  
            template.Listbox:Hide()
            Modal:Hide()
          end
        end
        
        for i = 1,6 do this["Slot_"..i]:Show() end
        
		    if Lobby.PracticeView.players_count then
	        for i,v in ipairs{this.Slot_1, this.Slot_4, this.Slot_2, this.Slot_5, this.Slot_3, this.Slot_6} do
	          if i > Lobby.PracticeView.players_count then
	            net.GLSetSlotType(-1, v.index, "closed")
	          end
	        end
        end
        this.ViewTitle.Text:SetStr(TEXT{"practice"})
      end
      
      if Lobby.currview then
        Lobby.currview:Hide()
      end       
      
      Lobby.currview = nil
      this:Show()
    end  
    
    -- players view
    local slot = this["Slot_"..argData.slot]
    local state = slot:GetState()
    local newstate = { id = state.id, type = state.type }
    
    if argData.id then
      newstate.id = argData.id
    end
      
    if argData.localplayer then
      newstate.type = "myslot"
    else
      if argData.type == "aieasy" then
        newstate.type = "ai"
        newstate.ai = 1
      elseif argData.type == "aihard" then
        newstate.type = "ai"
        newstate.ai = 2
      elseif argData.type then
        newstate.type = argData.type
      end
    end  
    
    -- reset state if slot type is changed
    local slotchanged = false

    if state.id ~= newstate.id or state.type ~= newstate.type then 
      state = newstate 
      slotchanged = true
    end

    if argData.userprefsnil then 
      state.unitskey = nil
      state.units = nil 
      slotchanged = true
    end

    if argData.name then state.name = argData.name end
    if argData.color then state.color = argData.color end
    if argData.race then state.race = argData.race end
    if argData.ready ~= nil then state.ready = argData.ready end
    if argData.slotchangeindicator ~= nil then state.swapindicator = argData.slotchangeindicator end
    if argData.userprefskey ~= nil then state.unitskey = argData.userprefskey end
    if argData.userprefs ~= nil then state.units = argData.userprefs end
    if argData.userlogo ~= nil then state.userlogo = argData.userlogo end
    
    slot:SetState(state)

    if not ShoppingUnits:IsHidden() and ShoppingUnits.slot == slot and slotchanged then
      ShoppingUnits:Hide()  
    end
    this:UpdateButtonStates()
  end
end

function Lobby.PlayersView:OnShow()
  PlayerColorMenu:SetList(PlayerColors)
  PlayerColorMenu:Reset()
  this.clickonhide = nil
  LobbyChat:SetWriteChannel("game")
end

function Lobby.PlayersView:OnHide()
  if LobbyChat.writechannel == TEXT_CHANNELS["game"] then
    LobbyChat:SetWriteChannel("default")
  end
end

function Lobby.PlayersView:OnHideGame(hidegame)
  net.GLSetGameVisibility(hidegame)
end

function Lobby.PlayersView:UpdateButtonStates()
  local gametype = net.GLGetGameType()
  if gametype == "speciallocation" or not net.GLIsHost() or net.GLIsPlayerReady()then
    --this.GameTitle.Edit:SetReadOnly(true)
    this.Template:Disable(true)
    if gametype == "speciallocation" then
      this.Template:Hide()
    end
    return
  end
  --this.GameTitle.Edit:SetReadOnly(false)
  this.Template:Disable(false)
  this.Template:Show()
end

function Lobby.PlayersView:OnTemplateChanged(listbox, idx)
  if listbox.list[idx].template then
    this.zonetemplate = listbox.list[idx].template
  else
    this.zonetemplate = listbox.list[idx].map
  end  
  
  --net.GLSetGameZoneName(this.zonetemplate)
  
  local fname = "data/textures/ui/maps/"..this.zonetemplate..".bmp"
  this.TemplateImage:SetTexture(fname)

  local gamename
  if listbox.list[idx].name then
    gamename = TEXT{"s game: ", net.Lobby_GetPlayerName()}..listbox.list[idx].name
  else
    gamename = TEXT{"s game: ", net.Lobby_GetPlayerName()}..listbox.list[idx].title
  end
  this.GameTitle.Edit:SetStr(gamename)
  net.GLSetGameName(gamename)
end

function Lobby.PlayersView:OnRaceChanged(slot, race)
  net.GLSetPlayerRace(slot.id, race)
end

function Lobby.PlayersView:OnColorChanged(slot, color)
  net.GLSetPlayerColor(slot.id, color)
end

function Lobby.PlayersView:OnReadyChanged(slot, ready)
  net.GLSetPlayerReady(slot.id, ready)
end

function Lobby.PlayersView:OnSwapRequest(slot, wonnaswap)
  net.GLRequestSlotChange(slot.id, 0, wonnaswap)
end

function Lobby.PlayersView:OnSwapWith(slot)
  net.GLRequestSlotChange(-1, slot.id, true)
end

function Lobby.PlayersView:OnInviteRequest(slot, player)
  net.SendGameInvitation(player, 3, slot.index)
  LobbyChat:AddLine(nil, nil, TEXT{"invitation_sent", player})
end

function Lobby.PlayersView:OnKickPlayer(slot)
  net.GLSetSlotType(slot.id or -1, slot.index, "open")
end

function Lobby.PlayersView:OnAITypeChanged(slot, type)
  local aitype = "aieasy"
  if type == 2 then aitype = "aihard" end  
  net.GLSetSlotType(slot.id or -1, slot.index, aitype)
end

function Lobby.PlayersView:OnSlotTypeChanged(slot, type)
  local settype
  if type == 1 then
    settype = "open"    
  elseif type == 2 then
    settype = "aieasy"
    if slot.Name.type == 2 then settype = "aihard" end  
  elseif type == 3 then
    settype = "closed"
  end
  net.GLSetSlotType(slot.id or -1, slot.index, settype)
end

function Lobby.PlayersView:OnGameNameChanged(gamename)
  net.GLSetGameName(gamename)
end

function Lobby.PlayersView:OnUnitsShopping(slot)
  if not ShoppingUnits:IsHidden() and ShoppingUnits.slot == slot then
    ShoppingUnits.slot = nil
    ShoppingUnits:Hide()
    return
  end
  
  if slot.index < 4 then
    ShoppingUnits:SetAnchor("TOPLEFT", this.Slot_1, "TOPRIGHT", {10,0})
  else  
    ShoppingUnits:SetAnchor("TOPRIGHT", this.Slot_4, "TOPLEFT", {-10,0})
  end
  
  ShoppingUnits:Set(slot)
  ShoppingUnits:Show()
end

function Lobby.PlayersView:OnStartGameBtn()
  Lobby:OnLeave()
  StartingGame.Text:SetStr(StartStr)
  StartingGame:Show()
  net.GLStartGame()
end

function Lobby.PlayersView:OnLeaveGameBtn()
  local gametype = net.GLGetGameType()
  if gametype == "speciallocation" then
    this.clickonhide = Lobby.SLocationBtn
  elseif gametype == "practice" then
    this.clickonhide = Lobby.PracticeBtn
  end  
  net.ExitLobby()
end

--
-- Invitation
--

Invitation = uiwnd {
  hidden = true,
  size = {300,150},
  layer = modallayer + 1,
  
  Back = DefSmallBackImage {},
  
  Title = uitext {
    size = {1,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51}, 
    anchors = { TOPLEFT = { 0,2 }, TOPRIGHT = { 0,2 } },
    str = TEXT{"invitation_ttl"},
  },
  
  Text = uitext {
    font = "Verdana,10",
    layer = "+1",
    color = {230, 230, 230},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Title", 0,0 }, BOTTOMRIGHT = { 0,-35 } },
  },
  
  Accept = DefButton {
    size = {120,25},
    layer = "+1",
    str = TEXT{"accept"},
    anchors = { BOTTOMLEFT = { 10,-10 } },
    OnClick = function(this)
      net.AcceptGameInvitation(this:GetParent().player, true)
      Invitation:Hide()
    end,
  },
  
  Decline = DefButton {
    size = {120,25},
    layer = "+1",
    str = TEXT{"decline"},
    anchors = { BOTTOMRIGHT = { -10,-10 } },
    OnClick = function(this)
      net.AcceptGameInvitation(this:GetParent().player, false)
      Invitation:Hide()
    end,
  },

  OnLoad = function(this)
    this:RegisterEvent("GAMEINVITATION")
    this:RegisterEvent("GAMEINVITATION_ACCEPTED")
  end,
  
  OnEvent = function(this, event)
    -- argPlayer, argErr
    if event == "GAMEINVITATION" then
      if not argErr then
        local ps = game.LoadUserPrefs("PlayerSettings")
        if ps and ps.ignore_invits and ps.ignore_invits == 1 then
          local player = argPlayer
          local delayedcall = function()
            net.AcceptGameInvitation(player, false)
          end
          Transitions:CallOnce(delayedcall, 0.1)
          return
        end
         
        if ps and ps.friends_invits and ps.friends_invits == 1 and not net.BuddyList_IsBuddy(argPlayer) then 
          local player = argPlayer
          local delayedcall = function()
            net.AcceptGameInvitation(player, false)
          end
          Transitions:CallOnce(delayedcall, 0.1)
          return
        end

        this.player = argPlayer
        this.Title:SetStr(TEXT{"invitation_ttl"})
        
        if argType and argType == 1 then 
          this.Text:SetStr(TEXT{"invitation_msg_ally", argPlayer})
        elseif argType and argType == 2 then 
          this.Text:SetStr(TEXT{"invitation_msg_opponent", argPlayer})
        else 
          this.Text:SetStr(TEXT{"invitation_msg", argPlayer})
        end          
        
        this:Show()
        game.PlaySnd("data/speech/advisor/invited.wav")
      else
        this:Hide()
        LobbyChat:AddLine(nil, nil, TEXT{"invitation_invalid", argPlayer})
      end
    end
    -- argPlayer, argErr
    if event == "GAMEINVITATION_ACCEPTED" then
      if argErr then
        LobbyChat:AddLine(nil, nil, TEXT{"invitation_declined", argPlayer})
      else
        LobbyChat:AddLine(nil, nil, TEXT{"invitation_accepted", argPlayer})
      end
    end
  end,
}
