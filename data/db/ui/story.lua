--                                                                                             
-- ON START/END GAME UI
--                                                                                             

local sub_intro = {
  [1]  = { ["show"] = 3.408,   ["hide"] = 6.246  },
  [2]  = { ["show"] = 6.281,   ["hide"] = 9.243  },
  [3]  = { ["show"] = 9.278,   ["hide"] = 12.433 },
  [4]  = { ["show"] = 12.759,  ["hide"] = 15.033 },
  [5]  = { ["show"] = 15.068,  ["hide"] = 19.513 },
  [6]  = { ["show"] = 25.399,  ["hide"] = 27.260 },
  [7]  = { ["show"] = 43.097,  ["hide"] = 45.816 },
  [8]  = { ["show"] = 45.816,  ["hide"] = 48.726 },
  [9]  = { ["show"] = 48.726,  ["hide"] = 52.381 },
  [10] = { ["show"] = 53.167,  ["hide"] = 54.113 },
  [11] = { ["show"] = 61.432,  ["hide"] = 65.388 },
  [12] = { ["show"] = 65.762,  ["hide"] = 67.417 },
  [13] = { ["show"] = 68.014,  ["hide"] = 72.564 },
  [14] = { ["show"] = 72.564,  ["hide"] = 77.705 },
  [15] = { ["show"] = 79.003,  ["hide"] = 80.873 },
  [16] = { ["show"] = 82.202,  ["hide"] = 83.502 },
  [17] = { ["show"] = 84.517,  ["hide"] = 86.462 },
  [18] = { ["show"] = 90.034,  ["hide"] = 95.969 },
  [19] = { ["show"] = 96.487,  ["hide"] = 100.210},
  [20] = { ["show"] = 100.211, ["hide"] = 102.382},
  [21] = { ["show"] = 103.596, ["hide"] = 105.318},
  [22] = { ["show"] = 105.318, ["hide"] = 109.889},
  [23] = { ["show"] = 109.889, ["hide"] = 113.167},
  count = 23,
}

Showline = function(param, elapsed)
  if param > sub_intro.count then 
    MovieFS.Subtitles:SetStr("") 
    return 0 
  end

  if sub_intro[param].pause then
    MovieFS.Subtitles:SetStr("")
    local time = sub_intro[param].pause
    sub_intro[param].pause = nil
    return time,param
  end

  if param + 1 <= sub_intro.count then
    local time = sub_intro[param+1].show - sub_intro[param].hide
    if time > 0 then
      sub_intro[param+1].pause = time
    end
  end

  MovieFS.Subtitles:SetStr("<p>"..TEXT("intro_line_"..param))

  return sub_intro[param].hide - sub_intro[param].show,param+1
end

local BITS_COUNT = 20
local stripeslayer = 2000

DefBit = uiwnd {
  virtual = true,
  hidden = true,
  mouse = true,

  size = {55,55},
  layer = stripeslayer+5,
  
  DefCornerFrameImage { layer = stripeslayer+3 },
  Text = uitext { layer = stripeslayer+4 },
  Icon = uiimg { size = {49,49}, layer = stripeslayer+5 },
  
  OnMouseEnter = function(this) Story:ShowBitInfo(this) end,
  OnMouseLeave = function(this) Story:HideBitInfo() end,
}

local DefUserProgress = uiwnd {
  virtual = true,
  hidden = true,
  size = {250,30},
  layer = stripeslayer+2,
  
  bar = DefCornerFrameImage{
    r = 0,
    speed = 400,
    bcolor = {0,0,0,255},
    dcolor = {0,255,0,255},
    color = bcolor,
    layer = "-1",
  },
  
  Name = uitext {
    halign = "LEFT",
    anchors = { LEFT = { 10,0 } },
  },
  
  Status = uitext {
    halign = "RIGHT",
    anchors = { RIGHT = { -10,0 } },
  },

  OnShow = function(this)
    this.done = nil
  end,
  
  OnUpdate = function(this)
    if this.done then
      this.bar:SetColor(this.bar.dcolor)
      return
    end
    this.bar.r = this.bar.r + (this.bar.speed * argElapsed)
    if this.bar.r >= 255 then this.bar.r = 255 this.bar.speed = -math.abs(this.bar.speed) end
    if this.bar.r <= 0 then this.bar.r = 0 this.bar.speed = math.abs(this.bar.speed) end
    this.bar.bcolor[1] = math.floor(this.bar.r)
    this.bar:SetColor(this.bar.bcolor)
  end,
}

MovieFS = uiwnd {
  hidden = true,
  mouse = true,
  keyboard = true,
  layer = 2200,
  
  Back = uiimg { color = {0,0,0,255} },

  Bink = uibink { },
  
  Subtitles = uitext {
    layer = "+1",
    size = {1,100},
    font = "Tahoma,15",
    shadow_ofs = {1,1},
    anchors = { BOTTOMLEFT = { 50,-120}, BOTTOMRIGHT = { -50,-120} },
  },

  OnLoad = function(this)
    this:RegisterEvent("MOVIE_END")
  end,
  
  OnEvent = function(this, event)
    if event == "MOVIE_END" then
      local cb = this.callback
      this.callback = nil
      this.unstoppable = nil
      this:Hide()
      if cb then cb() end
    end
  end,
  
  Play = function(this, movie, callback, subtitles)
    this.Subtitles:SetStr("")
    this.Bink:SetMovie(movie)
    this.callback = callback
    this:Show()
    if subtitles and not Login.openbeta then
      if this.subid then Transitions:CancelRepeat(this.subid) end
      this.subid = Transitions:CallRepeat(Showline, sub_intro[1].show, 1)
    end
  end,
  
  OnHide = function(this)
    if this.subid then Transitions:CancelRepeat(this.subid) end
    this.subid = nil
    this.unstoppable = nil
  end,

  OnMouseUp = function(this)
    if this.unstoppable then return end
    local cb = this.callback
    this.callback = nil
    this:Hide()
    if cb then cb("mouse") end
  end,

  OnKeyDown = function(this, key)
    if this.unstoppable then return end
    if key == "Escape" then 
      local cb = this.callback
      this.callback = nil
      this:Hide()
      if cb then cb("escape") end
    end
  end,
}

Story = uiwnd {
  hidden = true,
  mouse = true,
  layer = 50,
  
  Back = uiimg {
    layer = stripeslayer-2,
    color = {0,0,0,255} 
  },

  Movie1 = uiimg {
    layer = stripeslayer-1,
  },
  Movie2 = uiimg {
    layer = stripeslayer-1,
  },

  Bits = uiwnd {
    hidden = true,
    distance = 10,
    layer = stripeslayer+1,
    size = {1,1},
    anchors = { TOPRIGHT = { -10,10 } },
  },
  
  Users = uiwnd {
    hidden = true,

    User_1 = DefUserProgress { anchors = { TOPLEFT = { 10,10 } } },
    User_2 = DefUserProgress { anchors = { TOP = { "BOTTOM", "User_1", 0,0} } },
    User_3 = DefUserProgress { anchors = { TOP = { "BOTTOM", "User_2", 0,0} } },
    
    User_4 = DefUserProgress { anchors = { TOPRIGHT = { -10,10 } } },
    User_5 = DefUserProgress { anchors = { TOP = { "BOTTOM", "User_4", 0,0} } },
    User_6 = DefUserProgress { anchors = { TOP = { "BOTTOM", "User_5", 0,0} } },
    
    OnLoad = function(this)
      this:RegisterEvent("GL_LOADINGPROGRESS")
      this:RegisterEvent("GL_LOADINGPROGRESSRESET")
      this:RegisterEvent("GL_LOADINGPROGRESSPLAYERDROPPED")
    end,
    
    OnEvent = function(this, event)
      if event == "GL_LOADINGPROGRESSRESET" then
        for idx = 1,6 do
          local slot = this["User_"..idx]
          if slot then
            slot:Hide()
          end
        end
      end
    
      if event == "GL_LOADINGPROGRESS" then
        for k,v in pairs(argData) do
          local slot = this["User_"..v[1]]
          if slot then
            slot.Name:SetStr(k)
            if v[2] < 100 then
              slot.done = nil
              slot.Status:SetStr(TEXT{"loading..."})  
            else
              slot.Status:SetStr(TEXT{"done"})
              slot.done = true
            end
            slot:Show()
          end
        end
        this:Show()
      end
      
      if event == "GL_LOADINGPROGRESSPLAYERDROPPED" then
        if argPlayer then 
          local slot = this["User_"..argPlayer]
          slot.done = nil
          slot.Status:SetStr(TEXT{"dropped"})  
        end
      end
      
    end,
  },
  
  Progress = uiwnd {
    hidden = true,
    size = {150,30},
    layer = stripeslayer+2,
    anchors = { BOTTOMLEFT = { 10,-10 } },
    
    DefCornerFrameImage{},
    
    Text = uitext {
      halign = "LEFT",
      anchors = { LEFT = { 7,0 } },
    },
    
    line = uiimg { 
      speed = 20,
      x = 6,
      size = {3,20},
      color = {255,143,51,255},
      anchors = { LEFT = { 6,0 } },
    },
    
    OnShow = function(this)
      this.line.x = 6
      this.line:SetAnchor("LEFT", this, "LEFT", {this.line.x, 0})
      this.time = 0.0
      this.Text:SetStr("Loading time: "..this.time)
    end,
    
    OnUpdate = function(this)
      local dx = argElapsed * this.line.speed
      this.line.x = this.line.x + dx
      if this.line.x >= 142 then this.line.speed = -math.abs(this.line.speed) end
      if this.line.x <= 5 then this.line.speed = math.abs(this.line.speed) end
      this.line:SetAnchor("LEFT", this, "LEFT", {this.line.x, 0})
      this.time = this.time + argElapsed
      local i,f = math.modf(this.time) 
      this.Text:SetStr("Loading time: "..i.."."..string.sub(f, 3,3))
    end,
  },
  
  Briefing = uiwnd {
    hidden = false,
    layer = stripeslayer+1,
    size = {400,600},
    Frame = uiimg {
      layer= "-1",
      texture = "data/textures/ui/briefing_back.dds",
      coords = {0, 0, 324, 478},      
    },

    Title = uitext {
      size = {360,70},
      halign = "LEFT", 
      color = {241,182,1},
      anchors = {TOP = {0,10}},
      font = "Trebuchet MS,16b" 
    },
    
    Text = uitext { 
      size = {360,570}, 
      valign = "TOP", 
      halign = "LEFT", 
      color = {200,200,200}, 
      font = "Verdana,12",
      anchors = {TOP = {"BOTTOM", "Title", 0, 10}},
    },
    anchors = { LEFT = {10,0} },
  },
  
  SubtitlesBtn = DefButton {
    hidden = true,
    size = {30,30},
    layer = stripeslayer+1,
    str = "Tt",
    OnClick = function(this)
      if Story.Briefing:IsHidden() then
        Story.Briefing:Show() 
      else 
        Story.Briefing:Hide()
      end 
    end,
  },
  
  TipTxt = uitext {
    layer = stripeslayer+2,
    size = {1000,80},
    anchors = { TOP = { "BOTTOM", 0, -120 } },
    color = {240, 240, 240},
    font = "Tahoma,12",
  },  
  
  StartBtn = DefButton {
    hidden = true,
    size = {130,30},
    layer = stripeslayer+1,
    str = TEXT{"start"},
    anchors = { BOTTOMRIGHT = { -20,-20 } },
    OnClick = function(this) this:GetParent():OnStartMap() end,
  },

  ExitBtn = DefButton {
    hidden = true,
    size = {130,30},
    layer = stripeslayer+1,
    str = TEXT{"exit"},
    anchors = { RIGHT = { "LEFT", "StartBtn", -20,0 } },
    OnClick = function(this) this:GetParent():OnCancel() end,
  },
}

function CreateStoryBits()
  if Story.Bits.Bit_1 then return end
  for idx = 1,BITS_COUNT do
    slot = DefBit {}
    if idx == 1 then
      slot.anchors = { TOPRIGHT = { "TOPRIGHT", Story.Bits } }
    else
      slot.anchors = { RIGHT = { "LEFT", "Story.Bits.Bit_" .. (idx-1), -Story.Bits.distance,0 } }
    end
    Story.Bits["Bit_" .. idx] = slot
  end
  Story.Bits:CreateChildren()
end
CreateStoryBits()

function Story:OnShow()
  this.Users:Hide()
  for i = 1,6 do this.Users["User_"..i]:Hide() end
end

function Story:OnBegin()
  Story:CtrlShow(false)
  Stripes:FadeIN()
  this.map = net.GetMapName()
  MovieFS:Hide()
  if not BlackScreen:IsHidden() then
    Transitions:Fade(BlackScreen, this, nil, 0.5)
  else
    this:Show()
  end
  game.EnableUnitSelection(false)
  
  local shots = game.EnumLoadingShots(this.map)
  
  -- loading textures
  this.Movie1:SetTexture(shots[math.random(1, #shots)])
  while 1 do
    this.Movie2:SetTexture(shots[math.random(1, #shots)])
    if this.Movie1:GetTexture() ~= this.Movie2:GetTexture() then break end
  end
  this.interval = 10
  this.transtime = 0.9
  this.curTime = 0
  this.m1 = this.Movie2
  this.m2 = this.Movie1
  local sz = this:GetSize()
  local h = sz.x * (9/16)
  this.Movie1:SetSize{sz.x,h}
  this.Movie2:SetSize{sz.x,h}
  
  this.mapn = this.map
  if string.sub(this.mapn, 1, 9) == "missions/" then
    this.mapn = string.sub(this.mapn, 10)
  end
  
  -- briefing
  this.Briefing:Hide()
  this.SubtitlesBtn:Hide()
  local brief = TEXT{"briefings."..this.mapn}
  if brief and brief ~= "briefings."..this.mapn then
    this.Briefing.Text:SetStr("<p>" .. brief)
    this.SubtitlesBtn:SetAnchor("BOTTOMLEFT", this, "BOTTOMLEFT", {20,-(Stripes:GetHeight()+10)})
    --this.SubtitlesBtn:Show()
    this.Briefing:Show()
  end
  
  this.Briefing.Title:SetStr(game.GetMapTitle(this.map))

  Transitions:CallOnce(function() 
    this.briefSnd = game.PlaySnd("data/speech/briefings/"..this.mapn..".wav", 4) 
    this.briefMusic = game.PlaySnd("data/sounds/music/briefings/", 1) 
    end, 2)

  -- story bits
  for i = 1,BITS_COUNT do this.Bits["Bit_"..i]:Hide() end
  local info = game.GetLocationInfo(this.map)
  if info and info.story_bits then
    local last_idx = #(info.story_bits)
    for i,v in ipairs(info.story_bits) do
      local slot = this.Bits["Bit_"..(last_idx - i + 1)]
      if slot then
        --last_idx = i
        
        local filename = "data/textures/ui/storybits/"..this.mapn..' '..v.."_small.bmp"
        if game.GetTextureInfo(filename) then
          slot.Text:Hide()
          slot.Icon:SetTexture(filename, {0,0,49,49})
          slot.Icon:Show()
        else
          slot.Icon:Hide()
          slot.Text:SetStr(v)
          slot.Text:Show()
        end

        slot.tkey = "briefings."..this.mapn..' '..v
        slot.title = this.mapn..' '..v
        slot.pic = this.mapn..' '..v..".bmp"
        slot:Show()
      end  
    end
    for i = last_idx+1,BITS_COUNT do
      local slot = this.Bits["Bit_"..i]
      if slot then slot:Hide() else break end  
    end
    this.Bits:Show()
  else  
    this.Bits:Hide()
  end

  local sTip = game.GetTip()
  if sTip then
    
    while string.sub(sTip, -1) == ' ' do
      sTip = string.sub(sTip, 1, string.len(sTip) - 1)
    end
    
    this.TipTxt:SetStr(TEXT("tip")..": "..sTip)
  end
end

function Story:OnLoad()
  this:RegisterEvent("MINIMAP_BUILD")
  this:RegisterEvent("GL_START")
end
  
function Story:OnUpdate()
  this.curTime = this.curTime + argElapsed
  if this.transition then
    this.m1:SetAlpha(1 - this.curTime / this.transtime)
  end
  if not this.transition and this.curTime > this.interval then
    this.transition = true
    this.curTime = 0
    game.PauseGameLoading()
  end
  if this.transition and this.curTime > this.transtime then
    this.transition = nil
    this.curTime = 0
    this.m1:SetAlpha(1)
    this.m1:SetTexture(this.m2:GetTexture())
    local shots = game.EnumLoadingShots(this.map)
    while 1 do
      this.m2:SetTexture(shots[math.random(1, #shots)])
      if this.m1:GetTexture() ~= this.m2:GetTexture() then break end
    end
    local sz = this:GetSize()
    local h = sz.x * (9/16)
    this.Movie1:SetSize{sz.x,h}
    this.Movie2:SetSize{sz.x,h}
    game.ResumeGameLoading()
  end
end

function Story:StopSound()
  if this.briefSnd then
    game.StopSnd(this.briefSnd)
    this.briefSnd = nil
  end
  if this.briefMusic then
    game.StopSnd(this.briefMusic)
    this.briefMusic = nil
  end
end

function Story:OnEvent(event)
  if this.quiting then return end
  
  if event == "GL_START" and net.GLIsMultiplayer() then
    game.EnableUnitSelection(true)
    this:FadeOut()
    this:StopSound()
  end
  
  if event == "MINIMAP_BUILD" and not this:IsHidden() then
    --game.Pause(true)
    --this.Progress:Hide()
    if not net.GLIsMultiplayer() then
      Transitions:CallOnce(function() this:CtrlShow(true) end, 1)
    end  
  end
end

function Story:OnStartMap()
  game.Pause(false)
  game.EnableUnitSelection(true)
  this:FadeOut()
  this:StopSound()
end

function Story:OnCancel()
  this:StopSound()
  this.quiting = true
  InGameMenu:Hide()
  PauseWnd:Hide()
  game.CloseMap() 
  game.LoadEarth()
  Stripes:FadeOUT()
  Login:Hide()
  Lobby:Show()
  Transitions:Fade(Story, nil, function() 
    --game.Pause(false) 
    Story.quiting = nil 
  end)
end

function Story:OnEnd()
  Story:CtrlShow(false)
  Stripes:FadeIN()
  this:Show()
end

function Story:FadeOut()
  this.transition = nil
  this.Movie1:SetAlpha(-1)
  this.Movie2:SetAlpha(-1)
  Stripes:FadeOUT()
  Transitions:Fade(this, nil, function() game.Pause(false) end, 0.5)
end

function Story:CtrlShow(doshow)
  Stripes.GetHeightCustom = nil
  if doshow then
    if Stripes:GetHeight() == 0 then
      Stripes.GetHeightCustom = function() return 100 end
    end
    Stripes:FadeIN()
    this.Bits:Show()
    this.ExitBtn:Show()
    this.StartBtn:Show()
  else
    this.Bits:Hide()
    this.ExitBtn:Hide()
    this.StartBtn:Hide()
  end
end

function Story:ShowBitInfo(bit)
  StoryBitInfo:Set(TEXT{bit.title}, TEXT{bit.tkey}, bit.pic)
  StoryBitInfo:Show()
end

function Story:HideBitInfo()
  StoryBitInfo:Hide()
end

function Story:OnHide()
  Stripes:Hide()
end

--
-- bit info
--

local textw = 300
local picw = 300
local pich = 190

StoryBitInfo = uiwnd {
  hidden = true,
  layer = stripeslayer+2,
  size = {1,1},
  anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Story.Bits.Bit_1", 0,20 } },
  
  Frame = DefCornerFrameImage {
    layer = "-1",
  },
  
  Pic = uiimg { size = {picw,pich}, hidden = true },
  
  Title = uitext { size = {textw,30}, hidden = true, anchors = {TOP = {0, 5}}, valign = "TOP", halign = "LEFT", color = {241,182,1}},
  Text = uitext { size = {textw,textw}, hidden = true, anchors = {TOP = {"BOTTOM", "Title", 0, 5}}, valign = "TOP", halign = "LEFT", color = {142,142,141} },
  
  Set = function(this, titletxt, text, pic)
    local margin = 10
    local vert,th = true,0
    
    this.Title:SetStr("<p>"..titletxt)
    this.Title:Show()
    
    if text then
      this.Text:SetStr("<p>"..text)
      th = this.Text:GetStrHeight()
      this.Text:SetSize{textw,th}
    end
    if pic then
      local filename = "data/textures/ui/storybits/"..pic
      local pw,ph = game.GetTextureInfo(filename)
      if pw and ph then
        if pw > ph then vert = false end
        this.Pic:SetTexture(filename, {0,0,pw,ph})
      else
        pic = nil  
      end  
    end
    
    if pic and text then
      if vert then
        local width = margin + picw + (2*margin) + textw + margin
        local height = margin + math.max(pich, th) + margin
        this:SetSize{width,height+ this.Title:GetSize().y}
        this.Pic:SetAnchor("TOPLEFT", this, "TOPLEFT", {margin,margin})
        this.Text:SetAnchor("TOPRIGHT", this, "TOPRIGHT", {-margin,margin + this.Title:GetSize().y})
        this.Pic:Show()
        this.Text:Show()
      else
        local width = margin + math.max(picw, textw) + margin
        local height = margin + pich + (2*margin) + th + margin
        this:SetSize{width,height+ this.Title:GetSize().y}
        this.Pic:SetAnchor("TOP", this, "TOP", {0,margin})
        this.Text:SetAnchor("BOTTOM", this, "BOTTOM", {0,-margin + this.Title:GetSize().y})
        this.Pic:Show()
        this.Text:Show()
      end
    elseif text then
      local width = margin + textw + margin
      local height = margin + th + margin
      this:SetSize{width,height+ this.Title:GetSize().y}
      this.Text:SetAnchor("TOPLEFT", this, "TOPLEFT", {margin,margin + this.Title:GetSize().y})
      this.Pic:Hide()
      this.Text:Show()
    else
      local width = margin + picw + margin
      local height = margin + pich + margin
      this:SetSize{width,height+ this.Title:GetSize().y}
      this.Pic:SetAnchor("TOPLEFT", this, "TOPLEFT", {margin,margin})
      this.Pic:Show()
      this.Text:Hide()
    end
  end,
}

