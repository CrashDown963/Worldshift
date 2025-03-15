--
-- Lobby Chat
--

local only_once
local sz = {600, 270}
local chatlayer = 30

TEXT_ACC_MARK = {
  "reserved",
  "BSS",
}

TEXT_UNASSIGNEDKEY = "text_unassigned"
TEXT_UNASSIGNED = TEXT{TEXT_UNASSIGNEDKEY}
TEXT_CHANNELS = { 
  ["game"] = TEXT{"game"},
  ["general"] = TEXT{"chat_channel_loc_short"},
  ["default"] = TEXT{"chat_channel_int_short"},
  ["from"] = TEXT{"from"}, 
  ["to"] = TEXT{"to"}, 
}
CHAT_VIEWS = 10

DefViewBtn = DefButton {
  virtual = true,
  size = {31,31},
  font = "Tahoma,9b",
  checked = 0,
  
  NormalText = uitext { anchors = { CENTER = { -1,-1 } } },
  HighText = uitext { anchors = { CENTER = { -1,-1 } } },
  PushText = uitext { anchors = { CENTER = { -1,-1 } } },
  
  NormalImage = uiimg { texture = "data/textures/ui/chat_button.dds"},
  HighImage = uiimg { texture = "data/textures/ui/chat_button.dds"},
  PushImage = uiimg { texture = "data/textures/ui/chat_button.dds"},
  
  nn_crd = {0, 0, 31, 31},
  nh_crd = {0, 31, 31, 31+31},
  np_crd = {0, 31, 31, 31+31},
  nt_clr = {140,145,120},

  sn_crd = {0, 62, 31, 62+31},
  sh_crd = {0, 62, 31, 62+31},
  sp_crd = {0, 62, 31, 62+31},
  st_clr = {234,223,178},

  OnShow = function(this) this:updatetextures() end,

  updatetextures = function(this)
    if this.checked == 0 then
      this.NormalImage:SetTexture(nil, this.nn_crd)
      this.HighImage:SetTexture(nil, this.nh_crd)
      this.PushImage:SetTexture(nil, this.np_crd)
      
      this.NormalText:SetColor(this.nt_clr)
      this.HighText:SetColor(this.nt_clr)
      this.PushText:SetColor(this.nt_clr)
    else
      this.NormalImage:SetTexture(nil, this.sn_crd)
      this.HighImage:SetTexture(nil, this.sh_crd)
      this.PushImage:SetTexture(nil, this.sp_crd)
      
      this.NormalText:SetColor(this.st_clr)
      this.HighText:SetColor(this.st_clr)
      this.PushText:SetColor(this.st_clr)
    end  
  end,

  OnLoad = function(this)
    this:SetStr(this.idx)
  end,
  
  OnClick = function(this)
    LobbyChat:OnViewLClick(this)  
  end,

  OnMouseEnter = function(this) NTTooltip:DoShow("chat_views_tip", this, "TOPLEFT", "BOTTOMLEFT", {0,-10}) end,
  OnMouseLeave = function(this) NTTooltip:Hide() end,
}

LobbyChat = uiwnd {
	keyboard = true,
	layer = chatlayer,
	anchors = { BOTTOMLEFT = { 10, -10 } },
  size = {sz[1],sz[2]},
  
  Cracked = uiimg {
    hidden = true,
    size = {1024,1024},
    texture = "data/textures/ui/cracked.dds",
    coords = {0,0,1024,1024},
    anchors = { CENTER = { "DESKTOP", 0,0 } },

    show = function()
      if LobbyChat.Cracked.callID then
        Transitions:CancelOnce(LobbyChat.Cracked.callID)
        LobbyChat.Cracked.callID = nil
      end
      LobbyChat.Cracked.callID = Transitions:CallOnce(LobbyChat.Cracked.hide, 5)
      LobbyChat.Cracked:Show()
    end,

    hide = function() 
      Transitions:Fade(LobbyChat.Cracked)
    end,
  },
    
  Area = DefTextScrollArea {
    Text = uitext { shadow_ofs = {1,1}, font = "Verdana,11", halign = "LEFT", valign = "BOTTOM", },
    anchors = { 
      TOPLEFT = { 5, 2 },
      BOTTOMRIGHT = { "BOTTOMRIGHT", -5,-35 },
    },
    --DefFrameImage {
      --anchors = { 
        --TOPLEFT = { -5, -5 },
        --BOTTOMRIGHT = { "BOTTOMRIGHT", 5,5 },
      --},
    --},
    OnMouseWheel = function (this, delta, mods)
      if mods.shift then
        if delta < 0 then
          LobbyChat.Scrollbar:SetPos(0)
        else  
          LobbyChat.Scrollbar:SetPos(9999999999)
        end  
      elseif mods.alt then
        local pagerows = LobbyChat.Area.Text:GetSize().y / LobbyChat.Area.Text:GetLineHeight()
        if delta < 0 then
          LobbyChat.Scrollbar:SetPos(LobbyChat.Scrollbar:GetPos() - ((pagerows - 1) * LobbyChat.Area.Text:GetLineHeight()))
        else  
          LobbyChat.Scrollbar:SetPos(LobbyChat.Scrollbar:GetPos() + ((pagerows - 1) * LobbyChat.Area.Text:GetLineHeight()))
        end  
      else
        LobbyChat.Scrollbar:SetPos(LobbyChat.Scrollbar:GetPos() + delta * LobbyChat.Area.Text:GetLineHeight())
      end  
    end,
  },
  
  Scrollbar = DefVertScrollbar {
    hidden = true,
    anchors = { 
      TOPRIGHT = { -5, 5 },
      BOTTOMRIGHT = { -5, -5 },
    },
    OnScroll = function(this)
      LobbyChat.Area:OnScroll(argPos)
    end,
  },

  Target = uiwnd {
    hidden = true,
    size = {300,30},
    anchors = { BOTTOMLEFT = { "BOTTOMLEFT", 0, -2 } },
    
    Text = uitext {
      halign = "LEFT",
      font = "Arial,12",
      wordbrake = false,
      anchors = { TOPLEFT = { 2,0 }, BOTTOMRIGHT = { 0,0 } },
    },
    
    OnShow = function(this)
      local chn = this:GetParent():GetWriteTarget()
      this:SetTarget(chn)
    end,
    
    SetTarget = function(this, target)
      this.Text:SetStr('['..target..']: ')
      local w = this.Text:GetStrWidth()
      local sz = this:GetSize()
      this:SetSize{w, sz.y}
    end,
  },

  TextEdit = uiedit {
    hidden = true,
    keyboard = true,
    maxchars = 255,
	  font = "Verdana,11",
	  anchors = { 
	    TOPLEFT = { "TOPRIGHT", "Target", 3, -2 }, 
	    BOTTOMRIGHT = { -3, 0 },
	  },
	  
	  OnKeyDown = function(this, key, mod)
	    if this:IsHidden() then return end
	    this.keypressed = mod.key
	  end,
	  
	  OnKeyUp = function(this, key, mod)
	    if this.keypressed ~= mod.key then return end
	    this.keypressed = nil
	    if this.skipnextkeyup then this.skipnextkeyup = nil return end
	    
	    this:ScrollHistory(key)
	    
	    local str = this:GetStr() 
	    if not str then
	      if key == "Return" then
	        LobbyChat:ToggleWriteMode()
	      end
	      return 
	    end
	    local i,j,preff = string.find(str, "(/.)%s") 
	    if not i or i > 1 then 
	      if key == "Return" then
	        LobbyChat:OnChatEnter()
	      end
	      return
	    end
	    if preff == "/w" then
	      local str1 = str
	      local start,stop,mod,player = string.find(str1, "(/.)%s*(.+)%s+")
	      if not start then 
	        if key == "Return" then
	          LobbyChat:OnChatEnter()
	        end
	        return 
	      end
        local sb,se = string.find(player, "%s+")
        if sb then player = string.sub(player, 1, sb-1) end
	      LobbyChat:SetWritePerson(player)
	      this:SetStr("")
	    elseif preff == "/i" then
	      local str1 = str
	      local line = str
	      if key == "Return" then str1 = str1 ..' ' end
	      local start,stop,mod,player = string.find(str1, "(/.)%s*(.+)%s") 
	      if not start then 
	        if key == "Return" then
	          LobbyChat:OnChatEnter()
	        end
	        return 
	      end

	      net.SendGameInvitation(player)
	      this:SetStr("")
	      LobbyChat:AddLine(nil, nil, TEXT{"invitation_sent", player})
	      
        local last = this.history[#this.history]
        if not (line == last) then
	        table.insert(this.history, line)
        end
	    elseif preff == "/g" then
        LobbyChat:SetWriteChannel("game")
        this:SetStr(string.sub(str, j+1))
	    elseif preff == "/t" then
	      if LobbyChat.writeplayer then
	        LobbyChat:SetWritePerson(LobbyChat.writeplayer)
	        this:SetStr(string.sub(str, j+1))
	      end
	    elseif preff == "/r" then
	      if LobbyChat.lastwisper then
	        LobbyChat:SetWritePerson(LobbyChat.lastwisper)
	        this:SetStr(string.sub(str, j+1))
	      end
	    elseif preff == "/l" then
	      LobbyChat:SetWriteChannel("general")
	      this:SetStr(string.sub(str, j+1))
	    elseif preff == "/d" then
	      LobbyChat:SetWriteChannel("default")
	      this:SetStr(string.sub(str, j+1))
	    elseif preff == "/1" then
	      local chn = LobbyChat:GetUserChannel(1)
	      if chn then 
	        LobbyChat:SetWriteChannel(chn) 
	        this:SetStr(string.sub(str, j+1))
	      end  
	    elseif preff == "/2" then
	      local chn = LobbyChat:GetUserChannel(2)
	      if chn then 
	        LobbyChat:SetWriteChannel(chn) 
	        this:SetStr(string.sub(str, j+1))
	      end  
	    elseif preff == "/3" then
	      local chn = LobbyChat:GetUserChannel(3)
	      if chn then 
	        LobbyChat:SetWriteChannel(chn) 
	        this:SetStr(string.sub(str, j+1))
	      end  
	    elseif preff == "/4" then
	      local chn = LobbyChat:GetUserChannel(4)
	      if chn then 
	        LobbyChat:SetWriteChannel(chn) 
	        this:SetStr(string.sub(str, j+1))
	      end  
	    elseif preff == "/5" then
	      local chn = LobbyChat:GetUserChannel(5)
	      if chn then 
	        LobbyChat:SetWriteChannel(chn) 
	        this:SetStr(string.sub(str, j+1))
	      end  
	    elseif preff == "/6" then
	      local chn = LobbyChat:GetUserChannel(6)
	      if chn then 
	        LobbyChat:SetWriteChannel(chn) 
	        this:SetStr(string.sub(str, j+1))
	      end  
	    end
	    if key == "Return" then
	      LobbyChat:OnChatEnter()
	    end  
	  end,
	},
	
	EditFrame = DefFrameImage {
    hidden = true,
    layer = "LOW",
    anchors = { 
      TOPLEFT = { "Target", -3, 0 }, 
      BOTTOMRIGHT = { "TextEdit", 3, 0 },
    },
	},
	
  Buttons = uiwnd {
    size = {sz[1],30},
    anchors = { BOTTOMLEFT = { "BOTTOMLEFT", 0, 0 } },
    
    View_1 = DefViewBtn {
      size = {30,30},
      idx = 1,
      anchors = { BOTTOMLEFT = { "BOTTOMLEFT", 0, 0 } },
    },
    View_2 = DefViewBtn {
      size = {30,30},
      idx = 2,
      anchors = { LEFT = { "RIGHT", "View_1", 0, 0 } },
    },
    View_3 = DefViewBtn {
      size = {30,30},
      idx = 3,
      anchors = { LEFT = { "RIGHT", "View_2", 0, 0 } },
    },
    View_4 = DefViewBtn {
      size = {30,30},
      idx = 4,
      anchors = { LEFT = { "RIGHT", "View_3", 0, 0 } },
    },
    View_5 = DefViewBtn {
      size = {30,30},
      idx = 5,
      anchors = { LEFT = { "RIGHT", "View_4", 0, 0 } },
    },
    View_6 = DefViewBtn {
      size = {30,30},
      idx = 6,
      anchors = { LEFT = { "RIGHT", "View_5", 0, 0 } },
    },
    View_7 = DefViewBtn {
      size = {30,30},
      idx = 7,
      anchors = { LEFT = { "RIGHT", "View_6", 0, 0 } },
    },

    End = DefButton {
      size = {30,30},
      
      NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,124,30,30} },
      HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,124,30,30} },
      PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,124,30,30} },

      anchors = { BOTTOMRIGHT = { "BOTTOMRIGHT", 0, 0 } },
      OnClick = function(this)
        LobbyChat.Scrollbar:SetPos(9999999999)
      end,
    },
    
    Home = DefButton {
      size = {30,30},
      
      NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,93,30,30} },
      HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,93,30,30} },
      PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,93,30,30} },

      anchors = { RIGHT = { "LEFT", "End", 0, 0 } },
      OnClick = function(this)
        LobbyChat.Scrollbar:SetPos(0)
      end,
    },

    PgDn = DefButton {
      size = {30,30},
      
      NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,62,30,30} },
      HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,62,30,30} },
      PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,62,30,30} },

      anchors = { RIGHT = { "LEFT", "Home", 0, 0 } },
      OnClick = function(this)
        local pagerows = LobbyChat.Area.Text:GetSize().y / LobbyChat.Area.Text:GetLineHeight()
        LobbyChat.Scrollbar:SetPos(LobbyChat.Scrollbar:GetPos() + ((pagerows - 1) * LobbyChat.Area.Text:GetLineHeight()))
      end,
    },

    PgUp = DefButton {
      size = {30,30},
      
      NormalImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {0,31,30,30} },
      HighImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {31,31,30,30} },
      PushImage = uiimg { texture = "data/textures/ui/chat_icons.dds", coords = {62,31,30,30} },

      anchors = { RIGHT = { "LEFT", "PgDn", 0, 0 } },
      OnClick = function(this)
        local pagerows = LobbyChat.Area.Text:GetSize().y / LobbyChat.Area.Text:GetLineHeight()
        LobbyChat.Scrollbar:SetPos(LobbyChat.Scrollbar:GetPos() - ((pagerows - 1) * LobbyChat.Area.Text:GetLineHeight()))
      end,
    },

	},
}

function LobbyChat:GetUserChannel(idx)
  local data = game.LoadUserPrefs("LobbyUserChannels")
  if not data then return end
  if data["userch_"..idx] and data["userch_"..idx] ~= TEXT_UNASSIGNEDKEY then 
    return data["userch_"..idx] 
  end
end

function LobbyChat:GetWriteTarget()
  if this.writemode == 'channel' then
    if not this.writechannel then
      return TEXT_CHANNELS["default"]
    end
    return this.writechannel
  elseif this.writemode == 'person' then
    return this.writeplayer
  end
end

function LobbyChat:SetWritePerson(name)
  this.writemode = 'person'
  this.writeplayer = name
  if not this.Target:IsHidden() then
    this.Target:SetTarget(this:GetWriteTarget())
  end
end

function LobbyChat:SetWriteChannel(key)
  this.writemode = 'channel'
  this.writechannel = TEXT_CHANNELS[key]
  if not this.writechannel then this.writechannel = key end
  this.writechannelkey = key
  if not this.Target:IsHidden() then
    this.Target:SetTarget(this:GetWriteTarget())
  end
end

function LobbyChat:ToggleWriteMode()
  if this.TextEdit:IsHidden() then
    this.Buttons:Hide()
    this.TextEdit:Show()
    this.Target:Show()
    this.EditFrame:Show()
    this.TextEdit:SetFocus()
  else
    this.TextEdit:Hide()  
    this.Target:Hide()
    this.EditFrame:Hide()
    this.Buttons:Show()
    this.TextEdit:RemoveFocus()
  end
end

function LobbyChat:OnKeyEnter()
  if not ShortcutAssign:IsHidden() then return end
  --if this.TextEdit:IsHidden() then
    this:ToggleWriteMode()
  --end
end

function LobbyChat:OnChatEnter()
  local line = this.TextEdit:GetStr()
  if line and string.find(string.lower(line), "crack") then this.Cracked.show() game.PlaySnd("data/sounds/ui/cracked.wav") end
  local history = this.TextEdit.history
  local last = history[#history]
  if not (line == last) then
	  table.insert(history, line)
  end
  
  if line then
    if this.writemode == 'person' then
      if not net.BuddyList_IsBuddy(this.writeplayer) then
        net.IsPlayerValid(this.writeplayer)
      end
      
      net.SendPlayerMessage(this.writeplayer, line)
      this:AddLine("to", this.writeplayer, line)
    elseif this.writemode == 'channel' then
      if this.writechannel == TEXT_CHANNELS["game"] then
        net.GLSendMessage(line)
      else  
        if this.writechannelkey == 'general' then
          local tbl = game.LoadUserPrefs("chat_def_lang")
          if tbl then
            net.SendMessage(tbl.lang, line)
          end
        else
          net.SendMessage(this.writechannelkey, line)
        end
      end  
    end
  end
  this.TextEdit:SetStr()
  this:ToggleWriteMode()
end

function LobbyChat:OnKeyEscape()
  if not this.TextEdit:IsHidden() then
    this:ToggleWriteMode()
  end  
end

function LobbyChat:OnKeyUp(key, mod)
  if this.skipnextkeyup then this.skipnextkeyup = nil return end
  
  for k,v in pairs(UserContacts.ChatStuff.ChannelsSetup) do
    if type(v) == "table" and mod.key == v.shortcutkey then
      local ch_name = UserContacts.ChatStuff.ChannelsSetup.userchannels[v.value]
      if not ch_name then ch_name = v.value end
      if ch_name == "tells" then
        if this.writeplayer then
	        this:SetWritePerson(this.writeplayer)
	        this:ToggleWriteMode()
	      end
	      return  
	    end    
      this:SetWriteChannel(ch_name)
      this:ToggleWriteMode()
      return
    end
  end
  
  if mod.key == '#191' and this.TextEdit:IsHidden() then
    this.TextEdit:SetStr("/")
    this:ToggleWriteMode()
  end
  if mod.key == '1' then this.Buttons.View_1:OnClick() end
  if mod.key == '2' then this.Buttons.View_2:OnClick() end
  if mod.key == '3' then this.Buttons.View_3:OnClick() end
  if mod.key == '4' then this.Buttons.View_4:OnClick() end
  if mod.key == '5' then this.Buttons.View_5:OnClick() end
  if mod.key == '6' then this.Buttons.View_6:OnClick() end
  if mod.key == '7' then this.Buttons.View_7:OnClick() end
end

function LobbyChat.TextEdit:OnLoad()
	this.history = {}
	this.history.index = nil
end

function LobbyChat.TextEdit:OnShow()
  if #this.history > 0 then 
    this.history.index = #this.history 
  end
	this:SetFocus()
end

function LobbyChat.TextEdit:OnClick()
	this:SetFocus()
end

function LobbyChat.TextEdit:ScrollHistory(key)
	local history = this.history
	if not history.index then return end
	if key == "Up" then      
		local line = history[history.index]
		this:SetStr(line)
		history.index = history.index - 1
		if history.index == 0 then
			history.index = #history
		end	
	elseif key == "Down" then
		local line = history[history.index]
		this:SetStr(line)
		history.index = history.index + 1
		if history.index > #history then
			history.index = 1
		end	
	end
end               

function LobbyChat.TextEdit:OnKeyEscape()
  this:GetParent():OnKeyEscape()
end

function ChatGetLinkInfo(type, id)
  local color = colors.blue
  local rollover = colors.red
  local cursor = "hand"
  
  if type == "chat_channel" then
    color, rollover = UserContacts.ChatStuff.ChannelsSetup:GetChannelColor(id)
  end
  
  if type == "chat_player" then
    -- chechk id if friend or not !
    color = {240,240,240}
    rollover = {255,255,255}
  end

  if type == "chat_mark" then
    color = {240,240,0}
    rollover = {255,255,0}
  end

  return color, rollover, cursor
end

function LobbyChat:AddLine(chn, usr, msg, no_history)
  if not msg then return end
  if chn and (not usr or not string.find(usr, "%a")) then return end
  
  local tbl = game.LoadUserPrefs("chat_def_lang")
  if tbl and chn == tbl.lang then
    chn = 'general'
  end

  if game.IsInMap() then
    if not chn or chn == "default" or chn == "general" then return end
  end
 
  if not no_history then
    if not this.history then this.history = {} end
    table.insert(this.history, {channel = chn, user = usr, message = msg})
    if #this.history > 100 then 
      table.remove(this.history, 1)
    end
  end  
  
  local showline = true
  if this.filter and chn and usr and not this.filter[chn] then
    showline = false
  end
  if not showline then return end

  if TEXT_CHANNELS[chn] then chn = TEXT_CHANNELS[chn] end
  
  local tclr = ChatGetLinkInfo("chat_player")
  local lclr = "<color="..tclr[1]..","..tclr[2]..","..tclr[3]..">"
  
  local acc_mark
  local domark = string.byte(string.sub(msg, 1, 1))
  if usr and  domark and domark >= 1 and domark <= 9 then
    if domark <= #TEXT_ACC_MARK then
      acc_mark = "<link=chat_mark:"..usr..">"..TEXT_ACC_MARK[domark].."</>"
    end
    msg = string.sub(msg, 2)
  end

  local rgb = UserContacts.ChatStuff.ChannelsSetup:GetChannelColor(chn)
  local msg_color = "<color="..rgb[1]..","..rgb[2]..","..rgb[3]..">"
  local line
  if usr then
    if acc_mark then
      line = msg_color..
	           "<link=chat_channel:"..chn..">["..chn.."]</>"..
	           "<link=chat_player:"..usr..">["..usr.."<</>"..
	           acc_mark..
	           "<link=chat_player:"..usr..">>]</>"..
	           " "..msg..
	           "</>"
	  else       
      line = msg_color..
	           "<link=chat_channel:"..chn..">["..chn.."]</>"..
	           "<link=chat_player:"..usr..">["..usr.."]</>"..
	           " "..msg..
	           "</>"
	  end       
	elseif chn then
    line = msg_color..
	         "<link=chat_channel:"..chn..">["..chn.."]</>"..
	         " "..msg..
	         "</>"
  else
    line = "<color=230,230,0>"..msg.."</>"
	end             
	
  local s = this.Area.Text:GetStr()

  if s then
	  this.Area.Text:AddStr("<nl>" .. (line or ""))
  else	                                
	  this.Area.Text:SetStr(line)
  end	

  local newpos = this.Area.pos
  local min, max, step = this.Scrollbar:GetMinMaxRange()
  if this.Area.pos == max or max < min then
    newpos = nil
  end
	
  this.Area:AdjustScrollbar(this.Scrollbar, newpos)
end 

function LobbyChat:ClearChat()
	this.Area.Text:SetStr("")               
	this.Area:AdjustScrollbar(this.Scrollbar)
end

function LobbyChat:GetUser(user, channel)
  if not user or not channel then return end
	if not this.tblUsers or not this.tblUsers[channel] then return end
  for i,v in ipairs(this.tblUsers[channel]) do
  	if v == user then return i end
  end
end

function LobbyChat:AddUser(user, channel)
  if not user or not channel then return end
  if not this.tblUsers then this.tblUsers = {} end
  if not this.tblUsers[channel] then this.tblUsers[channel] = {} end
  if this:GetUser(user, channel) then return end
  table.insert(this.tblUsers[channel], user)
  UserContacts.ChatStuff:Update()
end 

function LobbyChat:DelUser(user, channel)
  if not user or not channel then return end
	if not this.tblUsers or not this.tblUsers[channel] then return end
  local i = this:GetUser(user, channel) if not i then return end
  table.remove(this.tblUsers[channel], i)
  UserContacts.ChatStuff:Update()
end

function LobbyChat:ClearUsers()
	this.tblUsers = {}
  UserContacts.ChatStuff:Update()
end

function LobbyChat:OnLoad()  
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("CHAT_MESSAGE") 
  this:RegisterEvent("CHAT_PRIVATE_MESSAGE")
  
  this:RegisterEvent("GLCHAT_MESSAGE") 
  this:RegisterEvent("GLCHAT_PLAYERJOIN") 
  this:RegisterEvent("GLCHAT_PLAYERLEFT") 
  --GLCHAT_PLAYERJOIN,argId,argPlayer,
  --GLCHAT_PLAYERLEFT,argId,argPlayer,
  --GLCHAT_MESSAGE,argId,argText,argPlayer 
  
  this:RegisterEvent("LINK_CLICKED")
  
  this:RegisterEvent("CHAT_PLAYERLEFT")
  this:RegisterEvent("CHAT_PLAYERJOINED")
  this:RegisterEvent("CHAT_PLAYERCHANGEDNICK")
  
  --this:RegisterEvent("LOBBY_PARTY_MESSAGE")
  --this:RegisterEvent("LOBBY_PARTY_INVITATION_ACCEPTED")
  this:RegisterEvent("CHAT_PLAYERVALID")
end

function LobbyChat:OnEvent(event)
  if event == "CHAT_PLAYERVALID" then
    if not argValid then
      this:AddLine(nil, nil, TEXT{"no_such_user", argPlayer})
    end
  end

  if event == "MAP_LOADED" then
    this:Hide()
  end
  if event == "GLCHAT_MESSAGE" then
    this:AddLine("game", argPlayer, argText)
  end
  if event == "GLCHAT_PLAYERLEFT" then
    if argKicked and argPlayer == net.Lobby_GetPlayerName() then
      this:AddLine("game", nil, TEXT("kicked"))
    else
      this:AddLine("game", nil, TEXT{"text_user_left_game", argPlayer})
    end
  end
  if event == "GLCHAT_PLAYERJOIN" then
    this:AddLine("game", nil, TEXT{"text_user_join_game", argPlayer})
  end
  if event == "LINK_CLICKED" then
    if argType == "chat_channel" and argID ~= TEXT_CHANNELS["from"] and argID ~= TEXT_CHANNELS["to"] then
      --if argID == TEXT_CHANNELS["default"] then ergID = nil end
      local key
      for k,v in pairs(TEXT_CHANNELS) do
        if v == argID then key = k break end
      end
      if not key then key = argID end
      this:SetWriteChannel(key)
      if this.TextEdit:IsHidden() then this:ToggleWriteMode() end
    end
    
    if argType == "chat_player" and string.len(argID) > 1 and argID ~= net.Lobby_GetPlayerName() then
      if argLeftMB then
        this:SetWritePerson(argID)
        if this.TextEdit:IsHidden() then this:ToggleWriteMode() end
      else
        --UserMenu:SetAnchor("BOTTOM", this, "BOTTOM", {0,-20})
        UserMenu:SetAnchor("BOTTOMLEFT", DESKTOP, "TOPLEFT", {argRCLeft,argRCTop})
        UserMenu:SetUser(argID)
      end
    end
  end

  if event == "CHAT_MESSAGE" then 
    if not argChannel then argChannel = "default" end
    this:AddLine(argChannel, argPlayer, argText)
  end

  if event == "CHAT_PRIVATE_MESSAGE" then
    this.lastwisper = argPlayer
    this:AddLine("from", argPlayer, argText)
  end

  if event == "CHAT_PLAYERJOINED" then 
    this:AddUser(argPlayer, argChannel)
  	if argNotify == true then 
  	  this:AddLine(TEXT{"text_user_join_game", argPlayer})
  	end  
  end
  if event == "CHAT_PLAYERLEFT" then 
    this:DelUser(argPlayer, argChannel)
  	this:AddLine(TEXT{"text_user_left_game", argPlayer})
  end
  if event == "CHAT_PLAYERCHANGEDNICK" then           
  	this:DelUser(argOldPlayer, argChannel)
  	this:AddUser(argNewPlayer, argChannel)
  	this:AddLine(TEXT{"text_user_rename", argOldPlayer, argNewPlayer})
  end
end

function LobbyChat:OnShow()
  if not this.history then this.history = {} end
  
  local tbl = game.LoadUserPrefs("chat_def_lang")
  if not tbl then
    tbl = { ["lang"] = string.upper(game.GetLang()) }
    game.SaveUserPrefs("chat_def_lang", tbl)
  end
  net.ChatEnterChannel(tbl.lang)
  --net.ChatEnterChannel("general")
  net.ChatEnterChannel("default")

  local userchannels = game.LoadUserPrefs("LobbyUserChannels")
  if userchannels then
    for i = 1,6 do
      if userchannels["userch_"..i] ~= TEXT_UNASSIGNEDKEY then
        net.ChatEnterChannel(userchannels["userch_"..i])
      end
    end
  end

  if not this.currview then this.Buttons.View_1:OnClick() end
  this:SetWriteChannel("default")
end

function LobbyChat:SetFilter(filter)
  this:ClearChat()
  
  if not only_once then
    if Login.openbeta then
      LobbyChat:AddLine(nil, nil, TEXT{"beta_welcome1"}, true)
      LobbyChat:AddLine(nil, nil, TEXT{"beta_welcome2"}, true)
      LobbyChat:AddLine(nil, nil, TEXT{"beta_welcome3"}, true)
    end
    only_once = true
  end  
  
  this.filter = filter
  for i,line in ipairs(this.history) do
    this:AddLine(line.channel, line.user, line.message, true)
  end
end

function LobbyChat:SetUserView(idx)
  local filter = {}
  local view = game.LoadUserPrefs("LobbyChatView_"..idx) if not view then return end
  if view.game > 0 then filter["game"] = true end
  if view.tells > 0 then filter["from"] = true filter["to"] = true end
  if view.general > 0 then filter["general"] = true end
  if view.default > 0 then filter["default"] = true end
  local userchannels = game.LoadUserPrefs("LobbyUserChannels")
  if userchannels then
    for i = 1,6 do
      if view["userch_"..i] > 0 and userchannels["userch_"..i] ~= TEXT_UNASSIGNEDKEY then
        filter[userchannels["userch_"..i]] = true
      end
    end
  end
  this:SetFilter(filter)
end

function LobbyChat:OnViewLClick(btn)
  if this.currview then
    this.currview.checked = 0
    this.currview:updatetextures()
  end
  this.currview = btn
  this.currview.checked = 1
  this.currview:updatetextures()
  
  this:SetUserView(btn.idx)  
end
