--Test = DefButton {
  --hidden = false,
  --anchors = { TOPLEFT = { } },
  --OnClick = function(this)
    --Login:Hide()
    --WaitingForPlayers:Show()
    --WaitingForPlayers:Set("Oleg", 10) 
    --WaitingForPlayers:Set("Boleg", 10) 
    --WaitingForPlayers:Set("Misho", 10) 
    --WaitingForPlayers:Set("Pisho", 10) 
    --WaitingForPlayers:Set("Ceco", 10) 
  --end,
--}
  
--
-- TitleImage
--
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


--
-- CD-KEY
--

CDKeyWnd = uiwnd {
  hidden = true,
  mouse = true,
  keyboard = true,
  layer = stripeslayer-5,
  
  Frame = DefSmallBackImage { 
    size = {382,200},
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
    size = {380,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { "Frame", 0,3 } },
    str = TEXT{"cdkey_validation"},
  },

  NameText = uitext {
    size = {200,25},
    halign = "LEFT",
    color = {255,255,255,255},
    anchors = { BOTTOMLEFT = { "TOPLEFT", "KeyEdit1", 0, -6 } },
    str = TEXT("enter cdkey"),
    layer = stripeslayer-4,
  },
  
  KeyEdit1 = uiedit {
    layer = stripeslayer-3,
    size = {60,23},
    maxchars = 4,
    uiimg { color = {0,0,0,190}, size = {70,23}, layer = stripeslayer-4 },
    anchors = { LEFT = { "Frame", 40,0 } },
    color = {255,255,255,255},
    autocaps = true,
    allowed_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    OnShow = function(this) this:SetFocus() end,
    OnKeyEnter = function(this) this:GetParent():ValidateKey() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().KeyEdit2:SetFocus() end end,
    OnKeyUp = function(this, key) 
      local s = this:GetStr()
      if key ~= "Tab" and s and string.len(s) == 4 then this:GetParent().KeyEdit2:SetFocus() end
    end,
  },
  
  KeyEdit2 = uiedit {
    layer = stripeslayer-3,
    size = {60,23},
    maxchars = 4,
    uiimg { color = {0,0,0,190}, size = {70,23}, layer = stripeslayer-4 },
    anchors = { LEFT = { "RIGHT", "KeyEdit1", 20,0 } },
    color = {255,255,255,255},
    autocaps = true,
    allowed_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    OnKeyEnter = function(this) this:GetParent():ValidateKey() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().KeyEdit3:SetFocus() end end,
    OnKeyUp = function(this, key) 
      local s = this:GetStr()
      if key ~= "Tab" and s and string.len(s) == 4 then this:GetParent().KeyEdit3:SetFocus() end
    end,
  },

  KeyEdit3 = uiedit {
    layer = stripeslayer-3,
    size = {60,23},
    maxchars = 4,
    uiimg { color = {0,0,0,190}, size = {70,23}, layer = stripeslayer-4 },
    anchors = { LEFT = { "RIGHT", "KeyEdit2", 20,0 } },
    color = {255,255,255,255},
    autocaps = true,
    allowed_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    OnKeyEnter = function(this) this:GetParent():ValidateKey() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().KeyEdit4:SetFocus() end end,
    OnKeyUp = function(this, key) 
      local s = this:GetStr()
      if key ~= "Tab" and s and string.len(s) == 4 then this:GetParent().KeyEdit4:SetFocus() end
    end,
  },

  KeyEdit4 = uiedit {
    layer = stripeslayer-3,
    size = {60,23},
    maxchars = 4,
    uiimg { color = {0,0,0,190}, size = {70,23}, layer = stripeslayer-4 },
    anchors = { LEFT = { "RIGHT", "KeyEdit3", 20,0 } },
    color = {255,255,255,255},
    autocaps = true,
    allowed_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    OnKeyEnter = function(this) this:GetParent():ValidateKey() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().KeyEdit1:SetFocus() end end,
  },

  ValidateBtn = DefButton { 
    size = {150,25},
    str = TEXT{"validate"},
    anchors = { BOTTOMLEFT = { "BOTTOM", "Frame", 20, -15 } },
    OnClick = function(this) this:GetParent():ValidateKey() end,
    layer = stripeslayer-4,
  },
  
  CancelBtn = DefButton { 
    size = {150,25},
    str = TEXT{"quit"},
    anchors = { BOTTOMRIGHT = { "BOTTOM", "Frame", -20, -15 } },
    OnClick = function(this) game.Quit() end,
    layer = stripeslayer-4,
  },
  
  OnShow = function(this)
    Login:Hide()
  end,
  
  ValidateKey = function(this)
    local k1 = this.KeyEdit1:GetStr() or " " this.KeyEdit1:RemoveFocus()
    local k2 = this.KeyEdit2:GetStr() or " " this.KeyEdit2:RemoveFocus()
    local k3 = this.KeyEdit3:GetStr() or " " this.KeyEdit3:RemoveFocus()
    local k4 = this.KeyEdit4:GetStr() or " " this.KeyEdit4:RemoveFocus()
    local key = k1.."-"..k2.."-"..k3.."-"..k4
    if game.ValidateCDKey(key) then
      Login:Show()
      this:Hide()
    else
      ErrMessage("cdkey_invalidkey", nil, function() this.KeyEdit1:SetFocus() end)
    end
  end,
}

--
-- AutoPatch
--

local progress = uiwnd {
  virtual = true,
	size = {338, 10},
	
	Back = uiimg { 
    layer = "-1", 
    size = {345, 16},
    texture = "data/textures/ui/patch_back.dds",
    coords = {0,0,345,16},
    anchors = { LEFT = { -4,0 } },
  },

	Left = uiimg { 
    size = {338,10},
    texture = "data/textures/ui/patch_fore.dds",
    coords = {0,0,338,10},
    anchors = { LEFT = { 0,0 } },
  },
	
  OnShow = function(this)
    this:Set(0)
  end,

  Set = function(this, val)
    if val < 0 then val = 0 end
    if val > 100 then val = 100 end
    local sz = this:GetSize()
    local x = sz.x * (val / 100)
    this.Left:SetSize{ x, sz.y }
    this.Left:SetTexture(nil, { 0, 0, x, sz.y } )
    this:Show()
  end,
}

AutoPatchWnd = uiwnd {
  hidden = true,
  mouse = true,
  keyboard = true,
  layer = stripeslayer-5,
  
  Frame = DefSmallBackImage { 
    size = {382,200},
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
    size = {380,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { "Frame", 0,3 } },
    str = TEXT{"ws_update"},
  },

  Progress = progress {
    anchors = { CENTER = { 0,-20 } },
  },

  ProgressText = uitext {
    size = {380,25},
    font = "Verdana,10b",
    color = {255,255,255,255},
    anchors = { TOP = { "BOTTOM", "Progress", 0,10 } },
    layer = stripeslayer-4,
    str = TEXT{"downloading"},
  },

  VerText = uitext {
    size = {180,25},
    font = "Verdana,10b",
    color = {255,255,255,255},
    anchors = { BOTTOM = { "TOP", "Progress", 0, -10 } },
    layer = stripeslayer-4,
    str = TEXT{"[#]"},
  },
  
  CancelBtn = DefButton { 
    size = {150,25},
    str = TEXT{"cancel"},
    anchors = { BOTTOM = { "Frame", 0,-15 } },
    OnClick = function(this) this:GetParent():Cancel() end,
    layer = stripeslayer-4,
  },
  
  OnLoad = function(this)
    this:RegisterEvent("GS_PATCHING_PROGRESS")
    this:RegisterEvent("GS_PATCHING_COMPLETED")
  end,
  
  OnShow = function(this)
    Login:Hide()
    local from, to = game.GetTargetPatchVersion()
    this.VerText:SetStr(TEXT{"[#] -> [#]", from, to})
  end,
  
  OnHide = function(this)
    Login:Show()
  end,

  Cancel = function(this)
    this:Hide()
    net.GSCancelPatch()
  end,
  
  Start = function(this)
    this:Show()
    net.GSGetPatch()
  end,
  
  OnEvent = function(this, event)
    if event == "GS_PATCHING_PROGRESS" then
      local perc = 0
      if argTotalBytes ~= -1 then
        perc = math.floor(100 * argBytes / argTotalBytes)
      end
      this.Progress:Set(perc)
      this.ProgressText:SetStr("<p>"..TEXT{"downloading"}..": ".."<color=255,143,51>"..perc.."%</>")
    end
    if event == "GS_PATCHING_COMPLETED" then
      this:Hide()
      if argErr then
        MessageBox:Alert(TEXT{argErr})
      else
        game.RunPatch()
      end
    end
  end,
}

--
-- Login
--

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
  
  OnLoad = function(this)
    this:RegisterEvent("GS_LOGIN_STATE_CHANGED")
  end,
  
  OnEvent = function(this, event)
    if event == "GS_LOGIN_STATE_CHANGED" then
      local s = TEXT(argState)
      this.StatusText:SetStr(s)
      this.StatusText:Show()
    end
  end,
}

local loginlayer = 40

Login = uiwnd {
  keyboard = true,
  --hidden = false,
  
  Title = uiimg {
    size = {953,266},
    anchors = { TOP = { 0,30 } },
    texture = "data/textures/ui/game_title.bmp",
    texture_auto_coords = true,
  },

  LanBtn = DefButton1 {
    str = TEXT{"lan"},
    anchors = { BOTTOMLEFT = { "TOPLEFT", "NETLogin", 0, -40 } },
    OnClick = function(this) 
      if Login.demo then 
        MessageBox:Alert(TEXT("demo_lan"))
      elseif Login.openbeta then 
        MessageBox:Alert("Disabled in BETA") 
      end
      Login:SetMode(this) 
    end,
    
    OnMouseEnter = function(this) NTTooltip:DoShow("lan_tip", this, "TOP", "BOTTOM", {0,-10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },

  InternetBtn = DefButton1 {
    str = TEXT{"internet"},
    anchors = { BOTTOMRIGHT = { "TOPRIGHT", "NETLogin", 0, -40 } },
    OnClick = function(this) Login:SetMode(this) end,
    
    OnMouseEnter = function(this) NTTooltip:DoShow("internet_tip", this, "TOP", "BOTTOM", {0,-10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
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
    str = "[#].[#].[#]" -- major, minor, sub, build
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

  GamespyLogo = uiimg {
    size = {85,25},
    texture = "data/textures/ui/logo_gamespy.dds",
    coords = {0,0,85,25},
    anchors = { BOTTOMLEFT = {10,-10} },
    anchors = { LEFT = { "RIGHT", "NvidiaLogo", 10,0} },
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

function Login:CheckCDKey()
  if game.GetDistro() ~= 503 then this.PlaylogicLogo:Hide() end
  if game.GetDistro() == 503 then this.LegalText:SetStr(TEXT{"legal_text_pl"}) end
  if Login.demo or game.IsCDKeyValid() then 
    if not NETLogin:IsHidden() then
      if Login.mode == "LAN" then
        NETLogin.NameEdit:SetFocus()
      else
        if NETLogin.NameEdit:GetStr() then
          NETLogin.PSWEdit:SetFocus()
        else
          NETLogin.NameEdit:SetFocus()
        end
      end  
    end
    return 
  end
  CDKeyWnd:Show()
end

function Login:OnLoad()
  this:RegisterEvent("EARTH_LOADED")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("EARTH_CLOSED")
  this:RegisterEvent("GS_LOGIN_FINISHED")

  this.Version:SetStrVals{game.GetVersion()};   
  if this.demo then
    this.Version:SetStr(this.Version:GetStr() .. " ("..game.GetLang().."-"..game.GetDistro()..") (DEMO)")
  elseif this.openbeta or this.devversion then
    this.Version:SetStr(this.Version:GetStr() .. " ("..game.GetLang().."-"..game.GetDistro()..") (BETA)")
  else
    this.Version:SetStr(this.Version:GetStr() .. " ("..game.GetLang().."-"..game.GetDistro()..")")
  end
  
  if game.GetLang() == "it" or game.GetLang() == "es" then
    this.BlackinkLogo:SetSize{50,25}
    this.BlackinkLogo:SetTexture("data/textures/ui/logo_fx.dds", {0,0,64,32})
  end
  
  this.QuitBtn.OnClick = function() game.Quit() end
  this.SettingsBtn.OnClick = function() Settings:Show() end
  this.CreditsBtn.OnClick = function() this:Hide() Credits:Show() game.MapBaseToScreen(true) end
  if this.demo then
    this.IntroBtn:Hide()
  end
end

function Login:ToggleMode(btn)
  if this.mode == "LAN" then
    this:SetMode(this.InternetBtn)
  else
    this:SetMode(this.LanBtn)
  end
end

function Login:SetMode(btn)
  if this.openbeta or this.nolan then btn = this.InternetBtn end
  if btn == this.LanBtn then
    this.mode = "LAN"
    this.LanBtn:Select(true)
    this.InternetBtn:Select(false)
    NETLogin.NameEdit:SetMaxChars(14)
  else
    this.mode = "INTERNET"
    this.LanBtn:Select(false)
    this.InternetBtn:Select(true)
    NETLogin.NameEdit:SetMaxChars(20)
  end
  NETLogin:updatemode()
end

function Login:OnShow()
  Transitions:CallOnce(function() Lobby.version = net.GLGetVersion() end, 0.1)

  TitleImage:Show()
  
  local name, avatar, plocal = game.GetPlayerInfo()
  if plocal then
    this:SetMode(this.LanBtn)
  else
    this:SetMode(this.InternetBtn)
  end
  NETLogin:Show()
end 
  --if disableMovies then
  --  if not moviesPlayed then
  --    moviesPlayed = true
  --    this:CheckCDKey()
  --  end
  --end
  --if not moviesPlayed then
  --  local pub1file = "blackinc.bm"
  --  local pub2file
  --  if game.GetLang() == "it" or game.GetLang() == "es" then pub1file = "fx.bm" end
  --  if game.GetDistro() == 503 then pub2file = "playlogic.bm" end
  --  local bsslogo = "data/movies/logos/bss.bm"
  --  local pub1logo = "data/movies/logos/" .. pub1file
  --  local pub2logo = pub2file and "data/movies/logos/" .. pub2file
  --  local nvidialogo = "data/movies/logos/nvidia.bm"
  --  local intro = "data/movies/game_intro.bm"
  --  local q = Login.openbeta and 0 or game.GetMoviePreferredQuality()
  --  local himovies = function()
  --    bsslogo = "data/movies/hi/logos/bss.bm"
  --    pub1logo = "data/movies/hi/logos/" .. pub1file
  --    pub2logo = pub2file and "data/movies/hi/logos/" .. pub2file
  --    nvidialogo = "data/movies/hi/logos/nvidia.bm"
  --    intro = "data/movies/hi/game_intro.bm"
  --  end
  --  if q and q == 1 then
  --    himovies()
  --  end
  --  local playAllMovies = function()
  --    if pub2logo then
  --      MovieFS:Play(bsslogo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --        MovieFS:Play(pub2logo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --          MovieFS:Play(pub1logo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --            MovieFS:Play(nvidialogo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --              if this.demo then moviesPlayed = true this:CheckCDKey() else MovieFS:Play(intro, function() moviesPlayed = true this:CheckCDKey() end) end end
  --            end) end
  --          end) end
  --        end) end
  --      end)
  --    else
  --      MovieFS:Play(bsslogo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --        MovieFS:Play(pub1logo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --          MovieFS:Play(nvidialogo, function(reason) if not moviesPlayed and reason ~= "escape" then
  --            if this.demo then moviesPlayed = true this:CheckCDKey() else MovieFS:Play(intro, function() moviesPlayed = true this:CheckCDKey() end) end end
  --          end) end
  --        end) end
  --      end)
  --    end
  --  end
  --  if q then
  --    playAllMovies()
  --  else
  --    MovieFS.unstoppable = true
  --    MovieFS:Play("data/movies/black_screen.bm", function() 
  --      if game.CalcMoviePreferredQuality() == 1 then
  --        himovies()
  --      end
  --      playAllMovies() end)
  --  end
  --end
  --if GameNews.unreadednews then
  --  GameNews:Show()
  --end
--end

function Login:OnHide()
  TitleImage:Hide()
  NETLogin:Hide()
  GameNews:Hide()
end

function Login:OnKeyDown(key)
  if key == "Escape" then moviesPlayed = true this:CheckCDKey() end
end

function Login:ShowLobby()
  Transitions:Fade(Login, Lobby)
  --Transitions:Fade(nil, BlackScreen, function() Login:Hide() Lobby:Show() Transitions:Fade(BlackScreen, nil, nil, TTIME) end)
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
  if event == "GS_LOGIN_FINISHED" then
    local err, url = argErr, argURL
    if err then 
      if err == "gs_patchfound" then
        EnterLobby:Hide() 
        MessageBox:Prompt(TEXT("gs_patchfound"), nil, function() AutoPatchWnd:Start() end)
        MessageBox.callback2 = function() Login:Show() end
      else
        EnterLobby:Hide() 
        ErrMessage(TEXT{err, url}, nil, function() NETLogin.PSWEdit:SetFocus() Login:Show() end) 
      end
      return
    end
    Login:ShowLobby()
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

  PSWTitle = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    halign = "LEFT",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "NameEdit", -5,10 } },
    str = TEXT{"net_enter_password"}..":",
  },

  PSWEdit = uiedit {
    size = {300,23},
    maxchars = 30,
    layer = loginlayer,
    password = true,
    uiimg { 
      layer = "-1", 
      size = {309,23}, 
      texture = "data/textures/ui/login_field_back.dds", 
      coords = {0,0,309,23},
      anchors = { CENTER = {-3,1} },
    },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "PSWTitle", 5, 5 } },
    OnKeyEnter = function(this) this:RemoveFocus() NETLogin.EnterGameBtn:OnClick() end,
    OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) 
      if key == "Tab" then this:GetParent().NameEdit:SetFocus() end 
      if key == "C+Tab" then Login:ToggleMode() end 
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
  
  NewPlayerBtn = DefButton { 
    size = {150,25},
    str = TEXT{"net_newplayer"},
    anchors = { BOTTOMRIGHT = { "BOTTOM", "Frame", -20, -15 } },
    OnClick = function(this)
      NETLogin:Hide()
      NETChooseGSAccount:Show()
    end,
    
    OnMouseEnter = function(this) NTTooltip:DoShow("new_player_tip", this, "BOTTOM", "TOP", {0,40}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
  
  OnShow = function(this)
    net.GSReleaseStaticProfilesData()
    this:updatemode()
    Login.InternetBtn:Show()
    Login.LanBtn:Show()
    if Login.nolan then
      Login.LanBtn:Hide()
      Login.InternetBtn:Hide()
    end
  end,

  OnHide = function(this)
    Login.InternetBtn:Hide()
    Login.LanBtn:Hide()
  end,

  updatemode = function(this)
    if Login.mode == "LAN" then
      this:SetSize{wsl_w, wsl_h2}
      this.PSWTitle:Hide()
      this.PSWEdit:Hide()
      this.NewPlayerBtn:Hide()
      this.NameEdit.OnKeyEnter = function(edit) edit:RemoveFocus() NETLogin.EnterGameBtn:OnClick() end
      if moviesPlayed then this.NameEdit:SetFocus() end
    else
      this:SetSize{wsl_w, wsl_h1}
      this.PSWTitle:Show()
      this.PSWEdit:Show()
      this.NewPlayerBtn:Show()
      this.NameEdit.OnKeyEnter = function(edit) edit:RemoveFocus() NETLogin.PSWEdit:SetFocus() end
    end
    this.ComboAccounts:InitCombo()
    this.ComboAccounts.Listbox:OnListClicked(1)
    if Login.mode ~= "LAN" then
      if moviesPlayed then 
        if this.NameEdit:GetStr() then
          this.PSWEdit:SetFocus() 
        else
          this.NameEdit:SetFocus() 
        end
      end
    end
  end,

  EnterGame = function(this)
    Login.name = this.NameEdit:GetStr() if not Login.name then return end
    Login.psw = this.PSWEdit:GetStr() if not Login.psw and Login.mode ~= "LAN" then return end
    this.PSWEdit:SetStr("")
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
      else  
        if game.LoginPlayer(Login.name, false) then
          net.CreateGSLobby(Login.name, Login.psw)
          return
        end
      end

      Login:ShowLobby()      
    end
    Transitions:CallOnce(LaterCall)
  end,
}  


--
-- NET choose gamespy account
--

NETChooseGSAccount = uiwnd {
  hidden = true,
  size = {wsl_w, 300},
  layer = loginlayer,
  
  Title = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,3 } },
    str = TEXT{"net_choosegsaccount"},
  },
  
  HelpText = uitext {
    size = {wsl_w-20,1},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,35 } },
    halign = "LEFT",
    valign = "TOP",
  },

  EMailTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    halign = "LEFT",
    anchors = { TOPLEFT = { "BOTTOMLEFT", "HelpText", 0,10 } },
    str = TEXT{"net_enter_email"}..":",
  },

  EMailEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 50,
    layer = "+1",
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "EMailTitle", 5, 5 } },
    OnShow = function(this) this:SetFocus() end,
    OnKeyEnter = function(this) this:RemoveFocus() NETChooseGSAccount.PSWEdit:SetFocus() end,
    OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().PSWEdit:SetFocus() end end,
  },

  PSWTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    halign = "LEFT",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "EMailEdit", -5,10 } },
    str = TEXT{"net_enter_password"}..":",
  },

  PSWEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 30,
    layer = loginlayer,
    password = true,
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "PSWTitle", 5, 5 } },
    OnKeyEnter = function(this) this:RemoveFocus() NETChooseGSAccount.NextBtn:OnClick() end,
    OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().EMailEdit:SetFocus() end end,
  },
  
  NewAccountBtn = DefButton { 
    size = {300,25},
    str = TEXT{"net_newaccount"},
    anchors = { TOP = { "BOTTOM", "PSWEdit", 0, 20 } },
    OnClick = function(this) 
      NETChooseGSAccount:Hide()
      NETCreateGSAccount:Show()
    end,
  },

  NextBtn = DefButton { 
    size = {150,25},
    str = TEXT{"net_next"},
    anchors = { TOPLEFT = { "BOTTOM", "NewAccountBtn", 20, 10 } },
    OnClick = function(this)
    
      NETChooseGSAccount:Hide()
      
      local email = NETChooseGSAccount.EMailEdit:GetStr()
      local psw = NETChooseGSAccount.PSWEdit:GetStr()
      
      if not email then
        NETMessage:Set(TEXT("net_error"), TEXT{"gs_empty_email"}, NETChooseGSAccount)
        return
      end

      if not psw then
        NETMessage:Set(TEXT("net_error"), TEXT{"gs_empty_pass"}, NETChooseGSAccount)
        return
      end
      
      NETWorking:Set(TEXT{"GSStatus_GetProfiles"})
      
      local delayedcall = function()
        local email = NETChooseGSAccount.EMailEdit:GetStr()
        local psw = NETChooseGSAccount.PSWEdit:GetStr()
        
        local err,profiles,skip,pname = net.GSGetProfiles(email, psw)
        NETWorking:Hide()
        
        if err then
          NETMessage:Set(TEXT("net_error"), TEXT{err}, NETChooseGSAccount)
          return
        end
        
        if skip then
          NETPlayerName.statusstr = "GSStatus_CreateProfile"
          NETPlayerName.profilename = pname
          NETPlayerName.showonhide = NETChooseGSAccount
          NETPlayerName:Show()
        else
          NETChooseGSProfile.profiles = {}
          for k,v in pairs(profiles) do
            table.insert(NETChooseGSProfile.profiles, {pname=k,wsname=v})
          end
          NETChooseGSProfile:Show()
        end
      end
      Transitions:CallOnce(delayedcall, 0.1)
    end,
  },
  
  CancelBtn = DefButton { 
    size = {150,25},
    str = TEXT{"cancel"},
    anchors = { TOPRIGHT = { "BOTTOM", "NewAccountBtn", -20, 10 } },
    OnClick = function(this)
      NETChooseGSAccount:Hide()
      NETLogin:Show()
    end,
  },
  
  Frame = DefSmallBackImage {
    layer = "-2",
    anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "NextBtn", 26,25 } },
  },
  
  OnShow = function(this)
    this.HelpText:SetStr("<p>"..TEXT{"net_helpchoosegsaccount"})
    local h = this.HelpText:GetStrHeight()
    this.HelpText:SetSize{this.HelpText:GetSize().x,h}
  end,
}  

--
-- NET create gamespy account
--

NETCreateGSAccount = uiwnd {
  hidden = true,
  size = {wsl_w, 330},
  layer = loginlayer,
  
  Frame = DefSmallBackImage {},
  
  Title = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,3 } },
    str = TEXT{"net_creategsaccount"},
  },
  
  EMailTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    halign = "LEFT",
    anchors = { TOP = { 0,35 } },
    str = TEXT{"net_enter_email"}..":",
  },

  EMailEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 50,
    layer = "+1",
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "EMailTitle", 5, 5 } },
    OnShow = function(this) this:SetFocus() end,
    OnKeyEnter = function(this) this:RemoveFocus() NETCreateGSAccount.PSWEdit:SetFocus() end,
    --OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().PSWEdit:SetFocus() end end,
  },

  PSWTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    halign = "LEFT",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "EMailEdit", -5,10 } },
    str = TEXT{"net_enter_password"}..":",
  },

  PSWEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 30,
    layer = "+1",
    password = true,
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "PSWTitle", 5, 5 } },
    OnKeyEnter = function(this) this:RemoveFocus() NETCreateGSAccount.RetypePSWEdit:SetFocus() end,
    --OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().RetypePSWEdit:SetFocus() end end,
  },
  
  RetypePSWTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    halign = "LEFT",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "PSWEdit", -5,10 } },
    str = TEXT{"net_retype_password"}..":",
  },

  RetypePSWEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 30,
    layer = "+1",
    password = true,
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "RetypePSWTitle", 5, 5 } },
    OnKeyEnter = function(this) this:RemoveFocus() NETCreateGSAccount.NameEdit:SetFocus() end,
    --OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().NameEdit:SetFocus() end end,
  },

  NameTitle = uitext {
    size = {wsl_w-20,20},
    layer = "+1",
    font = "Verdana,10b",
    halign = "LEFT",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "RetypePSWEdit", -5,10 } },
    str = TEXT{"net_enter_player_name"}..":",
  },

  NameEdit = uiedit {
    size = {wsl_w-40,25},
    maxchars = 14,
    layer = "+1",
    uiimg { color = {0,0,0,190}, size = {wsl_w-30,29}, layer = "-1" },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "NameTitle", 5, 5 } },
    OnKeyEnter = function(this) this:RemoveFocus() NETCreateGSAccount.CreateBtn:OnClick() end,
    --OnKeyEscape = function(this) this:RemoveFocus() end,
    OnKeyDown = function(this, key) if key == "Tab" then this:GetParent().EMailEdit:SetFocus() end end,
    allowed_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
  },

  CreateBtn = DefButton { 
    size = {150,25},
    layer = "+1",
    str = TEXT{"net_create"},
    anchors = { BOTTOMLEFT = { "BOTTOM", "Frame", 20, -15 } },
    OnClick = function(this)
      NETCreateGSAccount.email = NETCreateGSAccount.EMailEdit:GetStr()
      NETCreateGSAccount.psw1 = NETCreateGSAccount.PSWEdit:GetStr()
      NETCreateGSAccount.psw2 = NETCreateGSAccount.RetypePSWEdit:GetStr()
      NETCreateGSAccount.player = NETCreateGSAccount.NameEdit:GetStr()
      NETCreateGSAccount:Hide()
      
      if not NETCreateGSAccount.email then
        NETMessage:Set(TEXT("net_error"), TEXT{"gs_empty_email"}, NETCreateGSAccount)
        return
      end
      
      if not NETCreateGSAccount.psw1 and not NETCreateGSAccount.psw2 then
        NETMessage:Set(TEXT("net_error"), TEXT{"gs_empty_pass"}, NETCreateGSAccount)
        return
      end
      
      if NETCreateGSAccount.psw1 ~= NETCreateGSAccount.psw2 then
        NETMessage:Set(TEXT("net_error"), TEXT{"neterr_notsamepasswords"}, NETCreateGSAccount)
        return
      end
      
      NETWorking:Set(TEXT{"GSStatus_CreateProfile"})
      local delayedcall = function()
        local err = net.GSCreateProfile(NETCreateGSAccount.player, NETCreateGSAccount.player, NETCreateGSAccount.email, NETCreateGSAccount.psw1)
        NETWorking:Hide()
        
        if err then
          NETMessage:Set(TEXT("net_error"), TEXT{err}, NETCreateGSAccount)
        else
          game.CreateNewProfile(NETCreateGSAccount.player, "", false)
          NETMessage:Set(TEXT("net_success"),
                         TEXT{"net_successwscreate", NETCreateGSAccount.player},
                         NETLogin, NETLogin.PSWEdit)
        end
      end
      Transitions:CallOnce(delayedcall, 0.1)
    end,
  },
  
  CancelBtn = DefButton { 
    size = {150,25},
    layer = "+1",
    str = TEXT{"cancel"},
    anchors = { BOTTOMRIGHT = { "BOTTOM", "Frame", -20, -15 } },
    OnClick = function(this)
      NETCreateGSAccount:Hide()
      NETChooseGSAccount:Show()
    end,
  },
}  

--
-- NET choose gamespy profile
--

local function CreateProfilesListSlot(list, idx, cellh)
  local cellw = list.ScrollArea:GetSize()[1]
  local slot
  slot = uiwnd {
    mouse = true,
    layer = "+1",
    size = { cellw, cellh },

    PName = uiwnd {
      size = {1, cellh},
      anchors = { TOPLEFT = {0,0}, TOPRIGHT = {"TOP", 0,0} },
      selected = uiimg {hidden = true,color = {0,0,0,80}},
      text = uitext{font = "Verdana,9", color = {136,136,136}},
    },
    WSName = uiwnd {
      size = {1, cellh},
      anchors = { TOPLEFT = { "TOP", 0,0}, TOPRIGHT = {0,0} },
      selected = uiimg{hidden = true,color = {0,0,0,80}},
      text = uitext{font = "Verdana,9", color = {136,136,136}},
    },
    
    OnMouseWheel = function(slot, delta, mods) list:OnMouseWheel(delta, mods) end,
    OnMouseDown = function(slot) list:OnListClicked(idx) end,
  }
  return slot
end

NETChooseGSProfile = uiwnd {
  hidden = true,
  size = {wsl_w, 300},
  layer = loginlayer,
  
  Title = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,3 } },
    str = TEXT{"net_choosegsprofile"},
  },
  
  HelpText = uitext {
    size = {wsl_w-20,1},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,35 } },
    halign = "LEFT",
    valign = "TOP",
  },

  ProfilesList = uiwnd {
    layer = "+1",
    size = {wsl_w-20,150},
    anchors = { TOP = { "BOTTOM", "HelpText", 0,10 } },
    
    ProfileNames = uiwnd {
      size = {1,20},
      layer = "+1",
      anchors = { TOPLEFT = { 0,0 }, TOPRIGHT = { "TOP", 0,0 } },
      back = uiimg { layer = "-1", color = {0,0,0,255}, },
      text = uitext { 
        font = "Verdana,10b",
        str = TEXT{"net_profilenames"},
      },
    },
    
    WSPlayerNames = uiwnd {
      size = {1,20},
      layer = "+1",
      anchors = { TOPLEFT = { "TOP", 0,0 }, TOPRIGHT = { 0,0 } },
      back = uiimg { layer = "-1", color = {0,0,0,255}, },
      text = uitext { 
        font = "Verdana,10b",
        str = TEXT{"net_wsplayernames"},
      },
    },
    
    Vert_1 = uiwnd {
      size = {2,1},
      layer = "+1",
      anchors = { TOPLEFT = { "BOTTOMRIGHT", "ProfileNames", 0,2 }, BOTTOMRIGHT = { "BOTTOM", 2,-2 } },
      lt = uiimg { layer = "+1", color = {0,0,0,255}, anchors = { TOPLEFT = {0,0}, BOTTOMRIGHT = {-1,0} } },
      rt = uiimg { layer = "+1", color = {41,41,42,255}, anchors = { TOPLEFT = {1,0}, BOTTOMRIGHT = {0,0} } },
    },
    
    Listbox = DefBtnListBox {
      layer = "+1",
      ncolor = {143, 153, 138},
      hcolor = {236, 254, 227},
      pcolor = {236, 254, 227},
      scolor = {255, 143, 51},
      anchors = { TOPLEFT = { "BOTTOMLEFT", "ProfileNames", 0,0 }, BOTTOMRIGHT = { "BOTTOMRIGHT", 0,0 } },
      
      Scrollbar = DefBtnListBox.Scrollbar {
        hidden = true,
        layer = "+1",
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
        anchors = { TOPLEFT = { 2, 2 }, BOTTOMRIGHT = { -2,-2 } },
      },
      
      UpdateItem = function(this, item, data)
        item.data = data
        item.PName.text:SetStr(data.pname)
        item.WSName.text:SetStr(data.wsname)
      end,
      
      SelectItem = function(this, item, doselect)
        if not item then return end
        if doselect then
          item.PName.selected:Show()
          item.WSName.selected:Show()
        else
          item.PName.selected:Hide()
          item.WSName.selected:Hide()
        end
      end,
    },
  },
      
  NextBtn = DefButton { 
    layer = "+1",
    size = {150,25},
    anchors = { TOPLEFT = { "BOTTOM", "NETChooseGSProfile.ProfilesList", 20,10 } },
    str = TEXT{"net_next"},
    OnClick = function(this)
      NETChooseGSProfile:Hide()
      local idx, data = NETChooseGSProfile.ProfilesList.Listbox:GetNextSelected()
      if idx and data then
        if data.wsname and data.wsname ~= "" then
          NETMessage:Set(TEXT("net_error"), TEXT{"neterr_profilehaswsname", data.wsname}, NETChooseGSProfile)
        else
          NETPlayerName.statusstr = "GSStatus_RegisterUniqueName"
          NETPlayerName.profilename = data.pname
          NETPlayerName.showonhide = NETChooseGSProfile
          NETPlayerName:Show()
        end
      else
        NETMessage:Set(TEXT("net_error"), TEXT{"neterr_selectprofile"}, NETChooseGSProfile)
        return
      end
    end,
  },
  
  CancelBtn = DefButton { 
    layer = "+1",
    size = {150,25},
    anchors = { TOPRIGHT = { "BOTTOM", "NETChooseGSProfile.ProfilesList", -20,10 } },
    str = TEXT{"cancel"},
    OnClick = function(this)
      NETChooseGSProfile:Hide()
      NETChooseGSAccount:Show()
    end,
  },
  
  Frame = DefSmallBackImage {
    layer = "-2",
    anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "NextBtn", 26,25 } },
  },
  
  OnShow = function(this)
    this.HelpText:SetStr("<p>"..TEXT{"net_helpchoosegsprofile"})
    local h = this.HelpText:GetStrHeight()
    this.HelpText:SetSize{this.HelpText:GetSize().x,h}
    
    this.ProfilesList.Listbox:SetList(this.profiles, 20, CreateProfilesListSlot)
  end,
}  

--
-- Enter WS player name
--

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

  CreateBtn = DefButton { 
    size = {150,25},
    str = TEXT{"net_create"},
    anchors = { BOTTOMLEFT = { "BOTTOM", "Frame", 20, -15 } },
    OnClick = function(this)
      NETPlayerName.showonhide_tmp = NETPlayerName.showonhide
      NETPlayerName.showonhide = nil      
    
      NETPlayerName.wsname = NETPlayerName.NameEdit:GetStr()
      NETPlayerName:Hide()
      
      NETWorking:Set(TEXT{NETPlayerName.statusstr})
      local delayedcall = function()
        local err = net.GSCreateProfile(NETPlayerName.profilename, NETPlayerName.wsname)
        NETWorking:Hide()
        
        if err then
          NETPlayerName.showonhide = NETPlayerName.showonhide_tmp
          NETPlayerName.showonhide_tmp = nil
          NETMessage:Set(TEXT("net_error"), TEXT{err}, NETPlayerName)
        else
          game.CreateNewProfile(NETPlayerName.wsname, "", false)
          NETMessage:Set(TEXT("net_success"),
                         TEXT{"net_successwscreate", NETPlayerName.wsname},
                         NETLogin, NETLogin.PSWEdit)
        end
      end
      Transitions:CallOnce(delayedcall, 0.1)
    end,
  },
  
  CancelBtn = DefButton { 
    size = {150,25},
    str = TEXT{"cancel"},
    anchors = { BOTTOMRIGHT = { "BOTTOM", "Frame", -20, -15 } },
    OnClick = function(this)
      NETPlayerName:Hide()
    end,
  },
  
  OnHide = function(this)
    if this.showonhide then
      this.showonhide:Show()
    end  
    if this.setfocus then
      this.setfocus:SetFocus()
      this.setfocus = nil
    end
  end,
}  

--
-- NET choose gamespy account
--

NETMessage = uiwnd {
  hidden = true,
  size = {wsl_w, 1},
  layer = loginlayer,
  keyboard = true,
  
  Title = uitext {
    size = {wsl_w,20},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,3 } },
  },
  
  Message = uitext {
    size = {wsl_w-20,1},
    layer = "+1",
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOP = { 0,35 } },
    halign = "LEFT",
    valign = "TOP",
  },

  OkBtn = DefButton { 
    size = {150,25},
    str = TEXT{"ok"},
    anchors = { TOP = { "BOTTOM", "Message", 0, 20 } },
    OnClick = function(this)
      NETMessage:Hide()
    end,
  },
  
  Frame = DefSmallBackImage {
    layer = "-2",
    size = {wsl_w, 1},
    anchors = { TOPLEFT = { 0,0 }, BOTTOM = { "OkBtn", 0,25 } },
  },
  
  OnShow = function(this)
    this.Title:SetStr("<p>"..this.title)
    this.Message:SetStr("<p>"..this.message)
    local h = this.Message:GetStrHeight()
    this.Message:SetSize{this.Message:GetSize().x,h}
  end,
  
  OnHide = function(this)
    if this.showonhide then
      this.showonhide:Show()
    end  
    if this.setfocus then
      this.setfocus:SetFocus()
      this.setfocus = nil
    end
  end,
  
  Set = function(this, title, message, showonhide, setfocus)
    this.title = title
    this.message = message
    this.showonhide = showonhide
    this.setfocus = setfocus
    this:Show()
  end,
  
  OnKeyEnter = function() NETMessage:Hide() end,
  OnKeyEscape = function() NETMessage:Hide() end,
}  

--
-- NET working
--

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
