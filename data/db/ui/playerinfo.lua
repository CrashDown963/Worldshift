--
--  Player Info
--
local playerinfolayer = modallayer + 1

local pinfo_w = 360
local pinfo_h = 820

local text_icon_dy = 5
local StarColorDisabled = {90,90,90,255}
local StarColorEnabled = {255,255,255,255}

local DefUnitSlot = Inventory.DefItemSlot { 
	virtual = true,
	layer = playerinfolayer,
  size = {64,64},
  
	soundItemIn = sounds.unit_item_in,
  soundItemOut = sounds.unit_item_out,
  
  Empty = uiimg { color = {0,0,0,0}, },
 
  Level = Inventory.DefItemSlot.Level { 
    layer = playerinfolayer+1,
    size = {81,81},
 	},

  Frame = Inventory.DefItemSlot.Frame { 
    layer = playerinfolayer+2,
    size = {81,81},
  },
}

local DefSlots = uiwnd {
  virtual = true,

  ItemSlot_0 = DefUnitSlot { index = 1, anchors = { BOTTOM = { "TOP", "Frame" , 0,500 } } }, 
  ItemSlot_1_1 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", -95,-50 } } }, 
  ItemSlot_1_2 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", -50,-150 } } }, 
  ItemSlot_1_3 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 50,-150 } } }, 
  ItemSlot_1_4 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 95,-50 } } }, 
  ItemSlot_1_5 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 0,-105 } } }, 
  ItemSlot_2_1 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 0,-297 } } }, 
  ItemSlot_2_2 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_2_1", "CENTER", -95,50 } } }, 
  ItemSlot_2_3 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_2_1", "CENTER", 95,50 } } },
  ItemSlot_2_4 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_2_1", "CENTER", 0,105 } } },

  ItemLabl_0 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_0", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_1_1 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_1", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_1_2 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_2", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_1_3 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_3", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_1_4 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_4", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_1_5 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_5", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_2_1 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_1", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_2_2 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_2", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_2_3 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_3", "BOTTOM", 0,text_icon_dy } }, layer = playerinfolayer, },
  ItemLabl_2_4 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_4", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
}

--

local DefSpecStar = uiimg {
  size = {16,16},
  texture = "data/textures/ui/star_small.dds",
  coords = {0,0,16,16},
  hidden = true,
}

local DefSpecSlot = Inventory.DefItemSlot {
  size = {66,66},

  index = 1,
  hideitemframe = 2,
  layer = playerinfolayer + 2,
  
  SpecIcon = uiimg {
    layer = "+2",
    size = {72,71},
	  texture = "data/textures/ui/Spec_tree_icons.dds",
	  coords = {0,0,72,71},
  },
  
  SlotBack = uiimg {
  	layer = playerinfolayer + 5,
    size = {72,71},
	  texture = "data/textures/ui/Spec_tree_empty.dds",
	  coords = {0,0,72,71},
  },

  StarPlate = uiimg {
    layer = "+5",
    size = {64,34},
	  texture = "data/textures/ui/Spec_tree_starsplate.dds",
	  coords = {0,0,64,34},
	  anchors = { BOTTOMRIGHT = { "SpecIcon", 3,6 } },
  },
  
  Star_1 = DefSpecStar { 
    layer = "+6",
    anchors = { BOTTOMRIGHT = { "StarPlate", -8,-6 } },
    color = StarColorDisabled,
  },
  Star_2 = DefSpecStar { 
    layer = "+6",
    anchors = { RIGHT = { "Star_1", "LEFT", 3,0 } },
    color = StarColorDisabled,
  },
  Star_3 = DefSpecStar { 
    layer = "+6",
    anchors = { RIGHT = { "Star_2", "LEFT", 3,0 } },
    color = StarColorDisabled,
  },

  ShowTooltip = function(this) 
    local item = this:GetItem()
    if this.SlotBack:IsHidden() and item then 
      ItemTooltip:SetItem(item, this, 1) 
    end
  end,

  HideTooltip = function(this) 
    ItemTooltip:Hide() 
  end,

  OnLoad = function(this) 
    Inventory.DefItemSlot_OnLoad(this)
    local sz = this.SpecIcon:GetSize()
    local left = (this.col-1)*sz.x
    local top = (this.row-1)*sz.y
    this.SpecIcon:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
  end,
}

--

local DefRaceButton = DefButton {
  virtual = true,
  size = {55,55},

  Frame = DefCornerFrameImage2{},
  
  NormalImage = uiimg { size = {49,49}, texture = "data/textures/ui/player info race icons.dds" },
  HighImage = uiimg { size = {49,49}, texture = "data/textures/ui/player info race icons.dds" },
  PushImage = uiimg { size = {49,49}, texture = "data/textures/ui/player info race icons.dds" },

  selected = false,
  
  Select = function(this, doselect) this.selected = doselect this:updatestate() end,

  OnShow = function(this) this:updatestate() end,

  OnClick = function(this) 
    if Login.demo and this.index == 1 then
      MessageBox:Alert(TEXT("demo_aliens"))
      return
    end
    this:GetParent():OnRaceClicked(this) 
  end,

  updatestate = function(this)
    local sz = this.NormalImage:GetSize()
    local top = this.index*sz.y
    if this.selected == false then
      local left = 0
      this.NormalImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
      left = sz.x
      this.HighImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
      left = 2*sz.x
      this.PushImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    else
      local left = sz.x
      this.NormalImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
      this.HighImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
      this.PushImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    end
  end,
}

--

local DefTabBtn = DefButton {
  virtual = true,
  size = {(pinfo_w/3)-7, 25},
	font = "Verdana,10",

  selected = false,
  n_coords = {0,0,200,28},
  h_coords = {0,28,200,28+28},
  p_coords = {0,56,200,56+28},
  s_clr = {0, 0, 0, 0},
  n_clr = {100, 100, 100, 255},

	NormalImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  HighImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  PushImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },

  OnShow = function(this) this:updatestate() end,
  OnClick = function(this) this:GetParent():OnTabClicked(this) end,
  Select = function(this, doselect)  this.selected = doselect this:updatestate() end,
  updatestate = function(this) 
    if this.selected then
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
}

--

local DefStat = uiwnd {
  virtual = true,
  mouse = true,
  size = {100,42},

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
}

--

local DefAcievment = uiwnd {
  virtual = true,
  size = {42,42},
  
  Frame = DefCornerFrameImage2 {},
}

--

PlayerInfo = uiwnd {
  hidden = true,
  layer = playerinfolayer,
  size = {pinfo_w,pinfo_h},

  DefBigBackImage { layer = playerinfolayer-4 },

  Version = uitext {
    size = {200,20},
    font = "Verdana,9",
    color = {136,136,136},
    anchors = { BOTTOMRIGHT = {-22,-15} },
    halign = "RIGHT",
    str = "n/a",
  },

  Close = DefButton {
    size = {195, 26},
    font = "Verdana,10b",
    anchors = { BOTTOM = {0,-35} },
    str = TEXT("close"),
    OnClick = function(this) PlayerInfo:Hide() end,  
  },

  TechBtn = DefTabBtn {
    anchors = { TOPLEFT = { 10,8 } },
    showui = "Tech_tab",
    str = TEXT{"abilities"},
  },

  SpecBtn = DefTabBtn {
    anchors = { LEFT = { "RIGHT", "TechBtn", 1,0 } },
    showui = "Spec_tab",
    str = TEXT{"specializations"},
  },

  StatBtn = DefTabBtn {
    anchors = { LEFT = { "RIGHT", "SpecBtn", 1,0 } },
    showui = "Stat_tab",
    str = TEXT{"statistics"},
  },

  Tech_tab = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TechBtn", 0,1 }, BOTTOMRIGHT = { -10,-10 } },

    Name = uitext {
      size = {1,20},
      layer = "+1",
      font = "Verdana,11",
      anchors = { TOPLEFT = { 10,10 }, TOPRIGHT = { -10,10 } },
    },

    MutantsBtn = DefRaceButton { index = 2, showui = "MutantsView", anchors = { TOP = { "BOTTOM", "Name", 0,10 } } },
    HumansBtn = DefRaceButton { index = 0, showui = "HumansView", anchors = { RIGHT = { "LEFT", "MutantsBtn", -10,0 } } },
    AliensBtn = DefRaceButton { index = 1, showui = "AliensView", anchors = { LEFT = { "RIGHT", "MutantsBtn", 10,0 } } },

	  AliensView = uiwnd {
	    hidden = true,
      Frame = DefCornerFrameImage2 { layer = "-3" },

      ItemSlot_0   = DefSlots.ItemSlot_0   { frame_idx = 7, repo = "INSPECT_ALIEN_MASTER" }, 
 	    ItemSlot_1_1 = DefSlots.ItemSlot_1_1 { frame_idx = 6, repo = "INSPECT_ALIEN_DOMINATOR" }, 
      ItemSlot_1_2 = DefSlots.ItemSlot_1_2 { frame_idx = 4, repo = "INSPECT_ALIEN_HARVESTER" }, 
      ItemSlot_1_3 = DefSlots.ItemSlot_1_3 { frame_idx = 5, repo = "INSPECT_ALIEN_MANIPULATOR" }, 
      ItemSlot_1_4 = DefSlots.ItemSlot_1_4 { frame_idx = 8, repo = "INSPECT_ALIEN_ARBITER" }, 
      ItemSlot_1_5 = DefSlots.ItemSlot_1_5 { frame_idx = 9, repo = "INSPECT_ALIEN_DEFILER" },
      ItemSlot_2_1 = DefSlots.ItemSlot_2_1 { frame_idx = 2, repo = "INSPECT_ALIEN_CORRUPTION" }, 
      ItemSlot_2_2 = DefSlots.ItemSlot_2_2 { frame_idx = 1, repo = "INSPECT_ALIEN_POWER" }, 
      ItemSlot_2_3 = DefSlots.ItemSlot_2_3 { frame_idx = 3, repo = "INSPECT_ALIEN_DOGMA" },
      ItemSlot_2_4 = DefSlots.ItemSlot_2_4 { frame_idx = 10, repo = "INSPECT_ALIEN_ENIGMA" },

	    ItemLabl_0 = DefSlots.ItemLabl_0 { str = TEXT{"Master.name"} },
	    ItemLabl_1_1 = DefSlots.ItemLabl_1_1 { str = TEXT{"Dominator.name"} },
	    ItemLabl_1_2 = DefSlots.ItemLabl_1_2 { str = TEXT{"Harvester.name"} },
	    ItemLabl_1_3 = DefSlots.ItemLabl_1_3 { str = TEXT{"Manipulator.name"} },
	    ItemLabl_1_4 = DefSlots.ItemLabl_1_4 { str = TEXT{"Arbiter.name"} },
      ItemLabl_1_5 = DefSlots.ItemLabl_1_5 { str = TEXT{"Defiler.name"} },
	    ItemLabl_2_1 = DefSlots.ItemLabl_2_1 { str = TEXT{"corruption"} },
	    ItemLabl_2_2 = DefSlots.ItemLabl_2_2 { str = TEXT{"power"} },
	    ItemLabl_2_3 = DefSlots.ItemLabl_2_3 { str = TEXT{"dogma"} },
      ItemLabl_2_4 = DefSlots.ItemLabl_2_4 { str = TEXT{"enigma"} },

      OnShow = function(this) this:GetParent().AliensBtn:Select(true) end,
      OnHide = function(this) this:GetParent().AliensBtn:Select(false) end,
    },

	  MutantsView = uiwnd {
	    hidden = true,
      Frame = DefCornerFrameImage2 { layer = "-3" },

      ItemSlot_0   = DefSlots.ItemSlot_0   { frame_idx = 7, repo = "INSPECT_MUTANT_HIGHPRIEST" }, 
 	    ItemSlot_1_1 = DefSlots.ItemSlot_1_1 { frame_idx = 6, repo = "INSPECT_MUTANT_SHAMAN" }, 
      ItemSlot_1_2 = DefSlots.ItemSlot_1_2 { frame_idx = 4, repo = "INSPECT_MUTANT_STONEGHOST" }, 
      ItemSlot_1_3 = DefSlots.ItemSlot_1_3 { frame_idx = 5, repo = "INSPECT_MUTANT_ADEPT" }, 
      ItemSlot_1_4 = DefSlots.ItemSlot_1_4 { frame_idx = 8, repo = "INSPECT_MUTANT_GUARDIAN" }, 
      ItemSlot_1_5 = DefSlots.ItemSlot_1_5 { frame_idx = 9, repo = "INSPECT_MUTANT_PSYCHIC" }, 
      ItemSlot_2_1 = DefSlots.ItemSlot_2_1 { frame_idx = 2, repo = "INSPECT_MUTANT_NATURE" }, 
      ItemSlot_2_2 = DefSlots.ItemSlot_2_2 { frame_idx = 1, repo = "INSPECT_MUTANT_BLOOD" }, 
      ItemSlot_2_3 = DefSlots.ItemSlot_2_3 { frame_idx = 3, repo = "INSPECT_MUTANT_MIND" },
      ItemSlot_2_4 = DefSlots.ItemSlot_2_4 { frame_idx = 10, repo = "INSPECT_MUTANT_SPIRIT" },

	    ItemLabl_0 = DefSlots.ItemLabl_0 { str = TEXT{"HighPriest.name"} },
	    ItemLabl_1_1 = DefSlots.ItemLabl_1_1 { str = TEXT{"Shaman.name"} },
	    ItemLabl_1_2 = DefSlots.ItemLabl_1_2 { str = TEXT{"StoneGhost.name"} },
	    ItemLabl_1_3 = DefSlots.ItemLabl_1_3 { str = TEXT{"Sorcerer.name"} },
	    ItemLabl_1_4 = DefSlots.ItemLabl_1_4 { str = TEXT{"Guardian.name"} },
      ItemLabl_1_5 = DefSlots.ItemLabl_1_5 { str = TEXT{"Psychic.name"} },
	    ItemLabl_2_1 = DefSlots.ItemLabl_2_1 { str = TEXT{"nature"} },
	    ItemLabl_2_2 = DefSlots.ItemLabl_2_2 { str = TEXT{"blood"} },
	    ItemLabl_2_3 = DefSlots.ItemLabl_2_3 { str = TEXT{"mind"} },
      ItemLabl_2_4 = DefSlots.ItemLabl_2_4 { str = TEXT{"spirit"} },

      OnShow = function(this) this:GetParent().MutantsBtn:Select(true) end,
      OnHide = function(this) this:GetParent().MutantsBtn:Select(false) end,
    },

	  HumansView  = uiwnd {
	    hidden = true,
      Frame = DefCornerFrameImage2 { layer = "-3" },

      ItemSlot_0   = DefSlots.ItemSlot_0   { frame_idx = 7, repo = "INSPECT_HUMAN_COMMANDER" }, 
 	    ItemSlot_1_1 = DefSlots.ItemSlot_1_1 { frame_idx = 6, repo = "INSPECT_HUMAN_SURGEON" }, 
      ItemSlot_1_2 = DefSlots.ItemSlot_1_2 { frame_idx = 4, repo = "INSPECT_HUMAN_CONSTRUCTOR" }, 
      ItemSlot_1_3 = DefSlots.ItemSlot_1_3 { frame_idx = 5, repo = "INSPECT_HUMAN_ASSASSIN" }, 
      ItemSlot_1_4 = DefSlots.ItemSlot_1_4 { frame_idx = 8, repo = "INSPECT_HUMAN_JUDGE" }, 
      ItemSlot_1_5 = DefSlots.ItemSlot_1_5 { frame_idx = 9, repo = "INSPECT_HUMAN_ENGINEER" },
      ItemSlot_2_1 = DefSlots.ItemSlot_2_1 { frame_idx = 2, repo = "INSPECT_HUMAN_IMPLANTS" }, 
      ItemSlot_2_2 = DefSlots.ItemSlot_2_2 { frame_idx = 1, repo = "INSPECT_HUMAN_DEFENCE" }, 
      ItemSlot_2_3 = DefSlots.ItemSlot_2_3 { frame_idx = 3, repo = "INSPECT_HUMAN_WEAPONS" },
      ItemSlot_2_4 = DefSlots.ItemSlot_2_4 { frame_idx = 10, repo = "INSPECT_HUMAN_NEUROSCIENCE" },

	    ItemLabl_0 = DefSlots.ItemLabl_0 { str = TEXT{"Commander.name"} },
	    ItemLabl_1_1 = DefSlots.ItemLabl_1_1 { str = TEXT{"Surgeon.name"} },
	    ItemLabl_1_2 = DefSlots.ItemLabl_1_2 { str = TEXT{"Constructor.name"} },
	    ItemLabl_1_3 = DefSlots.ItemLabl_1_3 { str = TEXT{"Assassin.name"} },
	    ItemLabl_1_4 = DefSlots.ItemLabl_1_4 { str = TEXT{"Judge.name"} },
      ItemLabl_1_5 = DefSlots.ItemLabl_1_5 { str = TEXT{"Engineer.name"} },
	    ItemLabl_2_1 = DefSlots.ItemLabl_2_1 { str = TEXT{"implants"} },
	    ItemLabl_2_2 = DefSlots.ItemLabl_2_2 { str = TEXT{"defence"} },
	    ItemLabl_2_3 = DefSlots.ItemLabl_2_3 { str = TEXT{"weapon"} },
      ItemLabl_2_4 = DefSlots.ItemLabl_2_4 { str = TEXT{"neuroscience"} },

      OnShow = function(this) this:GetParent().HumansBtn:Select(true) end,
      OnHide = function(this) this:GetParent().HumansBtn:Select(false) end,
    },

    OnRaceClicked = function(this, btn)
      if this.currentview then
        this.currentview:Hide()  
      end
      this.currentview = this[btn.showui]
      this.currentview:Show()
    end,

    OnShow = function(this)
      this:GetParent().TechBtn:Select(true)
      this.Name:SetStr(PlayerInfo.player)
      if not this.currentview then
        this:OnRaceClicked(this.HumansBtn)  
      end
    end,
    
    OnHide = function(this)
      this:GetParent().TechBtn:Select(false)
    end,
  },

  Spec_tab = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TechBtn", 0,1 }, BOTTOMRIGHT = { -10,-10 } },

    Name = uitext {
      size = {1,20},
      layer = "+1",
      font = "Verdana,11",
      anchors = { TOPLEFT = { 10,10 }, TOPRIGHT = { -10,10 } },
    },

    MutantsBtn = DefRaceButton { index = 2, showui = "MutantsView", anchors = { TOP = { "BOTTOM", "Name", 0,10 } } },
    HumansBtn = DefRaceButton { index = 0, showui = "HumansView", anchors = { RIGHT = { "LEFT", "MutantsBtn", -10,0 } } },
    AliensBtn = DefRaceButton { index = 1, showui = "AliensView", anchors = { LEFT = { "RIGHT", "MutantsBtn", 10,0 } } },

	  AliensView = uiwnd {
	    hidden = true,
      Frame = DefCornerFrameImage2 { layer = "-3" },

	    SpecSlot_A1 = DefSpecSlot { row = 5, col = 1, repo = "INSPECT_ALIEN_SPECA1",   anchors = { TOPRIGHT = { "Frame" , "TOP", 10,160 } } },
	    SpecSlot_A2 = DefSpecSlot { row = 5, col = 2, repo = "INSPECT_ALIEN_SPECA2",   anchors = { TOPLEFT = { "Frame" , "TOP", 30,160 } } },
  	  
	    SpecSlot_B1 = DefSpecSlot { row = 5, col = 3, repo = "INSPECT_ALIEN_SPECB1",   anchors = { RIGHT = { "SpecSlot_B2" , "LEFT", -20,0 } } },
	    SpecSlot_B2 = DefSpecSlot { row = 5, col = 4, repo = "INSPECT_ALIEN_SPECB2",   anchors = { RIGHT = { "SpecSlot_B3" , "LEFT", -20,0 } } },
	    SpecSlot_B3 = DefSpecSlot { row = 5, col = 5, repo = "INSPECT_ALIEN_SPECB3",   anchors = { TOP = { "SpecSlot_A2" , "BOTTOM", 0,20 } } },
  	  
	    SpecSlot_C1 = DefSpecSlot { row = 6, col = 1, repo = "INSPECT_ALIEN_SPECC1",   anchors = { TOP = { "SpecSlot_B2" , "BOTTOM", -40,20 } } },
	    SpecSlot_C2 = DefSpecSlot { row = 6, col = 2, repo = "INSPECT_ALIEN_SPECC2",   anchors = { TOP = { "SpecSlot_B3" , "BOTTOM", 0,20 } } },
  	  
	    SpecSlot_D1 = DefSpecSlot { row = 6, col = 3, repo = "INSPECT_ALIEN_SPECD1",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", 0,20 } } },
	    SpecSlot_D2 = DefSpecSlot { row = 6, col = 4, repo = "INSPECT_ALIEN_SPECD2",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", -40,20 } } },
	    SpecSlot_D3 = DefSpecSlot { row = 6, col = 5, repo = "INSPECT_ALIEN_SPECD3",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", 40,20 } } },

      OnShow = function(this) this:GetParent().AliensBtn:Select(true) end,
      OnHide = function(this) this:GetParent().AliensBtn:Select(false) end,
    },

	  MutantsView = uiwnd {
	    hidden = true,
      Frame = DefCornerFrameImage2 { layer = "-3" },

	    SpecSlot_A1 = DefSpecSlot { row = 3, col = 1, repo = "INSPECT_MUTANT_SPECA1",   anchors = { TOPRIGHT = { "Frame" , "TOP", -30,160 } } },
	    SpecSlot_A2 = DefSpecSlot { row = 3, col = 2, repo = "INSPECT_MUTANT_SPECA2",   anchors = { TOPLEFT = { "Frame" , "TOP", 30,160 } } },
  	  
	    SpecSlot_B1 = DefSpecSlot { row = 3, col = 3, repo = "INSPECT_MUTANT_SPECB1",   anchors = { TOP = { "SpecSlot_A1" , "BOTTOM", -40,20 } } },
	    SpecSlot_B2 = DefSpecSlot { row = 3, col = 4, repo = "INSPECT_MUTANT_SPECB2",   anchors = { TOP = { "SpecSlot_A1" , "BOTTOM", 40,20 } } },
	    SpecSlot_B3 = DefSpecSlot { row = 3, col = 5, repo = "INSPECT_MUTANT_SPECB3",   anchors = { TOP = { "SpecSlot_A2" , "BOTTOM", 0,20 } } },
  	  
	    SpecSlot_C1 = DefSpecSlot { row = 4, col = 1, repo = "INSPECT_MUTANT_SPECC1",   anchors = { TOP = { "SpecSlot_B1" , "BOTTOM", 0,20 } } },
	    SpecSlot_C2 = DefSpecSlot { row = 4, col = 2, repo = "INSPECT_MUTANT_SPECC2",   anchors = { TOP = { "SpecSlot_B3" , "BOTTOM", 0,20 } } },
  	  
	    SpecSlot_D1 = DefSpecSlot { row = 4, col = 3, repo = "INSPECT_MUTANT_SPECD1",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", 0,20 } } },
	    SpecSlot_D2 = DefSpecSlot { row = 4, col = 4, repo = "INSPECT_MUTANT_SPECD2",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", -40,20 } } },
	    SpecSlot_D3 = DefSpecSlot { row = 4, col = 5, repo = "INSPECT_MUTANT_SPECD3",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", 40,20 } } },

      OnShow = function(this) this:GetParent().MutantsBtn:Select(true) end,
      OnHide = function(this) this:GetParent().MutantsBtn:Select(false) end,
    },

	  HumansView  = uiwnd {
	    hidden = true,
      Frame = DefCornerFrameImage2 { layer = "-3" },

      SpecSlot_A1 = DefSpecSlot { row = 1, col = 1, repo = "INSPECT_HUMAN_SPECA1",   anchors = { TOPRIGHT = { "Frame" , "TOP", -30,160 } } },
	    SpecSlot_A2 = DefSpecSlot { row = 1, col = 2, repo = "INSPECT_HUMAN_SPECA2",   anchors = { TOPLEFT = { "Frame" , "TOP", -10,160 } } },
  	  
	    SpecSlot_B1 = DefSpecSlot { row = 1, col = 3, repo = "INSPECT_HUMAN_SPECB1",   anchors = { TOP = { "SpecSlot_A1" , "BOTTOM", 0,20 } } },
	    SpecSlot_B2 = DefSpecSlot { row = 1, col = 4, repo = "INSPECT_HUMAN_SPECB2",   anchors = { TOP = { "SpecSlot_A2" , "BOTTOM", 0,20 } } },
	    SpecSlot_B3 = DefSpecSlot { row = 1, col = 5, repo = "INSPECT_HUMAN_SPECB3",   anchors = { LEFT = { "SpecSlot_B2" , "RIGHT", 20,0 } } },
  	  
	    SpecSlot_C1 = DefSpecSlot { row = 2, col = 1, repo = "INSPECT_HUMAN_SPECC1",   anchors = { TOP = { "SpecSlot_B1" , "BOTTOM", 0,20 } } },
	    SpecSlot_C2 = DefSpecSlot { row = 2, col = 2, repo = "INSPECT_HUMAN_SPECC2",   anchors = { TOP = { "SpecSlot_B2" , "BOTTOM", 40,20 } } },
  	  
	    SpecSlot_D1 = DefSpecSlot { row = 2, col = 3, repo = "INSPECT_HUMAN_SPECD1",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", -40,20 } } },
	    SpecSlot_D2 = DefSpecSlot { row = 2, col = 4, repo = "INSPECT_HUMAN_SPECD2",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", 40,20 } } },
	    SpecSlot_D3 = DefSpecSlot { row = 2, col = 5, repo = "INSPECT_HUMAN_SPECD3",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", 0,20 } } },

      OnShow = function(this) this:GetParent().HumansBtn:Select(true) end,
      OnHide = function(this) this:GetParent().HumansBtn:Select(false) end,
    },

    OnRaceClicked = function(this, btn)
      if this.currentview then
        this.currentview:Hide()  
      end
      this.currentview = this[btn.showui]
      this.currentview:Show()
    end,

    OnShow = function(this) 
      this:GetParent().SpecBtn:Select(true) 
      this.Name:SetStr(PlayerInfo.player)
      if not this.currentview then
        this:OnRaceClicked(this.HumansBtn)  
      end
      this:Update() 
    end,

    OnHide = function(this) 
      this:GetParent().SpecBtn:Select(false) 
    end,

    Update = function(this)
      for race, interface in pairs{humans = this.HumansView, mutants = this.MutantsView, aliens = this.AliensView} do
        for k,v in pairs(interface) do
          if string.sub(tostring(k), 1, 9) == 'SpecSlot_' then 
            local id = string.sub(tostring(k), 10, 11)
            local state, stars, maxStars, prevID = game.GetInspectSpecInfo(race, id)
            local prevState = game.GetInspectSpecInfo(race, prevID)
            if not state or state < 1 or (prevState and prevState <= 0) then
              v:SetAlpha(0)
              v.SpecIcon:SetAlpha(0)
              for i = 1,3 do v["Star_"..i]:SetAlpha(0) v["Star_"..i]:Hide() end
              v.StarPlate:SetAlpha(0)
              v.SlotBack:SetAlpha(1)
              v.SlotBack:Show()
            else
              v.SlotBack:SetAlpha(0)
              v.SlotBack:Hide()
              if state > 0 then
                v:SetAlpha(0)
                v.SpecIcon:SetAlpha(1)
                v.Star_1:SetColor(StarColorDisabled)
                v.Star_2:SetColor(StarColorDisabled)
                v.Star_3:SetColor(StarColorDisabled)
                if stars > 0 then v.Star_1:SetColor(StarColorEnabled) end
                if stars > 1 then v.Star_2:SetColor(StarColorEnabled) end
                if stars > 2 then v.Star_3:SetColor(StarColorEnabled) end
                for i = 1,maxStars do v["Star_"..i]:Show() end
                for i = maxStars+1,3 do v["Star_"..i]:Hide() end
                for i = 1,3 do v["Star_"..i]:SetAlpha(1) end
                local sz = v.StarPlate:GetSize()
                local top = (maxStars-1)*sz.y
                v.StarPlate:SetTexture(nil, {0,top,sz.x,top+sz.y})
                v.StarPlate:SetAlpha(1)
              else
                v:SetAlpha(0)
                v.SpecIcon:SetAlpha(0)
                for i = 1,3 do v["Star_"..i]:SetAlpha(0) v["Star_"..i]:Hide() end
                v.StarPlate:SetAlpha(0)
              end
            end
          end
        end
      end
    end,
  },

  Stat_tab = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TechBtn", 0,1 }, BOTTOMRIGHT = { -10,-10 } },

    Frame = DefCornerFrameImage2 { layer = "-3" },

    Name = uitext {
      size = {1,20},
      layer = "+1",
      font = "Verdana,11",
      anchors = { TOPLEFT = { "Frame", 10,10 }, TOPRIGHT = { "Frame", -10,10 } },
    },

    DamageStat = DefStat { ttkey = "avdamage", col = 1, anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 40,20 } } },
	  HealingStat = DefStat { ttkey = "avhealing", col = 2, anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Name", -40,20 } } },
	  KillsStat = DefStat { ttkey = "avkills", col = 3, anchors = { TOP = { "BOTTOM", "DamageStat", 0,20 } } },
	  DeathsStat = DefStat { ttkey = "avdeaths", col = 4, anchors = { TOP = { "BOTTOM", "HealingStat", 0,20 } } },
	  CommandsStat = DefStat { ttkey = "avcommand", col = 5, anchors = { TOP = { "BOTTOM", "KillsStat", 0,20 } } },
	  DamageTakenStat = DefStat { ttkey = "avdamagetaken", col = 6, anchors = { TOP = { "BOTTOM", "DeathsStat", 0,20 } } },

    MutantsStat = uiwnd {
      mouse = true,
      size = {85,90},
      anchors = { CENTER = { "Frame", 0,-100 } },

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

	  GameDuration = uiwnd {
	    size = {200,29},
	    anchors = { TOP = { "BOTTOM", "MutantsStat", 0,20 } },
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

    Rank1v1DM = DefGSStat {
      --anchors = { TOPLEFT = { 20,20 } },
      anchors = { TOP = { "BOTTOM", "GameDurationText", 0,20 } },
    },
	  
    Rating1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Rank1v1DM", 0,10 } },
    },	  

    Wins1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Rating1v1DM", 0,10 } },
    },	  

    Losses1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Wins1v1DM", 0,10 } },
    },	  

    Streak1v1DM = DefGSStat {
      anchors = { TOP = { "BOTTOM", "Losses1v1DM", 0,10 } },
    },	

	  BattlePoints = uiwnd {
	    hidden = true,
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
	    hidden = true,
	    layer = "+1",
	    size = {250,1},
	    --halign = "LEFT",
	    anchors = { TOP = { "BOTTOM", "BattlePoints", 0,5 } },
      font = "Verdana,10",
	  },

	  AchievementsText = uitext {
	    hidden = true, 
	    layer = "+1",
	    size = {250,1},
	    --halign = "LEFT",
	    anchors = { TOP = { "BOTTOM", "BattlePointsText", 0,25 } },
      font = "Verdana,10",
      str = TEXT{"achievements"},
	  },

	  Achievements = uiwnd {
	    hidden = true,
	    layer = "+1",
	    size = {265,1},
	    anchors = { TOP = { "BOTTOM", "AchievementsText", 0,15 } },
      
      OnShow = function(this)
        if not this.Cell_1 then
          local dx = 2
          local dy = 2
          local cols = 6
          local rows = 3
          local i = 1
          for y = 1,rows do
            for x = 1,cols do
              local cell =  DefAcievment { index = i }
              
              if x == 1 and y == 1 then
                cell.anchors = { TOPLEFT = { "TOPLEFT", 0, 0 } }
              elseif y == 1 then
                cell.anchors = { LEFT = { "Cell_" .. (i-1), "RIGHT", dx,0 } }
              else
                cell.anchors = { TOP = { "Cell_" .. (i-cols), "BOTTOM", 0,dy } }
              end
              
              this["Cell_" .. i] = cell
              i = i + 1
            end
          end
          this:CreateChildren()
        end
      end,
	  },

    OnShow = function(this)
      this:GetParent().StatBtn:Select(true)
      this.Name:SetStr(PlayerInfo.player)
      
      this.GameDurationText:SetStr("<p>"..TEXT"gamedurationtext")
      local h = this.GameDurationText:GetStrHeight()
      this.GameDurationText:SetSize{this.GameDurationText:GetSize().x, h}

      this.BattlePointsText:SetStr("<p>"..TEXT"battlepointstext")
      h = this.BattlePointsText:GetStrHeight()
      this.BattlePointsText:SetSize{this.BattlePointsText:GetSize().x, h}

      local inspect = game.GetInspectStatsInfo()
      if inspect then
        this.BattlePoints.Text:SetStr(TEXT{"battlepointsvalue", inspect.bp, 600})
        local durm, durs = inspect.durm, inspect.durs
        if durs < 10 then durs = "0" .. durs end
        this.GameDuration.Text:SetStr(TEXT{"gamedurationvalue", durm, durs})
        
        this.HumansStat.Text:SetStr(inspect.humans .. "%")
        this.AliensStat.Text:SetStr(inspect.aliens .. "%")
        this.MutantsStat.Text:SetStr(inspect.mutants .. "%")

        this.DamageStat.Value.Text:SetStr((inspect[1] or 0).."%")
        this.HealingStat.Value.Text:SetStr((inspect[2] or 0).."%")
        this.KillsStat.Value.Text:SetStr((inspect[3] or 0).."%")
        this.DeathsStat.Value.Text:SetStr((inspect[4] or 0).."%")
        this.CommandsStat.Value.Text:SetStr((inspect[5] or 0).."%")
        this.DamageTakenStat.Value.Text:SetStr((inspect[6] or 0).."%")
      end
      
      this.Rank1v1DM.Title:SetStr("<p>"..TEXT("rank1v1txt"))
      this.Rating1v1DM.Title:SetStr("<p>"..TEXT("rating1v1txt"))
      this.Wins1v1DM.Title:SetStr("<p>"..TEXT("wins1v1txt"))
      this.Losses1v1DM.Title:SetStr("<p>"..TEXT("losses1v1txt"))
      this.Streak1v1DM.Title:SetStr("<p>"..TEXT("streak1v1txt"))
      
      this.Rank1v1DM.StatPanel.Text:SetStr("N/A")
      this.Rating1v1DM.StatPanel.Text:SetStr("N/A")
      this.Wins1v1DM.StatPanel.Text:SetStr("N/A")
      this.Losses1v1DM.StatPanel.Text:SetStr("N/A")
      this.Streak1v1DM.StatPanel.Text:SetStr("N/A")      
      
      net.Competition_GetPlayerRankings(PlayerInfo.player, 0, 1, "ARENA_ELO_RATING_1V1")
      this:RegisterEvent("PLAYER_STATS")       
      
    end,

    OnHide = function(this) this:GetParent().StatBtn:Select(false) end,
    
    OnEvent = function(this, event)
      if event == "PLAYER_STATS" then
        local rat = 0
        for kk, vv in pairs(argPlayers) do
          if kk and string.lower(kk) == string.lower(PlayerInfo.player) then
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

  OnLoad = function(this)
    this:RegisterEvent("INSPECT_CALLBACK")
    this:RegisterEvent("PLAYERVERSION")
    this:RegisterEvent("MAP_LOADED")
  end,
  
  OnEvent = function(this, event)
    if event == "MAP_LOADED" then
      this:Hide()
    end

    if event == "PLAYERVERSION" then
      if this.player == argPlayer then
        this.Version:SetStr(argVersion)
      end
    end

    if event == "INSPECT_CALLBACK" then 
      this:Show()
    end
 
  end,
  
  OnTabClicked = function(this, tab)
    if this.currentview then
      this.currentview:Hide()  
    end
    this.currentview = this[tab.showui]
    this.currentview:Show()
  end,

  OnShow = function(this) 
    if not this.currentview then
      this:OnTabClicked(this.TechBtn)
    end  

    Modal.func = function() this:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,

  OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide()
    this.Version:SetStr("n/a")
	end,
	
	SetPlayer = function(this, player)
	  this.player = player
	  this:Hide()
    net.GetPlayerVersion(player)
	  net.Persist_GetPlayerData(player)
	end,
}