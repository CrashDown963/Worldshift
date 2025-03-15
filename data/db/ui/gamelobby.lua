--
-- TEMPLATES
--

local TEXT_USER_JOIN_GAME = "<i><color=180,180,180>Player '[#]' has joined the game.</></>"
local TEXT_USER_LEFT_GAME = "<i><color=180,180,180>Player '[#]' has left the game.</></>"
local TEXT_USER_RENAME = "<i><color=180,180,180>Player '[#]' has changed nick to: '[#]'</></>"
local sz = {400, 150}


PlayerSlot = uiwnd {
  virtual = true,
  hidden = true,
  size = { 300, 120 },
  
  Frame = DefFrameImage {
    size = { 300, 120 },
    anchors = { TOPLEFT = { "TOPLEFT" } },
    layer = -1,
  },

  Avatar = DefAvatarImage {
    size = { 100, 100 },
    anchors = { LEFT = { "LEFT", "Frame" , 6, 0 } },
  },
  
  LoadPerc = uitext {
    size = {100, 30},
    halign = "RIGHT",
    anchors = { BOTTOMRIGHT = { "BOTTOMRIGHT", "Frame" , -5, -5 } },
    hidden = true,
  },
  
  Name = uitext {
    size = { 200, 25 },
    halign = "LEFT",
    anchors = { TOPLEFT = { "TOPRIGHT", "Avatar", 10, 0 } },
    str = "Player name",
  },

  Color = uibtn {
    idx = 1,
    size = {100, 30},
    clr = uiimg { layer = -1, color = colors[1], },
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Name", 0, 10 } },
    OnClick = function(this) GameLobby:OnColorClick(this:GetParent()) end,
  },
  
  Kick = DefButton {
    hidden = true, 
    str = "kick",
    size = {50, 30},
    anchors = { TOPRIGHT = { "TOPRIGHT", "Frame" , -3, 3 } },
    OnClick = function(this) GameLobby:OnKickUser(this:GetParent()) end,
  },

  Team = DefButton {
    idx = 1,
    str = "1",
    size = {50, 30},
    anchors = { LEFT = { "RIGHT", "Color", 10, 0 } },
    OnClick = function(this) GameLobby:OnTeamClick(this:GetParent()) end,
  },

  Ready = uitext {
    hidden = true,
    size = {160, 25},
    str = "READY",
    font = "Agency FB,25",
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Color", 0, 10 } },
  },
}

--
-- GameLobby Screen
--
GameLobby = uiwnd {
  
  PlayerSlot_1 = PlayerSlot { playerIDX = 1, anchors = { TOPLEFT = { "TOPLEFT", 190, 40 } } },
  PlayerSlot_3 = PlayerSlot { playerIDX = 3, anchors = { TOP = { "BOTTOM", "PlayerSlot_1", 0, 10 } } },
  PlayerSlot_5 = PlayerSlot { playerIDX = 5, anchors = { TOP = { "BOTTOM", "PlayerSlot_3", 0, 10 } } },
  
  PlayerSlot_2 = PlayerSlot { playerIDX = 2, anchors = { LEFT = { "RIGHT", "PlayerSlot_1", 40, 0 } } },
  PlayerSlot_4 = PlayerSlot { playerIDX = 4, anchors = { TOP = { "BOTTOM", "PlayerSlot_2", 0, 10 } } },
  PlayerSlot_6 = PlayerSlot { playerIDX = 6, anchors = { TOP = { "BOTTOM", "PlayerSlot_4", 0, 10 } } },

  Chat = uiwnd {
		keyboard = true,
	  size = {sz[1],sz[2]},
		anchors = { BOTTOM = { -160, -25 } },
	  
	  Room = uitext {
		  size = {sz[1],20},
		  halign = "LEFT",
		  font = "Arial,12b",
			anchors = { BOTTOMLEFT = { "TOPLEFT" } },
			str = "Room Chat",
	  }, 
	  Roomback = uiimg {
	    anchors = { 
	      TOPLEFT = { "Room" },
	      BOTTOMRIGHT = { "Room" },
	    },
	    layer = "LOW",
	    color = {30,30,30,180},
	  },

	  Area = DefTextScrollArea {
	    anchors = { 
	      TOPLEFT = { 2, 3 },
	      BOTTOMRIGHT = { "BOTTOMLEFT", "Scrollbar" },
	    },
	    Back = uiimg { color = {30,30,30,180}, layer = "LOW" },
	    Text = uitext { font = "Arial,11b", halign = "LEFT", valign = "BOTTOM" },
	  },
	  
	  Scrollbar = DefVertScrollbar {
	    anchors = { 
	      TOPRIGHT = { -2, 3 },
	      BOTTOMRIGHT = { -2, -3 },
	    }
	  },
	  
	  Users = DefTextScrollArea {
	    anchors = { 
	      TOPLEFT = { "Scrollbar", "TOPRIGHT", 2, 0 },
	      BOTTOMRIGHT = { "Scrollbar", "BOTTOMRIGHT", 100 + 2, 0 },
	    },
	    Back = uiimg { color = {30,30,30,180}, layer = "LOW" },
	    Text = uitext { font = "Arial,11b", halign = "LEFT", valign = "TOP" },
	  },
	   
	  UsersScrollbar = DefVertScrollbar {
	    anchors = { 
	      TOPLEFT = { "Users", "TOPRIGHT", 0, 0 },
	      BOTTOMLEFT = { "Users", "BOTTOMRIGHT", 0, 0 },
	    }
	  },

	  TextEdit = uiedit {  
			size = {sz[1],20},
		  font = "Arial,12b",
		  uiimg { color = {30,30,30,180}, layer = "LOW" },
		  anchors = { TOPLEFT = { "BOTTOMLEFT", 0, 0 } },
		},
	},
	
  BackBtn = DefButton {
    size = {80,30},
    str = "BACK",
    anchors = { BOTTOMLEFT = { 20, -2 } },
  },

  StartBtn = DefButton {
    size = {80,30},
    str = "START",
    anchors = { BOTTOMRIGHT = { -20, -2 } },
    OnClick = function(this) net.GLStartGame() end
  },

  ReadyBtn = DefButton {
    size = {80,30},
    str = "READY",
    anchors = { RIGHT = { "StartBtn", "LEFT", -2, 0 } },
  },
  
  AddAIBtn = DefButton {
    size = {80,30},
    str = "ADD AI",
    anchors = { RIGHT = { "ReadyBtn", "LEFT", -2, 0 } },
    OnClick = function(this) net.GLAddAI() end
  },

  ChatBtn = DefButton {
    size = {120,25},
    str = "To Lobby Chat",
    anchors = { LEFT = { "Chat.TextEdit", "RIGHT", 40, 50 } },
    OnClick = function(this) 
      if GameLobby.Chat:IsHidden() then
        this:SetStr("To Lobby Chat")
        GameLobby.Chat:Show()
        LobbyChat:Hide()
      else
        this:SetStr("To Room Chat")
        LobbyChat:Show()
        GameLobby.Chat:Hide()
      end    
    end
  },
}  

--
function GameLobby.BackBtn:OnClick()
  net.ExitLobby()
end

function GameLobby.ReadyBtn:OnClick()
  local bReady = not GameLobby["PlayerSlot_" .. GameLobby.player].Ready:IsHidden()
  bReady = not bReady
  GameLobby:SetPlayerReady(GameLobby.player, bReady)
  net.GLSetPlayerReady(bReady)
end

function GameLobby:Reset()
  this:SetPlayer(nil)
  this:ShowStartButton(false)
  for i = 1, 6 do
    this:SetKickVisible(i)
    this:SetPlayerReady(i)
    this:SetPlayerName(i)
    this:SetPlayerAvatar(i)
    this:SetPlayerColor(i)
    this:SetPlayerTeam(i)
    this:SetPlayerVisible(i)
    this:SetLoadingPerc(i)
  end
end

--GL_SHOWSTARTBUTTON, argShow
function GameLobby:ShowStartButton(bshow)
  if bshow == true then
    this.StartBtn:Show()
  else
    this.StartBtn:Hide()
  end  
end

--GL_SETLOADINGPERC, argIdx, argPerc
function GameLobby:SetLoadingPerc(idx, perc)
  local slot = this["PlayerSlot_" .. idx]
  if perc == nil then
    slot.LoadPerc:Hide()
  else
    slot.LoadPerc:SetStr(perc .. "%")
    slot.LoadPerc:Show()
  end  
end

--GL_SETPLAYER, argIdx
function GameLobby:SetPlayer(idx)
  this.player = idx
  for i = 1,6 do
    local slot = this["PlayerSlot_" .. i]
    if idx == i then
      slot.controllable = true
    else  
      slot.controllable = nil
    end  
  end
end

--GL_PLAYERJOIN, argIdx
--GL_PLAYERLEAVE, argIdx
function GameLobby:SetPlayerVisible(idx, bshow)
  local slot = this["PlayerSlot_" .. idx]
  if bshow then
    slot:Show()
  else
    slot.Name:Hide()
    slot.Avatar:Hide()
    slot.Color:Hide()
    slot.Ready:Hide()
    slot:Hide()
  end    
end

--GL_SETPLAYERREADY, argIdx, argReady
function GameLobby:SetPlayerReady(idx, bready)
  local slot = GameLobby["PlayerSlot_" .. idx]
  if bready == true then
    slot.Ready:Show()
  else
    slot.Ready:Hide()
  end  
end

--GL_SETPLAYERNAME, argIdx, argName
function GameLobby:SetPlayerName(idx, name)
  local slot = this["PlayerSlot_" .. idx]
  if name == nil then
    slot.Name:Hide()
  else
    slot.Name:SetStr(name)
    slot.Name:Show()
  end
end

--GL_SETPLAYERAVATAR, argIdx, argAvatar
function GameLobby:SetPlayerAvatar(idx, avatar)
  local slot = this["PlayerSlot_" .. idx]
  if avatar == nil then
    slot.Avatar:Hide()
  else  
    slot.Avatar:SetTexture(avatar)
    slot.Avatar:Show()
  end
end

--GL_SETPLAYERCOLOR, argIdx, argColorIdx
function GameLobby:SetPlayerColor(idx, color)
  local slot = this["PlayerSlot_" .. idx]
  if color == nil then
    slot.Color:Hide()
  else  
    slot.Color.clr:SetColor(PlayerColors[color])
    slot.Color:Show()
  end
end

--GL_SETPLAYERTEAM, argIdx, argTeam
function GameLobby:SetPlayerTeam(idx, team)
  local slot = this["PlayerSlot_" .. idx]
  if team == nil then
    slot.Team:Hide()
  else  
    slot.Team:SetStr(team)
    slot.Team:Show()
  end
end

--GL_SHOWKICKBUTTON, argIdx, argShow
function GameLobby:SetKickVisible(idx, bvisible)
  local slot = this["PlayerSlot_" .. idx]
  if bvisible == true then
    slot.Kick:Show()
  else  
    slot.Kick:Hide()
  end
end

--GL_SHOWADDAIBUTTON, argShow
function GameLobby:ShowAddAIButton(bshow)
  if bshow == true then
    this.AddAIBtn:Show()
  else
    this.AddAIBtn:Hide()
  end  
end

--

function GameLobby:OnLoad()  

  this:RegisterEvent("GLCHAT_MESSAGE")
  this:RegisterEvent("GLCHAT_PLAYERLEFT")
  this:RegisterEvent("GLCHAT_PLAYERJOINED")
  this:RegisterEvent("GLCHAT_PLAYERCHANGEDNICK")
  this:RegisterEvent("GLCHAT_SETROOMNAME")
  
  this:RegisterEvent("GL_SHOWSTARTBUTTON") 
  this:RegisterEvent("GL_SETLOADINGPERC")
  this:RegisterEvent("GL_SETPLAYER")
  this:RegisterEvent("GL_PLAYERJOIN")
  this:RegisterEvent("GL_PLAYERLEAVE")
  this:RegisterEvent("GL_SETPLAYERREADY")
  this:RegisterEvent("GL_SETPLAYERNAME")
  this:RegisterEvent("GL_SETPLAYERAVATAR")
  this:RegisterEvent("GL_SETPLAYERCOLOR")
  this:RegisterEvent("GL_SETPLAYERTEAM")
  this:RegisterEvent("GL_EXIT")
  this:RegisterEvent("GL_START")
  this:RegisterEvent("GL_SHOWKICKBUTTON")
  this:RegisterEvent("GL_SHOWADDAIBUTTON")
  
  this:RegisterEvent("GS_DISCONNECTED")
  
end

function GameLobby:OnKickUser(slot)
  net.GLSetPlayerKick(slot.playerIDX)
end

function GameLobby:OnTeamClick(slot)
  if slot.controllable ~= true then return end
  slot.Team.idx = slot.Team.idx + 1
  if slot.Team.idx > 6 then slot.Team.idx = 1 end
  net.GLSetPlayerTeam(slot.Team.idx)
end

function GameLobby:OnColorClick(slot)
  if slot.controllable ~= true then return end
  slot.Color.idx = slot.Color.idx + 1
  if slot.Color.idx > #PlayerColors then slot.Color.idx = 1 end
  net.GLSetPlayerColor(slot.Color.idx)
end

function GameLobby:OnShow()
  LobbyChat:Hide()
  this.Chat:ClearUsers()
  this.Chat.Area.Text:SetStr()
  this:Reset()
  
  local name, avatar, plocal = game.GetPlayerInfo()
  
  if plocal then
    this.ChatBtn:Hide()
  else  
    this.ChatBtn:Show()
  end
  
end

function GameLobby:GameStarted()
  LobbyChat:Hide()
  this:Hide()
end

function GameLobby:Exit()
  Transitions:Fade(GameLobby, Lobby)
end

function GameLobby:OnEvent(event)

  if event == "GS_DISCONNECTED" then
    MessageBox:Alert(argReason, "DISCONNECTED")
    Transitions:Fade(GameLobby, Login)
    return
  end
  
  -- slots
  if event == "GL_SHOWSTARTBUTTON" then
    this:ShowStartButton(argShow)
  end
  if event == "GL_SETLOADINGPERC" then 
    this:SetLoadingPerc(argIdx, argPerc)
  end  
  if event == "GL_SETPLAYER" then 
    this:SetPlayer(argIdx)
  end  
  if event == "GL_PLAYERJOIN" then 
    this:SetPlayerVisible(argIdx, true)
  end 
  if event == "GL_PLAYERLEAVE" then 
    this:SetPlayerVisible(argIdx, false)
  end 
  if event == "GL_SETPLAYERREADY" then 
    this:SetPlayerReady(argIdx, argReady)
  end  
  if event == "GL_SETPLAYERNAME" then 
    this:SetPlayerName(argIdx, argName)
  end  
  if event == "GL_SETPLAYERAVATAR" then 
    this:SetPlayerAvatar(argIdx, argAvatar)
  end  
  if event == "GL_SETPLAYERCOLOR" then 
    this:SetPlayerColor(argIdx, argColorIdx)
  end  
  if event == "GL_SETPLAYERTEAM" then 
    this:SetPlayerTeam(argIdx, argTeam)
  end  
  if event == "GL_START" then 
    this:GameStarted()
  end  
  if event == "GL_EXIT" then 
    this:Exit()
  end  
  if event == "GL_SHOWKICKBUTTON" then
    this:SetKickVisible(argIdx, argShow)
  end
  if event == "GL_SHOWADDAIBUTTON" then
    this:ShowAddAIButton(argShow)
  end

  -- chat
  if event == "GLCHAT_MESSAGE" then 
  	this.Chat:AddLine(argPlayer .. ": " .. argText)
  end
  if event == "GLCHAT_PLAYERJOINED" then 
  	this.Chat:AddUser(argPlayer)
  	if argNotify == true then 
  	  this.Chat:AddLine(TEXT{TEXT_USER_JOIN_GAME, argPlayer})
  	end  
  end
  if event == "GLCHAT_PLAYERLEFT" then 
  	this.Chat:DelUser(argPlayer)
  	this.Chat:AddLine(TEXT{TEXT_USER_LEFT_GAME, argPlayer})
  end
  if event == "GLCHAT_PLAYERCHANGEDNICK" then           
  	this.Chat:DelUser(argOldPlayer)
  	this.Chat:AddUser(argNewPlayer)
  	this.Chat:AddLine(TEXT{TEXT_USER_RENAME, argOldPlayer, argNewPlayer})
  end
  if event == "GLCHAT_SETROOMNAME" then 
  	this.Chat:SetRoomName(argName)
  end
  
end

function GameLobby.Chat:OnLoad()
	this.UsersScrollbar.OnScroll = function()
		this.Users:OnScroll(argPos)
	end
  this.Scrollbar.OnScroll = function()
    this.Area:OnScroll(argPos)
  end
end

function GameLobby.Chat:OnKeyEnter()
	local line = this.TextEdit:GetStr()
	local history = this.TextEdit.history
	local last = history[#history]
	if not (line == last) then
		table.insert(history, line)
	end
  
  if line then
    net.GLSendMessage(line)
  end
  this.TextEdit:SetStr()
end

function GameLobby.Chat:OnKeyEscape()
	this.TextEdit:RemoveFocus()
end

function GameLobby.Chat.TextEdit:OnLoad()
	this.history = {}
	this.history.index = nil
end

function GameLobby.Chat.TextEdit:OnShow()
  if #this.history > 0 then 
    this.history.index = #this.history 
  end
end

function GameLobby.Chat.TextEdit:OnClick()
	this:SetFocus()
end

function GameLobby.Chat.TextEdit:OnKeyUp(key)
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

function GameLobby.Chat.TextEdit:OnKeyEnter()
  this:GetParent():OnKeyEnter()
end

function GameLobby.Chat.TextEdit:OnKeyEscape()
  this:GetParent():OnKeyEscape()
end

function GameLobby.Chat:AddLine(line)
  if not line then return end
	local s = this.Area.Text:GetStr()
	if s then
		this.Area.Text:SetStr(s .. "<nl>" .. (line or ""))
	else	                                
		this.Area.Text:SetStr(line)
	end	
	this.Area:AdjustScrollbar(this.Scrollbar)
end 

function GameLobby.Chat:ClearChat()
	this.Area.Text:SetStr("")               
	this.Area:AdjustScrollbar(this.Scrollbar)
end

function GameLobby.Chat:GetUser(user)               
	if not this.tblUsers then return end
  for i,v in ipairs(this.tblUsers) do
  	if v == user then return i end
  end
end

function GameLobby.Chat:AddUser(user)
  if not user then return end
  if not this.tblUsers then this.tblUsers = {} end
  if this:GetUser(user) then return end
  table.insert(this.tblUsers, user)
  local s = ""
  for i,v in ipairs(this.tblUsers) do s = s .. v .. "<nl>" end                          
  this.Users.Text:SetStr(s)
	this.Users:AdjustScrollbar(this.UsersScrollbar)
end 

function GameLobby.Chat:DelUser(user)
	if not this.tblUsers then return end
  local i = this:GetUser(user)
  if not i then return end
  table.remove(this.tblUsers, i)
  local s = ""
  for i,v in ipairs(this.tblUsers) do s = s .. v .. "<nl>" end                          
  this.Users.Text:SetStr(s)
  this.Users:AdjustScrollbar(this.UsersScrollbar)
end

function GameLobby.Chat:ClearUsers()
	if this.tblUsers then this.tblUsers = nil end
  this.Users.Text:SetStr("")
	this.Users:AdjustScrollbar(this.UsersScrollbar)
end

function GameLobby.Chat:SetRoomName(name)
	this.Room:SetStr(name)
end


