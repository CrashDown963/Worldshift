local set_layer = modallayer-1
local settw = 645
local setth = 720

local ladderclr1 = {250, 250, 250, 255}
local ladderclr2 = {255, 143, 51, 255}
local playerclr = {11, 250, 11, 255}

local ladderrows = 20
local lastladderpos = 100

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

local RankColW = 50
local PlayerColW = 300
local RatingColW = 70
local WinsColW = 70
local LossesColW = 70


local DefLadderRow = uiwnd {
  virtual = true,
  size = {settw - 20, 25},
  --mouse = true,
  
  LightBox = uiimg {
    hidden = true,
    color = {255,255,255, 20},
  },

  RankTxt = uitext {
    layer = "+2", 
    size = {RankColW, 25},
    anchors = { LEFT = { "LEFT", 5,0 } },  
    font = "Verdana,11",
    --color = {255, 143, 51},
    --halign = "RIGHT",
    str = "NN",
  },

  PlayerTxt = uitext {
    layer = "+2", 
    size = {PlayerColW, 25},
    anchors = { LEFT = { "RIGHT", "RankTxt", 20,0 } },  
    font = "Verdana,11",
    color = {255, 143, 51},
    halign = "LEFT",
    str = "WWWWWWWWWWWW",
  },


  LossesTxt = uitext {
    layer = "+2", 
    size = {LossesColW, 25},
    anchors = { RIGHT = { "RIGHT", -15,0 } },  
    font = "Verdana,11",
    color = {255, 143, 51},
    --halign = "RIGHT",
    str = "XXX",
  },

  WinsTxt = uitext {
    layer = "+2", 
    size = {WinsColW, 25},
    anchors = { RIGHT = { "LEFT", "LossesTxt", -10,0 } },  
    font = "Verdana,11",
    color = {255, 143, 51},
    --halign = "RIGHT",
    str = "XXX",
  },

  RatingTxt = uitext {
    layer = "+2", 
    size = {RatingColW, 25},
    anchors = { RIGHT = { "LEFT", "WinsTxt", -10,0 } },  
    font = "Verdana,11",
    color = {255, 143, 51},
    --halign = "RIGHT",
    str = "XXX",
  },

  SetClr = function(this, clr)
    this.RankTxt:SetColor(clr)
    this.PlayerTxt:SetColor(clr)
    this.RatingTxt:SetColor(clr)
    this.WinsTxt:SetColor(clr)
    this.LossesTxt:SetColor(clr)
  end,
  
  OnShow = function(this)
    if this.index % 2 == 1 then
      this.LightBox:Hide()
    else
      this.LightBox:Show()
    end
  end,

  OnMouseEnter = function(this)

  end,

  OnMouseLeave = function(this)

  end,
}

Stats = uiwnd {
  hidden = true,
  mouse = true,
  keyboard = true,
  layer = set_layer,
  size = {settw,setth},
  anchors = { TOPRIGHT = { "TOPRIGHT", "Lobby", -10, 60 } },

  Frame = DefBigBackImage{layer = set_layer-2},
  

  TabLadder = DefTab {
    size = {1,28},
    anchors = { TOPLEFT = { "Frame", 10, 10 }, TOPRIGHT = { "TOP", "Frame", -1,10 } },
    str = TEXT{"ladder"},
  },

  TabPlayerStats = DefTab {
    size = {1,28},
    anchors = { TOPRIGHT = { "TOPRIGHT", "Frame", -10,10 }, TOPLEFT = { "TOP", "Frame", 1,10 } },
    str = TEXT{"player_profile"},
  },

  LadderTab = uiwnd {
    hidden = true,
    mouse = true,
    startpos = 0,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TabLadder", 0,0 }, BOTTOMRIGHT = { "Frame", -10,-12 } },
    
    --Frame = DefHRFrameImage2{},
    Frame = DefSmallBackImage{},    
    
    RankTitle =  uitext {
      layer = "+5",
      size = {RankColW, 20},
      anchors = {BOTTOM = {"TOP", "Stats.LadderTab.Row1.RankTxt", 0, -9}},
      str = TEXT("rank1v1txt"),
      font = "Verdana,10b",
      color = ladderclr2,
    },
    
    PlayerTitle =  uitext {
      layer = "+5",
      size = {PlayerColW, 20},
      --anchors = {LEFT = {"RIGHT", "RankTitle", 0, 0}},
      anchors = {BOTTOM = {"TOP", "Stats.LadderTab.Row1.PlayerTxt", 0, -9}},
      str = TEXT("player_frame"),
      font = "Verdana,10b",
      color = ladderclr2,
    },
    
    RatingTitle =  uitext {
      layer = "+5",
      size = {RatingColW, 20},
      --anchors = {LEFT = {"RIGHT", "PlayerTitle", 0, 0}},
      anchors = {BOTTOM = {"TOP", "Stats.LadderTab.Row1.RatingTxt", 0, -9}},
      str = TEXT("rating1v1txt"),
      font = "Verdana,10b",
      color = ladderclr2,
    },
    
    WinsTitle =  uitext {
      layer = "+5",
      size = {WinsColW, 20},
      --anchors = {LEFT = {"RIGHT", "RatingTitle", 0, 0}},
      anchors = {BOTTOM = {"TOP", "Stats.LadderTab.Row1.WinsTxt", 0, -9}},
      str = TEXT("wins1v1txt"),
      font = "Verdana,10b",
      color = ladderclr2,
    },
    
    LossesTitle =  uitext {
      layer = "+5",
      size = {LossesColW, 20},
      --anchors = {LEFT = {"RIGHT", "WinsTitle", 0, 0}},
      anchors = {BOTTOM = {"TOP", "Stats.LadderTab.Row1.LossesTxt", 0, -9}},
      str = TEXT("losses1v1txt"),
      font = "Verdana,10b",
      color = ladderclr2,
    },            
    
    Sepline1 = uiimg {
      size = {1,505},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 60, 3, 60},
      anchors = {TOPLEFT = {"TOPLEFT", "Frame", RankColW+12, 29}},
    },	  
    
    Sepline2 = uiimg {
      size = {1,505},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 60, 3, 60},
      --anchors = {TOPLEFT = {"TOPRIGHT", "Frame", -LossesColW-12, 25}},
      anchors = {TOPLEFT = {"TOPLEFT", "Sepline1", PlayerColW+12, 0}},
    },	  
    
    Sepline3 = uiimg {
      size = {1,505},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 60, 3, 60},
      anchors = {TOPLEFT = {"TOPLEFT", "Sepline2", RatingColW+12, 0}},
    },	  
    
    Sepline4 = uiimg {
      size = {1,505},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 60, 3, 60},
      anchors = {TOPLEFT = {"TOPLEFT", "Sepline3", WinsColW+12, 0}},
    },	              
    
    Sepline5 = uiimg {
      size = {600,30},
      layer = "+5",
      texture = "data/textures/ui/stats_horizont_line_6-n.dds", 
      coords = {0,0,256,6},
      tiled = {60, 3, 60, 3},    
      anchors = {TOP = {"BOTTOM", "Stats.LadderTab.Row20", 0, 20}},
    },	              


    MiniSepline1 = uiimg {
      size = {1,25},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 5, 3, 5},
      anchors = {TOPLEFT = {"TOPLEFT", "PlayerRow", RankColW+12, 0}},
    },	  
    
    MiniSepline2 = uiimg {
      size = {1,25},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 5, 3, 5},
      --anchors = {TOPLEFT = {"TOPRIGHT", "Frame", -LossesColW-12, 25}},
      anchors = {TOPLEFT = {"TOPLEFT", "MiniSepline1", PlayerColW+12, 0}},
    },	  
    
    MiniSepline3 = uiimg {
      size = {1,25},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 5, 3, 5},
      anchors = {TOPLEFT = {"TOPLEFT", "MiniSepline2", RatingColW+12, 0}},
    },	  
    
    MiniSepline4 = uiimg {
      size = {1,25},
      layer = "+5",
      texture = "data/textures/ui/stats_vertical_line_6-n.dds", 
      coords = {0,0,6,256},
      tiled = {3, 5, 3, 5},
      anchors = {TOPLEFT = {"TOPLEFT", "MiniSepline3", WinsColW+12, 0}},
    },	


    PlayerRow = DefLadderRow {
      index = 0,
      anchors = {TOP = {"BOTTOM", "Sepline5", 0, -10}},
    },
    
    LadderGetTxt = uitext {
      layer = "+5",
      hidden = true,
      anchors = { BOTTOM = {"BOTTOM", 0, -20}},
      size = {300, 25},
      str = TEXT("ladder_get"),
      font = "Verdana,11",
      color = {200, 200, 200},
    },
    
    PrevBtn = DefButton {
      layer = "+5",
      anchors = { BOTTOMLEFT = {"BOTTOMLEFT", 20, -20}},
      size = {120,26},
      str = "<",
      OnClick = function(this)
        if this:GetParent().startpos - ladderrows >= 0 then
          this:GetParent().startpos = this:GetParent().startpos - ladderrows
          net.Competition_GetRankings(this:GetParent().startpos, ladderrows, "ARENA_ELO_RATING_1V1")
          this:GetParent().LadderGetTxt:Show()
        end
      end,
    },    

    NextBtn = DefButton {
      layer = "+5",
      anchors = { BOTTOMRIGHT = {"BOTTOMRIGHT", -20, -20}},
      size = {120,26},
      str = ">",
      OnClick = function(this)
        if this:GetParent().startpos + ladderrows < lastladderpos then
          this:GetParent().startpos = this:GetParent().startpos + ladderrows
          net.Competition_GetRankings(this:GetParent().startpos, ladderrows, "ARENA_ELO_RATING_1V1")
          this:GetParent().LadderGetTxt:Show()
        end
      end,
    },    

    
    OnShow = function(this)
      --this.Sepline1:SetAnchor("TOP", this.Row1.RankTxt, "TOPRIGHT", {15, 0})
      --this.Sepline1:AddAnchor("BOTTOM", this.Row20.RankTxt, "BOTTOMRIGHT", {15, 0})
      
      this.startpos = 0
      
      this.PlayerRow.RankTxt:SetStr("N/A")
      this.PlayerRow.RatingTxt:SetStr("N/A")
      this.PlayerRow.WinsTxt:SetStr("N/A")
      this.PlayerRow.LossesTxt:SetStr("N/A")
      this.PlayerRow.PlayerTxt:SetStr(net.Lobby_GetPlayerName())
      this.PlayerRow.LightBox:SetColor({255,255,255, 6})
      this.PlayerRow:SetClr(playerclr)
      
      --net.Competition_GetPlayerRankings(net.Lobby_GetPlayerName(), 0, 1, "ARENA_ELO_RATING_1V1")
      net.Competition_GetPlayerRankings(nil, 0, 1, "ARENA_ELO_RATING_1V1")
      net.Competition_GetRankings(this.startpos, ladderrows, "ARENA_ELO_RATING_1V1")
      this:RegisterEvent("PLAYER_STATS")      
      this.LadderGetTxt:Show()
      for idx = 1, ladderrows do
        this["Row"..idx]:Hide()
      end
    end,
    
    OnEvent = function(this, event)
      if event == "PLAYER_STATS" then
        local counter = 0
        
        for kk, vv in pairs(argPlayers) do
          counter = counter + 1
        end

        if counter == 0 then return end
        
        local rat = 0
        if counter == 1 then        
          for kk, vv in pairs(argPlayers) do
            if kk and string.lower(kk) == string.lower(net.Lobby_GetPlayerName()) then
              for k,v in pairs(vv) do
                if k == "row" then
                  this["PlayerRow"].RankTxt:SetStr(v)
                elseif k == "ARENA_ELO_RATING_1V1" then
                  this["PlayerRow"].RatingTxt:SetStr(v)
                  rat = v
                elseif k == "STAT_PLAYER_1V1_WINS" then
                  this["PlayerRow"].WinsTxt:SetStr(v)
                elseif k == "STAT_PLAYER_1V1_LOSSES" then
                  this["PlayerRow"].LossesTxt:SetStr(v)
                end
              end
              if rat.."" == "0" then
                this["PlayerRow"].RankTxt:SetStr("N/A")
                this["PlayerRow"].RatingTxt:SetStr("N/A")
                --this["PlayerRow"].LossesTxt:SetStr("N/A")
                --this["PlayerRow"].WinsTxt:SetStr("N/A")
              end          
              break
            end
          end
          return
        end
      
        local startrow = this.startpos + 1
        
        local biggestidx = 0

        for kk, vv in pairs(argPlayers) do
          if kk then
            for k,v in pairs(vv) do
              if k == "row" then
                local i = v - startrow + 1
                if i <= ladderrows and i > 0 then
                  if biggestidx < i then
                    biggestidx = i
                  end
                  for k1,v1 in pairs(vv) do
                    if k1 == "row" then
                      this["Row"..i].RankTxt:SetStr(v1)
                    elseif k1 == "ARENA_ELO_RATING_1V1" then
                      this["Row"..i].RatingTxt:SetStr(v1)
                    elseif k1 == "STAT_PLAYER_1V1_WINS" then
                      this["Row"..i].WinsTxt:SetStr(v1)
                    elseif k1 == "STAT_PLAYER_1V1_LOSSES" then
                      this["Row"..i].LossesTxt:SetStr(v1)
                    end
                  end
                  this["Row"..i].PlayerTxt:SetStr(kk)
                  this["Row"..i]:Show()
                  
                  if kk and string.lower(kk) == string.lower(net.Lobby_GetPlayerName()) then
                    this["Row"..i].PlayerTxt:SetStr(net.Lobby_GetPlayerName())
                    this["Row"..i]:SetClr(playerclr)
                  elseif this["Row"..i].index % 2 == 1 then
                    this["Row"..i]:SetClr(ladderclr1)
                  else 
                    this["Row"..i]:SetClr(ladderclr2)
                  end
                  
                  break
                end
              end
            end
          end
        end
        
        if biggestidx ~= 0 then
          for idx = biggestidx + 1, ladderrows do
            this["Row"..idx]:Hide()
          end
        end
        
        this.LadderGetTxt:Hide()
      end
    end,
  },
  
-----------------------------
  
  PlayerStatsTab = uiwnd {
    hidden = true,
    mouse = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TabLadder", 0, 0 }, BOTTOMRIGHT = { "Frame", -10,-12 } },

    Frame = DefHRFrameImage2{},

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
        local rat = 0
        for kk, vv in pairs(argPlayers) do
          if kk and string.lower(kk) == string.lower(net.Lobby_GetPlayerName()) then
            for k,v in pairs(vv) do
              if k == "row" then
                this.Rank1v1DM.StatPanel.Text:SetStr(v)
              elseif k == "ARENA_ELO_RATING_1V1" then
                this.Rating1v1DM.StatPanel.Text:SetStr(v)
                rat = v
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
        
        if rat.."" == "0" then
          this.Rank1v1DM.StatPanel.Text:SetStr("N/A")
          this.Rating1v1DM.StatPanel.Text:SetStr("N/A")
          --this.Wins1v1DM.StatPanel.Text:SetStr("N/A")
          --this.Losses1v1DM.StatPanel.Text:SetStr("N/A")          
        end
      end
    end,
  },
}

function Stats:OnShow()
  this.TabLadder.wnd = this.LadderTab
  this.TabPlayerStats.wnd = this.PlayerStatsTab
  
  if not net.GLIsGameSpyLobby() then
    this.TabLadder.disabled = true
    this.TabLadder:SelectTab(false)
  else  
    this.TabLadder.disabled = nil
    this.TabLadder:SelectTab(false)
  end
  
  if not this.currtab then
    if this.TabLadder.disabled then
      --this.TabPlayerStats:OnClick()
      this:OnTabClick(this.TabPlayerStats)
    else
      --this.TabLadder:OnClick()
      this:OnTabClick(this.TabLadder)
    end
  end
  
  Lobby.StatsBtn.checked = 1
  Lobby.StatsBtn:updatetextures()
end

function Stats:OnHide()
  Lobby.StatsBtn.checked = 0
  Lobby.StatsBtn:updatetextures()
  
--  if this.cur_tab then
--    this.curr_tab:SelectTab(false)
--    this.cur_tab = nil
--  end
end

function Stats:OnTabClick(tab)
  if this.curr_tab then
    if this.curr_tab == tab then
      --return
    else
      this.curr_tab:SelectTab(false)
      this.curr_tab.wnd:Hide()
    end
  end
  
  this.curr_tab = tab
  this.curr_tab:SelectTab(true)
  this.curr_tab.wnd:Show()
end



local function CreateLadderRows()
  local dx,dy = 0,0
  local rows = ladderrows
  local offx,offy = 0,35
	local r
	
	for r = 1, rows do
		local row = DefLadderRow{}
		row.index = r
		
	  if r == 1 then
		  row.anchors = { TOP = {offx,offy} }
	  else
      row.anchors = { TOP = {"Row" .. (r-1), "BOTTOM", dx, dy} } 
    end	
    
    Stats.LadderTab["Row"..r] = row
	end
	Stats.LadderTab:CreateChildren()
end

CreateLadderRows()