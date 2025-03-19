local moviesPlayed

TitleImage = uiwnd {
  size = {200,65},
  anchors = { TOPLEFT = {} },
  
  OnLoad = function(this)
    this:RegisterEvent("MAP_LOADED") 
    this:RegisterEvent("EARTH_LOADED")
  end,

  OnEvent = function(this, event)
    if (event == "MAP_LOADED") then this:Hide() else this:Show() end
  end
}

EnterLobby = uiwnd {
  hidden = true,
  size = { 200, 90 },
  layer = 1000,

  DefFrameImage { size = { 200, 90 } },
  
  Text = uitext {
    font = "Agency FB,25",
    str = TEXT{"entering lobby"}
  },
  
  StatusText = uitext {
    size = {400, 30},
    str = "status",
    anchors = { TOP = { "BOTTOM", "Text", 0, 0 } },
  },
}

local loginlayer = 40

Login = uiwnd {
  keyboard = true,
  Title = uiimg {
    size = {953,266},
    anchors = { TOP = { 0,30 } },
    texture = "data/textures/ui/game_title.bmp",
    texture_auto_coords = true,
  },

  QuitBtn = DefButton {
    size = {220,30},
    str = TEXT{"exit to desktop"},
    anchors = { BOTTOMRIGHT = { -80, -100 } }
  },

  CreditsBtn = DefButton {
    size = {220,30},
    str = TEXT{"credits"},
    anchors = { BOTTOM = { "TOP", "QuitBtn", 0, -80 } },
  },

  SettingsBtn = DefButton {
    size = {220,30},
    str = TEXT{"settings"},
    anchors = { BOTTOM = { "TOP", "CreditsBtn", 0, -20 } }
  },

  IntroBtn = DefButton {
    size = {220,30},
    str = TEXT{"replay intro"},
    anchors = { BOTTOM = { "TOP", "SettingsBtn", 0, -20 } },
    OnClick = function(this)
      local q = Login.openbeta and 0 or game.GetMoviePreferredQuality()
      if q and q == 1 then
        MovieFS:Play("data/movies/hi/game_intro.bm")
      else
        MovieFS:Play("data/movies/game_intro.bm")
      end
    end,
  },

  Version = uitext {
    size = {200,20},
    font = "Arial,8",
    anchors = { BOTTOMRIGHT = {-4,0} },
    halign = "RIGHT",
    str = "[#].[#].[#] Community Patch" -- major, minor, sub, build
  },
  
  BSSLogo = uiimg {
    size = {60,53},
    texture = "data/textures/ui/logo_bss.dds",
    coords = {0,0,60,53},
    anchors = { BOTTOMLEFT = {10,-10} },
  },

  BlackinkLogo = uiimg {
    size = {40,48},
    texture = "data/textures/ui/logo_blackinc.dds",
    coords = {0,0,40,48},
    anchors = { LEFT = { "RIGHT", "BSSLogo", 10,0} },
  },

  NvidiaLogo = uiimg {
    size = {72,34},
    texture = "data/textures/ui/logo_nvidia.dds",
    coords = {0,0,72,34},
    anchors = { LEFT = { "RIGHT", "BlackinkLogo", 10,0} },
  },

  PlaylogicLogo = uiimg {
    size = {80,64},
    texture = "data/textures/ui/logo_playlogic.dds",
    coords = {0,0,96,76},
    anchors = { BOTTOMLEFT = {10,-10} },
    anchors = { LEFT = { "RIGHT", "GamespyLogo", 10,0} },
  },

  LegalText = uitext {
    size = {400,100},
    font = "Arial,8",
    halign = "LEFT",
    valign = "BOTTOM",
    color = {130,130,130},
    shadow_ofs = {1,1},
    anchors = { BOTTOMLEFT = { "TOPLEFT", "BSSLogo", 0,-20 } },
    str = "<p>"..TEXT{"legal_text"},
  },
}

function Login:OnLoad()
  this:RegisterEvent("EARTH_LOADED")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("EARTH_CLOSED")
  this:SetMode(this.LanBtn)
  this.Version:SetStrVals{game.GetVersion()};   
  this.Version:SetStr(this.Version:GetStr() .. " ("..game.GetLang().."-"..game.GetDistro()..")")
  if game.GetLang() == "it" or game.GetLang() == "es" then
    this.BlackinkLogo:SetSize{50,25}
    this.BlackinkLogo:SetTexture("data/textures/ui/logo_fx.dds", {0,0,64,32})
  end
  this.QuitBtn.OnClick = function() game.Quit() end
  this.SettingsBtn.OnClick = function() Settings:Show() end
  this.CreditsBtn.OnClick = function() this:Hide() Credits:Show() game.MapBaseToScreen(true) end
end

function Login:SetMode()
  this.mode = "LAN"
  NETLogin.NameEdit:SetMaxChars(14)
end

function Login:OnShow()
  Transitions:CallOnce(function() Lobby.version = net.GLGetVersion() end, 0.1)
  TitleImage:Show()
  NETLogin:Show()
end 

function Login:OnHide()
  TitleImage:Hide()
  NETLogin:Hide()
end

function Login:ShowLobby()
  Transitions:Fade(Login, Lobby)
  if shift then Lobby:ShowMaps() end		
end

function Login:OnEvent(event)
  if event == "EARTH_LOADED" then
    if this.skipshow then return end
    this:Show()
  end
  if event == "EARTH_CLOSED" or event == "MAP_LOADED" then
    this:Hide()
  end
end

--
-- NET login
--

local wsl_w = 382
local wsl_h1 = 200
local wsl_h2 = 160

NETLogin = uiwnd {
  hidden = true,
  size = {wsl_w, wsl_h1},
  layer = loginlayer,
  
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

  Title = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { "Frame", 0,3 } },
    str = TEXT{"net_login"},
  },

  NameTitle = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    halign = "LEFT",
    anchors = { TOPLEFT = { "Frame", 10,35 } },
    str = TEXT{"net_enter_player_name"}..":",
  },

  NameEdit = uiedit {
    size = {300,23},
    maxchars = 20,
    layer = "+1",
    uiimg { 
      layer = "-1", 
      size = {309,23}, 
      texture = "data/textures/ui/login_field_back.dds", 
      coords = {0,0,309,23},
      anchors = { CENTER = {-3,2} },
    },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "NameTitle", 5, 5 } },
    OnKeyEnter = function(this) this:RemoveFocus() end,
    OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) 
      if key == "Tab" then this:GetParent().PSWEdit:SetFocus() end 
      if key == "C+Tab" then Login:ToggleMode() end 
    end,
    allowed_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
  },

  ComboAccounts = DefCombobox {
    size = {300+40,130},
    btn_height = 21,
    customanchored = true,
    layer = loginlayer + 2,
    anchors = { TOPLEFT = { "TOPLEFT", "NameEdit", -7,0 } },

    Button = DefCombobox.Button { 
      size = {29,21}, 
      
      NormalImage = uiimg { texture = "data/textures/ui/login_dropdown_button.dds", coords = {0,0,29,21} },
      HighImage = uiimg { texture = "data/textures/ui/login_dropdown_button.dds", coords = {0,21,29,21} },
      PushImage = uiimg { texture = "data/textures/ui/login_dropdown_button.dds", coords = {0,21,29,21} },
      
      NormalText = uitext { hidden = true },
      HighText = uitext { hidden = true },
      PushText = uitext { hidden = true },
      anchors = { TOPRIGHT = { 0,3 } },
    },
    
    Listbox = DefCombobox.Listbox {
      textjustify = "LEFT",
      layer = loginlayer + 10,
      anchors = { TOPLEFT = { 0,25 }, BOTTOMRIGHT = {0,0} },

      font = "Verdana,10",
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
      
      GetItemText = function(this, idx) return this.list[idx].name end,
      
      UpdateItem = function(this, item, data)
        item.data = data
        item:SetStr(data.name)
      end,
    },

    InitCombo = function(this)
      local all_accounts = game.EnumPlayerAccounts()
      local accounts = {}
      for i,v in ipairs(all_accounts) do
        if (v.localtype and Login.mode == "LAN") or (not v.localtype and Login.mode == "INTERNET") then
          table.insert(accounts, v)
        end
      end
      this.Listbox:SetList(accounts)
    end,
    
    OnItemSelected = function(listbox, idx)
      NETLogin.NameEdit:SetStr(listbox.list[idx].name)
    end,
  },

  EnterGameBtn = DefButton { 
    size = {150,25},
    str = TEXT{"enter game"},
    anchors = { BOTTOMLEFT = { "BOTTOM", "Frame", 20, -15 } },
    OnClick = function(this) 
      NETLogin:EnterGame() 
    end,
    
    OnMouseEnter = function(this) NTTooltip:DoShow("enter_game_tip", this, "BOTTOM", "TOP", {0,40}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  EnterGame = function(this)
    Login.name = this.NameEdit:GetStr() if not Login.name then return end
    LobbyChat.Area.Text:SetStr()
    EnterLobby:Show()
    EnterLobby.StatusText:Hide()

    local shift = false
    local ctrl = false
    if argMods then shift = argMods.shift ctrl = argMods.ctrl end
    local LaterCall = function()
      Login:Hide()
      Lobby:Reset()
 
      local name, avatar, plocal = game.GetPlayerInfo()
      if Login.mode == "LAN" then
        if not game.LoginPlayer(Login.name, true) then
          local err = game.CreateNewProfile(Login.name, "", true)
          if err then
            Login:Show()
            EnterLobby:Hide()
            ErrMessage(err) 
            return
          end
        end
        local err = net.CreateLANLobby()
        if err then EnterLobby:Hide() Login:Show() ErrMessage(err) return end
      end
      Login:ShowLobby()      
    end
    Transitions:CallOnce(LaterCall)
  end,
}  

NETPlayerName = uiwnd {
  hidden = true,
  size = {wsl_w, 150},
  layer = loginlayer,
  
  Frame = DefSmallBackImage { layer = "-2" },

  Title = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { "Frame", 0,3 } },
    str = TEXT{"net_playername"},
  },

  NameTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    halign = "LEFT",
    anchors = { TOP = { "Frame", 10,35 } },
    str = TEXT{"net_enter_player_name"}..":",
  },

  NameEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 14,
    layer = "+1",
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "NameTitle", 5, 5 } },
    OnShow = function(this) this:SetFocus() end,
    OnKeyEnter = function(this) this:RemoveFocus() NETPlayerName.CreateBtn:OnClick() end,
    OnKeyEscape = function(this) this:RemoveFocus() end,
    allowed_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
  },
}

NETWorking = uiwnd {
  hidden = true,
  size = {wsl_w, 50},
  layer = loginlayer+50,
  
  Frame = DefFrameImage { layer = "-2" },

  Message = uitext {
    size = {wsl_w,50},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
  },
  
  OnShow = function(this)
    this.Message:SetStr("<p>"..this.message)
    local w = this:GetSize().x
    local h = this.Message:GetStrHeight()
    if h < 50 then h = 50 end
    this.Message:SetSize{w,h}
    this:SetSize{w,h}
  end,
  
  Set = function(this, message)
    this.message = message
    this:Show()
  end,
}  
