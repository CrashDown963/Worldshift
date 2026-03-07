 --                                                                                                 
-- ITEM TOOLTIP                                                                                    
--                                                                                                 

local SlotNames = {
  HUMAN_COMMANDER = "Commander.name",
  HUMAN_SURGEON  = "Surgeon.name",
  HUMAN_CONSTRUCTOR = "Constructor.name",
  HUMAN_ASSASSIN = "Assassin.name",
  HUMAN_JUDGE = "Judge.name",
  HUMAN_ENGINEER = "Engineer.name",
  HUMAN_DEFENCE  = "defence",
  HUMAN_IMPLANTS = "implants",
  HUMAN_WEAPONS = "weapon",
  HUMAN_NEUROSCIENCE = "neuroscience",

  MUTANT_HIGHPRIEST = "HighPriest.name",
  MUTANT_SHAMAN   = "Shaman.name",
  MUTANT_STONEGHOST  = "StoneGhost.name",
  MUTANT_ADEPT  = "Sorcerer.name",
  MUTANT_GUARDIAN  = "Guardian.name",
  MUTANT_PSYCHIC  = "Psychic.name",
  MUTANT_BLOOD  = "blood",
  MUTANT_NATURE  = "nature",
  MUTANT_MIND = "mind",
  MUTANT_SPIRIT = "spirit",

  ALIEN_MASTER = "Master.name",
  ALIEN_DOMINATOR = "Dominator.name",
  ALIEN_HARVESTER = "Harvester.name",
  ALIEN_MANIPULATOR  = "Manipulator.name",
  ALIEN_DEFILER  = "Defiler.name",
  ALIEN_ARBITER  = "Arbiter.name",
  ALIEN_POWER  = "power",
  ALIEN_CORRUPTION  = "corruption",
  ALIEN_DOGMA  = "dogma",
  ALIEN_ENIGMA  = "enigma",
}

local max_stats = 5
local max_units = 10

local itemcolors = {
  clr1 = {183,187,200,255},
  clr2 = {119,224,80,255},
  clr3 = {255,255,0,255},
  clr4 = {255,172,49,255},
  clr5 = {204,0,204,255},
  clr6 = {255,20,0,255},
}

-- default colors
local hdrcolor = {255,189,68,255}
local subtitlecolor = {223,226,0,255}
local valuecolor = {255,216,0,255}

-- default fonts
local hdrfont = "Verdana,9"

local DefStat = uitext { 
	virtual = true,
	size = {200,16},
	halign = "LEFT",
	font = "Arial,8",
	color = {222,222,222,255},
	str = "<color=[#]>[#]  [#]</>",
}

local DefEffDescr = uitext {
	virtual = true,
	size = {200,70},
	halign = "LEFT",
	valign = "TOP",
	font = "Arial,8",
	color = {179,226,124,255},
}

local ttip_w = 360

local StatBase = uiwnd {
  virtual = true,
  size = {ttip_w - 56, 1},
  
  Stat = uitext {
    layer = "+1",
    size = {150, 20},
    --anchors = { TOPLEFT = {0,0}}, --TOPRIGHT = {"TOPLEFT", 50,0}},
    anchors = { TOPRIGHT = {"TOPLEFT",40,0}}, --TOPRIGHT = {"TOPLEFT", 50,0}},
    color = {0, 255, 0}, 
    halign = "RIGHT", 
    valign = "TOP",
    font = "Tahoma,11",
  },

  StatDesc = uitext {
    layer = "+1",
    size = {1, 60},
    anchors = { TOPLEFT = { "TOPLEFT", 45,0 }, TOPRIGHT = {-5,0}}, 
    color = {255, 255, 255},
    halign = "LEFT", 
    valign = "TOP",
    shadow_ofs = {1,1},
    font = "Tahoma,11",
  },  
  
  Set = function(this, stat, desc)
    this.Stat:SetStr("<p>"..stat)
    this.StatDesc:SetStr("<p>"..desc)
    local sz = this:GetSize()
    local h = this.StatDesc:GetStrHeight()
    this:SetSize{sz.x, h}
  end,
}

UnitStatBase = uiwnd {
  virtual = true,
  hidden = true,
  size = {ttip_w-50,1},
  layer = "+1",
  
  UnitName = uitext {
    layer = "+1",
    size = {ttip_w-30,20},
    anchors = { TOPLEFT = { 0,5 } },
    color = {255, 143, 51},
    font = "Trebuchet,11b",
    halign = "LEFT",
  }, 
        
  UnitStat1 = StatBase { anchors = {TOP = {"BOTTOM", "UnitName", 0, 0}} },
  UnitStat2 = StatBase { anchors = {TOP = {"BOTTOM", "UnitStat1", 0, 2}} },
  UnitStat3 = StatBase { anchors = {TOP = {"BOTTOM", "UnitStat2", 0, 2}} },
  UnitStat4 = StatBase { anchors = {TOP = {"BOTTOM", "UnitStat3", 0, 2}} },
  UnitStat5 = StatBase { anchors = {TOP = {"BOTTOM", "UnitStat4", 0, 2}} },
   
  Sepline = uiimg {
    layer = "+1",
    size = {ttip_w - 60,2},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    tiled = {60, 3, 60, 3},
    anchors = { TOP = { 0, 100 } },
  },   

  Set = function(this, tbl)
    if tbl.name == "Overseer" then
      this.UnitName:SetStr(TEXT{"Overseer.field_name"})
    elseif tbl.name == "Trooper" then
      this.UnitName:SetStr(TEXT{"Trooper.trooper_name"})
    else
      this.UnitName:SetStr(TEXT{tbl.name .. ".name"})
    end

    local h = 0    
    for i,v in ipairs(tbl) do
      local curStat = this["UnitStat"..i]
      if string.sub(v.val, 1, 1) == "-" then
        curStat:Set(v.val, TEXT("stat."..v.desc))
      else
        curStat:Set("+"..v.val, TEXT("stat."..v.desc))
      end
      curStat:Show()
      h = h + curStat:GetSize().y
    end
    
    for ii = #tbl+1,max_stats do
      this["UnitStat"..ii]:Hide()
    end
    
    this:SetSize{this:GetSize().x, h + 30 + 10}
    this.Sepline:SetAnchor("TOP", this["UnitStat"..#tbl], "BOTTOM", {0,10})
    this.Sepline:Show()
  end,
}

DefItemTooltip = uiwnd {
  virtual = true,
  layer = modallayer + 100,
	size = {ttip_w,30},
  anchors = { TOP = { 0, 200 } },
  
  Frame = uiimg {
    texture = "data/textures/ui/tooltip_frame.dds",
    coords = {0, 0, 100, 100},
    tiled = {15,15,15,15},
  },
  
  Back = uiimg {
    layer = "-3",
    texture = "data/textures/ui/tooltip_back.dds",
    coords = {0, 0, 100, 100},
    tiled = {15,15,15,15},
    shader = "_Misc_IDBB_Tooltip",
  },
  
  BlackBox = uiimg {
    layer = "-1",
    texture = "data/textures/ui/tooltip_black.dds",
    coords = {0, 0, 100, 50},
    tiled = {15,15,15,15},
    anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { "TOPRIGHT", 0,34 } },
  },

  WhiteBox = uiimg {
    layer = "-2",
    texture = "data/textures/ui/tooltip_white1.dds",
    coords = {0, 0, 100, 60},
    tiled = {15,5,15,5},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "BlackBox", 0,-3 }, BOTTOMRIGHT = { "BOTTOMRIGHT", "BlackBox", 0, 18 }},
    color = {255,255,255,168},
  },
   
  ItemNameTxt = uitext {
    layer = "+3",
    size = {ttip_w,22},
    anchors = { CENTER = {"CENTER", "BlackBox", 0, 7 } },
    color = {255, 143, 51},
  	font = "Trebuchet,11b",
  },     

  ItemSlotTxt = uitext {
    layer = "+3",
    size = {ttip_w,21},
    anchors = { CENTER = {"CENTER", "WhiteBox", 0,2 } },
    color = {5, 5, 5},
  	font = "Tahoma,11",
  },      
   
  Unit1 = UnitStatBase { anchors = {TOP = { "BOTTOM", "WhiteBox", 0, 2}}},
  Unit2 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit1", 0, 5}}},
  Unit3 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit2", 0, 5}}},
  Unit4 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit3", 0, 5}}},
  Unit5 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit4", 0, 5}}},
  Unit6 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit5", 0, 5}}},
  Unit7 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit6", 0, 5}}},
  Unit8 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit7", 0, 5}}},
  Unit9 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit8", 0, 5}}},
  Unit10 = UnitStatBase { anchors = {TOP = { "BOTTOM", "Unit9", 0, 5}}},

  Sepline = uiimg {
    layer = "+3",
    size = {ttip_w - 14,20},
    texture = "data/textures/ui/stats_horizont_line_6.dds", 
    coords = {0,0,256,6},
    tiled = {60, 3, 60, 3},
    anchors = { TOP = { 0, 100 } },
  },   

  ItemDescr = uitext {
    layer = "+3",
	  size = {ttip_w - 50,500},
	  halign = "LEFT",
	  valign = "TOP",
		anchors = { TOP = {"TOP", "Sepline", 0, 10 } },
		font = "Tahoma,11",
		color = {142,142,142},
	},  
	
  PVPItemCostTxt = uitext {
    layer = "+3",  
	  size = {ttip_w - 50,24},
	  hidden = true,
	  halign = "LEFT",
	  valign = "TOP",
		anchors = { TOP = {"TOP", "Sepline", 0, 10 } },
		font = "Tahoma,11",
		color = {142,142,142},
	}, 	
	
	Set = function(this, tbl, item, itemSlot, inspect)
	  this.PVPItemCostTxt:Hide()
	  if itemSlot and itemSlot:IsSpec() then
      for i = 1,8 do
        this["Unit"..i]:Hide()
      end      
      
      this.ItemNameTxt:SetColor({255, 143, 51, 255})
      
      if inspect == 1 then
        local specstate, stars, maxstars, prev =  game.GetInspectSpecInfo(item.race, string.sub(itemSlot:GetRepo(), -2)) 
        if stars > 0 then
          this.ItemSlotTxt:SetStr("<p>"..stars.."/"..maxstars)
        else
          this.ItemSlotTxt:SetStr("<p>("..TEXT("inactive_spec")..")")
        end
      else
        local specstate, stars, maxstars, prev, err =  game.GetSpecInfo(item.race, string.sub(itemSlot:GetRepo(), -2)) 
        if stars > 0 then
          this.ItemSlotTxt:SetStr("<p>"..stars.."/"..maxstars)
        else
          this.ItemSlotTxt:SetStr("<p>("..TEXT("inactive_spec")..")")
        end
      end
      
      
      if item.text then
        this.ItemDescr:SetStr("<p>"..TEXT(item.text))
      else
        this.ItemDescr:SetStr("<p>"..TEXT("generic_item."..item.repo[1]))
      end    
      
      this.Sepline:SetAnchor("TOP", this.WhiteBox, "BOTTOM", {0,0})
      this.Sepline:Hide()
    
      this.ItemDescr:SetSize{this.ItemDescr:GetSize().x, this.ItemDescr:GetStrHeight() + 10}
      this:AddAnchor("BOTTOM", this.ItemDescr, "BOTTOM", {0, 10})      

	  else
	    this.ItemSlotTxt:Show()
      for i,v in ipairs(tbl) do
        local unit = this["Unit"..i]
        unit:Set(v)
        unit:Show()
      end
  
      for ii = #tbl+1,max_units do
        this["Unit"..ii]:Hide()
      end 	
    
      this["Unit"..#tbl].Sepline:Hide()
    
      if itemSlot and itemSlot.repo == "PVP" then
        this.PVPItemCostTxt:SetAnchor("TOP", this["Unit"..#tbl], "BOTTOM", {0, 5})
        if game.GetPlayerBattlePoints() < item.bpcost then
          this.PVPItemCostTxt:SetStr("<p><color = 234,223,178,255>"..TEXT("battle points cost:").." </color>".."<color = 255,0,0,255>"..item.bpcost.."</color>")
        else
          this.PVPItemCostTxt:SetStr("<p><color = 234,223,178,255>"..TEXT("battle points cost:").." </color>".."<color = 0,255,0,255>"..item.bpcost.."</color>")
        end
        this.PVPItemCostTxt:Show()
        this.Sepline:SetAnchor("TOP", this.PVPItemCostTxt, "BOTTOM", {0,0})
      else
        this.Sepline:SetAnchor("TOP", this["Unit"..#tbl], "BOTTOM", {0,-5})
      end
    
      this.Sepline:Show()
    
      if item.text then
        this.ItemDescr:SetStr("<p><i>"..TEXT(item.text).."</i>")
      else
        this.ItemDescr:SetStr("<p><i>"..TEXT("generic_item."..item.repo[1]).."</i>")
      end    
    
      this.ItemDescr:SetSize{this.ItemDescr:GetSize().x, this.ItemDescr:GetStrHeight() + 10}
      this:AddAnchor("BOTTOM", this.ItemDescr, "BOTTOM", {0, 10})
    end
	end,
}

function DefItemTooltip:SetItem(item, itemSlot, inspect)
	if not item then return 0 end

  this.ItemNameTxt:SetColor(itemcolors["clr"..item.quality])

  -- For the Spanish and Italian versions, item names should be enclosed in angle quotes.
  local lng = string.upper(game.GetLang())
  if ("ES" == lng or "IT" == lng) and not (itemSlot and itemSlot:IsSpec()) then
    this.ItemNameTxt:SetStr(TEXT{"format_item_name", item.name})  
  else  
    this.ItemNameTxt:SetStr(TEXT{item.name})
  end

  this.ItemSlotTxt:SetStr("<p>("..TEXT{SlotNames[item.repo[1]]}..")")
  
  local tbl = item.stats
  this:Set(tbl, item, itemSlot, inspect)
  
  if itemSlot then
	  local height = this:GetSize().y
	  local pos = itemSlot:GetAbsPos()
	  local ds = DESKTOP:GetSize()
	  local ox, oy = 0,0

	  if pos.x > ds.x / 2 then
		  if pos.y > ds.y / 2 then
			  this:SetAnchor("BOTTOMRIGHT", itemSlot, "TOPLEFT", {ox, oy} )
			  local mpos = this:GetAbsPos()
			  if mpos.y < 0 then oy = -mpos.y end
			  if oy > 0 then                                         
				  this:SetAnchor("BOTTOMRIGHT", itemSlot, "TOPLEFT", {ox, oy} )
			  end	
		  else
			  this:SetAnchor("TOPRIGHT", itemSlot, "BOTTOMLEFT", {ox, oy} )
			  local mpos = this:GetAbsPos()
			  if mpos.y + height > ds.y then oy = -((mpos.y + height) - ds.y) end
			  if oy < 0 then                                         
				  this:SetAnchor("TOPRIGHT", itemSlot, "BOTTOMLEFT", {ox, oy} )
			  end	
		  end
	  else
		  if pos.y > ds.y / 2 then
			  this:SetAnchor("BOTTOMLEFT", itemSlot, "TOPRIGHT", {ox, oy} )
			  local mpos = this:GetAbsPos()
			  if mpos.y < 0 then oy = -mpos.y end
			  if oy > 0 then                                            
				  this:SetAnchor("BOTTOMLEFT", itemSlot, "TOPRIGHT", {ox, oy} )
			  end	
		  else
			  this:SetAnchor("TOPLEFT", itemSlot, "BOTTOMRIGHT", {ox, oy} )      
			  local mpos = this:GetAbsPos()
			  if mpos.y + height > ds.y then oy = -((mpos.y + height) - ds.y) end
			  if oy < 0 then
				  this:SetAnchor("TOPLEFT", itemSlot, "BOTTOMRIGHT", {ox, oy} )
			  end	
		  end
	  end
    local repo = itemSlot:GetInfo()
    if string.sub(repo, 1, 10) == "INVENTORY_" then
      this:SetAnchor("TOPRIGHT", itemSlot, "TOPLEFT", {0,-8} )  
      local ttpos = this:GetAbsPos()
      local offsy = (ttpos.y + height)-ds.y
      if offsy > 0 then
        this:SetAnchor("TOPRIGHT", itemSlot, "TOPLEFT", {0,-offsy+8} )    
      end
    end
  else
    this:SetAnchor("LEFT", DESKTOP, "LEFT", {50, 0} )
  end
  
  this:Show()
  
 	return 1
end

--
ItemTooltip = DefItemTooltip {}
--
LinkItemTooltip = DefItemTooltip {
  layer = modallayer - 10,

  Close = DefButton {
    size = {17,17},
    anchors = { TOPRIGHT = { "Frame", -14,14 } },

    NormalImage = uiimg { texture = "data/textures/ui/x-close-tooltip.dds", coords = {0, 0, 17, 17} },
    HighImage = uiimg { texture = "data/textures/ui/x-close-tooltip.dds", coords = {0, 17, 17, 17} },
    PushImage = uiimg { texture = "data/textures/ui/x-close-tooltip.dds", coords = {0, 34, 17, 17} },

    OnClick = function(this) this:GetParent():Hide() end,
  },

  OnLoad = function(this) this:RegisterEvent("LINK_CLICKED") end,
  OnEvent = function(this, event)
    if event == "LINK_CLICKED" and argType == "item" then
      local item = game.GetItem(argID)
      if item then
        if argShift then
          DESKTOP:CreateItemLink(item)
        else
          this:SetItem(item, nil, 0)
        end
      end
    end
  end,
}
--