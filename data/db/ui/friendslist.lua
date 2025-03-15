--
--  caht setup, buddy list
--
local friendslayer = 40
local DEF_CHANNEL_COLOR = colors.white
local chk_size = {20,20}

--
local DefCheck = DefButton {
  virtual = true,
  size = {230,40},
  
  checked = 0,
  
  NormalImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  HighImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  PushImage = uiimg { size = chk_size, texture = "data/textures/ui/slot_ready.dds", anchors = { LEFT = {0,0} } },
  
  NormalText = DefButton.NormalText { halign = "LEFT", color = {225,225,225,255}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  HighText = DefButton.HighText { halign = "LEFT", color = {255,255,255,255}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  PushText = DefButton.PushText { halign = "LEFT", color = {255,255,255,255}, anchors = { LEFT = { chk_size[1] + 10, 0 } } },
  
  -- unchecked texture coordinates
  UN_coords = { 0, 0, 24, 24},
  UH_coords = {24, 0, 24+24, 24},
  UP_coords = {48, 0, 24+48, 24},
  -- checked texture coordinates
  CN_coords = { 0, 24, 24, 24+24},
  CH_coords = {24, 24, 24+24, 24+24},
  CP_coords = {48, 24, 24+48, 24+24},
  
  OnShow = function(this) this:updatetextures() end,

  updatetextures = function(this)
    if this.checked == 0 then
      this.NormalImage:SetTexture(nil, this.UN_coords)
      this.HighImage:SetTexture(nil, this.UN_coords)
      this.PushImage:SetTexture(nil, this.UN_coords)
    else
      this.NormalImage:SetTexture(nil, this.UP_coords)
      this.HighImage:SetTexture(nil, this.UP_coords)
      this.PushImage:SetTexture(nil, this.UP_coords)
    end  
  end,

  OnClick = function(this)
    if this.checked == 0 then this.checked = 1 else this.checked = 0 end  
    this:updatetextures()
  end,
}
-- access data
local GetSetupChannel = function()
  return UserContacts.ChatStuff.ChannelsSetup.setup_channel
end

local GetUserChannel = function(index)
  if not index then 
    return UserContacts.ChatStuff.ChannelsSetup.userchannels
  end
  if UserContacts.ChatStuff.ChannelsSetup.userchannels then
    return UserContacts.ChatStuff.ChannelsSetup.userchannels[index]
  end
end

local SetUserChannel = function(index, channel)
  if not index then return end
  UserContacts.ChatStuff.ChannelsSetup.userchannels[index] = channel
end

-- channel color picker
local cell_w = 8
local cell_h = 8
local cell_cols = 32
local cell_rows = 16
local cell_dx = 0
local cell_dy = 0
local offs_x = 5
local offs_y = 5
local colors_w = (cell_cols * (cell_w + cell_dx)) + cell_dx
local colors_h = (cell_rows * (cell_h + cell_dy)) + cell_dy

ColorPicker = uiwnd {
  hidden = true,
  layer = modallayer+1,
  size = {colors_w + (2*offs_x) + 6, colors_h + (2*offs_y) + 6},
  
  DefCornerFrameImage2 {},
  
  Colors = uiwnd {
    size = {colors_w, colors_h},
    anchors = { TOPLEFT = { 3,3 } },

    Texture = uiimg {
      size = {colors_w, colors_h},
      texture = "data/textures/ui/colour_picker_chat.dds",
      coords = {0, 0, colors_w, colors_h},
      anchors = { TOPLEFT = { offs_x,offs_y } },
    },  

    OnTextureClicked = function(this, x, y)
      local picker = this:GetParent()
      if picker.func then
        local clr = this.Texture:PickColor({x,y})
        picker.func(clr, this)
      end
      ColorPicker:Hide()
    end,
    
    OnRollInColor = function(this, x, y)
      local picker = this:GetParent()
      if picker.rollinfunc then
        local clr = this.Texture:PickColor({x,y})
        picker.rollinfunc(clr, this)
      end
    end,
    
    OnRollOutColor = function(this)
      local picker = this:GetParent()
      if picker.rolloutfunc then
        picker.rolloutfunc(this)
      end
    end,
  },
  
  OnShow = function()
    if not ColorPicker.Colors.Cell_1 then
      local i = 1
      for y = 1, cell_rows do
        for x = 1, cell_cols do
          local cell = uibtn {
            size = {cell_w,cell_h},
            col = x,
            row = y,
            OnClick = function(this)
              local x = ((this.col - 1) * (cell_w + cell_dx)) + cell_dx + (cell_w / 2)
              local y = ((this.row - 1) * (cell_h + cell_dy)) + cell_dy + (cell_h / 2)
              this:GetParent():OnTextureClicked(x,y) 
            end,
            OnMouseEnter = function(this)
              local x = ((this.col - 1) * (cell_w + cell_dx)) + cell_dx + (cell_w / 2)
              local y = ((this.row - 1) * (cell_h + cell_dy)) + cell_dy + (cell_h / 2)
              this:GetParent():OnRollInColor(x,y) 
            end,
            OnMouseLeave = function(this)
              this:GetParent():OnRollOutColor() 
            end,
          }
          
          if x == 1 and y == 1 then
            cell.anchors = { TOPLEFT = { "TOPLEFT", offs_x, offs_y } }
          elseif y == 1 then
            cell.anchors = { LEFT = { "Cell_" .. (i-1), "RIGHT" } }
          else
            cell.anchors = { TOP = { "Cell_" .. (i-cell_cols), "BOTTOM" } }
          end
          
          ColorPicker.Colors["Cell_" .. i] = cell
          i = i + 1
        end
      end
      ColorPicker.Colors:CreateChildren()
    end
    Modal.func = function() ColorPicker:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide()
	  this.func = nil
	  this.rollinfunc = nil
	  this.rolloutfunc = nil
	  if this.execonhide then this.execonhide(this) end
	  this.execonhide = nil
	end,
}

-- assign chat channel shortcuts
ShortcutAssign = uiwnd {
  hidden = true,
  size = {350,100},
  keyboard = true,
  layer = modallayer + 1,

  DefFrameNoTranspImage {},
  Text = uitext {},
  
  OnShow = function(this)
    Modal.func = function() this:Hide() end 
    Modal:SetLayer(modallayer)
    Modal:Show()
  end,
	
	OnHide = function(this) 
	  Modal.func = nil 
	  Modal:Hide() 
	  ShortcutAssign.channel.Shortcut:SetStr(ShortcutAssign.channel.shortcutkey)
	end,
	
	FlashLetter = function()
	  if not ShortcutAssign:IsHidden() then
	    local current = ShortcutAssign.channel.Shortcut:GetStr()
	    if current == ShortcutAssign.flashkey then
	      ShortcutAssign.channel.Shortcut:SetStr(ShortcutAssign.channel.shortcutkey)
	    else
	      ShortcutAssign.channel.Shortcut:SetStr(ShortcutAssign.flashkey)
	    end
	  else
	    return 0
	  end  
	end,
	
	SetChannel = function(this, channel)
	  this.channel = channel
	  this.flashkey = "?"
	  
	  this.Text:SetStr(TEXT{"shorcut_assign", channel.Edit:GetStr()})
	  this:SetAnchor("TOP", channel.Shortcut, "BOTTOM", {0,0})
	  this.channel.Shortcut:SetStr(this.flashkey)
    Transitions:CallRepeat(this.FlashLetter, 0.4)
    
	  this:Show()
	end,
	
  OnKeyUp = function(this, key, mod)
    if key == "Escape" then 
      this:Hide()
      return
    end
    if key == "Space" then
      this.channel:SetShortcut()
      this:Hide()
      return
    end
    if key == "Return" then
      this.channel:SetShortcut()
      this:Hide()
      LobbyChat.skipnextkeyup = true
      return
    end
    local len = string.len(mod.key)
    local code = string.byte(mod.key)
    -- latin letters only from 'A' to 'Z'
    if this.channel and len == 1 and code >= 65 and code <= 90 then
      for k,v in pairs(UserContacts.ChatStuff.ChannelsSetup) do
        if type(v) == "table" and v.Shortcut and v.shortcutkey == mod.key then
          v:SetShortcut()
        end
      end
      this.channel:SetShortcut(mod.key)
      this:Hide()
      
      LobbyChat.skipnextkeyup = true
    end
  end,
}
--
local DefCheckButton = DefButton {
  virtual = true,
  
  checked = 0,
  
  NormalImage = uiimg { texture = "data/textures/ui/slot_ready.dds" },
  HighImage = uiimg { texture = "data/textures/ui/slot_ready.dds" },
  PushImage = uiimg { texture = "data/textures/ui/slot_ready.dds" },
  
  -- unchecked texture coordinates
  UN_coords = { 0, 0, 24, 24},
  UH_coords = {24, 0, 24+24, 24},
  UP_coords = {48, 0, 24+48, 24},
  -- checked texture coordinates
  CN_coords = { 0, 24, 24, 24+24},
  CH_coords = {24, 24, 24+24, 24+24},
  CP_coords = {48, 24, 24+48, 24+24},
  
  OnShow = function(this) this:updatetextures() end,

  updatetextures = function(this)
    if this.checked == 0 then
      this.NormalImage:SetTexture(nil, this.UN_coords)
      this.HighImage:SetTexture(nil, this.UN_coords)
      this.PushImage:SetTexture(nil, this.UN_coords)
    else
      this.NormalImage:SetTexture(nil, this.UP_coords)
      this.HighImage:SetTexture(nil, this.UP_coords)
      this.PushImage:SetTexture(nil, this.UP_coords)
    end  
  end,
}
	
-- left part - channels setup
local DefChannelRow = uiwnd {
  virtual = true,
  mouse = true,
  layer = friendslayer + 1,
  sound = "def_button",
  
  channel_color = DEF_CHANNEL_COLOR,
  
  SelBack = uiimg { hidden = true, color = {19,23,49,255}, },
        
  Check = DefCheckButton { 
    hidden = true,
    size = {24,24}, 
    anchors = { LEFT = { 0, 0 } },
    
    OnClick = function(this)
      this:GetParent():OnCheckClick("LEFT")
    end,

    OnMouseEnter = function(this) 
      local slot = this:GetParent()
      slot:GetParent().rollover = slot 
    end,

    OnMouseLeave = function(this)
      local slot = this:GetParent()
      slot:GetParent().rollover = nil
    end,
  },

  Shortcut = DefButton { 
    hidden = true,
    size = {30,30}, 
    anchors = { LEFT = { 0, 0 } },

    NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,0,30,30} },
    HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,0,30,30} },
    PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,0,30,30} },
    
    OnClick = function(this)
      this:GetParent():OnShorcutClick("LEFT")
    end,
    OnRClick = function(this)
      this:GetParent():OnShorcutClick("RIGHT")
    end,
    OnMouseEnter = function(this) 
      local slot = this:GetParent()
      slot:GetParent().rollover = slot 
      NTTooltip:DoShow("chat_channel_tip", this, "BOTTOM", "TOP", {0,10})
    end,
    OnMouseLeave = function(this)
      local slot = this:GetParent()
      slot:GetParent().rollover = nil
      NTTooltip:Hide()
    end,
  },
  
  Delete = DefButton { 
    hidden = true,
    size = {24,24},
    anchors = { RIGHT = { 0, 0 } },
    NormalImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 0, 24, 24},
    },
    
    HighImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 24, 24, 24},
    },

    PushImage = uiimg {
      texture = "data/textures/ui/slot_kick.dds",
      coords = {0, 48, 24, 24},
    },
    OnClick = function(this) this:GetParent():OnDeleteClick() end,
    OnMouseEnter = function(this) local slot = this:GetParent() slot:GetParent().rollover = slot end,
    OnMouseLeave = function(this) local slot = this:GetParent() slot:GetParent().rollover = nil end,
  },
  
  Edit = uiedit {
    readonly = true,
    parsing = false,
    font = "Arial,12",
    maxchars = 18,
    allowed_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',

    anchors = { 
      TOPLEFT = { "TOPRIGHT", "Shortcut", 5, 0 }, 
      BOTTOMRIGHT = {"BOTTOMLEFT", "Delete", -5, 0 } 
    },
    
    OnKeyEnter = function(this)
      if not this:IsFocused() then return end
      local new = this:GetStr()
      if not new or not string.find(new, "[^ ]") then
        this:GetParent():OnDeleteClick()
        return
      end
      if new == TEXT_UNASSIGNED then this:RemoveFocus() return end

      local chn_idx = LobbyChat.currview.idx
      UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this:GetParent().value] = 1
      game.SaveUserPrefs("LobbyChatView_"..chn_idx, UserContacts.ChatStuff.ChannelsSetup.data[chn_idx])
      chn_idx = GetSetupChannel()
      if chn_idx then
        UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this:GetParent().value] = 1
        game.SaveUserPrefs("LobbyChatView_"..chn_idx, UserContacts.ChatStuff.ChannelsSetup.data[chn_idx])
      end

      local curr = GetUserChannel(this:GetParent().value)
      if curr ~= TEXT_UNASSIGNEDKEY then
        net.ChatLeaveChannel(curr)
      end  
      
      SetUserChannel(this:GetParent().value, new)
      net.ChatEnterChannel(new)
      
      game.SaveUserPrefs("LobbyUserChannels", GetUserChannel())
      this:RemoveFocus()
      this:GetParent():UpdateChannel()
    end,
    
    OnKeyEscape = function(this)
      if not this:IsFocused() then return end
      this:SetStr(GetUserChannel(this:GetParent().value))
      this:RemoveFocus() 
      this:GetParent():UpdateChannel()
    end,
    
    OnMouseEnter = function(this) local slot = this:GetParent() slot:GetParent().rollover = slot end,
    OnMouseLeave = function(this) local slot = this:GetParent() slot:GetParent().rollover = nil end,
    OnMouseDown = function(this) this:GetParent():OnNameClick(argBtn) end,
  },
  
  OnShow = function(this) 
    this:UpdateChannel()
  end,

  OnCheckClick = function(this, mousebtn)
    local chn_idx = GetSetupChannel() if not chn_idx then return end
    local ch_name = GetUserChannel(this.value) if not ch_name then ch_name = this.value end
    if ch_name == TEXT_UNASSIGNEDKEY then return end
    
    if mousebtn == "LEFT" then
      UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] = UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] + 1
      if UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] > 1 then UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] = 0 end

      game.SaveUserPrefs("LobbyChatView_"..chn_idx, UserContacts.ChatStuff.ChannelsSetup.data[chn_idx])
      this:UpdateChannel()
      LobbyChat:SetUserView(LobbyChat.currview.idx)
    end
  end,
  
  OnShorcutClick = function(this, mousebtn)
    local ch_name = GetUserChannel(this.value) if not ch_name then ch_name = this.value end
    if ch_name == TEXT_UNASSIGNEDKEY then return end
    
    local chn_idx = GetSetupChannel() 
    if mousebtn == "LEFT" and not chn_idx then 
      ShortcutAssign:SetChannel(this)
    end
    if mousebtn == "RIGHT" then
      ColorPicker:SetAnchor("TOPLEFT", this.Shortcut, "BOTTOMLEFT", {0,0})
      ColorPicker.func = function(clr)
        this.channel_color = clr
        this:SaveChannelColors()
        this:UpdateChannel()
      end
      ColorPicker:Show()
      LobbyChat:SetUserView(LobbyChat.currview.idx)
    end
  end,

  OnNameClick = function(this, mousebtn)
    local ch_name = GetUserChannel(this.value) if not ch_name then ch_name = this.value end
    if ch_name == TEXT_UNASSIGNEDKEY then return end
    
    local chn_idx = GetSetupChannel()
    if not chn_idx then
      if this.value == "general" then
        local tbl = game.LoadUserPrefs("chat_def_lang")
        ch_name = tbl.lang
      end
      if not this.selected then this.selected = false end
      this.selected = not this.selected
      this:UpdateChannel()
      UserContacts.ChatStuff:ShowChannelUsers(ch_name, this.selected)
    elseif mousebtn == "LEFT" then
      UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] = UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] + 1
      if UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] > 1 then UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] = 0 end

      game.SaveUserPrefs("LobbyChatView_"..chn_idx, UserContacts.ChatStuff.ChannelsSetup.data[chn_idx])
      this:UpdateChannel()
      LobbyChat:SetUserView(LobbyChat.currview.idx)
    end
  end,

  OnDeleteClick = function(this)
    for i = 1,CHAT_VIEWS do
      UserContacts.ChatStuff.ChannelsSetup.data[i][this.value] = 0
      game.SaveUserPrefs("LobbyChatView_"..i, UserContacts.ChatStuff.ChannelsSetup.data[i])
    end
    
    local curr = GetUserChannel(this.value)
    if curr ~= TEXT_UNASSIGNEDKEY then
      net.ChatLeaveChannel(curr)
    end  
    
    SetUserChannel(this.value, TEXT_UNASSIGNEDKEY)
    game.SaveUserPrefs("LobbyUserChannels", GetUserChannel())
    
    this.channel_color = DEF_CHANNEL_COLOR
    this:SaveChannelColors()
    
    this:SetShortcut()
    
    this.selected = nil
    
    this.Edit:SetStr(TEXT_UNASSIGNED)
    this.Edit:RemoveFocus()
    this:UpdateChannel()
    LobbyChat:SetUserView(LobbyChat.currview.idx)
  end,

  SetShortcut = function(this, key)
    this.shortcutkey = key
    this:UpdateChannel()
    LobbyChat:SetUserView(LobbyChat.currview.idx)
    this:SaveChannelShortkeys()
  end,

  UpdateChannel = function(this)
    local chn_idx = GetSetupChannel()
    -- selected or not - 'view channel users' mode
    if this.selected then
      this.SelBack:Show()
    else
      this.SelBack:Hide()
    end    
    -- shortcut frame color
    if not chn_idx or UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] == 0 then
      this.Shortcut.NormalImage:SetColor(colors.white)
      this.Shortcut.PushImage:SetColor(colors.white)
      this.Shortcut.HighImage:SetColor(colors.white)
    else
      this.Shortcut.NormalImage:SetColor(colors.green)
      this.Shortcut.PushImage:SetColor(colors.green)
      this.Shortcut.HighImage:SetColor(colors.green)
    end
    -- shortcut letter
    this.Shortcut:SetStr(this.shortcutkey)
    -- check or shortcut
    if chn_idx then
      if UserContacts.ChatStuff.ChannelsSetup.data[chn_idx][this.value] > 0 then
        this.Check.checked = 1
      else
        this.Check.checked = 0
      end
      this.Check:updatetextures()
      this.Check:Show()
      this.Shortcut:Hide()
    else
      this.Check:Hide()
      this.Shortcut:Show()
    end
    -- channel name
    local unassigned_user = false
    if this.editonclick then
      local ch_name = GetUserChannel(this.value)
      if ch_name == TEXT_UNASSIGNEDKEY then 
        unassigned_user = true
        ch_name = TEXT_UNASSIGNED
      end
      this.Edit:SetStr(ch_name)
    else
      this.Edit:SetStr(TEXT{this.long_str, this.channelindex})
    end
    -- editable or not
    if this.editonclick and unassigned_user then
      this.Edit:SetReadOnly(false)
    else
      this.Edit:SetReadOnly(true)
    end
    -- channel color
    this.Edit:SetColor(this.channel_color)
    -- allow deleting or not
    if this.editonclick and this.Edit:GetStr() ~= TEXT_UNASSIGNED then
      this.delete_show = true
    else
      this.delete_show = nil
    end
  end,
  
  SaveChannelColors = function(this)
    local clrs = {}
    for k,v in pairs(UserContacts.ChatStuff.ChannelsSetup) do
      if type(v) == "table" and v.channel_color then 
        if not v.channel_color[1] then v.channel_color = DEF_CHANNEL_COLOR end
        clrs[v:GetName()] = v.channel_color
      end
    end
    game.SaveUserPrefs("ChatChanelColors", clrs)
  end,
  
  SaveChannelShortkeys = function(this)
    local keys = {}
    for k,v in pairs(UserContacts.ChatStuff.ChannelsSetup) do
      if type(v) == "table" and v.Shortcut then
        keys[v:GetName()] = v.shortcutkey
      end
    end
    game.SaveUserPrefs("ChatChanelShortkeys", keys)
  end,

  Highlight = function(this, light)
    if light and this.delete_show then
      this.Delete:Show()
    else  
      this.Delete:Hide()  
    end  
  end,
  
  OnMouseEnter = function(this) this:GetParent().rollover = this end,
  OnMouseLeave = function(this) this:GetParent().rollover = nil end,
}

-- 
local DefSlotButton = DefButton {
  virtual = true,
  size = {20,20},
  font = "Verdana,11",
  
  index = 1,
      
  NormalImage = uiimg { texture = "data/textures/ui/social_icons.dds"},
  HighImage = uiimg { texture = "data/textures/ui/social_icons.dds"},
  PushImage = uiimg { texture = "data/textures/ui/social_icons.dds"},
  
  OnShow = function(this)
    local left
    local sz = this:GetSize()
    local top = (this.index-1)*sz.y
    left = 0  this.NormalImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    left = 20 this.HighImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    left = 40 this.PushImage:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
  end,

  Disable = function(this, disable)
    if disable then
      this.disabled = true
      this.NormalImage:SetAlpha(0.4)
      this.PushImage:SetAlpha(0.4)
      this.HighImage:SetAlpha(0.4)
    else
      this.disabled = nil
      this.NormalImage:SetAlpha(1)
      this.PushImage:SetAlpha(1)
      this.HighImage:SetAlpha(1)
    end
  end,

  OnMouseEnter = function(this) local slot = this:GetParent() slot.list.rollover = slot end,
  OnMouseLeave = function(this) local slot = this:GetParent() slot.list.rollover = nil end,
  OnMouseWheel = function(this, delta, mods) this:GetParent():OnMouseWheel(delta, mods) end
}
-- Chat member slot
local function CreateMemberSlotFunc(listbox, row, col, slotw, sloth)
  local slot
  slot = uibtn {
    size = { slotw, sloth },
    font = "Verdana,11",
    
    org_width = slotw,
    org_height = sloth,
    sel_height = sloth*2,
    
    list = listbox,
    
    clr_normal = {51,102,255},
    clr_selected = {51,150,255},
    
    Status = uiimg {
      hidden = true,
      size = {20,20},
      texture = "data/textures/ui/social_icons.dds",
      coords = {0,160,20,20},
      anchors = { TOPLEFT = { 2,0 } },
    },

    NormalText = uitext { valign = "TOP", halign = "LEFT", color = {51,102,255,255}, anchors = { LEFT = { "RIGHT", "Status", 5,2 } } },
    HighText  = uitext { valign = "TOP", halign = "LEFT", color = {51,150,255,255}, anchors = { LEFT = { "RIGHT", "Status", 5,2 } } },
    PushText = uitext { valign = "TOP", halign = "LEFT", color = {51,150,255,255}, anchors = { LEFT = { "RIGHT", "Status", 5,2 } } },

    RemoveStatus = DefSlotButton {
      hidden = true,
      index = 2,
      anchors = { BOTTOMLEFT = { 2,-2 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        if slot.data.friend then
          local id = net.BuddyList_IsBuddy(slot.data.name)
          UserContacts.FriendsList:Delete(id)
          slot.data.friend = nil
        end  
        slot:ShowData(slot.data)
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_remove_friend_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    AddFriend = DefSlotButton {
      hidden = true,
      index = 1,
      anchors = { BOTTOMLEFT = { 2,-2 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        net.BuddyList_SendRequest(slot.data.name)
        LobbyChat:AddLine(nil, nil, TEXT{"auth_request", slot.data.name})
        slot:ShowData(slot.data)
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_add_friend_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Info = DefSlotButton {
      hidden = true,
      index = 5,
      anchors = { BOTTOMRIGHT = { -2,-2 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts:OnInfoClick(slot:GetStr()) 
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_inspect_tip", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Invite = DefSlotButton {
      hidden = true,
      index = 4,
      anchors = { RIGHT = { "LEFT", "Info", -2,0 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts:OnInviteClick(slot:GetStr()) 
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_invite_tip", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Tell = DefSlotButton {
      hidden = true,
      index = 3,
      anchors = { RIGHT = { "LEFT", "Invite", -2,0 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts:OnTellClick(slot:GetStr())
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_tell_tip", this, "BOTTOMRIGHT", "TOPRIGHT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },
    
    SelBack = uiimg { hidden = true, color = {0,0,0,128}, },

    OnMouseEnter = function(this) this.list.rollover = this end,
    OnMouseLeave = function(this) this.list.rollover = nil end,

    ShowData = function(this, data)
      this.data = data
      this:SetStr(data.name)
      data.friend = net.BuddyList_IsBuddy(data.name)
      if data.friend then
        this.Status:Show()
      else
        this.Status:Hide()
      end  

      if this.list.selected_data and this.list.selected_data.name == data.name then
        this:SetSize{this.org_width,this.sel_height}
        this.Info:Show()
        if net.GLIsHost() then
          this.Invite:Disable(false)
        else
          this.Invite:Disable(true)
        end
        this.Invite:Show()
        this.Tell:Show()
        this.SelBack:Show()
        if not net.GLIsGameSpyLobby() then
          this.RemoveStatus:Hide()
          this.AddFriend:Hide()
          this.Info:Hide()
        elseif this.data.friend then
          this.RemoveStatus:Show()
          this.AddFriend:Hide()
        else
          this.RemoveStatus:Hide()
          this.AddFriend:Show()
        end
        this.list.selected = this
      else  
        this:SetSize{this.org_width,this.org_height}
        this.Info:Hide()
        this.Invite:Hide()
        this.Tell:Hide()
        this.SelBack:Hide()
        this.RemoveStatus:Hide()
        this.AddFriend:Hide()
      end  
    end,
    
    OnClick = function(this)
      if net.Lobby_GetPlayerName() == this.data.name then return end
      if this.list.selected_data and this.list.selected_data.name == this.data.name then
        this.list.selected_data = nil
      else
        this.list.selected_data = this.data
      end
      this.list:UpdateList()
    end,
    
  }
  return slot
end

-- Friends slot
local function CreateFriendSlotFunc(listbox, row, col, slotw, sloth)
  local slot
  slot = uiwnd {
    size = { slotw, sloth },
    font = "Verdana,11",
    mouse = true,
    
    org_width = slotw,
    org_height = sloth,
    sel_height = sloth*2,
    online_clr = {255,255,255},
    online_playing_clr = {58,133,255},
    offline_clr = {90,90,90},
    online_ext_clr = {128,128,128},
    list = listbox,
    
    
    StatusIcon = uiimg {
      hidden = true,
      size = { 16,16 },
      anchors = { TOPLEFT = { 2,4 } },
      texture = "data/textures/ui/friend_status_icons.dds",
      idx = { 
        ["speciallocation"] = {0,0,16,16},
        ["pvp"] = {0,16,16,32},
        ["pvpa"] = {0,16,16,32},
        ["mission"] = {0,32,16,48},
        ["practice"] = {0,32,16,48},
      },
    },

    Name = uitext {
      size = {200,20},
      valign = "TOP",
      halign = "LEFT",
      color = {51,102,255,255},
      anchors = { LEFT = { "RIGHT", "StatusIcon", 5,0 } },
    },
      
    StatusText = uitext {
      size = {400,20},
      valign = "TOP",
      halign = "LEFT",
      color = {51,102,255,255},
      anchors = { LEFT = { "RIGHT", "Name", 20,0 } },
    },

    Join = DefSlotButton {
      hidden = true,
      index = 6,
      anchors = { TOP = { "BOTTOM", "StatusIcon", 0,4 } },
      OnClick = function(this)
        if this.disabled then return end
        local slot = this:GetParent()
        if slot.data.gameid then 
          net.BuddyList_JoinGame(slot.data.gameid)
        end  
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_join_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Tell = DefSlotButton {
      hidden = true,
      index = 3,
      anchors = { LEFT = { "RIGHT", "Join", 2,0 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts:OnTellClick(slot.Name:GetStr()) 
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_tell_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Invite = DefSlotButton {
      hidden = true,
      index = 4,
      anchors = { LEFT = { "RIGHT", "Tell", 2,0 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts:OnInviteClick(slot.Name:GetStr()) 
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_invite_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Info = DefSlotButton {
      hidden = true,
      index = 5,
      anchors = { LEFT = { "RIGHT", "Invite", 2,0 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts:OnInfoClick(slot.Name:GetStr())
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_inspect_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    RemoveFirend = DefSlotButton {
      hidden = true,
      index = 2,
      anchors = { TOPRIGHT = { "BOTTOMRIGHT", "Name", 0,4 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        UserContacts.FriendsList:Delete(slot.data.id)
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_remove_friend_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    SelBack = uiimg { hidden = true, layer = "-1", color = {19,23,49,255}, },

    OnMouseEnter = function(this) this.list.rollover = this end,
    OnMouseLeave = function(this) this.list.rollover = nil end,
    OnMouseDown = function(this) 
      if listbox.selected_data and listbox.selected_data.name == this.data.name then
        listbox.selected_data = nil
      else
        listbox.selected_data = this.data
      end
      listbox:UpdateList()
    end,

    ShowData = function(this, data)
      this.data = data
      this.Name:SetStr(data.wsname or data.name)
      this.StatusIcon:Hide()
      local status

      if data.prm_status then
        status = TEXT{data.str_status, data.prm_status[1], data.prm_status[2], data.prm_status[3], data.prm_status[4], data.prm_status[5]}
      else 
        status = TEXT{data.str_status}
      end      
      this.StatusText:SetStr(status)
      
      if data.num_status == 0 then
        this.Name:SetColor(this.offline_clr)
        this.StatusText:SetColor(this.offline_clr)
      else
        if not data.wsname then
          this.Name:SetColor(this.online_ext_clr)
          this.StatusText:SetColor(this.online_ext_clr)
        else
          if data.num_status == 2 then
            this.Name:SetColor(this.online_playing_clr)
            this.StatusText:SetColor(this.online_playing_clr)
            if not data.gametype then data.gametype = "practice" end
            this.StatusIcon:SetTexture(nil, this.StatusIcon.idx[data.gametype])
            this.StatusIcon:Show()
          else
            this.Name:SetColor(this.online_clr)
            this.StatusText:SetColor(this.online_clr)
          end
        end
      end

      if listbox.selected_data and listbox.selected_data.name == data.name then
        this:SetSize{this.org_width,this.sel_height}
        if data.gameid then
          this.Join:Disable(false)
        else
          this.Join:Disable(true)
        end
        this.Join:Show()
        this.Tell:Show()
        if net.GLIsHost() then
          this.Invite:Disable(false)
        else
          this.Invite:Disable(true)
        end
        this.Invite:Show()
        this.Info:Disable(data.num_status < 1)
        this.Info:Show()
        this.RemoveFirend:Show()
        this.SelBack:Show()
        this.list.selected = this
      else  
        this:SetSize{this.org_width,this.org_height}
        this.Join:Hide()
        this.Tell:Hide()
        this.Invite:Hide()
        this.Info:Hide()
        this.RemoveFirend:Hide()
        this.SelBack:Hide()
      end  
    end,
    
    Highlight = function(this, dolight)
      if dolight then
      else  
      end  
    end,
    
    OnClick = function(this)
      if net.Lobby_GetPlayerName() == this.data.name then return end
      if this.list.selected_data and this.list.selected_data.name == this.data.name then
        this.list.selected_data = nil
      else
        this.list.selected_data = this.data
      end
      this.list:UpdateList()
    end,
  }
  return slot
end
-- message slot
local function CreateMessageSlotFunc(listbox, row, col, slotw, sloth)
  local slot
  slot = uiwnd {
    size = { slotw, sloth },
    font = "Verdana,11",
    mouse = true,
    
    list = listbox,

    Message = uitext {
      size = { slotw,sloth },
      valign = "TOP",
      halign = "LEFT",
      anchors = { TOPLEFT = { 2,2 } },
    },

    Accept = DefSlotButton {
      hidden = true,
      index = 7,
      anchors = { TOPLEFT = { 2,2 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        net.BuddyList_AuthRequest(slot.data.id, true)
        slot.data.accepted = true
        slot:ShowData(slot.data)
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_authorize_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Reject = DefSlotButton {
      hidden = true,
      index = 8,
      anchors = { LEFT = { "RIGHT", "Accept", 2,0 } },
      OnClick = function(this) 
        if this.disabled then return end
        local slot = this:GetParent()
        net.BuddyList_AuthRequest(slot.data.id, false)
        slot.data.rejected = true
        slot:ShowData(slot.data)
      end,
      OnMouseEnter = function(this) DefSlotButton.OnMouseEnter(this) NTTooltip:DoShow("chat_reject_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) end,
      OnMouseLeave = function(this) DefSlotButton.OnMouseLeave(this) NTTooltip:Hide() end,
    },

    Status = uitext {
      hidden = true,
      size = { 200,20 },
      font = "Verdana,11",
      halign = "LEFT",
      color = {105,105,105,255},
      anchors = { TOPLEFT = { 2,2 } },
      str_accepted = "("..TEXT{"accepted"}..")",
      str_rejected = "("..TEXT{"rejected"}..")",
    },

    --SelBack = uiimg { hidden = true, layer = "-1", color = {19,23,49,255} },

    --OnMouseEnter = function(this) listbox.rollover = this end,
    --OnMouseLeave = function(this) listbox.rollover = nil end,
    --OnMouseDown = function(this) 
      --if this.data.request then 
        --if listbox.selected_data and listbox.selected_data.name == this.data.name then
          --listbox.selected_data = nil
        --else
          --listbox.selected_data = this.data
        --end
        --listbox:UpdateList()
      --end 
    --end,

    ShowData = function(this, data)
      if not data then return end
      this.data = data
      this.Message:SetStr("<p>"..data.msg)
      if data.request then
        if data.accepted then
          this.Accept:Hide()
          this.Reject:Hide()
          this.Status:SetStr(this.Status.str_accepted)
          this.Status:Show()
          local sw = this.Status:GetStrWidth()
          this.Message:SetAnchor("TOPLEFT", this.Status, "TOPLEFT", {sw+5, 0})
        elseif data.rejected then
          this.Accept:Hide()
          this.Reject:Hide()
          this.Status:SetStr(this.Status.str_rejected)
          this.Status:Show()
          local sw = this.Status:GetStrWidth()
          this.Message:SetAnchor("TOPLEFT", this.Status, "TOPLEFT", {sw+5, 0})
        else
          this.Accept:Show()
          this.Reject:Show()
          this.Status:Hide()
          this.Message:SetAnchor("TOPLEFT", this.Reject, "TOPRIGHT", {5, 0})
        end
        --this.SelBack:Show()
      else
        this.Accept:Hide()
        this.Reject:Hide()
        this.Status:Hide()
        this.Message:SetAnchor("TOPLEFT", this, "TOPLEFT", {2, 2})
        --this.SelBack:Hide()
      end
      this.Message:SetSize{slotw, this.Message:GetStrHeight()}
      this:SetSize{slotw, this.Message:GetStrHeight()+5}
    end,
    
    Highlight = function(this, dolight)
      if dolight then
      else  
      end  
    end,
  }
  return slot
end
--
local DefTab = DefButton {
  virtual = true,
	font = "Verdana,10b",
	
	selected = false,
  
  n_coords = {0,0,311,28},
  h_coords = {0,28,311,28+28},
  p_coords = {0,56,311,56+28},
  s_clr = {0, 0, 0, 0},
  n_clr = {100, 100, 100, 255},
  d_clr = {60, 60, 60, 255},

	NormalImage = uiimg { texture = "data/textures/ui/tab2.dds" },
  HighImage = uiimg { texture = "data/textures/ui/tab2.dds" },
  PushImage = uiimg { texture = "data/textures/ui/tab2.dds" },
  
	SelectTab = function(this, select)
    this.selected = select
    if select then
      this.NormalImage:SetTexture(nil, this.p_coords)
      this.HighImage:SetTexture(nil, this.p_coords)
      this.PushImage:SetTexture(nil, this.h_coords)
      
      this.NormalText:SetColor(this.s_clr)
      this.HighText:SetColor(this.s_clr)
      this.PushText:SetColor(this.s_clr)
    else
      if this.disabled then
        this.NormalImage:SetTexture(nil, this.n_coords)
        this.HighImage:SetTexture(nil, this.n_coords)
        this.PushImage:SetTexture(nil, this.n_coords)
        
        this.NormalText:SetColor(this.d_clr)
        this.HighText:SetColor(this.d_clr)
        this.PushText:SetColor(this.d_clr)
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
    this:SelectTab(this.selected) 
  end,

  OnClick = function(this)
    if this.disabled then return end
    this:GetParent():OnTabClick(this)
  end,
}
--
local DefChannelBtn = DefViewBtn {
  OnClick = function(this) UserContacts.ChatStuff.ChannelsSetup:SetupChannel(this) end,
}
--
local frndw = 645
local frndh = 720
local tabw = (frndw/3)-10

UserContacts = uiwnd {
  layer = friendslayer,
  hidden = true,
  size = {frndw,frndh}, 
  anchors = { TOPRIGHT = { "TOPRIGHT", "Lobby", -10, 60 } },

  Frame = DefBigBackImage{layer = friendslayer-2},

  FriendsTab = DefTab {
    size = {1,28},
    anchors = { TOPLEFT = { "Frame", 10, 10 }, TOPRIGHT = { "TOP", "Frame", -1,10 } },
    str = TEXT{"friends list"},
  },

  ChatTab = DefTab {
    size = {tabw,28},
    anchors = { TOPRIGHT = { "TOPRIGHT", "Frame", -10,10 }, TOPLEFT = { "TOP", "Frame", 1,10 } },
    str = TEXT{"chat_tab"},
  },

  FriendsList = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "FriendsTab", 0, 1 }, TOPRIGHT = { "BOTTOMRIGHT", "ChatTab", 0,1 }, BOTTOM = { 0,-10 } },

    Listbox = DefColumnsList {
      size = {1,300},
      anchors = { TOPLEFT = { 5,9 }, TOPRIGHT = { -20,9 } },
      rows = 12,
      cols = 1,
      col_dist = 0,
      row_dist = 0,
      func = CreateFriendSlotFunc,

      Scrollbar = DefColumnsList.Scrollbar { hidden = false },
      
      Frame = DefCornerFrameImage2 { anchors = { TOPLEFT = {-5,-9}, BOTTOMRIGHT = {20,25} } },
      
      OnUpdate = function(this)
        if this.rollover then
          if this.showrollover then
            if this.showrollover == this.rollover then return end
            this.showrollover:Highlight(false)
          end  
          this.showrollover = this.rollover
          this.showrollover:Highlight(true)
        elseif this.showrollover then
          this.showrollover:Highlight(false)
          this.showrollover = nil
        end
      end,
    },

    CheckShowOfflines = DefCheck {
      checked = 1,
      font = "Verdana,10",
      anchors = { TOPLEFT = { "BOTTOMLEFT", "UserContacts.FriendsList.Listbox.Frame", 0,-3 } },
      str = "<p>"..TEXT{"show_offline_players"},
      OnClick = function(this)
        if not this:GetParent().Listbox.list then return end
        DefCheck.OnClick(this)
        for i,v in ipairs(this:GetParent().Listbox.list) do
          if this.checked == 0 then
            if v.num_status < 1 then v.hidden = true end
          else
            v.hidden = nil
          end
        end
        this:GetParent().Listbox:UpdateList()
      end,
    },

    Messages = DefColumnsList {
      anchors = { TOPLEFT = { "BOTTOMLEFT", "UserContacts.FriendsList.Listbox.Frame", 5,30+5 },
                  TOPRIGHT = { "BOTTOMRIGHT", "UserContacts.FriendsList.Listbox.Frame", -5,30+5 },
                  BOTTOM = { 0,-5 } },
      rows = 11,
      cols = 1,
      col_dist = 0,
      row_dist = 0,
      func = CreateMessageSlotFunc,

      Frame = DefCornerFrameImage2 { anchors = { TOPLEFT = {-5,-5}, BOTTOMRIGHT = {5,5} } },
      
      Scrollbar = DefColumnsList.Scrollbar { hidden = false, anchors = { TOPRIGHT = { "TOPRIGHT", -3, 5 }, BOTTOMRIGHT = { "BOTTOMRIGHT", -3, -5 } }  },
      
      OnUpdate = function(this)
        if this.rollover then
          if this.showrollover then
            if this.showrollover == this.rollover then return end
            this.showrollover:Highlight(false)
          end  
          this.showrollover = this.rollover
          this.showrollover:Highlight(true)
        elseif this.showrollover then
          this.showrollover:Highlight(false)
          this.showrollover = nil
        end
      end,
    },
  },

  ChatStuff = uiwnd {
    hidden = true,
    anchors = { TOPLEFT = { "BOTTOMLEFT", "FriendsTab", 0, 0 }, BOTTOMRIGHT = { "Frame", -10,-10 } },
    
    ChannelsSetup = uiwnd {
      layer = friendslayer,
      mouse = true,
      
      size = {1,1},
      anchors = { TOPLEFT = { 10,10 }, BOTTOMRIGHT = { "BOTTOM", -5,-10 } },
      
      DefCornerFrameImage2{ anchors = { TOPLEFT = {-10,-10}, BOTTOMRIGHT = {5,10} } },
      
      StandartChannels = uitext {
        size = {1,30},
        layer = friendslayer,
        halign = "LEFT",
        font = "Arial,11b",
        anchors = { TOPLEFT = {5,0}, TOPRIGHT = {-5,0} },
        str = TEXT{"standart channels"},
      },
      
      Default = DefChannelRow {
        shortcutkey = "D",

        layer = friendslayer,
        size = {1,30},
        channel_color = {255,200,100,255},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "StandartChannels", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "StandartChannels", 0,0 }
        },
        long_str = "chat_channel_int_form",
        value = 'default',
        
        OnLoad = function(this)
          this:RegisterEvent("CHAT_CHANNEL_ENTERED")
        end,

        OnEvent = function(this, event)
          if event == "CHAT_CHANNEL_ENTERED" and argChannel == "default" then
            this.channelindex = argIndex+1
            this:UpdateChannel()
          end
        end,
      },

      General = DefChannelRow {
        shortcutkey = "E",

        layer = friendslayer,
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Default", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Default", 0,0 }
        },
        long_str = "chat_channel_loc_form",
        value = 'general',
        
        Lang = uiwnd {
          size = {42,23},
          layer = "+1",

          anchors = { RIGHT = { -80,-3 } },
          uiimg { 
            size = {42,23},
            layer = "-1",
            texture = "data/textures/ui/login_field_back.dds", 
            coords = {0,0,309,23},
          },
          text = uitext {
            size = {36,23},
            layer = "+1",
            font = "Verdana,10",
            color = {255,255,255},
            halign = "LEFT",
          },
        },

        ComboLangs = DefCombobox {
          size = {65,120},
          btn_height = 21,
          customanchored = true,
          anchors = { TOPLEFT = { "TOPLEFT", "Lang", 0,0 } },

          Button = DefCombobox.Button { 
            size = {20,20}, 
            layer = "+1",

            NormalImage = uiimg { texture = "data/textures/ui/login_dropdown_button.dds", coords = {0,0,29,21} },
            HighImage = uiimg { texture = "data/textures/ui/login_dropdown_button.dds", coords = {0,21,29,21} },
            PushImage = uiimg { texture = "data/textures/ui/login_dropdown_button.dds", coords = {0,21,29,21} },
            
            NormalText = uitext { hidden = true },
            HighText = uitext { hidden = true },
            PushText = uitext { hidden = true },

            anchors = { TOPRIGHT = { 0,2 } },
          },
          
          Listbox = DefCombobox.Listbox {
            textjustify = "LEFT",
            anchors = { TOPLEFT = { 0,21 }, BOTTOMRIGHT = {0,0} },

            font = "Verdana,10",
            ncolor = {143, 153, 138},
            hcolor = {236, 254, 227},
            pcolor = {236, 254, 227},
            scolor = {255, 143, 51},
            ScrollArea = DefCombobox.Listbox.ScrollArea {
              back = uiimg { 
                texture = "data/textures/ui/ui.tga",
                coords = {0, 199, 27, 27},
                tiled = 1,
                shader = "_Misc_IDBB",
              },
            },
            
            Scrollbar = DefCombobox.Listbox.Scrollbar { hidden = false },
            GetItemText = function(this, idx) return this.list[idx].name end,
            
            UpdateItem = function(this, item, data)
              item.data = data
              item:SetStr(data)
            end,

            SelectItem = function(this, item, data, selected)
              local tbl = game.LoadUserPrefs("chat_def_lang")
              if data ~= tbl.lang then
                UserContacts.ChatStuff:ShowChannelUsers(tbl.lang, false)
                net.ChatLeaveChannel(tbl.lang)
                tbl.lang = string.upper(data)
                game.SaveUserPrefs("chat_def_lang", tbl)
                net.ChatEnterChannel(tbl.lang)
                UserContacts.ChatStuff:ShowChannelUsers(tbl.lang, true)
              end
            end,
          },

          InitCombo = function(this)
            local userdef = string.upper(game.GetLang())
            local langs = { [1] = userdef }
            if userdef ~= "EN" then table.insert(langs, "EN") end
            if userdef ~= "FR" then table.insert(langs, "FR") end
            if userdef ~= "DE" then table.insert(langs, "DE") end
            if userdef ~= "RU" then table.insert(langs, "RU") end
            if userdef ~= "ES" then table.insert(langs, "ES") end
            if userdef ~= "IT" then table.insert(langs, "IT") end
            if userdef ~= "ZH" then table.insert(langs, "ZH") end
            this.Listbox:SetList(langs)
            local tbl = game.LoadUserPrefs("chat_def_lang")
            if not tbl then
              tbl = { ["lang"] = userdef }
              game.SaveUserPrefs("chat_def_lang", tbl)
            end
            local index = 1
            for i,v in ipairs(langs) do
              if v == tbl.lang then
                index = i break
              end
            end
            this.Button.selected = index
          end,
          
          OnItemSelected = function(listbox, idx)
            listbox:GetParent():GetParent().Lang.text:SetStr(listbox.list[idx])
          end,
        },

        OnLoad = function(this)
          this:RegisterEvent("CHAT_CHANNEL_ENTERED")
        end,

        OnEvent = function(this, event)
          local tbl = game.LoadUserPrefs("chat_def_lang") if not tbl then return end
          if event == "CHAT_CHANNEL_ENTERED" and argChannel == tbl.lang then
            this.channelindex = argIndex+1
            this:UpdateChannel()
          end
        end,
      },

      VirtualChannels = uitext {
        size = {1,30},
        layer = friendslayer,
        halign = "LEFT",
        font = "Arial,11b",
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "General", 0,15 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "General", 0,15 }
        },
        str = TEXT{"virtual channels"},
      },

      Game = DefChannelRow {
        shortcutkey = "G",

        layer = friendslayer,
        size = {1,30},
        channel_color = {155,255,140,255},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "VirtualChannels", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "VirtualChannels", 0,0 }
        },
        long_str = "created game lobby",
        value = 'game',
      },
      
      Tells = DefChannelRow {
        shortcutkey = "T",

        layer = friendslayer,
        size = {1,30},
        channel_color = {160,210,255,255},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Game", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Game", 0,0 }
        },
        long_str = "tells",
        value = 'tells',
      },

      UserChannels = uitext {
        size = {1,30},
        layer = friendslayer,
        halign = "LEFT",
        font = "Arial,11b",
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Tells", 0,15 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Tells", 0,15 }
        },
        str = TEXT{"user channels"},
      },

      Ch_1 = DefChannelRow {
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "UserChannels", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "UserChannels", 0,0 }
        },
        layer = friendslayer,
        editonclick = 1,
        value = 'userch_1',
      },

      Ch_2 = DefChannelRow {
        layer = friendslayer,
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Ch_1", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Ch_1", 0,0 }
        },
        editonclick = 1,
        value = 'userch_2',
      },

      Ch_3 = DefChannelRow {
        layer = friendslayer,
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Ch_2", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Ch_2", 0,0 }
        },
        editonclick = 1,
        value = 'userch_3',
      },

      Ch_4 = DefChannelRow {
        layer = friendslayer,                                  
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Ch_3", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Ch_3", 0,0 }
        },
        editonclick = 1,
        value = 'userch_4',
      },

      Ch_5 = DefChannelRow {
        layer = friendslayer,
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Ch_4", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Ch_4", 0,0 }
        },
        editonclick = 1,
        value = 'userch_5',
      },

      Ch_6 = DefChannelRow {
        layer = friendslayer,
        size = {1,30},
        anchors = { 
          TOPLEFT = { "BOTTOMLEFT", "Ch_5", 0,0 }, 
          TOPRIGHT= { "BOTTOMRIGHT", "Ch_5", 0,0 }
        },
        editonclick = 1,
        value = 'userch_6',
      },

      Channel_1  = DefChannelBtn { str = "1", idx = 1,  anchors = { BOTTOMLEFT = {-4,0} } },
      Channel_2  = DefChannelBtn { str = "2", idx = 2,  anchors = { LEFT = { "RIGHT", "Channel_1", -1,0 } } },
      Channel_3  = DefChannelBtn { str = "3", idx = 3,  anchors = { LEFT = { "RIGHT", "Channel_2", -1,0 } } },
      Channel_4  = DefChannelBtn { str = "4", idx = 4,  anchors = { LEFT = { "RIGHT", "Channel_3", -1,0 } } },
      Channel_5  = DefChannelBtn { str = "5", idx = 5,  anchors = { LEFT = { "RIGHT", "Channel_4", -1,0 } } },
      Channel_6  = DefChannelBtn { str = "6", idx = 6,  anchors = { LEFT = { "RIGHT", "Channel_5", -1,0 } } },
      Channel_7  = DefChannelBtn { str = "7", idx = 7,  anchors = { LEFT = { "RIGHT", "Channel_6", -1,0 } } },
      
      Help = uitext {
        layer = friendslayer,
        halign = "LEFT",
        valign = "TOP",
        font = "Arial,9",
        size = {1,1},
        anchors = { 
          BOTTOMLEFT = { 0,-40 }, 
          BOTTOMRIGHT= { -5,-40 },
        },
      },

      ChatViews = uitext {
        size = {1,30},
        layer = friendslayer,
        halign = "LEFT",
        font = "Arial,11b",
        anchors = { 
          BOTTOMLEFT = { "TOPLEFT", "Help", 0,-5 }, 
          BOTTOMRIGHT= { "TOPRIGHT", "Help", 0,-5 }
        },
        str = TEXT{"chat views:"},
      },
      
      OnUpdate = function(this)
        if this.rollover then
          if this.showrollover then
            if this.showrollover == this.rollover then return end
            this.showrollover:Highlight(false)
          end  
          this.showrollover = this.rollover
          this.showrollover:Highlight(true)
        elseif this.showrollover then
          this.showrollover:Highlight(false)
          this.showrollover = nil
        end
      end,
      
      SetupChannel = function(this, btn)
        if this.btn then 
          this.btn.checked = 0
          this.btn:updatetextures()
        end
        if this.btn == btn then
          this.setup_channel = nil
          this.btn = nil
          this:Hide()
          this:Show()
        else
          this.btn = btn
          this.btn.checked = 1
          this.btn:updatetextures()
          this.setup_channel = btn.idx if this.setup_channel == 0 then this.setup_channel = 10 end
          this:Hide()
          this:Show()
        end
        if this.setup_channel then
          UserContacts.ChatStuff.ClickToSetupChannel.Text:SetStr(TEXT{"clicktosetupchanel", this.setup_channel})
          UserContacts.ChatStuff.ClickToSetupChannel:Show()
          UserContacts.ChatStuff.MembersList:Hide()
        else
          UserContacts.ChatStuff.ClickToSetupChannel:Hide()
          UserContacts.ChatStuff.MembersList:Show()
        end
      end,
      
      GetChannelColor = function(this, channel)
        local color
      
        if channel == TEXT_CHANNELS["game"] then
          color = this.Game.channel_color
        end
        if channel == TEXT_CHANNELS["general"] then
          color = this.General.channel_color
        end
        if channel == TEXT_CHANNELS["default"] then
          color = this.Default.channel_color
        end
        if channel == TEXT_CHANNELS["from"] then
          color = this.Tells.channel_color
        end
        if channel == TEXT_CHANNELS["to"] then
          color = this.Tells.channel_color
        end
        
        if not color then
          for i = 1,6 do
            if channel == LobbyChat:GetUserChannel(i) then
              color = this["Ch_"..i].channel_color
              break
            end
          end
        end
        
        if not color then
          color = {240, 240, 240}
        end  
        
        local colors = {}
        colors['0'] = color
        colors['1'] = { 255,255,255 }
        local rollover = game.MapColor(0.2, colors)
        
        return color, rollover
      end,
      
      OnShow = function(this)
        this.Help:SetStr("<p>"..TEXT{"help_chatsetup"})
        local h = this.Help:GetStrHeight()
        this.Help:SetSize{this.Help:GetSize().x, h}
        
        if this.setup_channel then
          UserContacts.ChatStuff.ClickToSetupChannel.Text:SetStr(TEXT{"clicktosetupchanel", this.setup_channel})
          UserContacts.ChatStuff.ClickToSetupChannel:Show()
          UserContacts.ChatStuff.MembersList:Hide()
        else
          UserContacts.ChatStuff.ClickToSetupChannel:Hide()
          UserContacts.ChatStuff.MembersList:Show()
        end
      end,
    },
    
    MembersList = DefColumnsList {
      hidden = true,
      rows = 27,
      cols = 1,
      col_dist = 0,
      row_dist = 0,
      func = CreateMemberSlotFunc,
      
      anchors = { TOPLEFT = { "TOPRIGHT", "ChannelsSetup", 10,0 }, BOTTOMRIGHT = { -20,-50 } },

      Frame = DefCornerFrameImage2{ anchors = { TOPLEFT = {-5,-10}, BOTTOMRIGHT = {20,50} } },
      
      Scrollbar = DefColumnsList.Scrollbar { hidden = false },
      
      OrderByName = DefButton {
        hidden = true,
        size = {30,30},
        str = "N",
        anchors = { TOPLEFT = { "BOTTOMLEFT", 0, 40 } },
        OnClick = function(this)
          UserContacts.ChatStuff.sortbychannel = nil
          UserContacts.ChatStuff:Update()
        end,
      },
      
      OrderByChannel = DefButton {
        hidden = true,
        size = {30,30},
        str = "C",
        anchors = { LEFT = { "RIGHT", "OrderByName", 0,0 } },
        OnClick = function(this)
          UserContacts.ChatStuff.sortbychannel = true
          UserContacts.ChatStuff:Update()
        end,
      },

      PlayersCount = uitext {
        layer = "+1",
        size = {180, 30},
        font = "Verdana,11b",
        color = {234,223,178},
        halign = "LEFT",
        anchors = { BOTTOMLEFT = { "Frame", 15,-10 } },
      },

      End = DefButton {
        size = {30,30},
        
        NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,124,30,30} },
        HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,124,30,30} },
        PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,124,30,30} },
        anchors = { BOTTOMRIGHT = { "Frame", -10,-10 } },
        OnClick = function(this)
          this:GetParent().Scrollbar:SetPos(9999999999)
        end,
      },
      
      Home = DefButton {
        size = {30,30},
        
        NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,93,30,30} },
        HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,93,30,30} },
        PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,93,30,30} },
        anchors = { RIGHT = { "LEFT", "End", 0, 0 } },
        OnClick = function(this)
          this:GetParent().Scrollbar:SetPos(0)
        end,
      },

      PgDn = DefButton {
        size = {30,30},
        
        NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,62,30,30} },
        HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,62,30,30} },
        PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,62,30,30} },
        anchors = { RIGHT = { "LEFT", "Home", 0, 0 } },
        OnClick = function(this)
          local rows = this:GetParent().rows
          local scroll = this:GetParent().Scrollbar
          scroll:SetPos(scroll:GetPos() + (rows - 1))
        end,
      },

      PgUp = DefButton {
        size = {30,30},
        
        NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,31,30,30} },
        HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,31,30,30} },
        PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,31,30,30} },
        anchors = { RIGHT = { "LEFT", "PgDn", 0, 0 } },
        OnClick = function(this)
          local rows = this:GetParent().rows
          local scroll = this:GetParent().Scrollbar
          scroll:SetPos(scroll:GetPos() - (rows - 1))
        end,
      },
    
    },

    ClickToSetupChannel = uiwnd {
      hidden = true,
      anchors = { TOPLEFT = { "TOPRIGHT", "ChannelsSetup", 5,0 }, BOTTOMRIGHT = { -5,-80 } },
      Text = uitext {
        font = "Verdana,12",
      },
    },
  },
}

-- Lobby fiends
function UserContacts:OnShow()
  if not net.GLIsGameSpyLobby() then
    this.FriendsTab.disabled = true
    this.FriendsTab:SelectTab(false)
  else  
    this.FriendsTab.disabled = nil
    this.FriendsTab:SelectTab(false)
  end
  
  if not this.currtab then
    if this.FriendsTab.disabled then
      this.ChatTab:OnClick()
    else
      this.FriendsTab:OnClick()
    end
  end
  Lobby.FriendsBtn.checked = 1
  Lobby.FriendsBtn:updatetextures()
end

function UserContacts:OnHide()
  Lobby.FriendsBtn.checked = 0
  Lobby.FriendsBtn:updatetextures()
end

function UserContacts:OnTabClick(tab)
  if this.currtab then
    this.currtab:SelectTab(false)
  end
  this.currtab = tab
  this.currtab:SelectTab(true)
  
  if tab == this.FriendsTab then
    this.ChatStuff:Hide()
    this.FriendsList:Show()
  else  
    this.FriendsList:Hide()
    this.ChatStuff:Show()
  end
end

function UserContacts:OnInviteClick(player)
  net.SendGameInvitation(player)
  LobbyChat:AddLine(nil, nil, TEXT{"invitation_sent", player})
end

function UserContacts:OnInfoClick(player)
  PlayerInfo:SetPlayer(player)
end

function UserContacts:OnTellClick(player)
  if LobbyChat.TextEdit:IsHidden() then
    LobbyChat:ToggleWriteMode()
  end
  LobbyChat:SetWritePerson(player)  
end

-- Friends list
function UserContacts.FriendsList:OnLoad()
  this:RegisterEvent("BUDDYLIST_STATUS_CHANGED")
  --Kogato dojde -> ako njamash takuv player v listata dobavjash, inache updatevash infoto
  --argID -> ID, vrushtash mi go za povecheto funkcii
  --argStatus -> == 0 -> player-a e offline, inache e online
  --argPlayer -> Player name
  --argWSPlayer -> WorldShift Player name (moje da e 0)
  --argLocation -> Location String, zasega ignore
  --argStatusString -> Status string, zasega ignore
  --argGameID -> filled if user is host and joiingn the game is possible

  this:RegisterEvent("BUDDYLIST_REVOKE")
  --kogato njakoj te razkara ot buddi lista si, trjabva i ti da go razkarash ot listata
  --argID -> ID, vrushtash mi go za povecheto funkcii
  --argPlayer -> Player name
  --argWSPlayer -> WorldShift Player name (moje da e 0)
  --argMsg -> Message
  
  this:RegisterEvent("BUDDYLIST_AUTH")
  --kogato njakoj te razkara ot buddi lista si, trjabva i ti da go razkarash ot listata
  --argID -> ID, vrushtash mi go za povecheto funkcii
  --argPlayer -> Player name
  --argWSPlayer -> WorldShift Player name (moje da e 0)
  
end

function UserContacts.FriendsList:OnEvent(event)
  if event == "BUDDYLIST_REVOKE" then
    this:DelUser(argID)
    LobbyChat:AddLine(nil, nil, TEXT{"revoke", argWSPlayer or argPlayer})
  end
  
  if event == "BUDDYLIST_AUTH" then
    LobbyChat:AddLine(nil, nil, TEXT{"auth_requestaccepted", argWSPlayer or argPlayer})
  end
 

  if event == "BUDDYLIST_STATUS_CHANGED" then
    local user = {
      id = argID,
      name = argPlayer,
      wsname = argWSPlayer,
      num_status = argStatus,
      str_status = argStatusString,
      prm_status = argStatusStringParams,
      gametype = argGameType,
      gameid = argGameID,
    }
    
    local usr,idx = this:GetUser(argID)
    if not usr then
      this:AddUser(user)
    else
      if usr.num_status == 0 and user.num_status > 0 then 
        LobbyChat:AddLine(nil, nil, TEXT{"online_notification", user.wsname or user.name, msg})
      end 
      
      if usr.num_status > 0 and user.num_status == 0 then 
        LobbyChat:AddLine(nil, nil, TEXT{"offline_notification", user.wsname or user.name, msg})
      end 
      
      this:UpdateUser(argID, user)
    end

    UserContacts.ChatStuff.MembersList:UpdateList()
  end
end

function UserContacts.FriendsList:Delete(id)
  this:DelUser(id)
  net.BuddyList_Delete(id)
end

function UserContacts.FriendsList:GetUser(id)
  if not this.Listbox.list then return end
  for i,v in ipairs(this.Listbox.list) do
    if v.id == id then return v,i end
  end
end

function UserContacts.FriendsList:DelUser(id)
  local _,i = this:GetUser(id) if not i then return end
  table.remove(this.Listbox.list, i)
  this.Listbox:UpdateScrollbar()
  this.Listbox:UpdateList()
end

local function StatusSort(a,b)
  local as = a.num_status
  local bs = b.num_status
  
  if not a.wsname and as > 0 then as = 0.1 end
  if not b.wsname and bs > 0 then bs = 0.1 end

  if as ~= bs then
    local astat = as if astat == 1 then astat = 100 end
    local bstat = bs if bstat == 1 then bstat = 100 end
    return astat > bstat
  end
  return string.lower(a.name) < string.lower(b.name)
end

function UserContacts.FriendsList:AddUser(user)
  if not this.Listbox.list then this.Listbox:SetList({}) end
  table.insert(this.Listbox.list, user)
  table.sort(this.Listbox.list, StatusSort)
  this.Listbox:UpdateScrollbar()
  this.Listbox:UpdateList()
end

function UserContacts.FriendsList:UpdateUser(id, user)
  local usr,idx = this:GetUser(argID) if not usr then return end
  this.Listbox.list[idx] = user
  table.sort(this.Listbox.list, StatusSort)
  this.Listbox:UpdateList()
end

function UserContacts.FriendsList.Messages:OnLoad()
  this:RegisterEvent("BUDDYLIST_REQUEST")
  --Request njakoj da te dobavi vuv listata si
  --argID -> ID, vrushtash mi go za povecheto funkcii
  --argPlayer -> Player name
  --argWSPlayer -> WorldShift Player name (moje da e 0)
  --argReason -> Request message

  this:RegisterEvent("BUDDYLIST_MESSAGE")
  --message
  --argID -> ID, vrushtash mi go za povecheto funkcii
  --argPlayer -> Player name
  --argWSPlayer -> WorldShift Player name (moje da e 0)
  --argMsg -> Message
end

function UserContacts.FriendsList.Messages:OnEvent(event)
  if event == "BUDDYLIST_REQUEST" then
    this:AddMsg(argID, argWSPlayer or argPlayer, "", "request")
  end
  if event == "BUDDYLIST_MESSAGE" then
    this:AddMsg(argID, argWSPlayer or argPlayer, argMsg)
  end
end

function UserContacts.FriendsList.Messages:AddMsg(usrid, user, msg, type)
  if not user or not string.find(user, "%a") then return end
  local rgb = colors.white
  local tbl = UserContacts.FriendsList:GetUser(usrid)
  if not tbl then
    rgb = {0,181,233}
  else
    if not tbl.wsname then
      rgb = {100,100,100}
    else
      rgb = colors.white
    end
  end
  if type == "request" then
    rgb = {230,230,0}
  end
  local msg_color = "<color="..rgb[1]..","..rgb[2]..","..rgb[3]..">"
  
  local line = {}
  line.id = usrid
  if type then line[type] = true end
  
  if type == "request" then
    local link = "<link=chat_player:"..user..">["..user.."]</>"
    line.msg = msg_color..link.." "..TEXT{"autorization_request"}.."</>"
    LobbyChat:AddLine(nil, nil, TEXT{"autorization_request", user})
    game.PlaySnd("data/speech/Advisor/auth request.wav")
  else
    line.msg = msg_color.."<link=chat_player:"..user..">["..user.."]</>".." "..msg.."</>"
    LobbyChat:AddLine("from", user, msg)
  end
                 
  if not this.list then this:SetList({}) end
  table.insert(this.list, line)
  this:UpdateScrollbar()
  this:UpdateList()
end 

-- chat list

local channel_sort_table
local function CreateChannelSortTable()
  local tbl = game.LoadUserPrefs("chat_def_lang") if not tbl then return end
  channel_sort_table = {}
  
  channel_sort_table[UserContacts.ChatStuff.ChannelsSetup.Default.value] = 1
  channel_sort_table[UserContacts.ChatStuff.ChannelsSetup.General.value] = tbl.lang
  channel_sort_table[UserContacts.ChatStuff.ChannelsSetup.Game.value] = 3
  channel_sort_table[UserContacts.ChatStuff.ChannelsSetup.Tells.value] = 4
  for i = 1,6 do
    local ch_name = GetUserChannel(UserContacts.ChatStuff.ChannelsSetup["Ch_"..i].value)
    if cn_name and ch_name ~= TEXT_UNASSIGNEDKEY then
      channel_sort_table[ch_name] = 4+i
    end  
  end
end

function UserContacts.ChatStuff:OnShow()
  this:Update()
end

function UserContacts.ChatStuff:ShowChannelUsers(channel, bshow)
  if not this.channelfilter then this.channelfilter = {} end
  if bshow then
    this.channelfilter[channel] = true
  else
    this.channelfilter[channel] = nil
  end
  local empty = true
  for k,v in pairs(this.channelfilter) do empty = false break end
  if empty then 
    this.channelfilter = nil
  end
  this:Update()
  this.MembersList:OnScroll(1)
end

local function ChannelSort(a,b)
  if a.channel_index == b.channel_index then
    return a.name < b.name
  end
  return a.channel_index < b.channel_index
end

local function NameSort(a,b)
  return string.lower(a.name) < string.lower(b.name)
end

function UserContacts.ChatStuff:Update()
  if not LobbyChat.tblUsers then return end
  CreateChannelSortTable()
  local tbl_temp = {}
  for channel,users in pairs(LobbyChat.tblUsers) do
    if not this.channelfilter or this.channelfilter[channel] then
      for _,user in ipairs(users) do
        if not tbl_temp[user] then tbl_temp[user] = {} end
        tbl_temp[user][channel] = true
        tbl_temp[user].channel_index = channel_sort_table[channel]
      end
    end
  end
  
  local tbl_temp1 = {}
  for user,chnls in pairs(tbl_temp) do
    local usr = {name = user, channels = chnls}
    table.insert(tbl_temp1, usr)
  end
  
  if this.sortbychannel then
    table.sort(tbl_temp1, ChannelSort)
  else
    table.sort(tbl_temp1, NameSort)                       
  end
  
  this.MembersList:SetList(tbl_temp1, true)

  this.MembersList.PlayersCount:SetStr(TEXT{"online_players", #tbl_temp1})
end
