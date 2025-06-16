--
-- UNITS INFO
--
local techlayer = 40

local ERRTEXTS = {
  INVALID = TEXT{"invalid"},
  PREDNOTREV = TEXT{"prednotrev"},
  NOSTARS = TEXT{"nostars"},
  NOREQSTARS = TEXT{"noreqstars"},
  NOGEMS = TEXT{"nogems"},
}

local ERRSOUNDS = {
  INVALID = sounds.on_error,
  PREDNOTREV = "data/speech/advisor/uncover prev.wav",
  NOSTARS = "data/speech/advisor/no stars.wav",
  NOREQSTARS = "data/speech/advisor/no stars prev.wav",
  NOGEMS = "data/speech/advisor/no xenoshards.wav",
}

local DefRacesBtn = DefButton {
  virtual = true,
	size = {208,28},
	font = "Verdana,10b",
	
	selected = false,
  
  n_coords = {0,0,200,28},
  h_coords = {0,28,200,28+28},
  p_coords = {0,56,200,56+28},
  s_clr = {0, 0, 0, 0},
  n_clr = {100, 100, 100, 255},
  d_clr = {50, 50, 50, 255},

	NormalImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  HighImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  PushImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  
	SelectTab = function(this, select)
    this.selected = select
    if this.demodisabled then
      this.NormalImage:SetTexture(nil, this.n_coords)
      this.HighImage:SetTexture(nil, this.h_coords)
      this.PushImage:SetTexture(nil, this.h_coords)
      
      this.NormalText:SetColor(this.d_clr)
      this.HighText:SetColor(this.d_clr)
      this.PushText:SetColor(this.d_clr)
    else
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
    end
  end,
  
  OnShow = function(this) 
    if Login.demo and this.race == "aliens" then
      this.demodisabled = true
    end
    this:SelectTab(this.selected) 
  end,

  OnClick = function(this)
    if Login.demo and this.race == "aliens" then
      MessageBox:Alert(TEXT("demo_aliens"))
      return
    end
    local parent = this:GetParent()
    if parent.race == this.race then return end
    parent:SelectRace(this) 
  end,
}

local DefUnitBtn = DefButton {
  virtual = true,
	size = {100,30},
	NormalText = DefButton.NormalText { font = "Arial,12" },
	HighText = DefButton.HighText { font = "Arial,12" },
	PushText = DefButton.PushText { font = "Arial,12" },
}

local unitslotlayer = 50

local DefUnitSlot = Inventory.DefItemSlot { 
	virtual = true,
	layer = unitslotlayer,
  size = {64,64},
  
	soundItemIn = sounds.unit_item_in,
  soundItemOut = sounds.unit_item_out,
  
  Empty = uiimg { color = {0,0,0,0}, },
 
  Level = Inventory.DefItemSlot.Level { 
    size = {81,81},
 	},

  Frame = Inventory.DefItemSlot.Frame { 
    size = {81,81},
  },
}

local text_icon_dy = 5

local DefTechHolderSlots = uiwnd {
  --master
  ItemSlot_0 = DefUnitSlot { index = 1, anchors = { CENTER = { "LeftFrame" , 0,150 } } }, 
  ItemLabl_0 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_0", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },

  --officers
  ItemSlot_1_1 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", -95,-40 } } }, 
  ItemSlot_1_2 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", -95,-155 } } }, 
  ItemSlot_1_3 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 95,-155 } } }, 
  ItemSlot_1_4 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 95,-40 } } },
  ItemSlot_1_5 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 0,-105 } } }, 

  ItemLabl_1_1 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_1", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_1_2 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_2", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_1_3 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_3", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_1_4 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_4", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_1_5 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_1_5", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },

  --common
  ItemSlot_2_1 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_0", "CENTER", 0,-315 } } }, 
  ItemSlot_2_2 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_2_1", "CENTER", -95,40 } } }, 
  ItemSlot_2_3 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_2_1", "CENTER", 95,40 } } },
  ItemSlot_2_4 = DefUnitSlot { index = 1, anchors = { CENTER = { "ItemSlot_2_1", "CENTER", 0,105 } } },

  ItemLabl_2_1 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_1", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_2_2 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_2", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_2_3 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_3", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
  ItemLabl_2_4 = uitext { font = "Verdana,9", color = {194,194,194}, size = {200,20}, anchors = { TOP = { "ItemSlot_2_4", "BOTTOM", 0,text_icon_dy } }, layer = techlayer, },
}

local DefSpendStar = uiimg {
  hidden = true,
  size = {16,16},
  texture = "data/textures/ui/star_small.dds",
  
  visible_c = {0,0,16,16},
  hole_c = {0,16,16,32},
  
  SetState = function(this, state)
    if state == 2 then
      this:SetTexture(nil, this.visible_c)
      this:Show()
    elseif state == 1 then
      this:SetTexture(nil, this.hole_c)
      this:Show()
    else
      this:Hide()
    end
  end,
}

local DefSpecStar = uiimg {
  size = {16,16},
  texture = "data/textures/ui/star_small.dds",
  coords = {0,0,16,16},
  hidden = true,
}

local StarColorDisabled = {90,90,90,255}
local StarColorEnabled = {255,255,255,255}

local DefSpecSlot = Inventory.DefItemSlot {
  size = {66,66},

  index = 1,
  
  SpecIcon = uiimg {
    layer = "+2",
    size = {72,71},
	  texture = "data/textures/ui/Spec_tree_icons.dds",
	  coords = {0,0,72,71},
  },
  
  SlotBack = uiimg {
  	layer = unitslotlayer + 5,
    size = {72,71},
	  texture = "data/textures/ui/Spec_tree_empty.dds",
	  coords = {0,0,72,71},
  },

  Animation = DefAnim {
    size = {84,73},
    hidden = true,
    layer = unitslotlayer + 1,
    texture = "data/textures/ui/monitor.dds",
    coords = {0, 0, 84, 73},
    fps = 10,
    frames = 14,
    looped = true,
    defazed = true,
    autoplay = true,
    horizontal = false,
  },
  
  SlotDisabled = uiimg {
    layer = "+4",
    size = {72,71},
	  texture = "data/textures/ui/Spec_tree_disable.dds",
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

  ShowTooltip = function(this) if this.Animation:IsHidden() and this.SlotBack:IsHidden() then ItemTooltip:SetItem(this:GetItem(), this, 0) end end,
  HideTooltip = function(this) ItemTooltip:Hide() end,
  OnMouseDown = function(this) 
    if argBtn ~= "LEFT" then return end
    local id = string.sub(this:GetName(), 10, 11)
    local state = game.GetSpecInfo(TechGrid.race, id)
    local err = game.SpecClicked(TechGrid.race, id)
    if err then
      ErrText:ShowText(ERRTEXTS[err])
      game.PlaySnd(ERRSOUNDS[err])
      --game.PlaySnd(sounds.on_error) 
    else
      TechGrid:UpdateGems()
      if state <= 0 then
        game.PlaySnd(sounds.on_reveal) 
      else
        game.PlaySnd(sounds.on_addstar) 
      end

      this:ShowTooltip()
    end
  end,
  OnLoad = function(this) 
    Inventory.DefItemSlot_OnLoad(this)
    
    local sz = this.SpecIcon:GetSize()
    local left = (this.col-1)*sz.x
    local top = (this.row-1)*sz.y
    this.SpecIcon:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
  end,
}

local tgszw = 645
local tgszh = 720

TechGrid = uiwnd {
  layer = techlayer,
  size = {tgszw,tgszh},
  anchors = { TOPRIGHT = { "TOPRIGHT", "Lobby", -10, 60 } },
	hidden = true,
	mouse = true,
	
	DefBigBackImage{layer = techlayer-2},
	
	AliensInterface = uiwnd {
	  work_tbl = {},
	  hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Humans", 0, 0 }, BOTTOMRIGHT = { "TOPRIGHT", "Inventory", 0,-5 } },

	  LeftFrame = uiwnd {
	    layer = techlayer-1,
	    anchors = { TOPLEFT = { 0, 0 }, BOTTOMRIGHT = { "BOTTOM", -1,0 } },
	    DefCornerFrameImage2{},
	  },
	  
	  RightFrame = uiwnd {
	    layer = techlayer-1,
	    anchors = { TOPRIGHT = { 0, 0 }, BOTTOMLEFT = { "BOTTOM", 1,0 } },
	    DefCornerFrameImage2{},
	    Title = uiwnd {
  	  },  
	  },

    -- tech
    ItemSlot_2_2 = DefTechHolderSlots.ItemSlot_2_2 { frame_idx = 7, repo = "ALIEN_POWER" },
    ItemSlot_2_1 = DefTechHolderSlots.ItemSlot_2_1 { frame_idx = 8, repo = "ALIEN_CORRUPTION" },
    ItemSlot_2_3 = DefTechHolderSlots.ItemSlot_2_3 { frame_idx = 6, repo = "ALIEN_DOGMA" },
    ItemSlot_2_4 = DefTechHolderSlots.ItemSlot_2_4 { frame_idx = 10, repo = "ALIEN_ENIGMA" },
    ItemSlot_1_2 = DefTechHolderSlots.ItemSlot_1_2 { frame_idx = 5, repo = "ALIEN_HARVESTER" },
    ItemSlot_1_3 = DefTechHolderSlots.ItemSlot_1_3 { frame_idx = 4, repo = "ALIEN_MANIPULATOR" },
 	  ItemSlot_1_1 = DefTechHolderSlots.ItemSlot_1_1 { frame_idx = 3, repo = "ALIEN_DOMINATOR" },
    ItemSlot_0   = DefTechHolderSlots.ItemSlot_0   { frame_idx = 1, repo = "ALIEN_MASTER" },
    ItemSlot_1_4 = DefTechHolderSlots.ItemSlot_1_4 { frame_idx = 2, repo = "ALIEN_ARBITER" },
    ItemSlot_1_5 = DefTechHolderSlots.ItemSlot_1_5 { frame_idx = 9, repo = "ALIEN_DEFILER" },

	  ItemLabl_2_2 = DefTechHolderSlots.ItemLabl_2_2 { str = TEXT{"power"} },
	  ItemLabl_2_1 = DefTechHolderSlots.ItemLabl_2_1 { str = TEXT{"corruption"} },
	  ItemLabl_2_3 = DefTechHolderSlots.ItemLabl_2_3 { str = TEXT{"dogma"} },
    ItemLabl_2_4 = DefTechHolderSlots.ItemLabl_2_4 { str = TEXT{"enigma"} },
	  ItemLabl_1_2 = DefTechHolderSlots.ItemLabl_1_2 { str = TEXT{"Harvester.name"} },
	  ItemLabl_1_3 = DefTechHolderSlots.ItemLabl_1_3 { str = TEXT{"Manipulator.name"} },
	  ItemLabl_1_1 = DefTechHolderSlots.ItemLabl_1_1 { str = TEXT{"Dominator.name"} },
	  ItemLabl_0 = DefTechHolderSlots.ItemLabl_0 { str = TEXT{"Master.name"} },
	  ItemLabl_1_4 = DefTechHolderSlots.ItemLabl_1_4 { str = TEXT{"Arbiter.name"} },
	  ItemLabl_1_5 = DefTechHolderSlots.ItemLabl_1_5 { str = TEXT{"Defiler.name"} },

	  -- spec
	  SpecSlot_A1 = DefSpecSlot { row = 5, col = 1, repo = "ALIEN_SPECA1",   anchors = { TOPRIGHT = { "RightFrame" , "TOP", 10,20 } } },
	  SpecSlot_A2 = DefSpecSlot { row = 5, col = 2, repo = "ALIEN_SPECA2",   anchors = { TOPLEFT = { "RightFrame" , "TOP", 30,20 } } },
	  
	  SpecSlot_B1 = DefSpecSlot { row = 5, col = 3, repo = "ALIEN_SPECB1",   anchors = { RIGHT = { "SpecSlot_B2" , "LEFT", -20,0 } } },
	  SpecSlot_B2 = DefSpecSlot { row = 5, col = 4, repo = "ALIEN_SPECB2",   anchors = { RIGHT = { "SpecSlot_B3" , "LEFT", -20,0 } } },
	  SpecSlot_B3 = DefSpecSlot { row = 5, col = 5, repo = "ALIEN_SPECB3",   anchors = { TOP = { "SpecSlot_A2" , "BOTTOM", 0,20 } } },
	  
	  SpecSlot_C1 = DefSpecSlot { row = 6, col = 1, repo = "ALIEN_SPECC1",   anchors = { TOP = { "SpecSlot_B2" , "BOTTOM", -40,20 } } },
	  SpecSlot_C2 = DefSpecSlot { row = 6, col = 2, repo = "ALIEN_SPECC2",   anchors = { TOP = { "SpecSlot_B3" , "BOTTOM", 0,20 } } },
	  
	  SpecSlot_D1 = DefSpecSlot { row = 6, col = 3, repo = "ALIEN_SPECD1",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", 0,20 } } },
	  SpecSlot_D2 = DefSpecSlot { row = 6, col = 4, repo = "ALIEN_SPECD2",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", -40,20 } } },
	  SpecSlot_D3 = DefSpecSlot { row = 6, col = 5, repo = "ALIEN_SPECD3",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", 40,20 } } },
	  
    OnShow = function(this)
      TechGrid.HumansInterface:Hide()
      TechGrid.MutantsInterface:Hide()
    end,
	},
	
	MutantsInterface = uiwnd {
	  hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Humans", 0, 0 }, BOTTOMRIGHT = { "TOPRIGHT", "Inventory", 0,-5 } },

	  LeftFrame = uiwnd {
	    layer = techlayer-1,
	    anchors = { TOPLEFT = { 0, 0 }, BOTTOMRIGHT = { "BOTTOM", -1,0 } },
	    DefCornerFrameImage2{},
	    Title = uiwnd {
  	  },  
	  },
	  
	  RightFrame = uiwnd {
	    layer = techlayer-1,
	    anchors = { TOPRIGHT = { 0, 0 }, BOTTOMLEFT = { "BOTTOM", 1,0 } },
	    DefCornerFrameImage2{},
	    Title = uiwnd {
  	  },  
	  },

    -- tech
    ItemSlot_2_2 = DefTechHolderSlots.ItemSlot_2_2 { frame_idx = 7, repo = "MUTANT_BLOOD" },
    ItemSlot_2_1 = DefTechHolderSlots.ItemSlot_2_1 { frame_idx = 8, repo = "MUTANT_NATURE" },
    ItemSlot_2_3 = DefTechHolderSlots.ItemSlot_2_3 { frame_idx = 6, repo = "MUTANT_MIND" },
    ItemSlot_2_4 = DefTechHolderSlots.ItemSlot_2_4 { frame_idx = 10, repo = "MUTANT_SPIRIT" },
    ItemSlot_1_2 = DefTechHolderSlots.ItemSlot_1_2 { frame_idx = 5, repo = "MUTANT_STONEGHOST" },
    ItemSlot_1_3 = DefTechHolderSlots.ItemSlot_1_3 { frame_idx = 4, repo = "MUTANT_ADEPT" },
 	  ItemSlot_1_1 = DefTechHolderSlots.ItemSlot_1_1 { frame_idx = 3, repo = "MUTANT_SHAMAN" },
    ItemSlot_0   = DefTechHolderSlots.ItemSlot_0   { frame_idx = 1, repo = "MUTANT_HIGHPRIEST" },
    ItemSlot_1_4 = DefTechHolderSlots.ItemSlot_1_4 { frame_idx = 2, repo = "MUTANT_GUARDIAN" },
    ItemSlot_1_5 = DefTechHolderSlots.ItemSlot_1_5 { frame_idx = 9, repo = "MUTANT_PSYCHIC" },

	  ItemLabl_2_2 = DefTechHolderSlots.ItemLabl_2_2 { str = TEXT{"blood"} },
	  ItemLabl_2_1 = DefTechHolderSlots.ItemLabl_2_1 { str = TEXT{"nature"} },
	  ItemLabl_2_3 = DefTechHolderSlots.ItemLabl_2_3 { str = TEXT{"mind"} },
    ItemLabl_2_4 = DefTechHolderSlots.ItemLabl_2_4 { str = TEXT{"spirit"} },
	  ItemLabl_1_2 = DefTechHolderSlots.ItemLabl_1_2 { str = TEXT{"StoneGhost.name"} },
	  ItemLabl_1_3 = DefTechHolderSlots.ItemLabl_1_3 { str = TEXT{"Sorcerer.name"} },
	  ItemLabl_1_1 = DefTechHolderSlots.ItemLabl_1_1 { str = TEXT{"Shaman.name"} },
	  ItemLabl_0 = DefTechHolderSlots.ItemLabl_0 { str = TEXT{"HighPriest.name"} },
	  ItemLabl_1_4 = DefTechHolderSlots.ItemLabl_1_4 { str = TEXT{"Guardian.name"} },
    ItemLabl_1_5 = DefTechHolderSlots.ItemLabl_1_5 { str = TEXT{"Psychic.name"} },
	  
	  -- spec
	  SpecSlot_A1 = DefSpecSlot { row = 3, col = 1, repo = "MUTANT_SPECA1",   anchors = { TOPRIGHT = { "RightFrame" , "TOP", -30,20 } } },
	  SpecSlot_A2 = DefSpecSlot { row = 3, col = 2, repo = "MUTANT_SPECA2",   anchors = { TOPLEFT = { "RightFrame" , "TOP", 30,20 } } },
	  
	  SpecSlot_B1 = DefSpecSlot { row = 3, col = 3, repo = "MUTANT_SPECB1",   anchors = { TOP = { "SpecSlot_A1" , "BOTTOM", -40,20 } } },
	  SpecSlot_B2 = DefSpecSlot { row = 3, col = 4, repo = "MUTANT_SPECB2",   anchors = { TOP = { "SpecSlot_A1" , "BOTTOM", 40,20 } } },
	  SpecSlot_B3 = DefSpecSlot { row = 3, col = 5, repo = "MUTANT_SPECB3",   anchors = { TOP = { "SpecSlot_A2" , "BOTTOM", 0,20 } } },
	  
	  SpecSlot_C1 = DefSpecSlot { row = 4, col = 1, repo = "MUTANT_SPECC1",   anchors = { TOP = { "SpecSlot_B1" , "BOTTOM", 0,20 } } },
	  SpecSlot_C2 = DefSpecSlot { row = 4, col = 2, repo = "MUTANT_SPECC2",   anchors = { TOP = { "SpecSlot_B3" , "BOTTOM", 0,20 } } },
	  
	  SpecSlot_D1 = DefSpecSlot { row = 4, col = 3, repo = "MUTANT_SPECD1",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", 0,20 } } },
	  SpecSlot_D2 = DefSpecSlot { row = 4, col = 4, repo = "MUTANT_SPECD2",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", -40,20 } } },
	  SpecSlot_D3 = DefSpecSlot { row = 4, col = 5, repo = "MUTANT_SPECD3",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", 40,20 } } },
	  
    OnShow = function(this)
      TechGrid.AliensInterface:Hide()
      TechGrid.HumansInterface:Hide()
    end,
	},
	

	HumansInterface  = uiwnd {
	  hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Humans", 0, 0 }, BOTTOMRIGHT = { "TOPRIGHT", "Inventory", 0,-5 } },

	  LeftFrame = uiwnd {
	    layer = techlayer-1,
	    anchors = { TOPLEFT = { 0, 0 }, BOTTOMRIGHT = { "BOTTOM", -1,0 } },
	    DefCornerFrameImage2{},
	    Title = uiwnd {
  	  },  
	  },
	  
	  RightFrame = uiwnd {
	    layer = techlayer-1,
	    anchors = { TOPRIGHT = { 0, 0 }, BOTTOMLEFT = { "BOTTOM", 1,0 } },
	    DefCornerFrameImage2{},
	    Title = uiwnd {
  	  },  
	  },
	  
    -- tech
    ItemSlot_2_2 = DefTechHolderSlots.ItemSlot_2_2 { frame_idx = 7, repo = "HUMAN_DEFENCE" },
    ItemSlot_2_1 = DefTechHolderSlots.ItemSlot_2_1 { frame_idx = 8, repo = "HUMAN_IMPLANTS" },
    ItemSlot_2_3 = DefTechHolderSlots.ItemSlot_2_3 { frame_idx = 6, repo = "HUMAN_WEAPONS" },
    ItemSlot_2_4 = DefTechHolderSlots.ItemSlot_2_4 { frame_idx = 10, repo = "HUMAN_NEUROSCIENCE" },
    ItemSlot_1_2 = DefTechHolderSlots.ItemSlot_1_2 { frame_idx = 5, repo = "HUMAN_CONSTRUCTOR" },
    ItemSlot_1_3 = DefTechHolderSlots.ItemSlot_1_3 { frame_idx = 4, repo = "HUMAN_ASSASSIN" },
 	  ItemSlot_1_1 = DefTechHolderSlots.ItemSlot_1_1 { frame_idx = 3, repo = "HUMAN_SURGEON" },
    ItemSlot_0 =   DefTechHolderSlots.ItemSlot_0   { frame_idx = 1, repo = "HUMAN_COMMANDER" },
    ItemSlot_1_4 = DefTechHolderSlots.ItemSlot_1_4 { frame_idx = 2, repo = "HUMAN_JUDGE" },
    ItemSlot_1_5 = DefTechHolderSlots.ItemSlot_1_5 { frame_idx = 9, repo = "HUMAN_ENGINEER" },

	  ItemLabl_2_2 = DefTechHolderSlots.ItemLabl_2_2 { str = TEXT{"defence"} },
	  ItemLabl_2_1 = DefTechHolderSlots.ItemLabl_2_1 { str = TEXT{"implants"} },
	  ItemLabl_2_3 = DefTechHolderSlots.ItemLabl_2_3 { str = TEXT{"weapon"} },
    ItemLabl_2_4 = DefTechHolderSlots.ItemLabl_2_4 { str = TEXT{"neuroscience"} },
	  ItemLabl_1_2 = DefTechHolderSlots.ItemLabl_1_2 { str = TEXT{"Constructor.name"} },
	  ItemLabl_1_3 = DefTechHolderSlots.ItemLabl_1_3 { str = TEXT{"Assassin.name"} },
	  ItemLabl_1_1 = DefTechHolderSlots.ItemLabl_1_1 { str = TEXT{"Surgeon.name"} },
	  ItemLabl_0 = DefTechHolderSlots.ItemLabl_0 { str = TEXT{"Commander.name"} },
	  ItemLabl_1_4 = DefTechHolderSlots.ItemLabl_1_4 { str = TEXT{"Judge.name"} },
    ItemLabl_1_5 = DefTechHolderSlots.ItemLabl_1_5 { str = TEXT{"Engineer.name"} },

	  -- spec
    SpecSlot_A1 = DefSpecSlot { row = 1, col = 1, repo = "HUMAN_SPECA1",   anchors = { TOPRIGHT = { "RightFrame" , "TOP", -30,20 } } },
	  SpecSlot_A2 = DefSpecSlot { row = 1, col = 2, repo = "HUMAN_SPECA2",   anchors = { TOPLEFT = { "RightFrame" , "TOP", -10,20 } } },
	  
	  SpecSlot_B1 = DefSpecSlot { row = 1, col = 3, repo = "HUMAN_SPECB1",   anchors = { TOP = { "SpecSlot_A1" , "BOTTOM", 0,20 } } },
	  SpecSlot_B2 = DefSpecSlot { row = 1, col = 4, repo = "HUMAN_SPECB2",   anchors = { TOP = { "SpecSlot_A2" , "BOTTOM", 0,20 } } },
	  SpecSlot_B3 = DefSpecSlot { row = 1, col = 5, repo = "HUMAN_SPECB3",   anchors = { LEFT = { "SpecSlot_B2" , "RIGHT", 20,0 } } },
	  
	  SpecSlot_C1 = DefSpecSlot { row = 2, col = 1, repo = "HUMAN_SPECC1",   anchors = { TOP = { "SpecSlot_B1" , "BOTTOM", 0,20 } } },
	  SpecSlot_C2 = DefSpecSlot { row = 2, col = 2, repo = "HUMAN_SPECC2",   anchors = { TOP = { "SpecSlot_B2" , "BOTTOM", 40,20 } } },
	  
	  SpecSlot_D1 = DefSpecSlot { row = 2, col = 3, repo = "HUMAN_SPECD1",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", -40,20 } } },
	  SpecSlot_D2 = DefSpecSlot { row = 2, col = 4, repo = "HUMAN_SPECD2",   anchors = { TOP = { "SpecSlot_C1" , "BOTTOM", 40,20 } } },
	  SpecSlot_D3 = DefSpecSlot { row = 2, col = 5, repo = "HUMAN_SPECD3",   anchors = { TOP = { "SpecSlot_C2" , "BOTTOM", 0,20 } } },
	  
    OnShow = function(this)
      TechGrid.AliensInterface:Hide()
      TechGrid.MutantsInterface:Hide()
    end,
    
  },
  
	Humans = DefRacesBtn {
	  layer = 50,
		str = TEXT{"humans"},
		anchors = { TOPLEFT = { 10,10 } },
    OnMouseEnter = function(this) NTTooltip:DoShow("ability_grid_tab_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
	},

	Mutants = DefRacesBtn {
	  layer = 50,
		str = TEXT{"tribes"},
		anchors = { LEFT = { "RIGHT", "Humans", 0, 0 } },
    OnMouseEnter = function(this) NTTooltip:DoShow("ability_grid_tab_tip", this, "BOTTOM", "TOP", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
	},

	Aliens = DefRacesBtn {
	  layer = 50,
		str = TEXT{"the cult"},
		anchors = { LEFT = { "RIGHT", "Mutants", 0, 0 } },
    OnMouseEnter = function(this) NTTooltip:DoShow("ability_grid_tab_tip", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
	},

  Gems = uiwnd {
    size = {120,26},
    anchors = { BOTTOMRIGHT = { "BOTTOM", "TechGrid.HumansInterface.RightFrame", -10, -39 } },
    Back = uiimg {
	    texture = "data/textures/ui/shard_quantity_plate_2.dds",
	    coords = {0,0,80,26},
    },
    Text = uitext {
      size = {100,26},
      halign = "RIGHT",
      font = "Verdana,11",
    },
    GemsTakenNif = uinif {
      layer = "+10",
      hidden = true,
      size = {10,10},
      nif = "Data/Models/MiscObjects/Interface_item_effect.nif",
      anchors = {CENTER = {2, 0}},
      scale = 0.25,
    },	    
  },

  Stars = uiwnd {
    size = {192,16},
    anchors = { BOTTOMRIGHT = { "HumansInterface", -60,-10 } },

    dx = 0,
    count = 12,
    
    Star_1 = DefSpendStar { anchors = { RIGHT = { 0,0 } } },
    Star_2 = DefSpendStar {},
    Star_3 = DefSpendStar {},
    Star_4 = DefSpendStar {},
    Star_5 = DefSpendStar {},
    Star_6 = DefSpendStar {},
    Star_7 = DefSpendStar {},
    Star_8 = DefSpendStar {},
    Star_9 = DefSpendStar {},
    Star_10 = DefSpendStar {},
    Star_11 = DefSpendStar {},
    Star_12 = DefSpendStar {},
    
    OnShow = function(this)
      local ss = this.Star_1:GetSize()
      this:SetSize{(this.count*ss.x) + ((this.count-1)*this.dx), ss.y}
      for i = 2,this.count do
        this["Star_"..i]:SetAnchor("RIGHT", this["Star_"..i-1], "LEFT", {this.dx,0})  
      end
    end,
  },
  
  ResetSpec = DefButton {
    layer = techlayer+1,
    size = {120,26},
    anchors = { BOTTOMLEFT = { "BOTTOM", "TechGrid.HumansInterface.RightFrame", 10, -40 } },
    font = "Verdana,10",
    str = TEXT{"reset"},
    OnClick = function(this)
      if game.ResetSpecs(TechGrid.race) then
        TechGrid:UpdateGems()
        game.PlaySnd(sounds.on_reset) 
      else
        ErrText:ShowText(ERRTEXTS["NOGEMS"])
        game.PlaySnd("data/speech/Advisor/no xenoshards.wav")
        --game.PlaySnd(sounds.on_error)
      end
    end,
    OnMouseEnter = function(this) 
      local gems = game.GetResetGems()
      NTTooltip:DoShow(TEXT{"reset_spec_tip"}.." (<color=130,130,255>"..gems.."</>)", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) 
    end,
    OnMouseLeave = function(this) NTTooltip:Hide() end,
  },
}

function TechGrid:OnLoad()
  this.Humans.race = "humans"
  this.Mutants.race = "mutants"
  this.Aliens.race = "aliens"
  this:RegisterEvent("ITEM_UPDATE")
  this:RegisterEvent("ITEM_DRAGEND")
  this:RegisterEvent("ITEM_DRAGBEGIN")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("PLAYER_GEMS_CHANGED")
end

function TechGrid:OnEvent(event)
  if event == "PLAYER_GEMS_CHANGED" then
    this:UpdateGems()
    if argDelta and argDelta > 0 then
      this.Gems.GemsTakenNif:Show()
      Transitions:CallOnce(function() this.Gems.GemsTakenNif:Hide() end, 0.767)
    end
  end  
  if event == "MAP_LOADED" then
    this:Hide()
  end  
	if event == "ITEM_UPDATE" then
	end
  if event == "ITEM_DRAGBEGIN" then
    this.stratdragslot = argSlot
    this.startdragitem = argSlot:GetItem()
  end
  
  if event == "ITEM_DRAGEND" then
    if this.stratdragslot then 
      this.stratdragslot = nil
      this.startdragitem = nil
    end  
  end  
end

function TechGrid:OnShow()
  Lobby.AbilityBtn.checked = 1
  Lobby.AbilityBtn:updatetextures()
  
  Inventory:SetAnchor("BOTTOM", this, "BOTTOM", {0,-15})
	if this.race == nil then 
	  this:SelectRace(this.Humans) 
	else
	  Inventory:Show(this.race)  
	  this:UpdateGems()
	end
	
  local interface = TechGrid.HumansInterface
  if this.race == "aliens" then interface = TechGrid.AliensInterface end
  if this.race == "mutants" then interface = TechGrid.MutantsInterface end
  
  this.zoneDisabled = true
  game.SetEarthActive(false)
end

function TechGrid:OnHide()              
  Lobby.AbilityBtn.checked = 0
  Lobby.AbilityBtn:updatetextures()
	Inventory:Hide()
  this.zoneDisabled = false
  game.SetEarthActive(true)
end

function TechGrid:SelectRace(btn)
  this.race = btn.race
  
  Inventory:Show(this.race)

  this.Humans:SelectTab(false)
  this.Mutants:SelectTab(false)
  this.Aliens:SelectTab(false)
  btn:SelectTab(true)
  
  local interface = TechGrid.HumansInterface
  if this.race == "aliens" then interface = TechGrid.AliensInterface end
  if this.race == "mutants" then interface = TechGrid.MutantsInterface end

  if this.race == "humans" then
    this.HumansInterface:Show()
  elseif this.race == "aliens" then
    this.AliensInterface:Show()
  elseif this.race == "mutants" then
    this.MutantsInterface:Show()
  end

  this:UpdateGems()
end

function TechGrid:UpdateGems()
  local gems, allGems = game.GetPlayerGems()
  this.Gems.Text:SetStr("<color=103,137,236>"..gems.."</><color=50,62,140>/"..allGems.."</>")

  for race, interface in pairs{humans = this.HumansInterface, mutants = this.MutantsInterface, aliens = this.AliensInterface} do  
    local starsFree, starsUsed = game.GetPlayerStars(race)
    if not interface:IsHidden() then
      starsFree = starsFree + starsUsed
      
      local hs = this.Stars:GetSize()
      local ss = this.Stars.Star_1:GetSize()
      local offs = (hs.x - ((starsFree*ss.x) + ((starsFree-1)*this.Stars.dx))) / 2
      this.Stars.Star_1:SetAnchor("RIGHT", this.Stars, "RIGHT", {-offs,0})
      
      for i = 1,this.Stars.count do
        if i <= starsFree then
          if i <= starsUsed then
            this.Stars["Star_"..i]:SetState(1)
          else
            this.Stars["Star_"..i]:SetState(2)
          end
        else
          this.Stars["Star_"..i]:SetState("hide")
        end
      end
    end
    
    for k,v in pairs(interface) do
      if string.sub(tostring(k), 1, 9) == 'SpecSlot_' then 
        local id = string.sub(tostring(k), 10, 11)
        local state, stars, maxStars, prevID, err = game.GetSpecInfo(race, id)
        local prevState = game.GetSpecInfo(race, prevID)
        if prevState and prevState <= 0 then
          v.Animation:SetAlpha(0)
          v.Animation:Hide()
          v.SlotDisabled:Hide()
          
          v:SetAlpha(0)
          v.SpecIcon:SetAlpha(0)
          v.Star_1:SetAlpha(0)
          v.Star_2:SetAlpha(0)
          v.Star_3:SetAlpha(0)
          v.StarPlate:SetAlpha(0)
          v.SlotBack:SetAlpha(1)
          v.SlotBack:Show()
        else
          v.SlotBack:Hide()
          if state > 0 then
            v.Animation:SetAlpha(0)
            v.Animation:Hide()
            v.Star_1:SetColor(StarColorDisabled)
            v.Star_2:SetColor(StarColorDisabled)
            v.Star_3:SetColor(StarColorDisabled)
            if stars > 0 then v.Star_1:SetColor(StarColorEnabled) end
            if stars > 1 then v.Star_2:SetColor(StarColorEnabled) end
            if stars > 2 then v.Star_3:SetColor(StarColorEnabled) end
            for i = 1,maxStars do v["Star_"..i]:Show() end
            for i = maxStars+1,3 do v["Star_"..i]:Hide() end
            v:SetAlpha(0)
            v.SpecIcon:SetAlpha(1)
            v.Star_1:SetAlpha(1)
            v.Star_2:SetAlpha(1)
            v.Star_3:SetAlpha(1)
            local sz = v.StarPlate:GetSize()
            local top = (maxStars-1)*sz.y
            v.StarPlate:SetTexture(nil, {0,top,sz.x,top+sz.y})
            v.StarPlate:SetAlpha(1)
          else
            v:SetAlpha(0)
            v.SpecIcon:SetAlpha(0)
            v.Animation:SetAlpha(1)
            v.Animation:Show()
            for i = 1,3 do v["Star_"..i]:Hide() end
            v.StarPlate:SetAlpha(0)
          end
          if err then
            v.SlotDisabled:SetAlpha(0.5)
            v.SlotDisabled:Show()
          else
            v.SlotDisabled:Hide()
          end
        end
      end
    end
  end
end
                                                          
