local DistanceColors = {}
DistanceColors['0'] = { 0,255,0 }
DistanceColors['2000'] = { 255,255,0 }
DistanceColors['12000'] = { 255,0,0 }

--        
-- DEFS
--        

local DefBtn = uiactbtn {
  virtual = true,
  hidden = true,
  size = {44,58},
  
  Frame = uiimg {  
  	layer = 2,
  	size = {42,42},
    texture = "data/textures/ui/action_button.dds",
  	texture_auto_coords = true,
  	anchors = { CENTER = { 0, 3 } },
	},

  Icon = uiimg { 
  	size = {38,38},
  	layer = 3,
  	texture = "data/textures/ui/buttons.dds",
  	texture_auto_coords = true,
  	anchors = { CENTER = { "Frame" } },
  	-- shader = "_Misc_InterfaceDrawAction",
  },
  
  Highlight = uiimg { 
    hidden = true,
  	size = {38,38},
  	layer = 5,
  	texture = "data/textures/ui/action_highlight_fx.dds",
    shader = "_Misc_InterfaceDrawScreen",
  	anchors = { CENTER = { "Frame" } },
  	texture_auto_coords = true,
  },
  
  OnMouseEnter = function(btn) 
    btn:GetParent():ShowTooltip(btn) 
    btn.Highlight:SetColor({138,125,255})
    btn.Highlight:Show()
  end,
  
  OnMouseLeave = function(btn) 
    Tooltip:Hide()
    btn.Highlight:Hide()
  end,
  
  OnMouseDown = function(btn) 
    if argBtn == "LEFT" then 
      btn.Icon:SetAnchor("CENTER", btn.Frame, "CENTER", {1,1}) 
      btn.Highlight:SetAnchor("CENTER", btn.Frame, "CENTER", {1,1}) 
    end 
  end,
  
  OnMouseUp = function(btn) 
    if argBtn == "LEFT" then 
      btn.Icon:SetAnchor("CENTER", btn.Frame, "CENTER", {0,0}) 
      btn.Highlight:SetAnchor("CENTER", btn.Frame, "CENTER", {0,0}) 
    end 
  end,
}

local DefCap = uiimg {
  virtual = true,
	hidden = true,
	layer = -1,
	size = {13,58},
	texture_auto_coords = true,
}

--        
-- ACTIONS
--        

local ACTION_COUNT = 20

local DefActionBtn = DefBtn {
  virtaul = true;

  Pad = uiimg {
  	size = {44,58},
  	layer = 1,
    texture = "data/textures/ui/actions_frame_middle.dds",
  	texture_auto_coords = true,
	},
	
	UnitsCount = uiimg {
	  hidden = true,
  	size = {16,16},
  	layer = 4,
    texture = "data/textures/ui/numbers.dds",
  	texture_auto_coords = true,
  	anchors = { BOTTOMRIGHT = { "BOTTOMRIGHT", "Frame", 0,0 } },
  	
  	Set = function(this, num)
  	  if (num or 0) < 2 then this:Hide() return end
  	  num = num - 1
  	  if num > 9 then num = 9 end
  	  local rc = {num * 16, 0, (num * 16) + 16, 16}
  	  this:SetTexture(nil, rc)
  	  this:Show()
  	end,
	},
	
  Light = uiimg {
  	size = {42,4},
  	layer = 4,
    texture = "data/textures/ui/action_light.dds",
  	texture_auto_coords = true,
  	anchors = { TOP = { "BOTTOM", "Frame", 0,0 } },
	},
	
	OnShow = function(this) this:OnUpdate() end,
	OnHide = function(this) this.UnitsCount:Hide() end,
}

function DefActionBtn:OnUpdate()
  local count, distance = this:GetDistanceAndCount()
  this.UnitsCount:Set(count)
  local clr = game.MapColor(distance, DistanceColors)
  this.Light:SetColor(clr)
end

Actions = uiwnd {
  count = ACTION_COUNT,
  ttanchor1 = "BOTTOMLEFT",
  ttanchor2 = "TOPLEFT",
  ttoffset = {0,-10},
  anchors = { BOTTOMLEFT = { "BOTTOMRIGHT", "Selection", 26, 12 } }, 

  size = {528,58},
  
  LeftCap = DefCap {
	  anchors = { RIGHT = { "LEFT", 0, 0 } },
	  texture = "data/textures/ui/actions_frame_left.dds",
  },
  
  RightCap = DefCap {
	  anchors = { LEFT = { "RIGHT", 0, 0 } },
    texture = "data/textures/ui/actions_frame_right.dds",
  },

  Btn1 = DefActionBtn { 
    anchors = { LEFT = { 0, 0 } }, 
    index = 1 
  },
  
  StopAction = uibtn {
    size = {43,43},
    layer = 2,
    anchors = { BOTTOMLEFT = { "BOTTOMRIGHT", "Selection", -23, 13 } }, 
    
    Back = uiimg  {
      layer = 1,
      size = {35,114},
      texture = "data/textures/ui/x-back.dds",
      texture_auto_coords = true,
      anchors = { BOTTOMLEFT = { "BOTTOMRIGHT", "Selection", -18, 12 } }, 
    },
    
    NormalImage = uiimg  {
      layer = 2,
      texture = "data/textures/ui/x-button.dds",
      texture_auto_coords = true,
    },
  
    OnMouseEnter = function(this) this:GetParent():ShowTooltip(this) end,
    OnMouseLeave = function(this) Tooltip:Hide() end,
    OnMouseDown = function(btn) if argBtn == "LEFT" then btn.NormalImage:SetAnchor("CENTER", btn, "CENTER", {1,1}) end end,
    OnMouseUp = function(btn) if argBtn == "LEFT" then btn.NormalImage:SetAnchor("CENTER", btn, "CENTER", {0,0}) end end,
  },
}

for i = 2,ACTION_COUNT do
  Actions["Btn"..i] = DefActionBtn { 
    anchors = { LEFT = { "RIGHT", "Actions.Btn"..i-1, 0, 0 } }, 
    index = i
  }
end

function Actions:OnLoad()
  table.insert(GameUI.topWindows.any, this)
  this:RegisterEvent("SEL_CHANGE")
  this:RegisterEvent("SEL_SELECT")
  this:RegisterEvent("MAP_CLOSED")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("ACTION_UPDATE")
end

function Actions:OnEvent(event)
	if event == "ACTION_UPDATE" then
		this:UpdateAction(argAction)
	end
	
	if event == "MAP_LOADED" then
	  this.lastUnit = nil
	  this:Update()
	end
	
  if event == "MAP_CLOSED" then
    for i = 1,this.count do this["Btn"..i]:Hide() end
  end
  
  if event == "SEL_CHANGE" or event == "SEL_SELECT" then
    if argSel and argSel.active then 
      this.lastUnit = argSel.active
    else 
      this.lastUnit = nil 
    end
    this:Update()
  end
end

function Actions:UpdateAction(btn)
	local id,pos,descr,reqs,type = btn:GetAction()

  if id then
    --name
    btn:SetStr(TEXT{id..".name"})
    --texture
    btn.Icon:SetTexture(nil, pos)
    --selected
    if btn:IsSelected() or (this.buildbtn and this.buildbtn == btn) then
    	btn.Frame:SetColor(colors.green)
    else
    	btn.Frame:SetColor(colors.white)
    end    
    --disabled
    local disabled, nomana = btn:IsDisabled()
    if disabled then
    	btn.Icon:SetColor(nomana and colors.nomana or colors.red)
    else
    	btn.Icon:SetColor(colors.white)
    end    
    btn:Show()
    
    if not Tooltip:IsHidden() and Tooltip.owner == this and Tooltip.actionBtn == btn then
      this:ShowTooltip(btn) -- refresh the tooltip
    end
    
    return 1
  end
  
  btn:Hide()
  return 0
end

function Actions:Update()
  local actor = this.lastUnit
  if not actor then
    for i = 1,this.count do 
      this["Btn"..i]:Hide()
    end
  	this.LeftCap:Hide()
  	this.RightCap:Hide()
  	if this.StopAction then this.StopAction:Hide() end
  	
    if not Tooltip:IsHidden() then
      if Tooltip.actionBtn and Tooltip.actionBtn:IsHidden() then
        Tooltip:Hide()
      end  
    end

    return
  end
  
  local visible = 0
  for i = 1,this.count do
    local btn = this["Btn"..i]
    visible = visible + this:UpdateAction(btn)
  end      
  local szx = visible * (this.Btn1:GetSize().x)
  this:SetSize{ szx, this:GetSize().y }
  
  if visible > 0 then
  	this.LeftCap:Show()
  	this.RightCap:Show()
  	if this.StopAction then
  	  this.StopAction.func = nil
  	  this.StopAction:Show() 
  	end
  else
    this.LeftCap:Hide()
  	this.RightCap:Hide()
  	if this.StopAction then this.StopAction:Hide() end
  end
  
  if not Tooltip:IsHidden() then
    if Tooltip.actionBtn and Tooltip.actionBtn:IsHidden() then
      Tooltip:Hide()
    end  
  end
end

function Actions:ShowTooltip(btn)
  local title
  local id,pos,descr,reqs,type,cnt,dist,key
  if btn == this.StopAction then
    title = TEXT{"stop_tooltip_ttl"}
    descr = TEXT{"stop_tooltip_txt"}
  else
    title = btn:GetStr()
    id,pos,descr,reqs,type,cnt,dist,key = btn:GetAction()
  end
  
  Tooltip:AttachTo(this, this.ttanchor1, this, this.ttanchor2, this.ttoffset)
  if key then title = title.." ("..key..")" end
  Tooltip.Title:SetStr(title)
  local str = "<p>" .. (descr or " ") --TEXT("TempText"))
  Tooltip.Text:SetStr(str)
  Tooltip:SetCost(id)
  Tooltip:SetRequirements(reqs)
  local sz = Tooltip:GetSize()
  Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
  Tooltip.actionBtn = btn
  Tooltip:Show()
end

function Actions:OnClick()
  if argBtn == this.StopAction then 
    if this.StopAction.func then
      this.StopAction.func()
    else
      game.StopAction()
    end
    return 
  end
  argBtn:DoAction(nil, argMods)
end

--        
-- BUILDINGS
--        

local DefBuildingBtn = DefBtn {
  virtaul = true;
  hidden = true,
  size = {44,60},

  Pad = uiimg {
  	size = {44,60},
  	layer = 1,
    texture = "data/textures/ui/second_actions_middle.dds",
  	texture_auto_coords = true,
	},
	
  OnMouseEnter = function(btn)
    btn:GetParent().highlightedbtn = true
    btn:GetParent().timeleft = 3
    
    btn:GetParent():ShowTooltip(btn) 
    btn.Highlight:SetColor({138,125,255})
    btn.Highlight:Show()
  end,
  
  OnMouseLeave = function(btn)
    btn:GetParent().highlightedbtn = nil
    btn:GetParent().timeleft = 3
    
    Tooltip:Hide()
    btn.Highlight:Hide()
  end,
}
local BUILDINGS_COUNT = 10

Buildings = uiwnd {
  hidden = true,
  count = BUILDINGS_COUNT,
  ttanchor1 = "BOTTOMLEFT",
  ttanchor2 = "TOPLEFT",
  ttoffset = {0,-10},

  size = {528,60},
  
  LeftCap = DefCap {
	  size = {10,60},
	  anchors = { RIGHT = { "LEFT", 0, 0 } },
	  texture = "data/textures/ui/second_actions_left.dds",
  },
  
  RightCap = DefCap {
	  size = {10,60},
	  anchors = { LEFT = { "RIGHT", 0, 0 } },
    texture = "data/textures/ui/second_actions_right.dds",
  },

  Bld1 = DefBuildingBtn { 
    anchors = { LEFT = { 0, 0 } }, 
    index = 21 
  },

}

for i = 2,BUILDINGS_COUNT do
  local prev = Buildings["Bld"..i-1]
  Buildings["Bld"..i] = DefBuildingBtn { 
    anchors = { LEFT = { "RIGHT", "Buildings.Bld"..i-1, 0, 0 } }, 
    index = prev.index+1
  }
end

function Buildings:OnLoad()
  table.insert(GameUI.topWindows.any, this)
  this:RegisterEvent("MAP_CLOSED")
  this:RegisterEvent("ACTION_UPDATE")
  this:RegisterEvent("ACTION_SUBMENU")
  this:RegisterEvent("SEL_CHANGE")
  this:RegisterEvent("SEL_SELECT")
  this.lastUnit = nil
end

function Buildings:OnUpdate()
  if this:IsHidden() or not this.timeleft or this.highlightedbtn then return end
  this.timeleft = this.timeleft - argElapsed
  if this.timeleft <= 0 then 
    Transitions:Fade(this)
    this.timeleft = nil
  end
end

function Buildings:OnShow()
  this.timeleft = 3
end

function Buildings:CheckVisibility()
  if not Actions.buildbtn then return false end
  return true
end

function Buildings:OnHide()
  if Actions.buildbtn then
    local btn = Actions.buildbtn
    Actions.buildbtn = nil
    Actions:UpdateAction(btn)
  end
end

function Buildings:OnEvent(event)
  if event == "ACTION_SUBMENU" then
    if this:IsHidden() then
      this:Update()
      Actions.buildbtn = Actions["Btn"..argActionIdx+1]
      if argActionIdx > 9 then
        this:SetAnchor("BOTTOMRIGHT", Actions.buildbtn, "TOPRIGHT", {0,0} ) 
      else
        this:SetAnchor("BOTTOMLEFT", Actions.buildbtn, "TOPLEFT", {0,0} ) 
      end  
      Actions:UpdateAction(Actions.buildbtn)
      this:Show()
    else
      this:Hide()
    end    
    return
  end

  if event == "SEL_CHANGE" or event == "SEL_SELECT" then
    if argSel and argSel.active then 
      this.lastUnit = argSel.active
    else 
      this.lastUnit = nil 
    end
    this:Hide()
  end

  if this:IsHidden() then return end
  
	if event == "ACTION_UPDATE" then
		this:UpdateAction(argAction)
	end
	
  if event == "MAP_CLOSED" then
    this:Hide()
  end
end

function Buildings:UpdateAction(btn)
	local id,pos,descr,reqs,type = btn:GetAction()

  if id then
    --name
    btn:SetStr(TEXT{id..".name"})
    --texture
    btn.Icon:SetTexture(nil, pos)
    --selected
    if btn:IsSelected() then
    	btn.Frame:SetColor(colors.green)
    else
    	btn.Frame:SetColor(colors.white)
    end    
    --disabled
    if btn:IsDisabled() then
    	btn.Icon:SetColor(colors.red)
    else
    	btn.Icon:SetColor(colors.white)
    end    
    btn:Show()
    
    if not Tooltip:IsHidden() and Tooltip.owner == this and Tooltip.actionBtn == btn then
      this:ShowTooltip(btn) -- refresh the tooltip
    end
    
    return 1
  end
  
  btn:Hide()
  return 0
end

function Buildings:Update()
  local actor = this.lastUnit
  if not actor then
    for i = 1,this.count do 
      this["Bld"..i]:Hide()
    end
  	this.LeftCap:Hide()
  	this.RightCap:Hide()
    return
  end
  
  local visible = 0
  for i = 1,this.count do
    local btn = this["Bld"..i]
    visible = visible + this:UpdateAction(btn)
  end      
  local szx = visible * (this.Bld1:GetSize().x)
  this:SetSize{ szx, this:GetSize().y }
  
  if visible > 0 then
  	this.LeftCap:Show()
  	this.RightCap:Show()
  else
    this.LeftCap:Hide()
  	this.RightCap:Hide()
  end
end

function Buildings:ShowTooltip(btn)
  local title
  local id,pos,descr,reqs,type
  title = btn:GetStr()
  id,pos,descr,reqs,type,cnt,dist,key = btn:GetAction()
  
  Tooltip:AttachTo(this, this.ttanchor1, this, this.ttanchor2, this.ttoffset)
  if key then title = title.." ("..key..")" end
  Tooltip.Title:SetStr(title)
  local str = "<p>" .. (descr or " ") --TEXT("TempText"))
  Tooltip.Text:SetStr(str)
  Tooltip:SetCost(id)
  Tooltip:SetRequirements(reqs)
  local sz = Tooltip:GetSize()
  Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
  Tooltip.actionBtn = btn
  Tooltip:Show()
end

function Buildings:OnClick()
  argBtn:DoAction(nil, argMods)
  this:Hide()
end

--        
-- AREA ACTIONS
--        
local AREA_COUNT = 3

AreaActions = uiwnd {
  layer = 5,
  size = {147,59},
  count = AREA_COUNT,
  actions_type = "area",
  anchors = { BOTTOMLEFT = { "TOPLEFT", "Selection", 44,16 } }, 
  
  Back = uiimg  {
    layer = 2,
    size = {147,59},
    texture = "data/textures/ui/areaactions_plate.dds",
    texture_auto_coords = true,
    anchors = { BOTTOMLEFT = { "BOTTOMLEFT", -54,0 } }, 
  },
  
  Btn1 = DefBtn { type = "area", index = 1, anchors = { TOPLEFT = { -44,-5 } } },
}

for i = 2,AREA_COUNT do
  AreaActions["Btn"..i] = DefBtn { 
    type = "area",
    anchors = { LEFT = { "RIGHT", "AreaActions.Btn"..i-1, 0, 0 } }, 
    index = i
  }
end

function AreaActions:OnLoad()
  table.insert(GameUI.topWindows.any, this)
  this:RegisterEvent("SEL_CHANGE")
  this:RegisterEvent("SEL_SELECT")  
  this:RegisterEvent("MAP_CLOSED")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("ACTION_UPDATE")
  this:RegisterEvent("ACTION_UPDATEAREA")
end

function AreaActions:OnEvent(event)
	if event == "ACTION_UPDATE" then
		this:UpdateAction(argAction)
	end
	
	if event == "ACTION_UPDATEAREA" then
	  this:Update()
	end
	
	if event == "MAP_LOADED" then
	  this.lastUnit = nil
	  this:Update()
	end
	
  if event == "MAP_CLOSED" then
    for i = 1,this.count do this["Btn"..i]:Hide() end
  end
  
  if event == "SEL_CHANGE" or event == "SEL_SELECT" then
    if argSel and argSel.active then 
      this.lastUnit = argSel.active
    else 
      this.lastUnit = nil 
    end
    this:Update()
  end
end

function AreaActions:UpdateAction(btn)
	local id,pos,descr,reqs,type = btn:GetAction()

  if id then
    --name
    btn:SetStr(TEXT{id..".name"})
    --texture
    btn.Icon:SetTexture(nil, pos)
    --selected
    if btn:IsSelected() then
    	btn.Frame:SetColor(colors.green)
    else
    	btn.Frame:SetColor(colors.white)
    end    
    --disabled
    if btn:IsDisabled() then
    	btn.Icon:SetColor(colors.red)
    else
    	btn.Icon:SetColor(colors.white)
    end    
    btn:Show()
    
    if not Tooltip:IsHidden() and Tooltip.owner == this and Tooltip.actionBtn == btn then
      this:ShowTooltip(btn) -- refresh the tooltip
    end
    
    return 1
  end
  
  btn:Hide()
  return 0
end

function AreaActions:Update()
  local actionID = this.Btn1:GetAction()
  if not actionID then
    for i = 1,this.count do 
      this["Btn"..i]:Hide()
    end
  	this.Back:Hide()
  	if Tooltip.owner == this then Tooltip:Hide() end
    return
  end
  
  local visible = 0
  for i = 1,this.count do
    local btn = this["Btn"..i]
    visible = visible + this:UpdateAction(btn)
  end      
  if visible > 0 then
  	this.Back:Show()
  else
  	this.Back:Hide()
  	if Tooltip.owner == this then Tooltip:Hide() end
  end
end

function AreaActions:ShowTooltip(btn)
  local title
  local id,pos,descr,reqs,type
  title = btn:GetStr()
  id,pos,descr,reqs,type,cnt,dist,key = btn:GetAction()
  
  Tooltip:AttachTo(Selection, "TOPLEFT", Selection, "TOPRIGHT", {-5,12})
  if key then title = title.." ("..key..")" end
  Tooltip.Title:SetStr(title)
  local str = "<p>" .. (descr or " ") --TEXT("TempText"))
  Tooltip.Text:SetStr(str)
  Tooltip:SetCost(id)
  Tooltip:SetRequirements(reqs)
  local sz = Tooltip:GetSize()
  Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
  Tooltip.actionBtn = btn
  Tooltip:Show()
end

function AreaActions:OnClick()
  argBtn:DoAction(nil, argMods)
end

