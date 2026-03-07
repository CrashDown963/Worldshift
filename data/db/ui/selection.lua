--                                                                                                     
-- selection ui
--                                                                                                     
local sel_w = 227
local sel_h = 227
local selectionlayer = 1
local buff_layer = 60
buff_min_dur = 10
--
DefUnitFrame = uiimg {
  virtual = true,
  texture = "data/textures/ui/selection_unit_frame.dds",
  coords = {0, 0, 38, 38},
  tiled = {3,3,3,3},
}
-- selection background
local back = uiimg {
  virtual = true,
  size = {sel_w,sel_h},
	layer = selectionlayer,
	texture = "data/textures/ui/left_monitor.dds",
	coords = {0,0,227,227},
}
-- icon + text ui
local stat = uiwnd {
  virtual = true,
  size = {80,18},
  mouse = true,
  layer = selectionlayer + 2,
  type = "stat",
  
  Icon = uiimg {
    size = {16,16},
    --color = {51,102,255},
    texture = "data/textures/ui/units_stats_icons.dds",
    coords = {0,0,16,16},
    anchors = { LEFT = {} },
  },
  
  Text = uitext {
    size = {200,18},
    halign = "LEFT",
    font = "Arial,10b",
    color = {51,102,255},
    anchors = { LEFT = { "RIGHT", "Icon", 5,0 } },
  },
  OnMouseEnter = function(this) Selection:ShowTooltip(this) end,
  OnMouseLeave = function(this) Tooltip:Hide() end,
}
-- progress bar  
local progress = uiwnd {
  virtual = true,
  hidden = true,
  
  fore_dx = 2,
  fore_dy = 0,
  fore_w = 116,
  fore_h = 7,
  fore_texture = "data/textures/ui/selection_bars.dds",
	fore_coords = {0,7,116,14},
  back_texture = "data/textures/ui/selection_bars_back.dds",
	back_coords = {0,11,120,22},

	Fore = uiimg { layer = selectionlayer+3 },
	Back = uiimg { layer = selectionlayer+2 },

  OnLoad = function(this)
    this.Fore:SetTexture(this.fore_texture, this.fore_coords)
    this.Fore:SetAnchor("LEFT", this, "LEFT", {this.fore_dx, this.fore_dy})
    this.Back:SetTexture(this.back_texture, this.back_coords)
  end,

  Set = function(this, val)
    if this.value and this.value == val then return end
    this.value = val
    if val < 0 then val = 0 end
    if val > 1 then val = 1 end
    local w = this.fore_w * val
    local coords = this.fore_coords
    coords[3] = coords[1] + w
    this.Fore:SetTexture(nil, coords)
    this.Fore:SetSize{coords[3], this.fore_h}
  end,
}

-- progress red rect  
local progress1 = uiwnd {
  virtual = true,
  hidden = true,
  color_fore = {0, 255, 0},
	Image = uiimg { },
	OnLoad = function(this)
	  this.Image:SetColor(this.color_fore)
	end,
  Set = function(this, val)
    if this.value and this.value == val then return end
    this.value = val
    if val < 0 then val = 0 end
    if val > 1 then val = 1 end
    local sz = this:GetSize()
    local y = sz.y - (sz.y * val)
    this.Image:SetAnchor("BOTTOMLEFT", this, "BOTTOMLEFT", {0,0})
    this.Image:SetSize{ sz.x, y }
  end,
}
-- buff icon
local Buff = uiwnd {
  virtual = true,
  hidden = true,
  size = {16,20},
  mouse = true,
  layer = buff_layer,
  type = "buff",
  
  Back = uiimg { layer = buff_layer-1, color = {0,0,0,255} },
  Icon = uiimg {
    size = {16,16},
    layer = buff_layer,
    texture = "data/textures/ui/buff_icons.dds",
    anchors = { TOP = { 0,0 } },
    Set = function(this, row, col)
      local sz = this:GetSize()
      local left = (col-1)*sz.x
      local top = (row-1)*sz.y
      this:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    end,
  },

  Text = uitext { size = {16,12}, anchors = { TOP = {  } }, layer = buff_layer+1, font = "Arial,8", color = {255,255,255,255} },
  
  Progress = uiwnd {
  	size = {16,2},
  	anchors = { TOP = { "BOTTOM", "Icon", 0,1 } },
  	Back = uiimg { layer = buff_layer, size = {16,2}, color = {255, 0, 0, 255} },
  	Image = uiimg { layer = buff_layer+1, size = {16,2},  anchors = { LEFT = {} }, color = {0, 255, 0, 255} },
    Set = function(this, val)
      if this.value and this.value == val then return end
      this.value = val
	    if val < 0 then val = 0 end
	    if val > 1 then val = 1 end
	    local sz = this:GetSize()
	    local x = sz.x * val
	    this.Image:SetSize{ x, sz.y }
    end,
  },
  OnMouseEnter = function(this) Selection:ShowTooltip(this) end,
  OnMouseLeave = function(this) Tooltip:Hide() end,
}
-- debuff icon
local Debuff = Buff {
  virtual = true,
  type = "debuff",
}
-- ability icon
local Abi = uiwnd {
  virtual = true,
  size = {16,16},
  hidden = true,
  mouse = true,
  type = "abi",
  
  Icon = uiimg { size = {16,16}, texture = "data/textures/ui/passive_abilities.dds" },
  OnMouseEnter = function(this) Selection:ShowTooltip(this) end,
  OnMouseLeave = function(this) Tooltip:Hide() end,
}
-- common retrieve actor name func
function GetActorName(info)
  local name = "unknown"
  if type(info) ~= "table" then 
    name = game.GetActorName(info)
  else
    if info == nil or info.name == nil then return name end
    if string.len(info.name) > 0 then name = info.name end
    name = TEXT{(info.name_var or info.name) .. ".name"}
  end
  if not name or string.len(name) == 0 then name = TEXT{"unknown.name"} end
  return name
end
-- common actor description retrieve func
function GetActorDescr(info)
  local descr = "Missing 'info' to retrieve description"
  if info and type(info) == "table" and (info.name_var or info.name) then
    descr = TEXT{(info.name_var or info.name) .. ".descr"}
  end  
  return descr
end

--                                                                                                     
-- selection ui
--                                                                                                     

Selection = uiwnd {
  size = {sel_w,sel_h},
  anchors = { BOTTOMLEFT = { 9, -12 } },
  mouse = true,
  
  Back = back { anchors = { BOTTOMLEFT = { -10, 12 } } },
  
  OnMouseDown = function() end,
  OnMouseUp = function() end,
}

function Selection:OnLoad()
	this.index_ui = {}
	table.insert(this.index_ui, this.MultiSel)
	table.insert(this.index_ui, this.Unit)
	table.insert(this.index_ui, this.Mob)
	table.insert(this.index_ui, this.Building)
	table.insert(this.index_ui, this.Switch)
	table.insert(this.index_ui, this.Artifact)
	table.insert(this.index_ui, this.Xenolite)
  
  table.insert(GameUI.topWindows.any, this)
  
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("SEL_CHANGE")
  this:RegisterEvent("SEL_SELECT")
  this:RegisterEvent("BLD_UNIT_QUEUE")
end

function Selection:OnShow()
  this:HideAll()
  this.sel = nil
  this:SelChanged()
  Stripes:Hide()
  Chat:Reset()
end

function Selection:ShowWnd(wnd)
  for i,v in ipairs(this.index_ui) do
  	if v ~= wnd then v:Hide() end
  end
  wnd:Show()
end

function Selection:HideAll()
  for i,v in ipairs(this.index_ui) do
  	v:Hide()
  end
end

function Selection:OnEvent(event)
  if event == "BLD_UNIT_QUEUE" and not this.Building:IsHidden() then
    local info = game.GetActorInfo(this.sel[1])
  	this.Building:Update(this.sel[1], info)
  end
  
  if event == "MAP_LOADED" then
    this.Unit.h = nil
    this.Mob.h = nil
    this.Building.h = nil
    this.Switch.h = nil
    this.Artifact.h = nil
    this.Xenolite.h = nil
  end
  
  if event == "SEL_SELECT" or event == "MAP_LOADED" then
    -- convert selection tbl format from 'handle = value' to 'index = handle'
    this.sel = nil 
    if argSel then 
      this.sel = {} 
      for k,v in pairs(argSel) do 
        if type(k) == "number" then
          table.insert(this.sel, k) 
        end  
      end 
    end
    this:SelChanged()
  end
  
  if event == "SEL_CHANGE" then 
    if argIconChanged then
      for i =  Selection.MultiSel.first_unit, Selection.MultiSel.last_unit do
        local slot = Selection.MultiSel["Slot" .. i]
        slot.handle = nil
      end
    end
    this:SelChanged()
  end
end

function Selection:SelChanged()
  if not this.sel or #this.sel == 0 then   
  	this:HideAll()
  elseif #this.sel == 1 then 
  	local info = game.GetActorInfo(this.sel[1])
	  if info.sel_ui == "unit" then
  	  this.Unit:Update(this.sel[1], info)
		  this:ShowWnd(this.Unit)
	  elseif info.sel_ui == "mob" then
	    this.Mob:Update(this.sel[1], info)
	    this:ShowWnd(this.Mob)
	  elseif info.sel_ui == "building" then
	    this.Building:Update(this.sel[1], info)
	    this:ShowWnd(this.Building)
	  elseif info.sel_ui == "switch" then
	    this.Switch:Update(this.sel[1], info)
	    this:ShowWnd(this.Switch)
	  elseif info.sel_ui == "artifact" then
	    this.Artifact:Update(this.sel[1], info)
	    this:ShowWnd(this.Artifact)
	  elseif info.sel_ui == "xenolite" then
	    this.Xenolite:Update(this.sel[1], info)
	    this:ShowWnd(this.Xenolite)
	  end
  else
  	this.MultiSel:Update(this.sel) 
  	this:ShowWnd(this.MultiSel) 
  end
end

function Selection:OnUpdate()
  if not this.sel then return end

  if #this.sel == 1 then
    local info = game.GetActorInfo(this.sel[1])
    if info.sel_ui == "unit" then
      this.Unit:Update(this.sel[1], info)
    elseif info.sel_ui == "mob" then
      this.Mob:Update(this.sel[1], info)
    elseif info.sel_ui == "building" then
      this.Building:Update(this.sel[1], info)
	  elseif info.sel_ui == "switch" then
	    this.Switch:Update(this.sel[1], info)
	    this:ShowWnd(this.Switch)
	  elseif info.sel_ui == "artifact" then
	    this.Artifact:Update(this.sel[1], info)
	    this:ShowWnd(this.Artifact)
	  elseif info.sel_ui == "xenolite" then
	    this.Xenolite:Update(this.sel[1], info)
	    this:ShowWnd(this.Xenolite)
    end  
  else
    this.MultiSel:Update()
  end
end

function Selection:ShowTooltip(ui)
  Tooltip:AttachTo(this, "TOPLEFT", this, "TOPRIGHT", {-5,12})
  
  if ui.type == "abi" then
    if not ui.abi.text then return end
    Tooltip.Title:SetStr(TEXT{ui.abi.name or ui.abi.id..".name"})
    Tooltip.Text:SetStr("<p>" .. ui.abi.text)
  elseif ui.type == "buff" or ui.type == "debuff" then
    Tooltip.Title:SetStr(ui.name)
    Tooltip.Text:SetStr("<p>"..(ui.text or "</>"))
  elseif ui.type == "stat" then
    local str = ui.Text:GetStr()
    if str and str ~= "" then
      Tooltip.Title:SetStr(TEXT{ui.ttkey})
      Tooltip.Text:SetStr("<p>"..TEXT{ui.ttkey.."_d"})
    else
      return  
    end
  end  
  
  Tooltip.creator = ui
  local sz = Tooltip:GetSize()
  Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
  Tooltip:Show()
end

--
-- Selection.MultiSel
--

local sw = 38
local sh = 38

local Slot = uibtn {
  virtual = true,
  hidden = true,
  size = {sw,sh},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { 3, 2 } },
  
  Frame = DefUnitFrame {
  	size = {sw,sh},
    layer = selectionlayer + 4, 
  },
  
  Icon = uiimg {
  	size = {sw,sh},
  	layer = selectionlayer + 2,
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_sel"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
      else
        this:Hide()
      end  
  	end,
  },
  
  Health = progress1 { 
    size = {sw,sh},
  	layer = selectionlayer + 3,
    color_fore = {255,0,0,100},
  },

  OnClick = function(this) this:GetParent():OnSlotClick(this) end,
  OnRClick = function(this) this:GetParent():OnSlotRClick(this) end,
  OnMouseEnter = function(this)
    Tooltip:AttachTo(Selection, "TOPLEFT", Selection, "TOPRIGHT", {-5,12})
    Tooltip.Title:SetStr(game.GetActorName(this.handle))
    Tooltip.Text:SetStr("<p>"..TEXT("multiselection_tooltip"))
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
  end,
  OnMouseLeave = function(this) Tooltip:Hide() end,
  OnHide = function(this) this.handle = nil end,
}

Selection.MultiSel = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { BOTTOMLEFT = { "Back", 5,-5 } },
  
  Slot1 = Slot { hidden = true, row = 1, col = 1, layer = 1000, anchors = { TOPLEFT = { 13, 10 } } },
  Slot2 = Slot { hidden = true, row = 1, col = 2, layer = 990, anchors = { LEFT = { "CENTER", "Slot1", 0,0 } } },
  Slot3 = Slot { hidden = true, row = 1, col = 3, layer = 980, anchors = { LEFT = { "CENTER", "Slot2", 0,0 } } },
  Slot4 = Slot { hidden = true, row = 1, col = 4, layer = 970, anchors = { LEFT = { "CENTER", "Slot3", 0,0 } } },
  Slot5 = Slot { hidden = true, row = 1, col = 5, layer = 960, anchors = { LEFT = { "CENTER", "Slot4", 0,0 } } },
  Slot6 = Slot { hidden = true, row = 1, col = 6, layer = 950, anchors = { LEFT = { "CENTER", "Slot5", 0,0 } } },
  Slot7 = Slot { hidden = true, row = 1, col = 7, layer = 940, anchors = { LEFT = { "CENTER", "Slot6", 0,0 } } },
  Slot8 = Slot { hidden = true, row = 1, col = 8, layer = 930, anchors = { LEFT = { "CENTER", "Slot7", 0,0 } } },
  Slot9 = Slot { hidden = true, row = 1, col = 9, layer = 920, anchors = { LEFT = { "CENTER", "Slot8", 0,0 } } },

  rows = 5,
  cols = 9,
  first_officer = 1, last_officer = 9,
  first_unit = 10, last_unit = 45,
  slots_count = 45,
}

function Selection.MultiSel:OnLoad()
  local dx,dy = -(this.Slot1:GetSize().x / 2),0
  local idx = this.first_unit
  for r = 2, this.rows do
	  for c = 1, this.cols do
	    local slayer = (1000 - (idx*5)) - 5
      local newslot = Slot { 
        layer = slayer,
        hidden = true, 
        row = r, 
        col = c,
        
        Frame = Slot.Frame { layer = slayer+4 },
        Icon = Slot.Icon { layer = slayer+2 },
        Health = Slot.Health { layer = slayer+3 },
      }
      
      if r == 2 then
        if c == 1 then
          newslot.anchors = { TOP = { "Slot1", "BOTTOM", 0,dy } }
        else
          newslot.anchors = { LEFT = { "Slot"..(idx-1), "RIGHT", dx,0 } }
        end  
      else
        newslot.anchors = { TOP = { "Slot"..(idx-this.cols), "BOTTOM", 0,dy } }
      end  
        
      this["Slot"..idx] = newslot
      idx = idx + 1
    end
  end
  this:CreateChildren()
end

function Selection.MultiSel:OnSlotClick(slot)
  if argBtn == "RIGHT" then 
    return 
  end

  if game.CheckActionExecute(slot.handle) then return end

  if argMods.ctrl then
    local sel = game.GetSelection()
    local mytype = sel[slot.handle]
    if argMods.shift then
      for h,type in pairs(sel) do
        if type == mytype then
          sel[h] = nil
        end
      end
    else
      for h,type in pairs(sel) do
        if type ~= mytype then
          sel[h] = nil
        end
      end
    end
    game.SetSelection(sel)
  elseif argMods.shift then
    local sel = game.GetSelection()
    if sel[slot.handle] then
      sel[slot.handle] = nil  
    else
      sel[slot.handle] = true
    end
    game.SetSelection(sel)
  else
    local tbl = {} tbl[slot.handle] = true
    game.SetSelection(tbl)
  end
end

function Selection.MultiSel:OnSlotRClick(slot)
end

function Selection.MultiSel:ParseOfficers(tbl)
  local off_count = this.last_officer - this.first_officer + 1

  local lasttype = ""
  local types = 0
  local count = 0
  for i,v in ipairs(this.selection) do
    if v.commander or v.officer then 
      count = count + 1
      if lasttype ~= v.name then
        types = types + 1
        lasttype = v.name
      end
    end
  end
  
  local step = 2
  if count > 5 then step = 1 end
  local forcestack = false
  if count + types - 1 > 9 then
    step = 1
    forcestack = true
  end

  lasttype = ""
  local off_idx = this.first_officer
  for i,v in ipairs(this.selection) do
    if v.commander or v.officer and off_idx <= this.last_officer then 
      if not forcestack and lasttype and lasttype ~= v.name and step == 1 then
        off_idx = off_idx + 1
      end
      tbl[i].slotindex = off_idx 
      off_idx = off_idx + step
      lasttype = v.name
    end  
  end
end

local function GetNextIndex(idx, stacked, newtype)
  if not idx then
    return Selection.MultiSel.first_unit
  else
    local slot = Selection.MultiSel["Slot"..idx] if not slot then return end
    local newrow = false
    local index = idx + 1
    local row = slot.row
    local col = slot.col + 1
    if col > Selection.MultiSel.cols then
      row = row + 1 if row > Selection.MultiSel.rows then return end
      newrow = true
      col = 1
    end
    if (not stacked or newtype) and not newrow then
      index = index + 1
      col = col + 1
      if col > Selection.MultiSel.cols then
        row = row + 1 if row > Selection.MultiSel.rows then return end
        newrow = true
        col = 1
      end
    end
    if index > Selection.MultiSel.last_unit then return end
    return index
  end
end

function Selection.MultiSel:ParseUnits(tbl)
  local lasttype
  local unit_idx
  local success = true
  for i,v in ipairs(this.selection) do
    if not v.commander and not v.officer then
      unit_idx = GetNextIndex(unit_idx, this.stacked[v.name], not(lasttype == v.name))
      if unit_idx then
        tbl[i].slotindex = unit_idx
        lasttype = v.name
      else
        if #this.unstacked > 0 then
          this.stacked[this.unstacked[#this.unstacked]] = 1
          this.unstacked[#this.unstacked] = nil
        else
          return
        end
        success = false
        break
      end
    end
  end
  if not success then
    this:ParseUnits(tbl)
  end
end

local function findtype(tbl, type)
  for i,v in ipairs(tbl) do
    if v == type then return true end
  end
  return false
end

function Selection.MultiSel:ResetStackingTables()
  this.stacked = {}
  this.unstacked = {}
  for i,v in ipairs(this.selection) do
    if not v.commander and not v.officer and not findtype(this.unstacked, v.name) then
      table.insert(this.unstacked, v.name)
    end
  end  
end

function Selection.MultiSel:ParseSlots()
  -- officers
  this:ParseOfficers(this.selection)
  -- units
  this:ResetStackingTables()
  this:ParseUnits(this.selection)
end

function sortunits(a,b)
  if a.commander ~= b.commander then
    if a.commander then return true end
    if b.commander then return false end
  end
  
  if a.officer ~= b.officer then
    if a.officer then return true end
    if b.officer then return false end
  end

  if a.sortnum and b.sortnum and a.sortnum ~= b.sortnum then
    return a.sortnum > b.sortnum
  end
  
  return a.name < b.name
end

function Selection.MultiSel:Update(sel)
  if sel then
    this.selection = {}
    local ind = 1
    for _,v in ipairs(sel) do
      local info = game.GetActorInfo(v)
      if info.sortnum then
        this.selection[ind] = { handle = v }
        this.selection[ind].sortnum = info.sortnum
        this.selection[ind].commander = info.commander
        this.selection[ind].officer = info.officer
        this.selection[ind].icon = info.icon
        this.selection[ind].class = info.class
        this.selection[ind].name = info.name
        ind = ind + 1
      end
    end
    table.sort(this.selection, sortunits)
    this:ParseSlots()                          
  end
  
  local lastvis = 0
  for i,v in ipairs(this.selection) do
    if v.slotindex then
      -- hide slots between prev and current
      for i = lastvis+1,v.slotindex-1 do
        local slot = this["Slot"..i]
        if slot and not slot:IsHidden() then
          slot:Hide()
        end
      end
    
      local slot = this["Slot"..v.slotindex]
      lastvis = v.slotindex
      local val
      local h,mh,m,mm = game.GetActorBriefInfo(v.handle)
      
      -- dead or alive
      if not h and not mh then
        slot:Hide()
      else
        if slot.handle ~= v.handle then
          slot.handle = v.handle
          if v.class and v.icon then
            slot.Icon:Set({icon = v.icon, class = v.class})
          else
            slot.Icon:Set()
          end
        end
        
        -- health
        if mh == 0 then h = 0 mh = 1 end
        val = h/mh
        if val ~= slot.Health.value then
          if val > 0 then
            slot.Health:Set(val) 
            slot.Health:Show()
          else
            slot.Health.value = 0
            slot.Health:Hide()
          end  
        end
        if slot:IsHidden() then slot:Show() end
      end
    end  
  end
  
  for i = lastvis+1,this.slots_count do
    local slot = this["Slot"..i]
    if slot and not slot:IsHidden() then
      slot:Hide()
    end
  end
end

--                  
-- Selection.Unit
--                  

local dist = 5

Selection.Unit = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { "Back", 6,6 } },
  
  abilities_count = 4,
  buffs_count = 5,
  debuffs_count = 5,

  Frame = DefUnitFrame {
  	size = {70,70},
    layer = selectionlayer+3, 
    anchors = { TOPLEFT = { dist,dist } },
  },

  Icon = uiimg {
  	size = {70,70},
    layer = selectionlayer+2,
  	anchors = { TOPLEFT = { dist,dist } },
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
        this:GetParent().ActionClick:Show()
      else
        this:Hide()
        this:GetParent().ActionClick:Hide()
      end  
  	end,
  },
  
  ActionClick = uiwnd {
  	size = {70,70},
  	anchors = { CENTER = { "Icon" } },
    layer = selectionlayer+3,
  	mouse = true,
  	OnMouseDown = function(this) 
  	  local handle = this:GetParent().h
  	  if handle then game.CheckActionExecute(handle) end
  	end,
  },

  Name = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Georgia,11",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", dist,-3 }, TOPRIGHT = { -dist,dist-3 } },
  },

  Owner = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Tahoma,9",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,-2 }, TOPRIGHT = { "BOTTOMRIGHT", "Name", 0,-2 } },
  },
  
  Health_prg = progress {
    size = {120,11},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Owner", 0,2 } },
  },
  
  Manna_prg = progress {
    size = {120,11},
	  fore_coords = {0,14,116,21},
  },

  Shield_prg = progress {
    size = {120,11},
	  fore_coords = {0,21,116,28},
  },

  Health = stat { ttkey = "health_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,dist+3 } } },
  Armour = stat { 
    ttkey = "armour_stat", 
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Health", 0,2 } },
    Icon = stat.Icon { coords = {0,4*16,16,16} },
  },
  Ranges = stat { 
    ttkey = "damage_stat", 
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Armour", 0,2 } },
    Icon = stat.Icon { coords = {0,2*16,16,16} },
  },
  Ranges_bar = stat { ttkey = "damagerange_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Armour", 0,2 } }, 
    Icon = stat.Icon { coords = {0,2*16,16,16} },
    Text = stat.Text { anchors = { TOPLEFT = { "TOPRIGHT", "Icon", 5,-4 } } },
    Image = uiwnd {
      size = {47,4},
      clr_green = {0,165,0},
      clr_orange = {255,102,0},
      anchors = { TOPLEFT = { "BOTTOMLEFT", "Text", 0,-2 } },
      
	    Left = uiimg { layer = selectionlayer+2 },
	    Right = uiimg { layer = selectionlayer+2 },
	    Mid = uiimg { layer = selectionlayer+2, color = {255,204,0} },
	    
	    OnLoad = function(this)
	      this.Left:SetAnchor("LEFT", this, "LEFT", {0,0})
	      this.Right:SetAnchor("RIGHT", this, "RIGHT", {0,0})
	      this.Mid:SetAnchor("LEFT", this.Left, "RIGHT")
	      this.Mid:AddAnchor("RIGHT", this.Right, "LEFT")
	    end,
	    
      Set = function(this, near, far, left, mid, right)
        if near > far then
          this.Left:SetColor(this.clr_green)
          this.Right:SetColor(this.clr_orange)
        else
          this.Left:SetColor(this.clr_orange)
          this.Right:SetColor(this.clr_green)
        end
        
        local all = left + mid + right
        local sz = this:GetSize()
        
        local w = sz.x * (left / all)
        this.Left:SetSize{ w, sz.y }
        
        w = sz.x * (right / all)
        this.Right:SetSize{ w, sz.y }
      end,
    },
  },
  
  Crit = stat { 
    ttkey = "crit_stat", 
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Ranges", 0,2 } },
    Icon = stat.Icon { coords = {0,3*16,16,16} },
  },
  
  Manna = stat { 
    ttkey = "manna_stat", 
    anchors = { LEFT = { "LEFT", "Health", 100,0 } },
    Icon = stat.Icon { coords = {0,1*16,16,16} },
  },
  
  Shield = stat { 
    ttkey = "shield_stat", 
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Manna", 0,2 } },
    Icon = stat.Icon { coords = {0,5*16,16,16} },
  },
  
  Debuff5 = Debuff { anchors = { BOTTOMRIGHT = { -dist,-dist } } },
  Debuff4 = Debuff { anchors = { RIGHT = { "Debuff5", "LEFT", 0, 0 } } },
  Debuff3 = Debuff { anchors = { RIGHT = { "Debuff4", "LEFT", 0, 0 } } },
  Debuff2 = Debuff { anchors = { RIGHT = { "Debuff3", "LEFT", 0, 0 } } },
  Debuff1 = Debuff { anchors = { RIGHT = { "Debuff2", "LEFT", 0, 0 } } },

  Buff1 = Buff { anchors = { BOTTOM = { "TOP", "Debuff1", 0,-dist } } },
  Buff2 = Buff { anchors = { BOTTOM = { "TOP", "Debuff2", 0,-dist } } },
  Buff3 = Buff { anchors = { BOTTOM = { "TOP", "Debuff3", 0,-dist } } },
  Buff4 = Buff { anchors = { BOTTOM = { "TOP", "Debuff4", 0,-dist } } },
  Buff5 = Buff { anchors = { BOTTOM = { "TOP", "Debuff5", 0,-dist } } },

  Abi1 = Abi { anchors = { BOTTOMLEFT = { dist,-dist } } },
  Abi2 = Abi { anchors = { LEFT = { "RIGHT", "Abi1", 0,0 } } },
  Abi3 = Abi { anchors = { LEFT = { "RIGHT", "Abi2", 0,0 } } },
  Abi4 = Abi { anchors = { LEFT = { "RIGHT", "Abi3", 0,0 } } },
  Abi5 = Abi { anchors = { LEFT = { "RIGHT", "Abi4", 0,0 } } },
  
  EffectsTitle = uitext {
    size = {100, 20},
    font = "Tahoma,9",
    halign = "LEFT",
    str = TEXT{"effects"},
    anchors = { BOTTOMLEFT = { "TOPLEFT", "Buff1", -10,-dist } },
  },
}
  
function Selection.Unit:Update(h, info)
  
  local name = GetActorName(h)
  if this.h ~= h or "<p>"..name ~= this.Name:GetStr() then
    this.Icon:Set(info)
    
    this.Name:SetStr("<p>"..name)
    local sz = this.Name:GetSize()
    local hg = this.Name:GetStrHeight()
    this.Name:SetSize{sz.x, hg}
    
    this.Owner:SetColor(info.color)
    this.Owner:SetStr(info.player)
  end
  this.h = h
  
  if info.max_health and info.health and info.max_health > 0 then
    this.Health_prg:Set(info.health / info.max_health)
    this.Health_prg:Show()
  else  
    this.Health_prg:Hide()
  end

  if info.power and info.max_power and info.max_power > 0 then
    this.Manna_prg:SetAnchor("TOPLEFT", this.Health_prg, "BOTTOMLEFT", {0,2})
    this.Manna_prg:AddAnchor("TOPRIGHT", this.Health_prg, "BOTTOMRIGHT", {0,2})
    this.Manna_prg:Set(info.power / info.max_power)
    this.Manna_prg:Show()
  else  
    this.Manna_prg:Hide()
  end  
  
  if info.shield.maxHull and info.shield.hull and info.shield.maxHull > 0 then
    if this.Manna_prg:IsHidden() then
      this.Shield_prg:SetAnchor("TOPLEFT", this.Health_prg, "BOTTOMLEFT", {0,2})
      this.Shield_prg:AddAnchor("TOPRIGHT", this.Health_prg, "BOTTOMRIGHT", {0,2})
    else
      this.Shield_prg:SetAnchor("TOPLEFT", this.Manna_prg, "BOTTOMLEFT", {0,2})
      this.Shield_prg:AddAnchor("TOPRIGHT", this.Manna_prg, "BOTTOMRIGHT", {0,2})
    end
    this.Shield_prg:Set(info.shield.hull / info.shield.maxHull)
    this.Shield_prg:Show()
  else
    this.Shield_prg:Hide()
  end
  
  this.Health.Text:SetStr(info.health..'/'..info.max_health)

  if info.armor and info.armor > 0 then
    this.Armour.Text:SetStr(info.armor)
    this.Armour.Icon:SetShader()
  else
    this.Armour.Text:SetStr("")
    this.Armour.Icon:SetShader("_Misc_InterfaceDrawBW")
  end  
  
  if info.nearDamage ~= info.farDamage then
    this.Ranges_bar.Image:Set(info.nearDamage, info.farDamage, info.minRange, info.midRange, info.maxRange)
    this.Ranges_bar.Text:SetStr(info.nearDamage..' - '..info.farDamage)
    this.Ranges_bar:Show()
    this.Ranges:Hide()
  else
    local damage = info.nearDamage
    if not info.nearDamage or info.nearDamage < 1 then 
      damage = info.damage
    end  
    this.Ranges.Text:SetStr(damage)
    this.Ranges:Show()
    this.Ranges_bar:Hide()
  end
  
  this.Crit.Text:SetStr(math.floor(info.crit)..'%')
  
  if info.power and info.power > 0 and info.max_power and info.max_power > 0 then
    this.Manna.Text:SetStr(info.power..'/'..info.max_power)
    this.Manna.Icon:SetShader()
  else
    this.Manna.Text:SetStr("")
    this.Manna.Icon:SetShader("_Misc_InterfaceDrawBW")
  end  
  
  if info.shield.maxHull and info.shield.hull then
    this.Shield.Text:SetStr(info.shield.hull..'/'..info.shield.maxHull)
    this.Shield:Show()
  else
    this.Shield:Hide()
  end
  
  local abi = info.abilities
  if abi then
    for i = 1,#abi do
      if i > this.abilities_count then break end
      local abs = this["Abi"..i]
      if abs.id ~= abi[i].id then
        abs.Icon:SetTexture(nil, abi[i].icon)
        abs.abi = abi[i] 
        abs.id = abi[i].id
      end
      if abs:IsHidden() then
        abs:Show()
      end
    end
    for i = #abi+1,this.abilities_count do this["Abi"..i]:Hide() end
  else
    for i = 1,this.abilities_count do this["Abi"..i]:Hide() end
  end
  
  local buff = info.buffs
  if buff and #buff > 0 then
    local tbl_buffs = {}
    local tbl_debuffs = {}
    
    local pushbuff = function(buff)
      local tbldst
      if buff.debuff then tbldst = tbl_debuffs else tbldst = tbl_buffs end

      local insertnew = true
      for i,v in ipairs(tbldst) do
        if v.id == buff.id and v.caster == buff.caster then
          insertnew = false 
          v.count = v.count + 1
          if v.duration > buff.duration then
            v.duration = buff.duration
            v.progress = buff.progress
          elseif v.duration == buff.duration then
            if v.progress > buff.progress then
              v.progress = buff.progress
            end
          end
        end
      end
      if insertnew then
        buff.count = 1
        buff.index = #tbldst + 1
        table.insert(tbldst, buff)
      end
    end
    
    for i = 1,#buff do 
      if not buff[i].caster then buff[i].caster = 0 end
      if buff[i].duration < buff_min_dur then buff[i].progress = 0 end
      pushbuff(buff[i]) 
    end
  
    local buff_idx = 1
    local getnextbuff = function(idx)
      local ret = buff_idx buff_idx = buff_idx + 1
      if ret <= this.buffs_count then
        return this["Buff"..ret]
      end
    end
    for i,v in pairs(tbl_buffs) do
      local slot = getnextbuff(buff_idx) if not slot then break end
      if (v.count) > 1 then
        slot.Text:SetStr(v.count)
      else  
        slot.Text:SetStr("")
      end
      if v.progress > 0 then
        slot.Progress:Set(v.progress)
        slot.Progress:Show()
      else
        slot.Progress:Hide()
      end  
      slot.Icon:Set(v.icon_row, v.icon_col)

      slot.name = v.name
      slot.text = v.text
      slot:Show()
    end
      
    local debuff_idx = 1
    local getnextdebuff = function(idx)
      local ret = debuff_idx debuff_idx = debuff_idx + 1
      if ret <= this.debuffs_count then
        return this["Debuff"..ret]
      end
    end
    for i,v in pairs(tbl_debuffs) do
      local slot = getnextdebuff(debuff_idx) if not slot then break end
      if (v.count) > 1 then
        slot.Text:SetStr(v.count)
      else  
        slot.Text:SetStr("")
      end  
      if v.progress > 0 then
        slot.Progress:Set(v.progress)
        slot.Progress:Show()
      else
        slot.Progress:Hide()
      end  
      slot.Icon:Set(v.icon_row, v.icon_col)

      slot.name = v.name
      slot.text = v.text
      slot:Show()
    end

    for i = buff_idx,this.buffs_count do this["Buff"..i]:Hide() end
    for i = debuff_idx,this.debuffs_count do this["Debuff"..i]:Hide() end
    this.EffectsTitle:Show()
  else
    this.EffectsTitle:Hide()
    for i = 1,this.buffs_count do this["Buff"..i]:Hide() end
    for i = 1,this.debuffs_count do this["Debuff"..i]:Hide() end
  end
end

--                  
-- Selection.Mob
--                  

Selection.Mob = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { "Back", 6,6 } },
  
  buffs_count = 5,
  debuffs_count = 5,

  Frame = DefUnitFrame {
  	size = {70,70},
    layer = selectionlayer+3,
    anchors = { TOPLEFT = { dist,dist } },
  },

  Icon = uiimg {
  	size = {70,70},
    layer = selectionlayer+2,
  	anchors = { TOPLEFT = { dist,dist } },
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:GetParent().Frame:Show()
        this:Show()
      else
        this:GetParent().Frame:Hide()
        this:Hide()
      end  
  	end,
  },

  Name = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Georgia,11",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", dist,-3 }, TOPRIGHT = { -dist,dist-3 } },
  },

  Health_prg = progress {
    size = {120,11},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,10 } },
  },
  
  Manna_prg = progress {
    size = {120,11},
	  fore_coords = {0,14,116,21},
  },

  Shield_prg = progress {
    size = {120,11},
	  fore_coords = {0,21,116,28},
  },

  Health = stat { ttkey = "health_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,dist+3 } } },
  Manna = stat { ttkey = "manna_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Health", 0,2 } }, Icon = stat.Icon { coords = {0,1*16,16,16} } },
  Shield = stat { ttkey = "shield_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Manna", 0,2 } }, Icon = stat.Icon { coords = {0,5*16,16,16} } },
  
  Debuff5 = Debuff { anchors = { BOTTOMRIGHT = { -dist,-(4*dist) } } },
  Debuff4 = Debuff { anchors = { RIGHT = { "Debuff5", "LEFT", 0, 0 } } },
  Debuff3 = Debuff { anchors = { RIGHT = { "Debuff4", "LEFT", 0, 0 } } },
  Debuff2 = Debuff { anchors = { RIGHT = { "Debuff3", "LEFT", 0, 0 } } },
  Debuff1 = Debuff { anchors = { RIGHT = { "Debuff2", "LEFT", 0, 0 } } },

  Buff1 = Buff { anchors = { BOTTOM = { "TOP", "Debuff1", 0,-dist } } },
  Buff2 = Buff { anchors = { BOTTOM = { "TOP", "Debuff2", 0,-dist } } },
  Buff3 = Buff { anchors = { BOTTOM = { "TOP", "Debuff3", 0,-dist } } },
  Buff4 = Buff { anchors = { BOTTOM = { "TOP", "Debuff4", 0,-dist } } },
  Buff5 = Buff { anchors = { BOTTOM = { "TOP", "Debuff5", 0,-dist } } },

  EffectsTitle = uitext {
    size = {100, 20},
    font = "Tahoma,9",
    halign = "LEFT",
    str = TEXT{"effects"},
    anchors = { BOTTOMLEFT = { "TOPLEFT", "Buff1", -10,-dist } },
  },
}
  
function Selection.Mob:Update(h, info)
  
  if this.h ~= h then
    this.Icon:Set(info)
    if this.Icon:IsHidden() then
      this.Name:SetAnchor("TOPLEFT", this, "TOPLEFT", {2*dist,dist})
      this.Name:AddAnchor("TOPRIGHT", this, "TOPRIGHT", {-dist,dist})
    else
      this.Name:SetAnchor("TOPLEFT", this.Icon, "TOPRIGHT", {dist,-3})
      this.Name:AddAnchor("TOPRIGHT", this, "TOPRIGHT", {-dist,dist-3})
    end
    this.Name:SetStr("<p>"..GetActorName(info))
    local sz = this.Name:GetSize()
    local hg = this.Name:GetStrHeight()
    this.Name:SetSize{sz.x, hg}
  end
  this.h = h
  
  if info.max_health and info.health and info.max_health > 0 then
    this.Health_prg:Set(info.health/info.max_health)
    this.Health_prg:Show()
  else  
    this.Health_prg:Hide()
  end

  if info.power and info.max_power and info.max_power > 0 then
    this.Manna_prg:SetAnchor("TOPLEFT", this.Health_prg, "BOTTOMLEFT", {0,2})
    this.Manna_prg:AddAnchor("TOPRIGHT", this.Health_prg, "BOTTOMRIGHT", {0,2})
    this.Manna_prg:Set(info.power / info.max_power)
    this.Manna_prg:Show()
  else  
    this.Manna_prg:Hide()
  end  
  
  if info.shield.maxHull and info.shield.hull and info.shield.maxHull > 0 then
    if this.Manna_prg:IsHidden() then
      this.Shield_prg:SetAnchor("TOPLEFT", this.Health_prg, "BOTTOMLEFT", {0,2})
      this.Shield_prg:AddAnchor("TOPRIGHT", this.Health_prg, "BOTTOMRIGHT", {0,2})
    else
      this.Shield_prg:SetAnchor("TOPLEFT", this.Manna_prg, "BOTTOMLEFT", {0,2})
      this.Shield_prg:AddAnchor("TOPRIGHT", this.Manna_prg, "BOTTOMRIGHT", {0,2})
    end
    this.Shield_prg:Set(info.shield.hull / info.shield.maxHull)
    this.Shield_prg:Show()
  else
    this.Shield_prg:Hide()
  end
  
  this.Health.Text:SetStr(math.floor((info.health/info.max_health)*100).."%")
  
  if info.power and info.power > 0 and info.max_power and info.max_power > 0 then
    this.Manna.Text:SetStr(math.floor((info.power/info.max_power)*100).."%")
    this.Manna.Icon:SetShader()
  else
    this.Manna.Text:SetStr("")
    this.Manna.Icon:SetShader("_Misc_InterfaceDrawBW")
  end  
  
  if info.shield.maxHull and info.shield.hull then
    this.Shield.Text:SetStr(math.floor((info.shield.hull/info.shield.maxHull)*100).."%")
    this.Shield.Icon:SetShader()
  else
    this.Shield.Text:SetStr("")
    this.Shield.Icon:SetShader("_Misc_InterfaceDrawBW")
  end
  
  local buff = info.buffs
  if buff and #buff > 0 then
    local tbl_buffs = {}
    local tbl_debuffs = {}
    
    local pushbuff = function(buff)
      local tbldst
      if buff.debuff then tbldst = tbl_debuffs else tbldst = tbl_buffs end

      local insertnew = true
      for i,v in ipairs(tbldst) do
        if v.id == buff.id and v.caster == buff.caster then
          insertnew = false 
          v.count = v.count + 1
          if v.duration > buff.duration then
            v.duration = buff.duration
            v.progress = buff.progress
          elseif v.duration == buff.duration then
            if v.progress > buff.progress then
              v.progress = buff.progress
            end
          end
        end
      end
      if insertnew then
        buff.count = 1
        buff.index = #tbldst + 1
        table.insert(tbldst, buff)
      end
    end
    
    for i = 1,#buff do 
      if not buff[i].caster then buff[i].caster = 0 end
      if buff[i].duration < buff_min_dur then buff[i].progress = 0 end
      pushbuff(buff[i]) 
    end
  
    local buff_idx = 1
    local getnextbuff = function(idx)
      local ret = buff_idx buff_idx = buff_idx + 1
      if ret <= this.buffs_count then
        return this["Buff"..ret]
      end
    end
    for i,v in pairs(tbl_buffs) do
      local slot = getnextbuff(buff_idx) if not slot then break end
      if (v.count) > 1 then
        slot.Text:SetStr(v.count)
      else  
        slot.Text:SetStr("")
      end
      if v.progress > 0 then
        slot.Progress:Set(v.progress)
        slot.Progress:Show()
      else
        slot.Progress:Hide()
      end  
      slot.Icon:Set(v.icon_row, v.icon_col)
      
      slot.name = v.name
      slot.text = v.text
      slot:Show()
    end
      
    local debuff_idx = 1
    local getnextdebuff = function(idx)
      local ret = debuff_idx debuff_idx = debuff_idx + 1
      if ret <= this.debuffs_count then
        return this["Debuff"..ret]
      end
    end
    for i,v in pairs(tbl_debuffs) do
      local slot = getnextdebuff(debuff_idx) if not slot then break end
      if (v.count) > 1 then
        slot.Text:SetStr(v.count)
      else  
        slot.Text:SetStr("")
      end  
      if v.progress > 0 then
        slot.Progress:Set(v.progress)
        slot.Progress:Show()
      else
        slot.Progress:Hide()
      end  
      slot.Icon:Set(v.icon_row, v.icon_col)
      
      slot.name = v.name
      slot.text = v.text
      slot:Show()
    end

    for i = buff_idx,this.buffs_count do this["Buff"..i]:Hide() end
    for i = debuff_idx,this.debuffs_count do this["Debuff"..i]:Hide() end
    this.EffectsTitle:Show()
  else
    this.EffectsTitle:Hide()
    for i = 1,this.buffs_count do this["Buff"..i]:Hide() end
    for i = 1,this.debuffs_count do this["Debuff"..i]:Hide() end
  end
end

--                  
-- Selection.Building
--                  

Selection.Building = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { "Back", 6,6 } },
  
  Frame = DefUnitFrame {
  	size = {70,70},
    layer = selectionlayer+3, 
    anchors = { TOPLEFT = { dist,dist } },
  },

  Icon = uiimg {
  	size = {70,70},
    layer = selectionlayer+2,
  	anchors = { TOPLEFT = { dist,dist } },
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
      else
        this:Hide()
      end  
  	end,
  },

  Name = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Georgia,11",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", dist,-3 }, TOPRIGHT = { -dist,dist-3 } },
  },

  Owner = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Tahoma,9",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,0 }, TOPRIGHT = { "BOTTOMRIGHT", "Name", 0,0 } },
  },

  Health_prg = progress {
    size = {120,11},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Owner", 0,5 } },
  },
  
  Health = stat { ttkey = "health_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Health_prg", 0,dist } } },
  Manna = stat { ttkey = "manna_stat", anchors = { LEFT = { "LEFT", "Health", 58,0 } }, Icon = stat.Icon { coords = {0,1*16,16,16} } },
  Shield = stat { ttkey = "shield_stat", anchors = { TOPLEFT = { "BOTTOMLEFT", "Manna", 0,2 } }, Icon = stat.Icon { coords = {0,5*16,16,16} } },
  
  Description = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,5 }, BOTTOMRIGHT = { -6,-6 } },
    
    abilities_count = 4,
    
    Text = uitext {
      font = "Tahoma,9",
      valign = "TOP",
      halign = "LEFT",
      anchors = { TOPLEFT = { }, BOTTOMRIGHT = { } },
    },
    
    Abi1 = Abi { anchors = { BOTTOMLEFT = { 3,0 } } },
    Abi2 = Abi { anchors = { LEFT = { "RIGHT", "Abi1", 0,0 } } },
    Abi3 = Abi { anchors = { LEFT = { "RIGHT", "Abi2", 0,0 } } },
    Abi4 = Abi { anchors = { LEFT = { "RIGHT", "Abi3", 0,0 } } },
  },
  
  Upgrade = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,20 }, BOTTOMRIGHT = { -6,-6 } },
    
    Frame = DefUnitFrame {
  	  size = {50,50},
      layer = selectionlayer+3, 
      anchors = { TOPLEFT = { 0,0 } },
    },

    UIcon = uiimg {
  	  size = {50,50},
      layer = selectionlayer+2,
  	  texture = "data/textures/ui/buttons.dds",
  	  texture_auto_coords = true,
  	  anchors = { TOPLEFT = { 0,0 } },

  	  Set = function(this, pos)
  	    this:SetTexture(nil, pos)
  	  end,
    },
  
    UpgradingTitle = uitext {
      size = {1, 20},
      font = "Tahoma,9",
      halign = "LEFT",
      str = TEXT{"upgrading"}..":",
      anchors = { TOPLEFT = { "TOPRIGHT", "UIcon", dist,0 }, TOPRIGHT = { -5,0 } },
    },
    
    Name = uitext {
      size = {1, 20},
      font = "Tahoma,9",
      halign = "LEFT",
      anchors = { TOPLEFT = { "BOTTOMLEFT", "UpgradingTitle", 0,0 }, TOPRIGHT = { "BOTTOMRIGHT", "UpgradingTitle", 0,0 } },
    },
    
    Upgrade_prg = progress {
      layer = selectionlayer+2,
      size = {137,11},
      fore_dx = 3,
      fore_dy = 0,
      fore_w = 133,
      fore_h = 7,
      fore_texture = "data/textures/ui/selection_bars.dds",
	    fore_coords = {0,0,133,7},
      back_texture = "data/textures/ui/selection_bars_back.dds",
	    back_coords = {0,0,137,11},
      anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,10 } },
    },
    
    Update = function(this, tbl)
      if tbl then
        if this.id ~= tbl.id then
          this.id = tbl.id
          this.name = TEXT{tbl.id..".name"}
          this.descr = TEXT{tbl.id..".descr"}
          this.Name:SetStr("<p>"..this.name)
          local sz = this.Name:GetSize()
          local hg = this.Name:GetStrHeight()
          this.Name:SetSize{sz.x, hg}
          this.UIcon:Set(tbl.icon)
        end
        
        if tbl.progress then
          this.Upgrade_prg:Set(tbl.progress/100)
          this.Upgrade_prg:Show()
        end  
        this:Show()
      else
        this:Hide()
      end  
    end,
    
    OnShow = function(this)
      Actions.StopAction.func = function(this)
        game.StopAction()
      end
      Actions.StopAction:Show()
    end,
    
    OnHide = function(this)
      if Actions:IsHidden() then
        Actions.StopAction:Hide()
      end  
    end,
  },

  Construct = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,20 }, BOTTOMRIGHT = { -6,-6 } },
    
    ConstructTitle = uitext {
      size = {1, 20},
      font = "Tahoma,9",
      halign = "LEFT",
      str = TEXT{"constructing"}..":",
      anchors = { TOPLEFT = { 5,5 }, TOPRIGHT = { -5,5 } },
    },
    
    Construct_prg = progress {
      layer = selectionlayer+2,
      size = {137,11},
      fore_dx = 3,
      fore_dy = 0,
      fore_w = 133,
      fore_h = 7,
      fore_texture = "data/textures/ui/selection_bars.dds",
	    fore_coords = {0,0,133,7},
      back_texture = "data/textures/ui/selection_bars_back.dds",
	    back_coords = {0,0,137,11},
      anchors = { TOPLEFT = { "BOTTOMLEFT", "ConstructTitle", 0,10 } },
    },
    
    Update = function(this, tbl)
      if tbl then
        if tbl.progress then
          this.Construct_prg:Set(tbl.progress/100)
          this.Construct_prg:Show()
        end  
        this:Show()
      else
        this:Hide()
      end  
    end,
    
    OnShow = function(this)
      Actions.StopAction.func = function(this)
        game.StopAction()
      end
      Actions.StopAction:Show()
    end,
    
    OnHide = function(this)
      if Actions:IsHidden() then
        Actions.StopAction:Hide()
      end  
    end,
  },
  
  Produce = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,3 }, BOTTOMRIGHT = { -6,-6 } },
    
    ProducingTitle = uitext {
      size = {1, 20},
      font = "Tahoma,9",
      halign = "LEFT",
      str = TEXT{"producing"}..":",
      anchors = { TOPLEFT = { 0,0 }, TOPRIGHT = { 0,0 } },
    },

    PIcon = uiwnd {
  	  size = {50,50},
      layer = selectionlayer+2,
    	anchors = { TOPLEFT = { "BOTTOMLEFT", "ProducingTitle", 0,0 } },

      Frame = DefUnitFrame { layer = selectionlayer+3 },
    	
    	click = uibtn { layer = selectionlayer+3, OnRClick = function(this) Selection.Building.Produce:CancelUnit(1) end },
    	
    	Image = uiimg {
    	  layer = selectionlayer+2,
        x = -1, y = -1, file = "",
        Set = function(this, info)
          if info and info.icon and info.class then
      	    local t = unitIcons[info.class .. "_70"]
            local x = (info.icon[1]-1) * t.size[1]
            local y = (info.icon[2]-1) * t.size[2]
            if this.file == t.file and this.x == x and this.y == y then 
              if this:IsHidden() then this:Show() end
              return 
            end
            this.file = t.file
            this.x = x
            this.y = y
            this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
            if this:IsHidden() then this:Show() end
          else
            this:Hide()
          end  
        end,
      },
    },
  
    Produce_prg = progress {
      size = {48,7},
      fore_dx = 0,
      fore_dy = 0,
      fore_w = 48,
      fore_h = 7,
      fore_texture = "data/textures/ui/selection_produce_bar.dds",
	    fore_coords = {0,7,48,14},
      back_texture = "data/textures/ui/selection_produce_bar.dds",
	    back_coords = {0,0,48,7},
      anchors = { TOP = { "BOTTOM", "PIcon", 0,2 } },
    },
    
    OnShow = function(this)
      Actions.StopAction.func = function(this)
        Selection.Building.Produce:CancelUnit(1) 
      end
      Actions.StopAction:Show()
    end,
    
    OnHide = function(this)
      if Actions:IsHidden() then
        Actions.StopAction:Hide()
      end  
    end,
    
    CancelUnit = function(this, index)
      game.CancelUnitProduction(index)
    end,

    Update = function(this, tbl)
      if not tbl or #tbl < 1 then this:Hide() return end 
      for i,v in ipairs(tbl) do
  	    local icn, cls = game.GetActorIcon(v)
        if i == 1 then
          if cls and icn then
            this.PIcon.Image:Set({icon = icn, class = cls})
          else
            this.PIcon.Image:Set()
          end
          local progress = tbl["progress_" .. i]
          if not progress then
            this.Produce_prg:Hide()
          else
            this.Produce_prg:Set(progress)
            this.Produce_prg:Show()
          end
          break
        end  
      end      
      this.ProdQ:Update(tbl)
    end,

    ProdQ = uiwnd {
      size = {160,102},
      anchors = { TOPLEFT = { "TOPRIGHT", "PIcon", 0,0 } },
      
      OnLoad = function(this)
        this.rows = 3
        this.cols = 9
        
        local sz = 26
        local dy = 3
        local dx = -(sz / 2)
        
        local idx = 1
        local newslot
        for r = 1, this.rows do
	        for c = 1, this.cols do
            this[idx] = uiwnd { 
  	          size = {sz,sz},
              hidden = true, 
              row = r, 
              col = c,
              anchors = { TOPLEFT = {} },
              
              click = uibtn { 
                layer = selectionlayer+3,
                OnRClick = function(this) Selection.Building.Produce:CancelUnit(this:GetParent().index) end,
              },
              
              Icon = uiwnd {
                layer = selectionlayer+2,
                
                Image = uiimg {
  	              Set = function(this, info)
  	                if info and info.icon and info.class then
                	    local t = unitIcons[info.class .. "_sel"]
                      local x = (info.icon[1]-1) * t.size[1]
                      local y = (info.icon[2]-1) * t.size[2]
                      this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
                      this:Show()
                    else
                      this:Hide()
                    end  
  	              end,
  	            },

                Frame = DefUnitFrame { },
              },
            }
            idx = idx + 1
          end
        end
        this:CreateChildren()

        local cnt = this.rows*this.cols
        idx = cnt
        for r = 1,this.rows do
	        for c = 1,this.cols do
	          if idx <  cnt then
		          if r == 1 then 
		            this[idx]:SetAnchor("LEFT", this[idx+1], "RIGHT", {dx,0})
		          else
		            this[idx]:SetAnchor("TOP", this[idx+this.cols], "BOTTOM", {0,dy})
	  	        end
	          end
	          idx = idx - 1
	        end
	      end 
	      
	      for idx = 1,cnt do
	        if cnt-idx+1 > idx then
	          local a = this[idx]
	          local b = this[cnt-idx+1]
	          this[cnt-idx+1] = a
	          this[idx] = b
	        end
	     	end
      end,
      
      Update = function(this, tbl)
        if not tbl or #tbl < 2 then this:Hide() return end 
        local lastidx = 1
	      for i,v in ipairs(tbl) do
	        if i > 1 then
	  	      local slot = this[i-1]
	  	      if slot then 
	  	        local icn, cls = game.GetActorIcon(v)
              if cls and icn then
                slot.Icon.Image:Set({icon = icn, class = cls})
              else
                slot.Icon.Image:Set()
              end
	            slot.index = i
	            slot:Show()
	            lastidx = i
	          end
	        end
	      end
	      local cnt = this.rows*this.cols
	      for i = lastidx,cnt do
	        local slot = this[i]
	        if slot then slot:Hide() end
	      end
	      this:Show()
      end,
    },
  },
}
  
function Selection.Building:Update(h, info)
  if this.h ~= h then
    this.Icon:Set(info)
    
    this.Name:SetStr("<p>"..GetActorName(info))
    local sz = this.Name:GetSize()
    local hg = this.Name:GetStrHeight()
    this.Name:SetSize{sz.x, hg}
    
    this.Owner:SetColor(info.color)
    this.Owner:SetStr(info.player)

    local descr = TEXT{info.name..".descr"}
    if descr then
      this.Description.Text:SetStr("<p>" .. descr)
      this.Description.Text:Show()
    else
      this.Description.Text:Hide()
    end
  end
  this.h = h
  
  if info.max_health and info.health and info.max_health > 0 then
    this.Health_prg:Set(info.health / info.max_health)
    this.Health_prg:Show()
  else  
    this.Health_prg:Hide()
  end

  this.Health.Text:SetStr(math.floor((info.health/info.max_health)*100).."%")
  
  if not info.construct and info.power and info.power > 0 and info.max_power and info.max_power > 0 then
    this.Manna.Text:SetStr(math.floor((info.power/info.max_power)*100).."%")
    this.Manna:Show()
  else
    this.Manna:Hide()
  end  
  
  if info.shield.maxHull and info.shield.hull then
    if this.Manna:IsHidden() then
      this.Shield:SetAnchor("LEFT", this.Health, "RIGHT", {58,0})
    else  
      this.Shield:SetAnchor("TOPLEFT", this.Manna, "BOTTOMLEFT", {0,2})
    end  
    this.Shield.Text:SetStr(math.floor((info.shield.hull/info.shield.maxHull)*100).."%")
    this.Shield:Show()
  else
    this.Shield:Hide()
  end
  
  local tbl = game.GetUnitProdQueue()
  if tbl and #tbl and not info.enemy then -- produce
    this.Construct:Hide()
    this.Description:Hide()
    this.Upgrade:Hide()
    this.Produce:Update(tbl)
    this.Produce:Show()
  elseif info.upgrade and not info.enemy then -- upgrade
    this.Construct:Hide()
    this.Description:Hide()
    this.Produce:Hide()
    this.Upgrade:Update(info.upgrade)
    this.Upgrade:Show()
  elseif info.construct and not info.enemy then -- construct
    this.Description:Hide()
    this.Produce:Hide()
    this.Upgrade:Hide()
    this.Construct:Show()
    this.Construct:Update(info.construct)
  else  -- normal state
    this.Construct:Hide()
    this.Upgrade:Hide()
    this.Produce:Hide()
    
    local abi = info.abilities
    if abi then
      for i = 1,#abi do
        if i > this.Description.abilities_count then break end
        local abs = this.Description["Abi"..i]
        if abs.id ~= abi[i].id then
          abs.Icon:SetTexture(nil, abi[i].icon)
          abs.abi = abi[i]
          abs.id = abi[i].id
        end
        if abs:IsHidden() then
          abs:Show()
        end
      end
      for i = #abi+1,this.Description.abilities_count do this.Description["Abi"..i]:Hide() end
    else
      for i = 1,this.Description.abilities_count do this.Description["Abi"..i]:Hide() end
    end
    this.Description:Show()
  end
end

--                  
-- Selection.Switch
--                  
local SwitchSlot = uiwnd {
  virtual = true,
  size = {30,30},
  hidden = true,
  layer = selectionlayer+2,
  Set = function(this) end,
}

Selection.Switch = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { "Back", 6,6 } },
  
  Frame = DefUnitFrame {
  	size = {70,70},
    layer = selectionlayer+3, 
    anchors = { TOPLEFT = { dist,dist } },
  },

  Icon = uiimg {
  	size = {70,70},
    layer = selectionlayer+2,
  	anchors = { TOPLEFT = { dist,dist } },
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
      else
        this:Hide()
      end  
  	end,
  },

  Name = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Georgia,11",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", dist,-3 }, TOPRIGHT = { -dist,dist-3 } },
  },

  State = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Tahoma,9",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,0 }, TOPRIGHT = { "BOTTOMRIGHT", "Name", 0,0 } },
  },

  Cooldown_prg = progress {
    size = {137,11},
    fore_dx = 3,
    fore_dy = 0,
    fore_w = 133,
    fore_h = 7,
    fore_texture = "data/textures/ui/selection_bars.dds",
    fore_coords = {0,0,133,7},
    back_texture = "data/textures/ui/selection_bars_back.dds",
    back_coords = {0,0,137,11},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "State", 0,5 } },
  },
  
  Description = uiwnd {
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,10 }, BOTTOMRIGHT = { -6,-6 } },
    
    Text = uitext {
      font = "Tahoma,9",
      valign = "TOP",
      halign = "LEFT",
      anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { 0,0 } },
    },
  },
  
  SwitchUsers = uiwnd {
    hidden = true,
    size = {1,30},
    anchors = { BOTTOMLEFT = { "BOTTOMLEFT", 6,-6 }, BOTTOMRIGHT = { -6,-6 } },
    
    Slot1 = SwitchSlot { anchors = { TOPLEFT = { 0,0 } } },
    Slot2 = SwitchSlot { anchors = { LEFT = { "RIGHT", "Slot1", 0,0 } } },
    Slot3 = SwitchSlot { anchors = { LEFT = { "RIGHT", "Slot2", 0,0 } } },
    Slot4 = SwitchSlot { anchors = { LEFT = { "RIGHT", "Slot3", 0,0 } } },
    Slot5 = SwitchSlot { anchors = { LEFT = { "RIGHT", "Slot4", 0,0 } } },
    Slot6 = SwitchSlot { anchors = { LEFT = { "RIGHT", "Slot5", 0,0 } } },
  },
  OnHide = function(this) this.h = nil end,
}
  
function Selection.Switch:Update(h, info)
  if this.h ~= h then
    this.Icon:Set(info)
    this.Name:SetStr("<p>"..GetActorName(info))
    local sz = this.Name:GetSize()
    local hg = this.Name:GetStrHeight()
    this.Name:SetSize{sz.x, hg}
    this.Description.Text:SetStr("<p>"..GetActorDescr(info))
  end
  this.h = h
  
  if info.state == "active" then
    this.State:SetStr("<color=0,255,0>"..TEXT{"active"}.."</>")
  elseif info.state == "cooldown" then
    this.State:SetStr("<color=223,180,7>"..TEXT{"cooldown"}.."</>")
  else
    this.State:SetStr("<color=255,0,0>"..TEXT{"inactive"}.."</>")
  end
 
  if info.state == "cooldown" and info.cooldown then
    this.Cooldown_prg:Set(info.cooldown)
    this.Cooldown_prg:Show()
  else  
    this.Cooldown_prg:Hide()
  end
end

--                  
-- Selection.Artifact
--                  
Selection.Artifact = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { "Back", 6,6 } },
  
  Frame = DefUnitFrame {
  	size = {70,70},
    layer = selectionlayer+3, 
    anchors = { TOPLEFT = { dist,dist } },
  },

  Icon = uiimg {
  	size = {70,70},
    layer = selectionlayer+2,
  	anchors = { TOPLEFT = { dist,dist } },
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
      else
        this:Hide()
      end  
  	end,
  },

  Name = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Georgia,11",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", dist,-3 }, TOPRIGHT = { -dist,dist-3 } },
  },

  Taking_prg = progress {
    size = {137,11},
    fore_dx = 3,
    fore_dy = 0,
    fore_w = 133,
    fore_h = 7,
    fore_texture = "data/textures/ui/selection_bars.dds",
    fore_coords = {0,0,133,7},
    back_texture = "data/textures/ui/selection_bars_back.dds",
    back_coords = {0,0,137,11},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,15 } },
  },
  
  Description = uiwnd {
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,10 }, BOTTOMRIGHT = { -6,-6 } },
    
    Text = uitext {
      font = "Tahoma,9",
      valign = "TOP",
      halign = "LEFT",
      anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { 0,0 } },
    },
  },
  OnHide = function(this) this.h = nil end,
}
  
function Selection.Artifact:Update(h, info)
  if this.h ~= h then
    this.Icon:Set(info)
    this.Name:SetStr("<p>"..GetActorName(info))
    local sz = this.Name:GetSize()
    local hg = this.Name:GetStrHeight()
    this.Name:SetSize{sz.x, hg}
    this.Description.Text:SetStr("<p>"..GetActorDescr(info))
  end
  this.h = h
  
  if info.state == "progress" and info.progress then
    this.Taking_prg:Set(info.progress)
    this.Taking_prg:Show()
  else  
    this.Taking_prg:Hide()
  end
end

--                  
-- Selection.Xenolite
--                  
Selection.Xenolite = uiwnd {
	size = {sel_w-12,sel_h-12},
  layer = selectionlayer + 1,
  anchors = { TOPLEFT = { "Back", 6,6 } },
  
  Frame = DefUnitFrame {
  	size = {70,70},
    layer = selectionlayer+3, 
    anchors = { TOPLEFT = { dist,dist } },
  },

  Icon = uiimg {
  	size = {70,70},
    layer = selectionlayer+2,
  	anchors = { TOPLEFT = { dist,dist } },
  	
  	Set = function(this, info)
  	  if info and info.icon and info.class then
  	    local t = unitIcons[info.class .. "_70"]
        local x = (info.icon[1]-1) * t.size[1]
        local y = (info.icon[2]-1) * t.size[2]
        this:SetTexture(t.file, {x,y,x+t.size[1],y+t.size[2]} )
        this:Show()
      else
        this:Hide()
      end  
  	end,
  },

  Name = uitext {
    size = {1,18},
    halign = "LEFT",
    font = "Georgia,11",
    color = {255,255,255,255},
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", dist,-3 }, TOPRIGHT = { -dist,dist-3 } },
  },

  Taking_prg = progress {
    size = {137,11},
    fore_dx = 3,
    fore_dy = 0,
    fore_w = 133,
    fore_h = 7,
    fore_texture = "data/textures/ui/selection_bars.dds",
    fore_coords = {0,0,133,7},
    back_texture = "data/textures/ui/selection_bars_back.dds",
    back_coords = {0,0,137,11},
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,15 } },
  },
  
  Description = uiwnd {
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0,10 }, BOTTOMRIGHT = { -6,-6 } },
    
    Text = uitext {
      font = "Tahoma,9",
      valign = "TOP",
      halign = "LEFT",
      anchors = { TOPLEFT = { 0,0 }, BOTTOMRIGHT = { 0,0 } },
    },
  },
  OnHide = function(this) this.h = nil end,
}
  
function Selection.Xenolite:Update(h, info)
  if this.h ~= h then
    this.Icon:Set(info)
    this.Name:SetStr("<p>"..GetActorName(info))
    local sz = this.Name:GetSize()
    local hg = this.Name:GetStrHeight()
    this.Name:SetSize{sz.x, hg}
    this.Description.Text:SetStr("<p>"..GetActorDescr(info))
  end
  this.h = h
  
  if info.state == "progress" and info.progress then
    this.Taking_prg:Set(info.progress)
    this.Taking_prg:Show()
  else  
    this.Taking_prg:Hide()
  end
end

