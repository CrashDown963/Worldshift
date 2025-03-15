--                                                                                             
-- VICTORY SCREEN                                                                              
--                                                                                             

LocationUnlocked = uiwnd {
  hidden = true,
  size = {580,450},
  layer = 10000,

  dark = uiwnd {
    mouse = true,
    keyboard = true,
    layer = "-5",
    anchors = { TOPLEFT = { "DESKTOP", 0,0 }, BOTTOMRIGHT = { "DESKTOP", 0,0 } },
    uiimg {
      texture = "data/textures/ui/black.dds",
      alpha = 0.6,
      shader = "_Misc_IDBB",
    },
  },
  
  LocationImage = uiimg {
    layer = "+2",
    size = {560,170},
    coords = {0,0,560,170},
    anchors = { TOP = { 0,10 } }, 
  },

  UnlockedText = uitext {
    layer = "+3",
    size = {500,30},
    color = {255, 143, 51},
    font = "Trebuchet MS,18b",
    shadow_ofs = {1,1},
    anchors = { CENTER = { "LocationImage", 0,0 } }, 
    str = "<p>"..TEXT("location_unlocked"),
  },

  LocationName = uitext {
    layer = "+2",
    size = {560,30},
    color = {255, 255, 255},
    font = "Trebuchet MS,18b",
    shadow_ofs = {1,1},
    anchors = { TOP = { "BOTTOM", "LocationImage", 0,7 } }, 
  },
  
  LocationDescr = uitext {
    layer = "+2",
    size = {540,130},
    color = {182, 179, 172},
    font = "Tahoma,11",
    halign = "LEFT",
    valign = "TOP",
    shadow_ofs = {1,1},
    auto_adjust_height = true,
    anchors = { TOP = { "BOTTOM", "LocationName", 0,5 } },
  },

  Frame = DefBigBackImage { 
    layer = "+1",
    anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "LocationDescr", 20,60 } },
  },

  Close = DefButton {
    layer = "+2",
    size = {150,25},
    str = TEXT("close"),
    anchors = { BOTTOMRIGHT = { "Frame", -20,-20 } },
    OnClick = function(this) this:GetParent():Hide() end,
  },

  OnShow = function(this)
    local title = game.GetMapTitle(this.map)
    this.LocationName:SetStr("<p>"..title)
    local descr = "<p>"..TEXT{"briefings."..string.sub(this.map, 10)}
    this.LocationDescr:SetStr("<p>"..descr)
    local fname = "data/textures/ui/maps/"..string.sub(this.map, 10).."_small.bmp"
    this.LocationImage:SetTexture(fname)
  end,
}

--
local ShowTooltip = function(ui)
  if not ui then Tooltip:Hide() return end

  Tooltip:AttachTo(ui, ui.tt_anc1, ui, ui.tt_anc2, ui.tt_offs)
  
  Tooltip.Title:SetStr(ui.tt_title)
  Tooltip.Text:SetStr("<p>"..ui.tt_text)
  local sz = Tooltip:GetSize()
  Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
  Tooltip:Show()
end

local	DefRewSlot = Inventory.DefItemSlot { 
  virtual = true,
  repo = "REWARDS",
  
  ItemMoveNif = uinif {
    layer = "+10",
    hidden = true,
    size = {10,10},
    nif = "Data/Models/MiscObjects/Interface_item_effect.nif",
    anchors = {CENTER = {2, 0}},
    scale = 0.35,
  },	    
  
  OnShow = function(this) this:UpdateFrame() end,
}

local	DefMissionSlot = Inventory.DefItemSlot { 
  virtual = true,
  repo = "MISSION",
  
  SelImage = uiimg {
    layer = "+3",
    hidden = true,
    size = {57,57},
    texture = "data/textures/ui/reward_chosen.dds",
    coords = {0,0,64,64},
  },
  OnLoad = function(this) Inventory.DefItemSlot_OnLoad(this) end,
  --OnMouseDown = function(this)
    --if this:GetItem() then
      --this:GetParent():OnItemSelect(this)
    --end
  --end,
  OnMouseDown = function(this)
    local item = this:GetItem()
    if item then
      local res = this:MoveItem("REWARDS")
      if res and res > 0 then
        Victory.Items["Slot"..res].ItemMoveNif:Show()
        game.PlaySnd(sounds.item_take) 
        Victory.Items.animslot = Victory.Items["Slot"..res]
        Transitions:CallOnce(function() Victory.Items:StopAnim() end, 0.767)
        Victory.ChooseMissionReward.rewardtaken = 1
      end
    
      this:GetParent():Hide()
      Victory.Items:SetSize{Victory.Items.size_big[1], Victory.Items.size_big[2]}
      Victory.Items.DestroyTxt:Show()
      Victory.Items.Sepline:Show()          
    end
  end,
}

local	DefPVPSlot = Inventory.DefItemSlot { 
  virtual = true,
  repo = "PVP",
  
  ItemMoveNif = uinif {
    layer = "+10",
    hidden = true,
    size = {10,10},
    nif = "Data/Models/MiscObjects/Interface_item_effect.nif",
    anchors = {CENTER = {2, 0}},
    scale = 0.35,
  },	    
  
  
  SelImage = uiimg {
    layer = "+3",
    hidden = true,
    size = {57,57},
    texture = "data/textures/ui/reward_chosen.dds",
    coords = {0,0,64,64},
  },
  OnLoad = function(this) Inventory.DefItemSlot_OnLoad(this) end,
  --OnMouseDown = function(this)
  --  if this:GetItem() then
  --    this:GetParent():OnItemSelect(this)
  --  end
  --end,
  
  
  OnMouseDown = function(this)
    if this:GetItem() then
      local quality = this:GetItem().quality
      local res = this:MoveItem("REWARDS")
      if res and res > 0 then
        Victory.ChoosePVPReward:UpdateBPText()
        Victory.Items["Slot"..res].ItemMoveNif:Show()
        game.PlaySnd(sounds.item_take) 
        Victory.Items.animslot = Victory.Items["Slot"..res]
        Transitions:CallOnce(function() Victory.Items:StopAnim() end, 0.767)
        Victory.ChoosePVPReward.animslot = this
        Transitions:CallOnce(function() Victory.ChoosePVPReward:PVPRewFillEmptySlot() end, 0.5)
            
        Victory.ChoosePVPReward.qualitytofill = quality
      else
        MessageBox:Alert(TEXT{"buyfailed"}, TEXT{"buyfailed_ttl"})
      end
    end
  end,
}


StatBase = uiwnd {
  virtual = true,
  size = {1,105},
  layer = "+1",
  
  TitleFrame = uiwnd {                                          
    size = {1,30},
	  anchors = { TOPLEFT = { 0, 0 }, TOPRIGHT = { 0, 0} },
	  
    Icon = uiimg {
      texture = "data/textures/ui/status_icons.dds",
      anchors = {LEFT = { 0, 0 }},
      coords = {0, 0, 42, 42},    
      size = {42, 42}, 
    },	  
	  
    Frame = uiimg {
      texture = "data/textures/ui/stat_black_back.dds",
      anchors = {LEFT = {"RIGHT", "Icon", -2, 0}},
      coords = {0, 0, 227, 29},
      size = {227, 29},
    },
    
    Title = uitext {
      layer = "+1",
      size = {270,30},
      anchors = { CENTER = { "CENTER", "Frame", 0,0 } },
      --anchors = { LEFT = { "RIGHT", "Icon", 4 ,0 } },
      color = {255, 143, 51},
  	  font = "Tahoma,12b",
    },
  },
    
  Top1Score = uitext {
    layer = "+1",
    size = {120, 20},
    anchors = { TOPRIGHT = { "BOTTOMLEFT", "TitleFrame", 110, 5}},
    --anchors = { LEFT = { "RIGHT", "Icon", 5, 0}},
    halign = "RIGHT", 
    font = "Tahoma,12",
  },

  Top1Player = uitext {
    layer = "+1",
    size = {220, 20},
    anchors = { LEFT = { "RIGHT", "Top1Score", 10, 0}}, 
    halign = "LEFT", 
    font = "Tahoma,12",
  },   
 
  Top2Score = uitext {
    layer = "+1",
    size = {120, 20},
    anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Top1Score", 0, 5}}, 
    halign = "RIGHT", 
    font = "Tahoma,12",
  },

  Top2Player = uitext {
    layer = "+1",
    size = {220, 20},
    anchors = { LEFT = { "RIGHT", "Top2Score", 10, 0}}, 
    halign = "LEFT", 
    font = "Tahoma,12",
  }, 
 
  Top3Score = uitext {
    layer = "+1",
    size = {120, 20},
    anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Top2Score", 0, 5}}, 
    halign = "RIGHT", 
    font = "Tahoma,12",
  },

  Top3Player = uitext {
    layer = "+1",
    size = {220, 20},
    anchors = { LEFT = { "RIGHT", "Top3Score", 10, 0}}, 
    halign = "LEFT", 
    font = "Tahoma,12",
  },    
  
  Sepline1 = uiimg {
    layer = "+1",
    size = {240,30},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    anchors = { TOP = { 0, 55 } },
    tiled = {60, 3, 60, 3},
  },   
  
  Sepline2 = uiimg {
    layer = "+1",
    size = {240,30},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    anchors = { TOP = { 0, 81 } },
    tiled = {60, 3, 60, 3},
  },   

 
  OnShow = function(this)
    local tbl = game.GetOutcomeStats(this.index)
    local idx = 1
    for i,v in ipairs(tbl) do
      local score = this["Top"..i.."Score"] 
      
      local clr = game.GetPlayerColorByName(v.name)
      score:SetStr("<p>"..v.value)
      score:SetColor(clr)
      score:Show()

      local player = this["Top"..i.."Player"]
      player:SetColor(clr)
      player:SetStr("<p>"..v.name)
      player:Show()
      idx = idx + 1

      if i == 3 then break end
    end
    for i = idx,3 do
      this["Top"..i.."Score"]:Hide()
      this["Top"..i.."Player"]:Hide()
    end
    this.TitleFrame.Title:SetStr("<p>"..this.TitleString)
    this.TitleFrame.Icon:SetTexture(nil, {(this.index - 1) * 42,0,this.index * 42,42})
  end,
}

Victory = uiwnd {
  keyboard = true,
  mouse = true,
  observe = false,

  size_big = {610, 720},
  size_small = {610, 408},

  Frame = DefBigBackImage{size = {610, 720}, anchors = { TOPLEFT = {10, 120}}},
  --Frame = DefBigBackImage{size = {610, 720}, anchors = { LEFT = {10, 0}}},
  
  Stats = uiwnd {
    hidden = true,
    size = {586, 380},
    anchors = { TOPLEFT = {22, 134}}, 
	  
	  Frame = DefSmallBackImage {},
	  
	  Title = uitext {
	    layer = "+1",
      size = {280,20},
      color = {255, 143, 51},
      anchors = { TOP = { 0,6 } },
  	  font = "Verdana,11b",
  	  str = TEXT{"stats_caps"},
	  },
	  
    Sepline = uiimg {
      size = {30,300},
      layer = "+ 1",
      texture = "data/textures/ui/stats_vertical_line_6.dds", 
      coords = {0,0,6,256},
      anchors = { TOP = {3, 40 } },
      tiled = {3, 60, 3, 60},
    },	  
	  
	  BestDamageStat = StatBase {
	    TitleString = TEXT("best_damage"),
	    index = 1,
	    anchors = {TOPLEFT = {5, 42}, TOPRIGHT = { "TOP", "Frame", -5, 42 }},
	  },

	  BestHealingStat = StatBase {
	    TitleString = TEXT("best_healing"),
	    index = 2,
	    anchors = {LEFT = {"RIGHT", "BestDamageStat", 5, 0}, TOPRIGHT = { "TOPRIGHT", "Frame", -5, 42 }},
	  },

	  MostKillsStat = StatBase {
	    TitleString = TEXT("most_kills"),
	    index = 3,
	    anchors = {TOPLEFT = {"BOTTOMLEFT", "BestDamageStat", 0, 5}, TOPRIGHT = {"BOTTOMRIGHT", "BestDamageStat", 0, 5}},
	  },

	  MostDeathsStat = StatBase {
	    TitleString = TEXT("most_deaths"),
	    index = 4,
	    anchors = {TOPLEFT = {"BOTTOMLEFT", "BestHealingStat", 0, 5}, TOPRIGHT = {"BOTTOMRIGHT", "BestHealingStat", 0, 5}},
	  },

	  MostCommandsStat = StatBase {
	    TitleString = TEXT("most_commands"),
	    index = 5,
	    anchors = {TOPLEFT = {"BOTTOMLEFT", "MostKillsStat", 0, 5}, TOPRIGHT = {"BOTTOMRIGHT", "MostKillsStat", 0, 5}},
	  },

	  DamageTakenStat = StatBase {
	    TitleString = TEXT("damage_taken"),
	    index = 6,
	    anchors = {TOPLEFT = {"BOTTOMLEFT", "MostDeathsStat", 0, 5}, TOPRIGHT = {"BOTTOMRIGHT", "MostDeathsStat", 0, 5}},
	  },
  },
  
  MissionTime = uiwnd {
    hidden = true,
    size = {586, 380},
    anchors = { TOPLEFT = {22, 134}},
	  
	  Frame = DefSmallBackImage {},
	  
	  Title = uitext {
	    layer = "+1",
      size = {400,20},
      color = {255, 143, 51},
      anchors = { TOP = { 0,6 } },
  	  font = "Tahoma,12b",
	  },
	  
	  MissionPic = uiimg {
	    size = {560,300},
	    anchors = {CENTER = {0, 13}},
	  },
	  
	  CurTimeBack = uiimg {
	    layer = "+1",
	    size = {480, 55},
	    anchors = {TOP = {0, 105}},
	    texture = "data/textures/ui/Time_back.dds",
	    coords = {0,0,480,42},
	  },
	  
	  CurTimeTitle = uitext {
	    layer = "+2",
      size = {320, 35},
      anchors = { CENTER = {"CENTER", "CurTimeBack", 0, 0}}, 
      color = {0, 0, 0},
      font = "Tahoma,20b",
      str = TEXT("cur_time"),
    },

	  CurTime = uitext {
	    layer = "+2",
      size = {320, 60},
      anchors = { TOP = { "BOTTOM", "CurTimeBack", 0, -13}},
      color = {255, 255, 255, 255}, 
      font = "Tahoma,29b",
    },

	   FastestTimeBack = uiimg {
	    layer = "+1",
	    size = {430, 90},
	    anchors = { TOP = { "BOTTOM", "CurTimeBack", 0, 65}}, 
	    texture = "data/textures/ui/Time_back_dark.dds",
	    coords = {0,0,400,80},
	  },

	  FastestTimeTitle = uitext {
	    layer = "+2",
      size = {320, 40},
      anchors = { TOP = { "TOP", "FastestTimeBack", 0, 15}}, 
      font = "Tahoma,15b",
      color = {142,142,141},
      str = TEXT("fastest_time"),
    },

	  FastestTime = uitext {
	    layer = "+2",
      size = {320, 42},
      anchors = { TOP = { "TOP", "FastestTimeBack", 0, 38}}, 
      font = "Tahoma,16b",
      color = {172,172,171},
    },
	  
    OnShow = function(this)
      local tbl = game.GetMissionTime()
      if game.PlayerWins() then
        this.Title:SetStr(TEXT("mis_complete_caps"))
      else
        this.Title:SetStr(TEXT("mis_failed_caps"))
      end
      
      if tbl and tbl.show_fastest then
        this.FastestTimeTitle:Show()
        this.FastestTime:Show()
      else
        this.FastestTimeTitle:Hide()
        this.FastestTime:Hide()      
      end
      
      if tbl then
        if tbl.record then
          this.FastestTimeTitle:SetStr("<p>"..TEXT("old_fastest"))
        else
          this.FastestTimeTitle:SetStr("<p>"..TEXT("fastest_time"))
        end
        
        this.CurTime:SetStr("<p>"..tbl.curr_time)
        this.FastestTime:SetStr("<p>"..tbl.fast_time)
      end  
      
      --local fname = "data/textures/ui/maps/"..tbl.map.."_big.bmp"
      local nn = game.GetMapName() or "missions/35"
      local fname = "data/textures/ui/maps/".. string.sub(nn, 9).."_big.bmp"
      this.MissionPic:SetTexture(fname)
      
    end,	  
  },
  
  Items = uiwnd {
    size_small = {586,165},
    size_big = {586, 308},
    hidden = true,
    size = {586, 308},
    anchors = { TOP = {"BOTTOM", "MissionTime", 0, 5}},
    animslot = nil,
	  
	  Frame = DefSmallBackImage {},
	  
	  Title = uitext {
	    layer = "+1",
      size = {400,20},
      color = {255, 143, 51},
      anchors = { TOP = { 0,6 } },
  	  font = "Tahoma,12b",
  	  str = TEXT{"items_taken_caps"},
	  },
	  
	  DestroyTxt = uitext {
	    layer = "+1",
      size = {600,200},
      color = {142,142,141},
      anchors = { TOP = { 0, 130 } },
  	  font = "Tahoma,14",
  	  str = TEXT{"drag_txt"},	  
	  },
	  
	  
	  ShardImg = uiwnd {
	    layer = "+1",
      size = {128, 128},
      anchors = { TOPLEFT = { 6, 33 } },
  	  Img = uiimg {
	      texture = "data/textures/ui/shards_big.dds",
	      coords = {0, 0, 128, 128},	    
	    },
  	  
  	  mouse = true,
  	  tt_title = TEXT("shards_tt_title"),
  	  tt_text = TEXT("shards_tt_text"),
  	  tt_anc1 = "BOTTOMLEFT",
  	  tt_anc2 = "TOPLEFT",
  	  tt_offs = {0,0},
  	  OnMouseEnter = function(this) ShowTooltip(this) end,
  	  OnMouseLeave = function(this) ShowTooltip() end,
	  },	
	  	  
	  ShardNumTxt = uitext {
	    layer = "+1",
      size = {30,40},
      color = {112,119,233},
      anchors = { TOPRIGHT = {"TOPRIGHT","ShardImg", -8, 0 } },
  	  font = "Tahoma,16b",
  	  --halign = "RIGHT", 
	  },

    Sepline = uiimg {
      size = {199,2},
      texture = "data/textures/ui/stats_horizont_line.dds", 
      coords = {0,0,256,2},
      anchors = { TOP = { 0,170 } },
    },   

	  Dim = Lobby.Dim { hidden = true, },
	  DragCatch = Lobby.DragCatch { hidden = true, },
	  
	  StopAnim = function(this)
	    if this.animslot then
	      this.animslot.ItemMoveNif:Hide()
	      this.animslot = nil
	    end
	  end,
	  
	  OnShow = function(this)
      local num_shards = game.GetPlayerAcquiredShards()
      this.ShardNumTxt:SetStr("<p>"..num_shards)
	  end,
  },  
  
  ChooseMissionReward = uiwnd {
    hidden = true,
    size = {586, 140},
    anchors = { TOP = {"BOTTOM", "Items", 0, 5}},
    rewardtaken = 0,
	  
	  Frame = DefSmallBackImage {},
	  
	  Title = uitext {
	    layer = "+1",
      size = {400,20},
      color = {255, 143, 51},
      anchors = { TOP = { 0,6 } },
  	  font = "Tahoma,12b",
  	  str = TEXT{"chs_reward_caps"},
	  },

	  Rew2 = DefMissionSlot {
	    index = 2,
	    anchors = { TOP = { 0, 40 } },
	  },
	 
	  Rew1 = DefMissionSlot {
	    index = 1,
	    anchors = { RIGHT = { "LEFT", "Rew2", -15, 0 } },
	  },

	  Rew3 = DefMissionSlot {
	    index = 3,
	    anchors = { LEFT = { "RIGHT", "Rew2", 15, 0 } },
	  },
   
    RewardChsTxt = uitext {
	    layer = "+1",
      size = {540,50},
      color = {143,143,143},
      anchors = { TOP = { "BOTTOM", "Rew2", 0, 0 } },
  	  font = "Tahoma,11",
  	  str = TEXT("reward_chs_txt"),    
    },   
   
    TakeBtn = DefButton {
      hidden = true,
      anchors = { BOTTOM = {"BOTTOM", 0, -8}},
      size = {120,26},
      str = TEXT("take_btn"),
      OnClick = function(this)
        local item = this:GetParent().selected
        if item then
          local res = item:MoveItem("REWARDS")
          if res and res > 0 then
            Victory.Items["Slot"..res].ItemMoveNif:Show()
            game.PlaySnd(sounds.item_take) 
            Victory.Items.animslot = Victory.Items["Slot"..res]
            Transitions:CallOnce(function() Victory.Items:StopAnim() end, 0.767)
          end
          --item:MoveItem("REWARDS")
          this:GetParent():Hide()
          Victory.Items:SetSize{Victory.Items.size_big[1], Victory.Items.size_big[2]}
          Victory.Items.DestroyTxt:Show()
          Victory.Items.Sepline:Show()          
        end
      end,
    },
    
	  --Dim = Lobby.Dim { hidden = true, },
	  --DragCatch = Lobby.DragCatch { hidden = true, },
	  
    OnShow = function(this)
      this.rewardtaken = 0
      if this.selected then
        this.selected.SelImage:Hide()
        this.selected = nil
      end
    end,	  

    OnItemSelect = function(this, item)
      if this.selected then
        this.selected.SelImage:Hide()
      end
      this.selected = item
      this.selected.SelImage:Show()
    end,
  },    
  
  
  ChoosePVPReward = uiwnd {
    hidden = true,
    size = {586, 140},
    anchors = { TOP = {"BOTTOM", "Items", 0, 5}},
	  animslot = nil,
	  qualitytofill = 1,
	  
	  Frame = DefSmallBackImage {},
	  
	  Title = uitext {
	    layer = "+1",
      size = {400,20},
      color = {255, 143, 51},
      anchors = { TOP = { 0,6 } },
  	  font = "Tahoma,12b",
  	  str = TEXT{"items_shop"},
	  },
	  
	  BattlePointsTxt = uitext {
	    layer = "+1",
      size = {160,20},
      color = {234,223,178},
      anchors = { TOPLEFT = { 15, 39 } },
  	  font = "Tahoma,13",
  	  halign = "LEFT",
  	  str = TEXT("battle_points")
	  },	  

	  BattlePointsNum = uiwnd {
	    layer = "+1",
      size = {120,120},
      anchors = { TOPLEFT = { 4, 40 } },
      text = uitext {
        color = {237,192,23},
        shadow_ofs = {2,2},
  	    font = "Trebutchet MS,35b",
  	  },
  	  
  	  mouse = true,
  	  tt_title = TEXT("battle_pts_tt_title"),
  	  tt_text = TEXT("battle_pts_tt_text"),
  	  tt_anc1 = "BOTTOMLEFT",
  	  tt_anc2 = "TOPLEFT",
  	  tt_offs = {0,0},
  	  OnMouseEnter = function(this) ShowTooltip(this) end,
  	  OnMouseLeave = function(this) ShowTooltip() end,
	  },	  

    Sepline = uiimg {
      size = {2,90},
      layer = "+ 1",
      texture = "data/textures/ui/stats_vertical_line.dds", 
      coords = {0,0,2,256},
      anchors = { TOP = {"TOPRIGHT", "BattlePointsTxt", -50, 0 } },
    },	 

	  Rew1 = DefPVPSlot {
	    index = 1,
	    ind = 1,
	    anchors = { TOPLEFT = { "TOPRIGHT", "Sepline", 73, 0 } },
	  },

	  Rew2 = DefPVPSlot {
	    index = 3,
	    ind = 3,
	    anchors = { LEFT = { "RIGHT", "Rew1", 15, 0 } },
	  },
	 
	  Rew3 = DefPVPSlot {
	    index = 5,
	    ind = 5,
	    anchors = { LEFT = { "RIGHT", "Rew2", 15, 0 } },
	  },
	  
	  Rew4 = DefPVPSlot {
	    index = 4,
	    ind = 4,
	    anchors = { LEFT = { "RIGHT", "Rew3", 15, 0 } },
	  },

	  Rew5 = DefPVPSlot {
	    index = 2,
	    ind = 2,
	    anchors = { LEFT = { "RIGHT", "Rew4", 15, 0 } },
	  },	  
	  

    ChangeOfferBtn = DefButton {
      size = {120,26},
      layer = "+1",
      --anchors = { TOP = {"BOTTOM", "Rew1", 0, 17}},
      anchors = { RIGHT = {"LEFT", "SkipLostBtn", -10, 0}},
      str = TEXT("chg_off_btn"),
      
      OnClick = function(this)
        if game.RerollPVPItemsOffer() == 1 then
          local par = this:GetParent()
          par:UpdateBPText()
        else
          MessageBox:Alert(TEXT{"no_bpoints"}, TEXT{"no_bpoints_ttl"})
        end
      end,
    },

    BuyBtn = DefButton {
      hidden = true,
      size = {120,26},
      layer = "+1",
      anchors = { LEFT = {"RIGHT", "ChangeOfferBtn", 10, 0}},
      str = TEXT("buy_btn"),
      qualitytofill = 1,
      
      OnClick = function(this)
        local itemSlot = this:GetParent().selected
        if itemSlot then
          local quality = itemSlot:GetItem().quality
          local res = itemSlot:MoveItem("REWARDS")
          if res and res > 0 then
            --game.AddPVPItem(quality)
            this:GetParent():UpdateBPText()
            itemSlot.SelImage:Hide()
            this:GetParent().selected = nil
            Victory.Items["Slot"..res].ItemMoveNif:Show()
            game.PlaySnd(sounds.item_take) 
            Victory.Items.animslot = Victory.Items["Slot"..res]
            Transitions:CallOnce(function() Victory.Items:StopAnim() end, 0.767)
            this:GetParent().animslot = itemSlot
            Transitions:CallOnce(function() this:GetParent():PVPRewFillEmptySlot() end, 0.5)
            
            this.qualitytofill = quality
            --par.Rew1:Show() par.Rew2:Show() par.Rew3:Show() par.Rew4:Show() par.Rew5:Show()
            
            --this:GetParent():Hide()
            --Victory.Items:SetSize{Victory.Items.size_big[1], Victory.Items.size_big[2]}
            --Victory.Items.DestroyTxt:Show()
            --Victory.Items.Sepline:Show()          
          else
            MessageBox:Alert(TEXT{"buyfailed"}, TEXT{"buyfailed_ttl"})
          end
        end
      end,      
    },
   
    SkipBtn = DefButton {
      size = {120,26},
      layer = "+1",
      --anchors = { LEFT = {"RIGHT", "BuyBtn", 10, 0}},
      anchors = { BOTTOMRIGHT = {-8, -8}},
      str = TEXT("close"),
      
      OnClick = function(this)
        this:GetParent():Hide()
        Victory.Items:SetSize{Victory.Items.size_big[1], Victory.Items.size_big[2]}
        Victory.Items.DestroyTxt:Show()
        Victory.Items.Sepline:Show()       
      end
    },
    
    LostInfoTxt = uitext {
	    layer = "+1",
      size = {480,50},
      color = {143,143,143},
      anchors = { TOP = { "TOP", "Rew3", 0, 0 } },
  	  font = "Tahoma,12",
  	  str = TEXT("lost_off_txt")    
    },
    
    SkipLostBtn = DefButton {
      size = {120,26},
      layer = "+1",
      anchors = { BOTTOMRIGHT = {-8, -8}},
      str = TEXT("close"),
      
      OnClick = function(this)
        this:GetParent():Hide()
        Victory.Items:SetSize{Victory.Items.size_big[1], Victory.Items.size_big[2]}
        Victory.Items.DestroyTxt:Show()
        Victory.Items.Sepline:Show()       
      end
    },        
    
    GetOfferBtn = DefButton {
      size = {120,26},
      layer = "+1",
      anchors = { RIGHT = {"LEFT", "SkipLostBtn", -10, 0}},
      str = TEXT("get_off_btn"),
      OnClick = function(this)
        if game.RerollPVPItemsOffer() == 1 then
          local par = this:GetParent()
          par:UpdateBPText()
          par.LostInfoTxt:Hide()
          par.GetOfferBtn:Hide()
          par.SkipLostBtn:Hide()
        
          par.Rew1:Show() par.Rew2:Show() par.Rew3:Show() par.Rew4:Show() par.Rew5:Show()
          par.ChangeOfferBtn:Show() 
          --par.BuyBtn:Show()
          par.SkipBtn:Show()   
        else
          MessageBox:Alert(TEXT{"no_bpoints"}, TEXT{"no_bpoints_ttl"})
        end   
      end
    },    
    
    
	  StopAnim = function(this)
	    if this.animslot then
	      this.animslot.ItemMoveNif:Hide()
	      this.animslot = nil
	    end
	  end,    

    PVPRewFillEmptySlot = function(this)
      if not Victory:IsHidden() and not Victory.ChoosePVPReward:IsHidden() then
        --game.AddPVPItem(Victory.ChoosePVPReward.BuyBtn.qualitytofill)
        game.AddPVPItem(Victory.ChoosePVPReward.qualitytofill)
        for i = 1,5 do
          --if Victory.ChoosePVPReward["Rew"..i].ind == Victory.ChoosePVPReward.BuyBtn.qualitytofill then
          if Victory.ChoosePVPReward["Rew"..i].ind == Victory.ChoosePVPReward.qualitytofill then
            Victory.ChoosePVPReward["Rew"..i].ItemMoveNif:Show()
            game.PlaySnd(sounds.item_take) 
            Transitions:CallOnce(function() Victory.ChoosePVPReward:StopAnim() end, 0.767)
            break
          end
        end
      end
    end,  
  
  
	  UpdateBPText = function(this)
      local points = game.GetPlayerBattlePoints()
      --if points < 10 then
      --  this.BattlePointsNum.text:SetStr("<p>0"..points)
      --else
        this.BattlePointsNum.text:SetStr("<p>"..points)
      --end
	  end,
	  
    OnShow = function(this)
      this:UpdateBPText()
      
      if game.PlayerWins() then
        this.LostInfoTxt:Hide()
        this.GetOfferBtn:Hide()
        this.SkipLostBtn:Hide()
        
        this.Rew1:Show() this.Rew2:Show() this.Rew3:Show() this.Rew4:Show() this.Rew5:Show()
        this.ChangeOfferBtn:Show() 
        --this.BuyBtn:Show()
        this.SkipBtn:Show()
      else
        this.LostInfoTxt:Show()
        this.GetOfferBtn:Show()
        this.SkipLostBtn:Show()
        
        this.Rew1:Hide() this.Rew2:Hide() this.Rew3:Hide() this.Rew4:Hide() this.Rew5:Hide()
        this.ChangeOfferBtn:Hide() 
        --this.BuyBtn:Hide()
        this.SkipBtn:Hide()        
      end
      
      if this.selected then
        this.selected.SelImage:Hide()
        this.selected = nil
      end
    end,	  

    OnItemSelect = function(this, item)
      if this.selected then
        this.selected.SelImage:Hide()
      end
      this.selected = item
      this.selected.SelImage:Show()
    end,
  },
  

	Dim = Lobby.Dim { hidden = true, },
	DragCatch = Lobby.DragCatch { hidden = true, },
	
	Result = uitext {
	  layer = 2100,
    size = {600,50},
    font = "Arial,38b",
    anchors = { TOP = { } },
	},
	
	Description = uitext {
	  layer = 2100,
	  hidden = true,
    size = {700,80},
    shadow_ofs = {1,1},
    font = "Arial,17",
    anchors = { TOP = { "BOTTOM", "Result", 0, 0 } },
	},

	CloseBtn = DefButton1 { 
    layer = 2100,
    --size = {120,30},
    anchors = { BOTTOMRIGHT = { -20, -10 } },
  	str = TEXT{"close_caps"},
  },

	ReplayBtn = DefButton1 { 
	  hidden = true,
    layer = 2100,
    --size = {120,30},
    anchors = { RIGHT = { "LEFT", "CloseBtn", -20, 0 } },
  	str = TEXT{"replay"},
  },

	ContinueBtn = DefButton1 { 
	  hidden = true,
    layer = 2100,
    --size = {120,30},
    anchors = { RIGHT = { "LEFT", "ReplayBtn", -20, 0 } },
  	str = TEXT{"continue_caps"},
  },
  
  ModeBtn = DefButton1 { 
    layer = 2100,
    --size = {120,30},
    anchors = { BOTTOMLEFT = { 20, -10 } },
	  str = TEXT{"observe_caps"},
	  OnClick = function(this)
      CollectedItems:Hide()
	    this.observe = not this.observe
	    if this.observe then
        for k,v in pairs(Victory) do
          if type(v) == "table" and v.IsHidden and not v:IsHidden() and v ~= this then
            v.observe_hidden = true
            v:Hide()
          end
        end      
 	      TechGrid:Hide()
 	      this:SetStr(TEXT{"stats_btn_caps"})
        Minimap:Show()
        Chat:Show()
 	    else
 	      TechGrid:SetAnchor("TOPRIGHT", Victory, "TOPRIGHT", {-10, 120 })
        for k,v in pairs(Victory) do
          if type(v) == "table" and v.observe_hidden then
            v.observe_hidden = nil
            v:Show()
          end
        end      
 	      Minimap:Hide()
        Chat:Hide()

 	      TechGrid:Show()
 	      this:SetStr(TEXT{"observe_caps"})
        if game.GetMapType() == "mission" then
          Victory.ReplayBtn:Show()
          if Victory.next and game.PlayerWins() then
            Victory.ContinueBtn:Show()
          else
            Victory.ContinueBtn:Hide()
          end  
        end
 	    end
    end
  },
}


function Victory:OnLoad()
  this:RegisterEvent("MAP_LOADED") 
  this:RegisterEvent("ITEM_DRAGBEGIN")
  this:RegisterEvent("ITEM_DRAGEND")
end

  
function Victory:CloseStuff()
  Victory:Close() 
  if net.Lobby_GetPlayerName() then
    Lobby.PlayersView:Hide()
    if Lobby.currview then
      Lobby.currview:Show()
    end  
    Transitions:Fade(Victory, Lobby)
  else
    --Lobby:OnLeave()
    leaveLobby()
    Transitions:Fade(Victory, Login)
  end
end


function Victory:ContinueStuff()
  local next = Victory.next
	Objectives:Reset() -- mishony
	--game.PlayerQuit() -- mishony
	game.CloseMap()
	TechGrid:Hide()
  Victory:Hide()
  Lobby:StartMission(next)
end

function Victory:ReplayWinStuff()  
  game.EnableUnitSelection(true)
  game.EnableSelection(true)
  Objectives:Reset() -- mishony
  --game.PlayerQuit() -- mishony
  game.CloseMap()
  TechGrid:Hide()
  Victory:Hide()
  Lobby:StartMission(Victory.map)  
end  
  
function Victory.CloseBtn:OnClick()
  local fullslots = 0
  for i = 1,16 do
    if Victory.Items["Slot"..i]:GetItem() then
      fullslots = 1
      break
    end
  end

  if fullslots > 0 then
    MessageBox:Prompt(TEXT("vic_close_items"), TEXT("Alert"), Victory.CloseStuff)
  else
    if net.GLGetGameType() == "mission" and game.PlayerWins() and Victory.ChooseMissionReward.rewardtaken == 0 then
      MessageBox:Prompt(TEXT("vic_close_reward"), TEXT("Alert"), Victory.CloseStuff)
    else
      Victory:CloseStuff()
    end  
  end
end


function Victory:OnEvent(event)
  if event == "MAP_LOADED" then
    Conversation:Reset()
    Objectives:Reset()
    this:Hide()
  end

  if event == "ITEM_DRAGBEGIN" and argSlot then
    this.Dim:SetAnchor("CENTER", argSlot, "CENTER")
    this.Dim:Show()
    this.DragCatch:Show()
  end

  if event == "ITEM_DRAGEND" then
    this.Dim:Hide()
    this.DragCatch:Hide()
  end
end

function Victory:OnShow()
  ConversationButton:Hide()
  ConversationHistory:Hide()
  BossFightWnd.boss = nil
  BossFightWnd:Hide()
  MindDuel.visible = nil
  MindDuel:Stop()
  GameUI:Hide()
  CollectedItems:Hide()
  Stripes:ShowOn()

  local gems, allGems = game.GetPlayerGems()
  this.Items.shards = gems
  this.Items.max_shards = allGems

  game.EnableSelection(false)
  InGameMenu:Hide()
  Conversation:Reset()
  this.unlocked_location = nil
  --Objectives:Reset()
  --if game.PlayerWins() then
    game.PlayerQuit() -- mishony
  --end  
  
  local map = game.GetMapName()
  this.map = map
  
  --local gametype = game.GetMapType()
  local gametype = net.GLGetGameType()

  if gametype == "mission" then
    game.Pause(true)
    PauseWnd:Hide()
  end

  if gametype == "practice" and net.GLIsGameSpyLobby() then
    this.Frame:SetSize{this.size_small[1], this.size_small[2]}
    this.Stats:Show()
    
    this.MissionTime:Hide()
    this.ChooseMissionReward:Hide()  
    this.Items:Hide()
    this.ChoosePVPReward:Hide()
  else
    this.Frame:SetSize{this.size_big[1], this.size_big[2]}
  end

  if gametype == "mission" and game.PlayerWins() then
    -- small items window initially
    this.Items.DestroyTxt:Hide()
    this.Items.Sepline:Hide()
    this.Items:SetSize{this.Items.size_small[1], this.Items.size_small[2]}
    
    this.MissionTime:Show()
    this.Items:Show()
    this.ChooseMissionReward:Show()
    
    this.Stats:Hide()
    this.ChoosePVPReward:Hide()
  end
  
  if gametype == "mission" and not game.PlayerWins() then
    -- mission failed, no rewards choice window, big items window initially
    this.Items.DestroyTxt:Show()
    this.Items.Sepline:Show()
    this.Items:SetSize{this.Items.size_big[1], this.Items.size_big[2]} 
    
    this.MissionTime:Show()
    this.Items:Show()
    
    this.ChooseMissionReward:Hide()
    this.Stats:Hide()
    this.ChoosePVPReward:Hide()
  end  
  
  if gametype == "speciallocation" or gametype == "special_location" then
    -- no rewards choice window, big items window initially
    this.Items.DestroyTxt:Show()
    this.Items.Sepline:Show()
    this.Items:SetSize{this.Items.size_big[1], this.Items.size_big[2]}  
    
    this.Stats:Show()
    this.Items:Show()

    this.MissionTime:Hide()
    this.ChooseMissionReward:Hide()
    this.ChoosePVPReward:Hide()
  end
  
  if gametype == "pvp" or gametype == "pvpat" or (gametype == "practice" and not net.GLIsGameSpyLobby()) then
    -- small items window initially
    this.Items.DestroyTxt:Hide()
    this.Items.Sepline:Hide()
    this.Items:SetSize{this.Items.size_small[1], this.Items.size_small[2]}
    
    this.Stats:Show()
    this.Items:Show()
    this.ChoosePVPReward:Show()
    
    this.MissionTime:Hide()
    this.ChooseMissionReward:Hide()
  end
  
--  if true or not gametype or gametype == "mission" or gametype == "pvp" or gametype == "pvpat" then
--    this.Items.DestroyTxt:Hide()
--    this.Items.Sepline:Hide()
--    this.Items:SetSize{this.Items.size_small[1], this.Items.size_small[2]}
--  end
  
  if game.PlayerWins() then
    this.Result:SetStr(TEXT{"victory"})
  else
    this.Result:SetStr(TEXT{"defeat"})
  end      
  
  if this.description then
    this.Description:SetStr("<p>" .. this.description)
    this.Description:Show()
  else
    this.Description:Hide()
  end
  this.description = nil
  
  TechGrid:SetAnchor("TOPRIGHT", Victory, "TOPRIGHT", {-10, 120 })
	TechGrid:Show()
	
	if Victory.map and game.GetMapType() == "mission" then
	  Victory.ReplayBtn.OnClick = function(pthis)
      local next = Victory.map
	    if game.PlayerWins() then
        if Victory.ChooseMissionReward.rewardtaken == 0 then
          MessageBox:Prompt(TEXT("vic_close_reward"), TEXT("Alert"), Victory.ReplayWinStuff)
        else
          Victory:ReplayWinStuff()
        end
	    else -- mishony
        game.EnableUnitSelection(true)
        game.EnableSelection(true)
	      TechGrid:Hide()
  	    Victory:Hide()
	      game.CheckpointLoad()
	      Stripes:Hide()
	      GameUI:Show()
	      game.Pause(false)
	    end  
	  end
    Victory.ReplayBtn:Show()
	else
	  Victory.ReplayBtn:Hide()
	end
	
	if this.next and game.PlayerWins() then
	  Victory.ContinueBtn.OnClick = function(pthis)
      local fullslots = 0
      for i = 1,16 do
        if Victory.Items["Slot"..i]:GetItem() then
          fullslots = 1
          break
        end
      end

      if fullslots > 0 then
        MessageBox:Prompt(TEXT("vic_close_items"), TEXT("Alert"), Victory.ContinueStuff)
      else 
        if Victory.ChooseMissionReward.rewardtaken == 0 then
          MessageBox:Prompt(TEXT("vic_close_reward"), TEXT("Alert"), Victory.ContinueStuff)
        else
          Victory:ContinueStuff()
        end
      end
	  end
	  Victory.ContinueBtn:Show()
	else
	  Victory.ContinueBtn:Hide()
	end  

  if game.PlayerWins() then
    if map == "missions/36" then
      local q = Login.openbeta and 0 or game.GetMoviePreferredQuality()
      if q and q == 1 then
        MovieFS:Play("data/movies/hi/campaign_outro.bm")
      else
        MovieFS:Play("data/movies/campaign_outro.bm")
      end
    elseif this.unlocked_location then
      LocationUnlocked.map = this.unlocked_location
      LocationUnlocked:Show()
    end
  end
end

function Victory:OnHide()
  game.EnableSelection(true)
  this.next = nil
end

function Victory:Close()
  Login.skipshow = true
  game.CloseMap() 
  game.LoadEarth()
  TechGrid:Hide()
  Stripes:Hide()
  Login.skipshow = nil
end
  
local function CreateSlots()
  local dx,dy = 7,8
  local cols,rows = 8,2
  local offx,offy = 160,48
	local idx = 1
	local r, c
	
	for r = 1, rows do
		for c = 1, cols do
		
			local slot = DefRewSlot{}
			slot.index = idx
			
		  if idx == 1 then
			  slot.anchors = { TOPLEFT = {offx,offy} }
		  else
		    if r == 1 then 
		      slot.anchors = { LEFT = {"Slot" .. (idx-1), "RIGHT", dx, 0} } 
		    else 
		      slot.anchors = { TOP = {"Slot" .. (idx-cols), "BOTTOM", 0, dy} } 
	  	  end
	    end	
	    
	    Victory.Items["Slot"..idx] = slot
      idx = idx + 1
    end
	end

end

CreateSlots()
