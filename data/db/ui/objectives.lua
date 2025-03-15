--                                                                                             
-- OBJECTIVES
--                                                                                             

local add_space = 5
local PPS = 200

local def_w = 500
local def_h = 30
local def_h1 = 55
local def_h2 = 90

local flashing = {}

local T = function(text)
  local t = TEXT("obj." .. text)
  if t:sub(1, 4) == "obj." then
    return text
  else
    return t
  end
end

function IsFlashingWND(wnd)
  if flashing[wnd] then 
    return true 
  end
  return false
end

function FlashWND(wnd, speed)
  if not wnd or not speed then return end
  if flashing[wnd] and speed == 0 then
    flashing[wnd] = nil
  elseif not flashing[wnd] and speed > 0 then
    flashing[wnd] = true
    Transitions:CallRepeat(FlashCallback, speed, wnd)
  end  
end

function FlashCallback(wnd)
  if wnd:IsHidden() then
    wnd:Show()
  else
    wnd:Hide()
  end
  if not flashing[wnd] then wnd:Show() return 0 end
end

local DefObjective = uiwnd {
	virtual = true,
	hidden = true,
	size = {def_w, def_h2},
	--uiimg { color = {250,0,0,180} },
	
	Title = uitext {
		size = {def_w,20},
		color = {255,143,51,255},
		shadow_ofs = {1,1},
		halign = "RIGHT",
		font = "Lucida Sans,13b",
		anchors = { TOPRIGHT = { 0, 0 } },
		Set = function(this, text) this:SetStr("<p>"..T(text)) end,
	},
	
	Icon1 = uiimg {
	  hidden = true,
  	size = {25,25},
	  texture = "data/textures/ui/Objective icons.tga",
	  coords = {0,0,25,25},
	  anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Title", 0, 4 } },
	},
	
	Row11 = uitext {
  	size = {def_w-25,15},
		color = {255,255,255,255},
		shadow_ofs = {1,1},
		halign = "RIGHT",
		font = "Verdana,9",
	  --anchors = { TOPRIGHT = { "TOPLEFT", "Icon1", -7, -4 } },
	  anchors = { TOPRIGHT = { "TOPRIGHT", "Icon1", 0, 0 } },
	  Set = function(this, text) this:SetStr("<i>"..T(text)) end,
	},

	Row12 = uitext {
  	size = {def_w-25,17},
		color = {255,255,255,255},
		shadow_ofs = {1,1},
		halign = "RIGHT",
		font = "Impact,12",
	  anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Row11", 0, -3 } },
	  Set = function(this, text) this:SetStr("<p>"..T(text)) end,
	},

	Icon2 = uiimg {
	  hidden = true,
  	size = {25,25},
	  texture = "data/textures/ui/Objective icons.tga",
	  coords = {0,0,25,25},
	  anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Icon1", 0, 7 } },
	},
	
	Row21 = uitext {
  	size = {def_w-25,15},
		color = {255,255,255,255},
		shadow_ofs = {1,1},
		halign = "RIGHT",
		font = "Verdana,9",
	  --anchors = { TOPRIGHT = { "TOPLEFT", "Icon2", -7, -4 } },
	  anchors = { TOPRIGHT = { "TOPRIGHT", "Icon2", 0, 0 } },
	  Set = function(this, text) this:SetStr("<i>"..T(text)) end,
	},

	Row22 = uitext {
  	size = {def_w-25,17},
		color = {255,255,255,255},
		shadow_ofs = {1,1},
		halign = "RIGHT",
		font = "Impact,12",
	  anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Row21", 0, -3 } },
	  Set = function(this, text) this:SetStr("<p>"..T(text)) end,
	},

	Reset = function(this)
	  this.Title:Hide()
	  this.Icon1:Hide()
	  this.Row11:Hide() this.Row11:SetColor(colors.white) FlashWND(this.Row11, 0)
	  this.Row12:Hide() this.Row12:SetColor(colors.white) FlashWND(this.Row12, 0)
	  this.Icon2:Hide()
	  this.Row21:Hide() this.Row21:SetColor(colors.white) FlashWND(this.Row21, 0)
	  this.Row22:Hide() this.Row22:SetColor(colors.white) FlashWND(this.Row22, 0)
	end,
	
	SetVisibleIcons = function(this, num)
	  if num == 0 then
	    this.Title:Show()
	    this:SetSize{def_w, def_h}
	  elseif num == 1 then
	    this.Title:Show()
	    --this.Icon1:Show()
	    this.Row11:Show()
	    this.Row12:Show()
	    this:SetSize{def_w, def_h1}
	  else
	    this.Title:Show()
	    --this.Icon1:Show()
	    this.Row11:Show()
	    this.Row12:Show()
	    --this.Icon2:Show()
	    this.Row21:Show()
	    this.Row22:Show()
	    this:SetSize{def_w, def_h2}
	  end  
	end,
}

Objectives = uiwnd {
  size = {def_w,1},
  anchors = { TOPRIGHT = { -10, 80 } },
  
  Obj_1 = DefObjective {},
  Obj_2 = DefObjective {},
  Obj_3 = DefObjective {},
  Obj_4 = DefObjective {},
  Obj_5 = DefObjective {},
  Obj_6 = DefObjective {},
  Obj_7 = DefObjective {},
}

function Objectives:OnLoad()
  this:Reset()
  table.insert(GameUI.topWindows.any, this)
end 

function Objectives:Reset()
  this.hidden = {}
  this.visible = {}
  this.animating = false
  
  local i = 1
  while 1 do
    local slot = this["Obj_" .. i]
    if not slot then break end
    table.insert(this.hidden, slot)
    slot:Hide()
    i = i + 1
  end
end 

function Objectives:Add(title, icon1, row1, row2, icon2, row3, row4)
  if #this.hidden < 1 then return end
  local obj = this.hidden[1]
  table.insert(this.visible, 1, obj)
  table.remove(this.hidden, 1)

	obj:Reset()
	obj:SetVisibleIcons(0)
	obj.Title:Set(title)
	
	if icon1 then
	  obj.Row11:Set(row1)
	  obj.Row12:Set(row2)
	  obj:SetVisibleIcons(1)
	end
	
	if icon2 then
	  obj.Row21:Set(row3)
	  obj.Row22:Set(row4)
	  obj:SetVisibleIcons(2)
	end

  obj.cur_offset = 0
  obj.dst_offset = 0
  obj:SetAnchor("TOP", this, "TOP", {0, 0})
  
  obj.fadein = true
  this:OnAnimStart()
	return obj
end

function Objectives:Del(obj)
  if not obj then return end
  Transitions:Fade(obj, nil, function() Objectives:doDelete(obj) end)
end

function Objectives:doDelete(obj)
  if not obj then return end
  table.insert(this.hidden, obj)
  for i,v in ipairs(this.visible) do
    if v == obj then
      table.remove(this.visible, i)
      break
    end  
  end
  this:OnAnimStart()
end

function Objectives:OnAnimStart()
  this.animating = true
end

function Objectives:OnAnimStop()
  this.animating = false
  for i,slot in ipairs(this.visible) do
    if slot.fadein then 
      Transitions:Fade(nil, slot)
      slot.fadein = nil
    end
  end
end

function Objectives:OnUpdate()
  local offset = 0
  local animating = false
  for i,slot in ipairs(this.visible) do
    local sz = slot:GetSize().y
    
    slot.dst_offset = offset
    if slot.cur_offset ~= slot.dst_offset then
      if slot.dst_offset > slot.cur_offset then
        slot.cur_offset = slot.cur_offset + (argElapsed * PPS)
        if slot.cur_offset > slot.dst_offset then
          slot.cur_offset = slot.dst_offset
        end  
      else  
        slot.cur_offset = slot.cur_offset - (argElapsed * PPS)
        if slot.cur_offset < slot.dst_offset then
          slot.cur_offset = slot.dst_offset
        end  
      end  
      slot:SetAnchor("TOP", this, "TOP", {0, slot.cur_offset})
      animating = true
    end
    
    offset = offset + sz + add_space
  end
  
  if this.animating == true and animating == false then
    this:OnAnimStop()
  end
end
