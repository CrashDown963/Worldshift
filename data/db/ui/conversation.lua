--game.PlayConvSnd(const char *pcSound)
--game.StopConvSnd()
--game.IsConvSndPlaying()

--                                                                                             
-- Conversation
--                                                                                             
local add_space = 5
local def_w = 255
local PPS = 200
local seqid = 1

local line_time = 10
local silence_time = 0
local piority_lock_time = 30

local curr_slot

local DefLine = uiwnd {
	virtual = true,
	hidden = true,
	size = {def_w, 40},
	uiimg { color = {0,0,0,80} },
	
	Icon = uiimg {
  	size = {49,49},
  	texture = "data/textures/ui/conversation_icons.dds",
	  anchors = { TOPLEFT = { "TOPLEFT", 5, 5 } },
    Set = function(this, col, row)
      if not row or not col then row = 1 col = 1 end
      local sz = this:GetSize()
      local left = (col-1)*sz.x
      local top = (row-1)*sz.y
      this:SetTexture(nil, {left, top, left+sz.x, top+sz.y})
    end,
	},

  Frame = DefUnitFrame {
	  size = {49,49},
    layer = "+1",
    anchors = { TOPLEFT = { "Icon", 0,0 } },
  },

	Title = uitext {
		color = {255,255,255},
		shadow_ofs = {1,1},
		halign = "LEFT",
		font = "Verdana,11b",
		anchors = { 
		  TOPLEFT = { "TOPRIGHT", "Icon", 10, 0 },
		  BOTTOMRIGHT = { "TOPRIGHT", -5, 25 },
		},
	},
	
	Text = uitext {
  	size = {def_w - 10,100},
  	--auto_adjust_height = true,
		color = {255,255,255,255},
		shadow_ofs = {1,1},
		halign = "LEFT",
		valign = "TOP",
		font = "Verdana,9",
	  anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", 0, 10 } },
	},

	fader = uiwnd {},
	
	OnShow = function(this)
	  if this.snd then
	    game.StopConvSnd()
	    game.PlayConvSnd(this.snd)
	  end
	end,
	
	OnHide = function(this)
	end,
}

Conversation = uiwnd {
  size = {def_w,1},
  keyboard = true,
  anchors = { BOTTOMLEFT = { "TOPLEFT", "Selection", 0, -50 } },
  
  Line_1 = DefLine {},
  Line_2 = DefLine {},
  Line_3 = DefLine {},
  Line_4 = DefLine {},
  Line_5 = DefLine {},
  Line_6 = DefLine {},
  Line_7 = DefLine {},

  OnKeyDown = function(this, key, mod)
    if key == "Tab" and not mod.alt then
      ConversationHistory:DoShow()
      if net.GLGetGameType() ~= "mission" then
        NetworkPlayers:Show()
      end
    end
  end,
  OnKeyUp = function(this, key, mod)
    if key == "Tab" and not mod.alt then
      ConversationHistory:Hide()
      if net.GLGetGameType() ~= "mission" then
        NetworkPlayers:Hide()
      end
    end
  end,
}

function Conversation:OnLoad()
  this:Reset()
  table.insert(GameUI.topWindows.any, this)
end 

function Conversation:Reset()
  curr_slot = nil
  this.hidden = {}
  this.visible = {}
  this.queue = {}

  this.animating = false
  
  local i = 1
  while 1 do
    local slot = this["Line_" .. i]
    if not slot then break end
    table.insert(this.hidden, slot)
    slot:Hide()
    i = i + 1
  end
end


function Conversation:QueueLine(handle, icon, title, text, pri, snd, timeout)
  local line = {}
	line.handle = handle
	line.icon = icon
	line.title = title
	line.text = text
	line.pri = pri
	line.snd = snd
	line.timeout = timeout
	line.timeadded = game.GetMapTime()
	line.seqid = seqid 
	seqid = seqid + 1
	
	table.insert(this.queue, line)
	
	table.sort(this.queue, function(l1, l2) 
	                         if l1.pri > l2.pri then return true end
	                         if l1.pri < l2.pri then return false end
	                         return l1.seqid < l2.seqid 
	                       end)
end

function Conversation:IsSndPlaying()
  local playing = game.IsConvSndPlaying()
  if playing then
    this.finish = nil
    return true
  end  

  local time = game.GetMapTime()
  if not this.finish then
    this.finish = time
    return true
  end
  
  if time < this.finish + silence_time then return true end
  this.finish = nil
  return false
end

function Conversation:CheckAddLine()
  if game.IsPaused() then return end
  local line
  local time = game.GetMapTime()
  while #this.queue > 0 do
    line = this.queue[1]
    if line.timeout and line.timeadded + line.timeout <= time then 
      table.remove(this.queue, 1)
      line = nil
    else
      break  
    end
  end
  if not line then return end
  if this.animating then return end
  if curr_slot then
    if this:IsSndPlaying() and curr_slot.pri >= line.pri then return end
    if curr_slot.pri > line.pri and time < curr_slot.timeadded + piority_lock_time then return end
  end
  
  this:AddLine(line.handle, line.icon, line.title, line.text, line.pri, line.snd, line.timeout)
  table.remove(this.queue, 1)
end

function Conversation:AddLine(handle, icon, title, text, pri, snd, timeout)
  if #this.hidden < 1 then return false end

  local slot = this.hidden[1]
  table.insert(this.visible, 1, slot)
  table.remove(this.hidden, 1)

	slot.handle = handle
  if not icon then icon = {col = 1, row = 1} end
	slot.Icon:Set(icon.col, icon.row)
	slot.Title:SetStr("<p>"..title)
	slot.Text:SetStr("<p>"..text)
	slot:SetSize{def_w, slot.Text:GetStrHeight() + 80}
	slot.pri = pri
	slot.snd = snd
	slot.timeout = timeout
	slot.timeadded = game.GetMapTime()
	
  slot.cur_offset = 0
  slot.dst_offset = 0
  slot:SetAnchor("BOTTOM", this, "BOTTOM", {0, 0})
  slot.fadein = true
  
  curr_slot = slot

  this:OnAnimStart()
  game.CreateTalkBalloon(handle)

  ConversationHistory:AddLine(title, text)

  return true
end

function Conversation:Del(line)
  if not line then return end
  if game.IsPaused() then Transitions:CallOnce(function() this:Del(line) end) return end
  Transitions:Fade(line, nil, function() Conversation:doDelete(line) end)
end

function Conversation:doDelete(line)
  if not line then return end
  table.insert(this.hidden, line)
  for i,v in ipairs(this.visible) do
    if v == line then
      table.remove(this.visible, i)
      break
    end  
  end
  this:OnAnimStart()
end

function Conversation:OnAnimStart()
  this.animating = true
end

function Conversation:OnAnimStop()
  this.animating = false
  for i,slot in ipairs(this.visible) do
    if slot.fadein then 
      Transitions:Fade(nil, slot)
      slot.fader:Show()
      Transitions:Fade(slot.fader, nil, function() Conversation:Del(slot) end, line_time)
      slot.fadein = nil
    end
  end
end

function Conversation:OnUpdate()
  this:CheckAddLine()

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
      slot:SetAnchor("BOTTOM", this, "BOTTOM", {0, -slot.cur_offset})
      animating = true
    end
    
    offset = offset + sz + add_space
  end
  
  if this.animating == true and animating == false then
    this:OnAnimStop()
  end
end

--
-- Conversation history
--

ConversationButton = uiwnd {
  hidden = true,
  mouse = true,
  size = {35,25},
  anchors = { TOPLEFT = { 3,138 } },
  Button = DefButton {
    size = {35,25},
    --NormalImage = uiimg { color = {0, 0, 0, 100}, },
    --HighImage = uiimg { color = {50, 50, 50, 250}, },
    --PushImage = uiimg { color = {100, 50, 20, 250}, },
    NormalText = uitext  { color = {255,143,51}, anchors = {CENTER={0,-3}} },
    HighText  = uitext { color = {255,143,51}, anchors = {CENTER={0,-3}} },
    PushText = uitext { color = {255,143,51}, anchors = {CENTER={0,-3}} },
    str = "...",
    OnMouseEnter = function(this)
      Tooltip:AttachTo(this, "TOPLEFT", this, "BOTTOMLEFT", {0,5})
      Tooltip.Title:SetStr("<p>"..TEXT{"log_ttl"})
      Tooltip.Text:SetStr("<p>"..TEXT{"log_txt"})
      local sz = Tooltip:GetSize()
      Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
      Tooltip:Show()
    end,
    OnMouseLeave = function(this)
      Tooltip:Hide()
    end,
  },
  OnClick = function(this) if ConversationHistory:IsHidden() then ConversationHistory:DoShow() else ConversationHistory:Hide() end end,
  Flick = function(this) Transitions:Fade(this, nil, function() 
      Transitions:Fade(nil, this, function() 
        Transitions:Fade(this, nil, function() 
          Transitions:Fade(nil, this, function() 
          end)
        end)
      end)
    end)
  end,
}

ConversationHistory = uiwnd {
  hidden = true,
  mouse = true,
  size = {600,310},
  anchors = { CENTER = { 0,-40 } },

  Back = uiimg {
    layer= "-1",
    texture = "data/textures/ui/briefing_back.dds",
    coords = {0, 0, 324, 478},      
  },

  Area = DefTextScrollArea {
    anchors = { TOPLEFT = { 20,20 }, BOTTOMRIGHT = { "BOTTOMRIGHT", -20,-20 } },

    Text = uitext { shadow_ofs = {1,1}, font = "Verdana,11", halign = "LEFT", valign = "BOTTOM", },

    OnMouseWheel = function (this, delta, mods)
      if mods.shift then
        if delta < 0 then
          ConversationHistory.Scrollbar:SetPos(0)
        else  
          ConversationHistory.Scrollbar:SetPos(9999999999)
        end  
      elseif mods.alt then
        local pagerows = ConversationHistory.Area.Text:GetSize().y / ConversationHistory.Area.Text:GetLineHeight()
        if delta < 0 then
          ConversationHistory.Scrollbar:SetPos(ConversationHistory.Scrollbar:GetPos() - ((pagerows - 1) * ConversationHistory.Area.Text:GetLineHeight()))
        else  
          ConversationHistory.Scrollbar:SetPos(ConversationHistory.Scrollbar:GetPos() + ((pagerows - 1) * ConversationHistory.Area.Text:GetLineHeight()))
        end  
      else
        ConversationHistory.Scrollbar:SetPos(ConversationHistory.Scrollbar:GetPos() + delta * ConversationHistory.Area.Text:GetLineHeight())
      end  
    end,
  },
  
  Scrollbar = DefVertScrollbar {
    --hidden = true,
    anchors = { 
      TOPRIGHT = { -5, 5 },
      BOTTOMRIGHT = { -5, -5 },
    },
    OnScroll = function(this)
      ConversationHistory.Area:OnScroll(argPos)
    end,
  },

  OnLoad = function(this)
    table.insert(GameUI.topWindows.any, this)
    this:RegisterEvent("MAP_LOADED")
    this:RegisterEvent("MAP_CLOSED")
  end,

  OnEvent = function(this, event)
    if event == "MAP_LOADED" then
      this.Area.Text:SetStr("")
      this.Area:AdjustScrollbar(this.Scrollbar)
      this.Scrollbar:Hide()
      if net.GLGetGameType() == "mission" then
        ConversationButton:Show()
      end
    end
    if event == "MAP_CLOSED" then
      this:Hide()
      ConversationButton:Hide()
    end
  end,

  AddLine = function(this, unit, text)
    local line = "<color=255,143,51>"..unit..": </>"..text

    local s = this.Area.Text:GetStr()
    if s then
      this.Area.Text:AddStr("<nl>" .. line)
    else
      this.Area.Text:SetStr(line)
    end

    local newpos = this.Area.pos 
    local min,max = this.Scrollbar:GetMinMaxRange()
    if this.Area.pos == max or max <= min then
      newpos = nil
    end
    this.Area:AdjustScrollbar(this.Scrollbar, newpos)

    local min1,max1 = this.Scrollbar:GetMinMaxRange()
    if max1 > min1 then
      if this.Scrollbar:IsHidden() then this.Scrollbar:Show() end
    else
      if not this.Scrollbar:IsHidden() then this.Scrollbar:Hide() end
    end
    
    ConversationButton:Flick()
  end,

  DoShow = function(this)
    local gametype = net.GLGetGameType()
    if gametype ~= "mission" then return end
    if this:IsHidden() then
      local min,max = this.Scrollbar:GetMinMaxRange()
      this.Scrollbar:SetPos(max)
    end
    this:Show()
  end,

  CheckVisibility = function()
    return false
  end,
}

