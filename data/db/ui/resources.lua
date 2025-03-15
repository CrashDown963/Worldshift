--
-- resource view
--

MenuBtn = uibtn {
  size = {56,64},
  anchors = { TOPRIGHT = { 0, -6 } },
  layer = 1,
  
  Frame = uiimg {  
  	layer = 1,
  	size = {56,64},
    texture = "data/textures/ui/menu_frame_new.dds",
  	texture_auto_coords = true,
	},
  
  NormalImage = uiimg {  
    layer = 2,
  	size = {27,23},
    texture = "data/textures/ui/menu_button_new.dds",
  	texture_auto_coords = true,
  	anchors = { CENTER = { -3, -5 } },
	},
	
	PushImage = uiimg {  
    layer = 2,
  	size = {27,23},
    texture = "data/textures/ui/menu_button_new.dds",
  	texture_auto_coords = true,
  	anchors = { CENTER = { -2, -4 } },
	},
	
  OnLoad = function(this) table.insert(GameUI.topWindows.any, this) end,
  
  OnClick = function(this) InGameMenu:Toggle() end,

  OnMouseEnter = function(this)
    Tooltip:RemoveAnchors()
    Tooltip:AttachTo(this, "TOPRIGHT", this, "BOTTOMLEFT", {0,-5})
    Tooltip.Title:SetStr("<p>"..TEXT{"menu button ttl"})
    Tooltip.Text:SetStr("<p>"..TEXT{"menu button"})
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,

  OnMouseLeave = function(this) Tooltip:Hide() end,
}

Resources = uiwnd {
	virtual = true,
  size = {430,30},
  anchors = { TOPRIGHT = { 0, 6 } },
  
  Text = uiwnd { 
    virtual = true,
    mouse = true,
    size = {94,29},
    
	  Back = uiimg {          
	  	layer = -3,
	  	size = {94,29},
			texture = "data/textures/ui/resources_back_new.dds",
			texture_auto_coords = true,
			anchors = { TOPLEFT = {} },
	  },
    
    Icon = uiimg {
	  	layer = -2,
    	size = {33,25},
    	texture = "data/textures/ui/resource_icons.dds",
    	anchors = { TOPLEFT = { 5, 2 } },
    },
    
  	t = uitext {
	    layer = -1,
	    font = "Arial,9b",
	    halign = "LEFT",
	    color = {243,185,93},
	    anchors = { LEFT = { 42, 1 } },
  	},
    
	  GetTooltips = function (this)
		  local title = this.t.tt_title
		  local text = this.t.tt_text
		  return title, text
	  end,
	  
	  OnMouseEnter = function(this)
	    this:GetParent():ShowTooltip(this)
	  end,
	  
	  OnMouseLeave = function(this)
	    this:GetParent():HideTooltip(this)
	  end,
  },

	ShowTooltip = function (parent, res)
	  Tooltip:RemoveAnchors()
	  Tooltip:AttachTo(parent, "TOPRIGHT", parent, "BOTTOMRIGHT", {-90,5})
	  local title, text = res:GetTooltips()
	  Tooltip.Title:SetStr("<p>"..title)
		Tooltip.Text:SetStr("<p>"..text)
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
	end,
	
	HideTooltip = function ()
	  Tooltip:Hide()
	end,
	
	CheckVisibility = function()
	  return game.GetMapType() ~= "mission" and game.GetMapType() ~= "special_location"
	end,
}

-- MutantRes

MutantRes = Resources {
  Text = {},
	
	UnitPoints = Resources.Text { 
		Back = Resources.Text.Back {},
		Icon = Resources.Text.Icon { coords = {33,0,33,25} },
		anchors = { TOPRIGHT = { "TOPLEFT", "MenuBtn", 0,5 } },
	  t = Resources.Text.t {
	    str = "[#]/<color=255,255,255>[#]</>",
	    tt_title = TEXT{"tribes resources ttl"},
	    tt_text = TEXT{"tribes unit points"},
	  },
	},

	Credits = Resources.Text {                  
		Back = Resources.Text.Back {},
		Icon = Resources.Text.Icon { coords = {0,0,33,25} },
		anchors = { RIGHT = { "LEFT", "UnitPoints", -5,0 } },
	  t = Resources.Text.t {
	    str = "[#]",
	    tt_title = TEXT{"tribes resources ttl"},
	    tt_text = TEXT{"tribes credits"},
	  },
	},
}

function MutantRes:OnLoad()
  this:RegisterEvent("MAP_LOADED") 
  this:RegisterEvent("RES_CHANGE")
  table.insert(GameUI.topWindows.mutants, this)
  this.Credits.t:SetStrVals{"-"}
  this.UnitPoints.t:SetStrVals{"-", "-"}
end

function MutantRes:OnEvent(event)
  if event == "RES_CHANGE" or event == "MAP_LOADED" then
    this:Update(argRes)
  end
end

function MutantRes:Update(res)
  if not res then res = game.GetResources() end
  this.Credits.t:SetStrVals{res.res}
  this.UnitPoints.t:SetStrVals{res.points, res.pointsMax}
end

-- HumanRes

HumanRes = Resources {
  Text = {},
	
	UnitPoints = Resources.Text { 
		Back = Resources.Text.Back {},
		Icon = Resources.Text.Icon { coords = {33,0,33,25} },
		anchors = { TOPRIGHT = { "TOPLEFT", "MenuBtn", 0,5 } },
	  t = Resources.Text.t {
	    str = "[#]/<color=255,255,255>[#]</>",
	    tt_title = TEXT{"humans resources ttl"},
	    tt_text = TEXT{"humans unit points"},
	  },
	},

	Credits = Resources.Text {                  
		Back = Resources.Text.Back {},
		Icon = Resources.Text.Icon { coords = {0,0,33,25} },
		anchors = { RIGHT = { "LEFT", "UnitPoints", -5,0 } },
	  t = Resources.Text.t {
	    str = "[#]",
	    tt_title = TEXT{"humans resources ttl"},
	    tt_text = TEXT{"humans credits"},
	  },
	},
}

function HumanRes:OnLoad()
  this:RegisterEvent("MAP_LOADED") 
  this:RegisterEvent("RES_CHANGE")
  table.insert(GameUI.topWindows.humans, this)
  this.Credits.t:SetStrVals{"-"}
  this.UnitPoints.t:SetStrVals{"-", "-"}
end    

function HumanRes:OnEvent(event)
  if event == "RES_CHANGE" or event == "MAP_LOADED" then
    this:Update(argRes)
  end
end

function HumanRes:Update(res)
  if not res then res = game.GetResources() end
  this.Credits.t:SetStrVals{res.res}
  this.UnitPoints.t:SetStrVals{res.points, res.pointsMax}
end

-- AlienRes

AlienRes = Resources {
  Text = {},
	
	UnitPoints = Resources.Text { 
		Back = Resources.Text.Back {},
		Icon = Resources.Text.Icon { coords = {33,0,33,25} },
		anchors = { TOPRIGHT = { "TOPLEFT", "MenuBtn", 0,5 } },
	  t = Resources.Text.t {
	    str = "[#]/<color=255,255,255>[#]</>",
	    tt_title = TEXT{"the cult resources ttl"},
	    tt_text = TEXT{"the cult unit points"},
	  },
	},

	Credits = Resources.Text {                  
		Back = Resources.Text.Back {},
		Icon = Resources.Text.Icon { coords = {0,0,33,25} },
		anchors = { RIGHT = { "LEFT", "UnitPoints", -5,0 } },
	  t = Resources.Text.t {
	    str = "[#]",
	    tt_title = TEXT{"the cult resources ttl"},
	    tt_text = TEXT{"the cult unit credits"},
	  },
	},
}

function AlienRes:OnLoad()
  this:RegisterEvent("MAP_LOADED") 
  this:RegisterEvent("RES_CHANGE")
  table.insert(GameUI.topWindows.aliens, this)
  this.Credits.t:SetStrVals{"-"}
  this.UnitPoints.t:SetStrVals{"-"}
end

function AlienRes:OnEvent(event)
  if event == "RES_CHANGE" or event == "MAP_LOADED" then
    this:Update(argRes)
  end
end

function AlienRes:Update(res)
  if not res then res = game.GetResources() end
  this.Credits.t:SetStrVals{res.res}
  this.UnitPoints.t:SetStrVals{res.points, res.pointsMax}
end
