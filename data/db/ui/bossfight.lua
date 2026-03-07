--                                                                                             
-- BOSS FIGHT
--                                                                                             

local prgr_layer = 60
local prgr_w = 186
local prgr_h = 12

local bossi_w = 250
local buffi_w = 250

ModInfo = uiwnd {
  hidden = true,
  size = {buffi_w, 1},
  anchors = { TOP = { "BOTTOM", "BossFightWnd", 0,30 } },
  
  Text = uitext { 
    layer = prgr_layer + 1,
    auto_adjust_height = true,
    halign = "LEFT",
		valign = "TOP",
    font = "Verdana,10",
    color = {255,255,255},
    anchors = { TOPLEFT = { 10,10 } },
  },
  
  Frame = DefCornerFrameImage2 {
    anchors = { TOPLEFT = { "Text", -10,-10 }, BOTTOMRIGHT = { "Text", 10,10 } },
  },

  Set = function(this, modui)
    this.modui = modui
    if modui and modui.name and modui.text then
      this.Text:SetStr("<p>"..modui.name.."<nl>".."<color = 200,200,200>"..modui.text)
      this:Show()
    else
      this:Hide()
    end  
  end,

  OnUpdate = function(this)
    if not this:IsHidden() and (not this.modui or this.modui:IsHidden()) then
      this:Hide()
    end
  end,
}

local ability = uiwnd {
  virtual = true,
  hidden = true,
  size = {bossi_w - 20, 1},
  
  Icon = uiimg {
    layer = prgr_layer + 1,
    size = {20, 20},
    texture = "data/textures/ui/passive_abilities.dds",
    anchors = { TOPLEFT = { 0,0 } },
  },
  
  Text = uitext { 
    layer = prgr_layer + 1,
    size = {bossi_w - 50, 1},
    auto_adjust_height = true,
    halign = "LEFT",
		valign = "TOP",
    font = "Arial,10",
    anchors = { TOPLEFT = { "TOPRIGHT", "Icon", 10,0 } },
  },
  
  Set = function(this, abi)
    if abi then
      this.Icon:SetTexture(nil, abi.icon)
      this.Text:SetStr(abi.id .. "<nl>" .. "<color = 200,200,200>" .. abi.text)
      local h = math.max(this.Icon:GetSize().y, this.Text:GetSize().y)
      this:SetSize(this:GetSize().x, h)
      this:Show()
    else
      this:Hide()
    end  
  end,
}

BossInfo = uiwnd {
  hidden = true,
  size = {bossi_w, 1},
  anchors = { TOP = { "BOTTOM", "BossFightWnd", 0,30 } },
  
  Frame = DefFrameImage {layer = prgr_layer},
  
	Name = uitext {
	  layer = prgr_layer + 1,
	  size = {bossi_w - 20, 20},
	  halign = "LEFT",
	  font = "Arial,15",
	  anchors = { TOP = { 0,15 } },
	},
	
	Text = uitext { 
	  layer = prgr_layer + 1,
	  size = {bossi_w - 20, 1},
	  color = {200,200,200,255},
	  auto_adjust_height = true,
    halign = "LEFT",
		valign = "TOP",
    font = "Arial,10",
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0,10 } },
  },
  
  abi_count = 7,
  Abi_1 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Text", 0,10 } } },
  Abi_2 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Abi_1", 0,10 } } },
  Abi_3 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Abi_2", 0,10 } } },
  Abi_4 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Abi_3", 0,10 } } },
  Abi_5 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Abi_4", 0,10 } } },
  Abi_6 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Abi_5", 0,10 } } },
  Abi_7 = ability { anchors = { TOPLEFT = { "BOTTOMLEFT", "Abi_6", 0,10 } } },
	
  Set = function(this, boss)
    local info = game.GetActorInfo(boss)
    if not info or not info.name then 
      this:Hide()
      return
    end
    
    this.Name:SetStr(TEXT{(info.name_var or info.name) .. ".name"})
    this.Text:SetStr("This is a placeholder unit description text.")--info.descr
    
    local last_abi = nil
    if info.abilities and #info.abilities then
      for i = 1,this.abi_count do
        local abi = info.abilities[i] or nil
        this["Abi_"..i]:Set(abi)
        if abi then last_abi = this["Abi_"..i] end
      end
    end
    if last_abi then
      this.Frame:SetAnchor("TOPLEFT", this, "TOPLEFT", {0, 0})
      this.Frame:AddAnchor("BOTTOMRIGHT", last_abi, "BOTTOMRIGHT", {0, 50})
    end
  end,  
}

local progress = uiwnd {
  virtual = true,
	size = {prgr_w, prgr_h},
	
	Text = uitext {
	  layer = prgr_layer+5,
	  shadow_ofs = {1,1},
	  size = {prgr_w-20, 16},
	  halign = "RIGHT",
	  font = "Verdana,10",
    anchors = { CENTER = {0,-1} },
	},
	
	Back = uiimg { 
    layer = prgr_layer, 
    size = {195, 20},
    texture = "data/textures/ui/boss_healthbar_empty.dds",
    coords = {0,0,195,20},
    anchors = { LEFT = { -4, 0 } },
  },

	Left = uiimg { 
    layer = prgr_layer+1, 
    size = {prgr_w, prgr_h},
    texture = "data/textures/ui/boss_healthbars.dds",
    anchors = { LEFT = { 0, 0 } },
  },
	
	OnShow = function(this)
    local sz = this.Left:GetSize()
    this.Left:SetTexture(nil, { 0, this.index*sz.y, sz.x, (this.index+1)*sz.y } )
	end,
	
  Set = function(this, val, max)
    if this.value and this.value == val then return end
    if val == 0 and max == 0 then
      this:Hide()
      return
    end
    this.value = val
    this.max = max
    
    this.Text:SetStr("<p>"..math.floor((val/max)*100).."%")
    
    if val < 0 then val = 0 end
    if val > max then val = max end
    local sz = this:GetSize()
    local x = sz.x * (val / max)
    this.Left:SetSize{ x, sz.y }
    this.Left:SetTexture(nil, { 0, this.index*sz.y, x, (this.index+1)*sz.y } )
    this:Show()
  end,
}

local smallicon = uiwnd {
  virtual = true,
  hidden = true,
	mouse = true,
  size = {16,20},
  Back = uiimg { layer = prgr_layer, color = {0,0,0,255} },
  Icon = uiimg {
    size = {16,16},
    layer = prgr_layer+1,
    texture = "data/textures/ui/buff_icons.dds",
    anchors = { TOP = { 0,0 } },
    Set = function(this, row, col)
      local sz = this:GetSize()
      local left = (col-1)*sz.x
      local top = (row-1)*sz.y
      this:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    end,
  },
  Text = uitext { layer = prgr_layer+2, font = "Arial,8" },
  Progress = uiwnd {
  	size = {16,2},
  	anchors = { TOP = { "BOTTOM", "Icon", 0,1 } },
  	Back = uiimg { layer = prgr_layer+3, size = {16,2}, color = {255, 0, 0, 255} },
  	Image = uiimg { layer = prgr_layer+4, size = {16,2},  anchors = { LEFT = {} }, color = {0, 255, 0, 255} },
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
	OnMouseEnter = function(this) this:GetParent():ShowModInfo(this) end,
	OnMouseLeave = function(this) this:GetParent():HideModInfo(this) end,
}

BossFightWnd = uiwnd {
	hidden = true,
	size = {340,88},
	anchors = { TOP = { 0, 0 } },

	Icon = uiimg {
    layer = "+1",
	  size = {72,86},
	  anchors = { LEFT = {40,5} },
    icon_w = 78,
    icon_h = 92,
  	texture = "data/textures/ui/boss_pictures.dds",
	  anchors = { TOPLEFT = { "TOPLEFT", 5, 5 } },

    Set = function(this, col, row)
      if not row or not col then row = 1 col = 1 end
      local left = (col-1)*this.icon_w
      local top = (row-1)*this.icon_h
      this:SetTexture(nil, {left, top, left+this.icon_w, top+this.icon_h})
    end,
	},

  IconFrame = uiimg {
    layer = "+2",
    size = {82,100},
    anchors = { CENTER = { "Icon", 0,0 } },
    texture = "data/textures/ui/boss_picture_border.dds",
    coords = {0, 0, 82, 100},
  },

  Shadow = uiimg {
    layer = "-1",
    size = {201,89},
    anchors = { TOPLEFT = { "TOPRIGHT", "IconFrame", 0,1 } },
    texture = "data/textures/ui/boss_healthbar_shadow.dds",
    coords = {0, 0, 201, 89},
  },
  
	buffs_count = 8,
	Buff_1 = smallicon { anchors = { TOPRIGHT = { "TOPLEFT", "IconFrame", -7, 0 } } },
	Buff_2 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_1", 0, 3 } } },
	Buff_3 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_2", 0, 3 } } },
	Buff_4 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_3", 0, 3 } } },
	Buff_5 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_4", 0, 3 } } },
	Buff_6 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_5", 0, 3 } } },
	Buff_7 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_6", 0, 3 } } },
	Buff_8 = smallicon { anchors = { TOP = { "BOTTOM", "Buff_7", 0, 3 } } },

	Health = progress { index = 0, anchors = { LEFT = { "RIGHT", "Icon", 11, -15 } } },
	Energy = progress { index = 1, anchors = { TOPLEFT = { "BOTTOMLEFT", "Health", 0, 10 } } },
	Hull = progress { index = 2, anchors = { TOPLEFT = { "BOTTOMLEFT", "Energy", 0, 10 } } },

  SBHolder = uiimg {
    layer = prgr_layer+5,
    size = {1,1},
    texture = "data/textures/ui/boss_healthbar_holder.dds",
    anchors = { TOPLEFT = { "TOPLEFT", "Health", -9,-8 } },
  },

	Name = uitext {
    layer = "+1",
		size = {190,26},
		font = "Verdana,11",
		shadow_ofs = {1,1},
    color = {255, 180, 0},
		anchors = { BOTTOMLEFT = { "TOPLEFT", "Health", 0, -3 } },
	},

  debuffs_count = 8,
	Debuff_1 = smallicon { anchors = { TOPLEFT = { "BOTTOMLEFT", "Hull", 0, 7 } } },
	Debuff_2 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_1", 3, 0 } } },
	Debuff_3 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_2", 3, 0 } } },
	Debuff_4 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_3", 3, 0 } } },
	Debuff_5 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_4", 3, 0 } } },
	Debuff_6 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_5", 3, 0 } } },
	Debuff_7 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_6", 3, 0 } } },
	Debuff_8 = smallicon { anchors = { LEFT = { "RIGHT", "Debuff_7", 3, 0 } } },
}

function BossFightWnd:OnLoad()
  this:RegisterEvent("BOSS_START")
  this:RegisterEvent("BOSS_END")
  this:RegisterEvent("BOSS_UPDATE")
  this:RegisterEvent("MAP_CLOSED")
  table.insert(GameUI.topWindows.any, this)
end

function BossFightWnd:CheckVisibility()
  if not this.boss then return false end
  return true
end

function BossFightWnd:OnEvent(event)
  if event == "BOSS_START" or event == "BOSS_UPDATE" and not this.Morgoth then
    this.boss = argBoss
    this:UpdateBoss(argBoss)
    if GameUI.hiddeninterface then return end
    this:Show()
  end
  if event == "BOSS_END" or event == "MAP_CLOSED" then
    this.boss = nil
    this:Hide()
  end
end

function BossFightWnd:UpdateBoss(boss)
  local info = game.GetActorInfo(boss) if not info or not info.name then this.boss = nil this:Hide() return end

  local col = 1
  local row = 1
  if info.boss_icon then
    col = info.boss_icon[1]
    row = info.boss_icon[2]
  end
  this.Icon:Set(col,row)

  this.Name:SetStr(GetActorName(info))

  local cnt = 1
  this.Health:Set(info.health, info.max_health)

  if info.max_power then 
    cnt = cnt + 1 
    this.Energy:Set(info.power, info.max_power)
    --this.Energy:SetAnchor("TOP", this.Health, "BOTTOM", {0,10})
    this.Energy:Show()
  else
    this.Energy:Hide()
  end

  if info.shield.maxHull then 
    cnt = cnt + 1 
    this.Hull:Set(info.shield.hull, info.shield.maxHull)
    --if cnt == 3 then
      --this.Energy:SetAnchor("TOP", this.Energy, "BOTTOM", {0,10})
    --else
      --this.Energy:SetAnchor("TOP", this.Health, "BOTTOM", {0,10})
    --end
    this.Hull:Show()
  else
    this.Hull:Hide()
  end
  
  if cnt == 1 then
    this.SBHolder:SetSize{32,28}
    this.SBHolder:SetTexture(nil, {0,0,32,28})
  elseif cnt == 2 then
    this.SBHolder:SetSize{32,50}
    this.SBHolder:SetTexture(nil, {0,28,32,28+50})
  elseif cnt == 3 then
    this.SBHolder:SetSize{32,72}
    this.SBHolder:SetTexture(nil, {0,78,32,78+72})
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
        return this["Buff_"..ret]
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
        return this["Debuff_"..ret]
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

    for i = buff_idx,this.buffs_count do this["Buff_"..i]:Hide() end
    for i = debuff_idx,this.debuffs_count do this["Debuff_"..i]:Hide() end
  else
    for i = 1,this.buffs_count do this["Buff_"..i]:Hide() end
    for i = 1,this.debuffs_count do this["Debuff_"..i]:Hide() end
  end
end

function BossFightWnd:ShowBossInfo()
  if not this.boss then return end
  BossInfo:Set(this.boss)
  BossInfo:Show()
end

function BossFightWnd:HideBossInfo()
  BossInfo:Hide()
end

function BossFightWnd:ShowModInfo(modui)
  if not modui.name or not modui.text then return end
  ModInfo:Set(modui)
  ModInfo:Show()
end

function BossFightWnd:HideModInfo(modui)
  ModInfo:Hide()
end

--                                                                                             
-- MindDuel
--                                                                                             

local mduel_layer = 60
local mduel_w = 480
local mduel_h = 110

MindDuel = uiwnd {
	hidden = true,
	size = {mduel_w,mduel_h},
	anchors = { TOP = { 0, 0 } },
	
	uiimg { color = {0,0,0,100} },
	
  Left = uiwnd {
    size = {90,90},
  	layer = mduel_layer,
  	anchors = { LEFT = { 5,0 } },
  	
  	DefCornerFrameImage{},
  	
  	Icon = uiimg {
  	  size = {82,82},
      texture = "data/textures/ui/Final_miss_icons.dds",
      coords = {0,0,82,82},
      anchors = { CENTER = { 1,1 } },
  	},
  	
	  Name = uitext {
		  size = {200,25},
		  font = "Verdana,10b",
		  shadow_ofs = {1,1},
		  anchors = { TOP = { "BOTTOM", "Icon", 0,5 } },
	  },
  },
	
  Right = uiwnd {
    size = {90,90},
  	layer = mduel_layer,
  	anchors = { RIGHT = { -5,0 } },
  	
  	DefCornerFrameImage{},
  	
  	Icon = uiimg {
  	  size = {82,82},
      texture = "data/textures/ui/Final_miss_icons.dds",
      coords = {82,0,82,82},
      anchors = { CENTER = { 1,1 } },
  	},
  	
	  Name = uitext {
		  size = {200,25},
		  font = "Verdana,10b",
		  shadow_ofs = {1,1},
		  anchors = { TOP = { "BOTTOM", "Icon", 0,5 } },
	  },
  },
	
  Meter = uiwnd {
    size = {280,22},
    
    Back = uiimg { 
      size = {280,22},
      layer = mduel_layer+1, 
      texture = "data/textures/ui/progressbar_miss.dds",
      coords = {0,0,280,22},
    },

    Left = uiimg { 
      size = {273,14},
      layer = mduel_layer+2, 
      texture = "data/textures/ui/progressbar_miss_fill.dds",
      coords = {0,0,273,14},
      anchors = { LEFT = { 4,0 } },
    },

    Right = uiimg { 
      size = {273,14},
      layer = mduel_layer+2,
      texture = "data/textures/ui/progressbar_miss_fill.dds",
      coords = {0,14,273,14},
      anchors = { RIGHT = { -4,0 } },
    },
    
    Set = function(this, left, right, all)
      local sz = {} sz.x = 273 sz.y = 14

      local wl = sz.x * (left / all)
      this.Left:SetSize{ wl, sz.y }
      this.Left:SetTexture(nil, {0,0,wl,sz.y})
      
      local wr = sz.x * (right / all)
      this.Right:SetSize{ wr, sz.y }
      this.Right:SetTexture(nil, {sz.x-wr,14,sz.x,14+sz.y})
    end,
  },
}

function MindDuel:OnLoad()
  this:RegisterEvent("MAP_CLOSED")
  table.insert(GameUI.topWindows.any, this)
end

function MindDuel:CheckVisibility()
  if not this.visible then return false end
  return true
end

function MindDuel:OnEvent(event)
  if event == "MAP_CLOSED" then
    this:Hide()
  end
end

function MindDuel:Start(hleft, hright)
  this.Meter:Set(0,0,1)
  this.visible = true
  local info = game.GetActorInfo(hleft)
  --this.Left.Icon:Set(info)
  this.Left.Name:SetStr(GetActorName(info))
  
  info = game.GetActorInfo(hright)
  --this.Right.Icon:Set(info)
  this.Right.Name:SetStr(GetActorName(info))
  
  this:Show()
end

function MindDuel:Stop()
  this.visible = nil
  this:Hide()
end

function MindDuel:Update(left, right, all)
  this.Meter:Set(left, right, all)
end
