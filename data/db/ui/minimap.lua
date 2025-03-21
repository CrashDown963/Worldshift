--
-- Minimap
--
local wnd_w = 227
local wnd_h = 227

local mm_w = 211
local mm_h = 211

local normalCoords = {0,0,58,30}
local itemsCoords = {0,30,58,30+30}

local normalImage = uiimg {
  virtual = true,
  texture = "data/textures/ui/minimap-items-button.dds",
  coords = normalCoords,
}

CollectedItemsBtn = uibtn {
  size = {58,30},
  anchors = { BOTTOMRIGHT = { "Minimap", "TOPRIGHT", -1, 7 } },
  NormalImage = normalImage {},
  HighImage = normalImage {},
  PushImage = normalImage {},

  OnShow = function(this)
    CollectedItems:Hide()
    Minimap.Image:Show()
    this:updatestate()
  end,

  OnClick = function(this)
    if CollectedItems:IsHidden() then
      Minimap.Image:Hide()
      CollectedItems:Show()
    else
      CollectedItems:Hide()
      Minimap.Image:Show()
    end
    this:updatestate()
  end,

  updatestate = function(this)
    if CollectedItems:IsHidden() then
      this.NormalImage:SetTexture(nil, normalCoords)
      this.HighImage:SetTexture(nil, normalCoords)
      this.PushImage:SetTexture(nil, normalCoords)
    else
      this.NormalImage:SetTexture(nil, itemsCoords)
      this.HighImage:SetTexture(nil, itemsCoords)
      this.PushImage:SetTexture(nil, itemsCoords)
    end
  end,

  OnMouseEnter = function(this)
    Tooltip:AttachTo(Minimap, "BOTTOMRIGHT", Minimap, "TOPRIGHT", {-10,-40})
    Tooltip.Title:SetStr(TEXT("items_toggle_tooltip_ttl"))
    local str = "<p>"..TEXT("items_toggle_tooltip_txt")
    Tooltip.Text:SetStr(str)
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,

  OnMouseLeave = function(this)
    Tooltip:Hide()
  end,
}

ToggleBarsBtn = uibtn {
  size = {58,30},
  anchors = { BOTTOMRIGHT = { "Minimap", "TOPLEFT", 58, 7 } },
  NormalImage = normalImage {},
  HighImage = normalImage {},
  PushImage = normalImage {},


  OnClick = function(this)
    local isGaugeActive = game.ToggleGlobalGauge(false) -- Check current state without changing it
    game.ToggleGlobalGauge(not isGaugeActive) -- Toggle the state
  end,

  OnMouseEnter = function(this)
    Tooltip:AttachTo(Minimap, "BOTTOMRIGHT", Minimap, "TOPRIGHT", {-10,-40})
    Tooltip.Title:SetStr(TEXT("bars_toggle_tooltip_ttl"))
    local str = "<p>"..TEXT("bars_toggle_tooltip_txt")
    Tooltip.Text:SetStr(str)
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,

  OnMouseLeave = function(this)
    Tooltip:Hide()
  end,
}

Minimap = uiwnd {
  size = {wnd_w,wnd_h},
  anchors = { BOTTOMRIGHT = { 0, 0 } },

  Frame = uiimg {
    size = {wnd_w,wnd_h},
	  texture = "data/textures/ui/left_monitor.dds",
	  coords = {0,0,227,227},
  },

  Image = uiminimap {
    size = {mm_w,mm_h},
    mouse = true,
    anchors = { TOPRIGHT = { "TOPRIGHT", "Frame", -8, 8 } },
  },

  OnLoad = function(this) table.insert(GameUI.topWindows.any, this) end,

  OnShow = function(this)
    if Victory:IsHidden() then
      this:SetLayer(1)
    else
      this:SetLayer(stripeslayer+10)
    end
  end,
}


--
-- COLLECTED ITEMS
--

local DefRewardSlot = Inventory.DefItemSlot { 
  virtual = true,
  --size = {47,47},
  layer = "+1",
}

local items_count = 25
local items_per_page = 16
local page = 1
local pages = items_count / items_per_page

CollectedItems = uiwnd {                                          
  hidden = true,
	anchors = { TOPLEFT = { "TOPLEFT", "Minimap", 7, 7 } },
  
  --Back = uiimg { layer = "-1", color = {0,0,0,255} },
}

function CollectedItems:OnLoad()
  table.insert(GameUI.topWindows.any, this)
  table.insert(GameUI.topWindows.any, CollectedItemsBtn)
  table.insert(GameUI.topWindows.any, ToggleBarsBtn)
  this:RegisterEvent("MAP_CLOSED")
  this:RegisterEvent("ITEM_PICKED")
end

function CollectedItems:OnShow()
  this:updatepages()
end

function CollectedItems:OnEvent(event)
  if event == "MAP_CLOSED" then
    this:Hide()
  end

  if event == "ITEM_PICKED" then
  end
end

function CollectedItems:updatepages()
  if page > pages then page = pages end
  if page < 1 then page = 1 end
  for i = 1,items_count do
    local slot = CollectedItems["Slot"..i]
    if not slot then return end
    slot:UpdateFrame()
    local max = page * items_per_page
    local min = max - items_per_page + 1
    if i >= min and i <= max then
      slot:Show()
    else
      slot:Hide()
    end
  end  
end

local function CreateSlots()
  local rows,cols = 4,4
  local dx,dy = 7,7
  local offx,offy = 12,12
  local idx = 1
  local r, c
  for r = 1, rows do
	  for c = 1, cols do
		
		  local slot = DefRewardSlot {}
		  slot.index = idx
		  slot.repo = "REWARDS"
			
		  if idx == 1 then
			  slot.anchors = { TOPLEFT = { offx,offy } }
		  else
		    if r == 1 then 
		      slot.anchors = { LEFT = { "Slot" .. (idx-1), "RIGHT", dx, 0 } } 
		    else 
		      slot.anchors = { TOP = { "Slot" .. (idx-cols), "BOTTOM", 0, dy } } 
	  	  end
	    end	
      
      CollectedItems["Slot" .. idx] = slot
      idx = idx + 1
	  end
  end
end

CreateSlots()

