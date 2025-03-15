--
-- in-game chat canals
--
local sz = {600, 275}
--local chatlayer = 50
local chatlayer = 80001

Chat = uiwnd {
	keyboard = true,
	layer = chatlayer,
  size = {sz[1],sz[2]},
  anchors = { BOTTOMLEFT = { "TOPLEFT", "Actions", 0, -30 } },
  
  fake = uiwnd { size = {1,1} },
  
  Area = DefTextScrollArea {
    anchors = { 
      TOPLEFT = { 5, 5 },
      BOTTOMRIGHT = { "BOTTOMRIGHT", -5,-35 },
    },

    Text = uitext { 
      font = "Verdana,11", 
      halign = "LEFT", 
      valign = "BOTTOM", 
      shadow_ofs = {1,1},
    },
    
    --Back = uiimg { 
      --hidden = true,
      --layer = chatlayer-1,
      --color = {0,0,0,100},
      --anchors = { 
        --TOPLEFT = { -5, -5 },
        --BOTTOMRIGHT = { "BOTTOMRIGHT", 0,5 },
      --},
    --},
    
    OnMouseWheel = function (this, delta, mods)
      if mods.shift then
        if delta < 0 then
          Chat.Scrollbar:SetPos(0)
        else  
          Chat.Scrollbar:SetPos(9999999999)
        end  
      elseif mods.alt then
        local pagerows = Chat.Area.Text:GetSize().y / Chat.Area.Text:GetLineHeight()
        if delta < 0 then
          Chat.Scrollbar:SetPos(Chat.Scrollbar:GetPos() - ((pagerows - 1) * Chat.Area.Text:GetLineHeight()))
        else  
          Chat.Scrollbar:SetPos(Chat.Scrollbar:GetPos() + ((pagerows - 1) * Chat.Area.Text:GetLineHeight()))
        end  
      else
        Chat.Scrollbar:SetPos(Chat.Scrollbar:GetPos() + delta * Chat.Area.Text:GetLineHeight())
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
      Chat.Area:OnScroll(argPos)
    end,
  },

  Target = uiwnd {
    hidden = true,
    size = {300,30},
    anchors = { TOPLEFT = { "BOTTOMLEFT", 0, -30 } },
    
    Text = uitext {
      halign = "LEFT",
      font = "Arial,12",
      wordbrake = false,
      anchors = { TOPLEFT = { 2,0 }, BOTTOMRIGHT = { 0,0 } },
    },
    
    Set = function(this, target)
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
    
    DoShow = function(this)
      Chat.Target:Show()
      Chat.EditFrame:Show()
      this:Show()
    end,

    DoHide = function(this)
      Chat.Target:Hide()
      Chat.EditFrame:Hide()
      this:Hide()
    end,
	},
	
	EditFrame = DefFrameImage {
    hidden = true,
    anchors = { 
      TOPLEFT = { "Target", -3, 0 }, 
      BOTTOMRIGHT = { "TextEdit", 3, 0 },
    },
	},
}

function Chat:OnLoad()
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("CHAT_PRIVATE_MESSAGE")
  this:RegisterEvent("BUDDYLIST_MESSAGE")
  this:RegisterEvent("LINK_CLICKED")
  
  table.insert(GameUI.topWindows.any, this)
  this.Scrollbar.OnScroll = function()
    this.Area:OnScroll(argPos)
  end
end

function Chat:Reset()
  this.TextEdit:SetStr("")
  this.Area.Text:SetStr("")
  this.TextEdit:SetFocus()
  this.Area:AdjustScrollbar(this.Scrollbar)
  this.TextEdit:DoHide()
  --this.Area.Back:Hide()
  this.Scrollbar:Hide()
end

function Chat:OnEvent(event)
  if event == "MAP_LOADED" then
    this:Reset()
  end
  
  if Selection:IsHidden() then return end

  if event == "CHAT_PRIVATE_MESSAGE" then 
    this:AddPrivateMsgLine("from", argPlayer, argText)
  end
  
  if event == "BUDDYLIST_MESSAGE" then 
    this:AddPrivateMsgLine("from", argWSPlayer or argPlayer, argMsg)
  end
  
  if event == "LINK_CLICKED" then
    if argID == "To" or argID == "From" then return end

    this.Target:Set(argID)

	  if this.TextEdit:IsHidden() then
		  this.TextEdit:DoShow()
		  this.TextEdit:SetStr("")
		  this.TextEdit:SetFocus()
  		this:CancelAutohideText()
	  end

	  this.writeplayer = argID
	  this.PrivateReply = 1
  end  
end

function Chat:AddLine(line)
  if not line then return end
  
	local s = this.Area.Text:GetStr()
	if s then
		this.Area.Text:SetStr(s .. "<nl>" .. (line or ""))
	else	                                
		this.Area.Text:SetStr(line)
	end	
	this.Area:AdjustScrollbar(this.Scrollbar)
  this:CancelAutohideText()
	this:StartAutohideText()
end 

function Chat:AddPrivateMsgLine(chn, usr, msg1)
  if not msg1 then return end
  
  if TEXT_CHANNELS[chn] then chn = TEXT_CHANNELS[chn] end

  local rgb = UserContacts.ChatStuff.ChannelsSetup:GetChannelColor(chn)
  local msg_color = "<color="..rgb[1]..","..rgb[2]..","..rgb[3]..">"
  local line
  if usr then
    line = msg_color..
	         "<link=chat_channel:"..chn..">["..chn.."]</>"..
	         "<link=chat_player:"..usr..">["..usr.."]:</>"..
	         " "..tostring(msg1)..
	         "</>"
  end       
	
	local s = this.Area.Text:GetStr()	
	if s then
		this.Area.Text:SetStr(s .. "<nl>" .. (line or ""))
	else	                                
		this.Area.Text:SetStr(line)
	end		
	
	this.Area:AdjustScrollbar(this.Scrollbar)
  this:CancelAutohideText()
	this:StartAutohideText()  
end 


function Chat:OnKeyEnter(mod)
	if not this.TextEdit:IsHidden() then
		local line = this.TextEdit:GetStr()

		local history = this.TextEdit.history
		local last = history[#history]
		if not (line == last) then
			table.insert(history, line)
		end
	  
	  if line then
	    if not this.PrivateReply or this.PrivateReply == 0 then
        local shift = false
        if mod and mod.shift then shift = mod.shift end
	      game.SendMessage(line, shift)
	    else
	      net.SendPlayerMessage(this.writeplayer, line)
	      this:AddPrivateMsgLine("to", this.writeplayer, line)
        LobbyChat:AddLine("to", this.writeplayer, line)
	    end
	  end
	  this.PrivateReply = 0
	  
		this.TextEdit:DoHide()
		--this.Area.Back:Hide()
		this.Scrollbar:Hide()
    this:CancelAutohideText()
	  this:StartAutohideText()
    return
  end
  this.Target:Set(TEXT("net_chattoally"))
	this.TextEdit:DoShow()
	this.TextEdit:SetStr("")
	this.TextEdit:SetFocus()
	--this.Area.Back:Show()
	--this.Scrollbar:Show()
	this:CancelAutohideText()
end

function Chat:StartAutohideText()
	Transitions:Cancel(this.fake)
	this.fake:Show()
	Transitions:Fade(this.fake, 
	                 nil, 
	                 function () 
	                   Transitions:Fade(Chat.Area.Text) 
	                 end, 
	                 10.0)
end

function Chat:CancelAutohideText()
	Transitions:Cancel(this.fake)
	this.Area.Text:Show()
end

function Chat:OnKeyEscape()
	this.TextEdit:DoHide()
  --this.Area.Back:Hide()
  this.Scrollbar:Hide()
  this:StartAutohideText()
end

--
-- Chat.TextEdit
--

function Chat.TextEdit:OnLoad()
	this.history = {}
	this.history.index = nil
end

function Chat.TextEdit:OnShow()
  if #this.history > 0 then 
    this.history.index = #this.history 
  end
end

function Chat.TextEdit:OnKeyUp(key, mod)
  local str = this:GetStr()
  if str then
    local i,j,preff = string.find(str, "(/.)%s") 
    if i and i == 1 and preff == "/w" then
      local str1 = str
      local start,stop,mod,player = string.find(str1, "(/.)%s*(.+)%s")
      if not start then return end

      Chat.writeplayer = player
      Chat.PrivateReply = 1
      Chat.Target:Set(player)
      this:SetStr("")
    end
  end
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

function Chat.TextEdit:OnKeyDown(key, mod)
  if mod.key == "Return" then
    this:GetParent():OnKeyEnter(mod)
  end
end

function Chat.TextEdit:OnKeyEscape()
  this:GetParent():OnKeyEscape()
end
