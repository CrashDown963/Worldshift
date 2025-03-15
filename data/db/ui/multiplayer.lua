local sz_w = 10
local sz_h = 10

local slot = uiwnd {
  virtual = true,
  hidden = true,
  size = {sz_w,sz_h},
  colors = {
    [1] = {200, 200, 200},
    [2] = {0, 255, 0},
    [3] = {255, 0, 0},
  },
  color = uiimg {},
}

NetworkStall = uiwnd {
  size = {sz_w*2+3,sz_h*3+4},
  anchors = { TOPRIGHT = { -260,5 } },
  
  back = uiimg { color = {0,0,0} },
  
  slot_1 = slot { anchors = { TOPLEFT = { 1,1 } } },
  slot_2 = slot { anchors = { TOP = { "BOTTOM", "slot_1", 0,1 } } },
  slot_3 = slot { anchors = { TOP = { "BOTTOM", "slot_2", 0,1 } } },
  slot_4 = slot { anchors = { TOPLEFT = { "TOPRIGHT", "slot_1", 1,0 } } },
  slot_5 = slot { anchors = { TOP = { "BOTTOM", "slot_4", 0,1 } } },
  slot_6 = slot { anchors = { TOP = { "BOTTOM", "slot_5", 0,1 } } },


  OnLoad = function(this)
    this:RegisterEvent("MPSTALL_SHOW")
    this:RegisterEvent("MPSTALL_HIDE")
    this:RegisterEvent("MPSTALL_SET")
    this:RegisterEvent("MAP_CLOSED")
  end,
  
  OnEvent = function(this, event)
    if event == "MPSTALL_SHOW" then this:Show() return end
    if event == "MPSTALL_HIDE" or event == "MAP_CLOSED" then this:Hide() return end
    if event == "MPSTALL_SET" then 
      -- argIdx, argColorIdx, argShow
      local slot = this["slot_"..argIdx] if not slot then return end
      if argColorIdx and argColorIdx <= #slot.colors then
        slot.color:SetColor(slot.colors[argColorIdx])
      end
      if argShow then
        slot:Show()
      else
        slot:Hide()
      end  
    end
  end,
}

--
local function createrow(listbox, row, col, slotw, sloth)
  local slot
  slot = uiwnd {
    size = {slotw,sloth},
    text = uitext {},
    ShowData = function(this, data)
      this.text:SetStr(data.name.." - "..data.time)
    end,
  }
  return slot
end

WaitingForPlayers = uiwnd {
  hidden = true,
  size = {200,150},

  DefCornerFrameImage2 {},
  
  Title = uitext {
    size = {1,20},
    font = "Verdana,10b",
    color = {255, 143, 51},
    anchors = { TOPLEFT = { 5,5 }, TOPRIGHT = { -5,5 } },
    str = TEXT("waiting_for_players"),
  },

  Waitinglist = DefColumnsList {
    anchors = { TOPLEFT = { "BOTTOMLEFT", "Title", 0,0 }, BOTTOMRIGHT = {-5,-5} },
    rows = 5,
    cols = 1,
    col_dist = 0,
    row_dist = 0,
    func = createrow,
  },

  OnLoad = function(this)
    this.users = {}
    this:RegisterEvent("MPWAITING_SET")
    this:RegisterEvent("MAP_CLOSED")
  end,

  OnEvent = function(this, event)
    if event == "MAP_CLOSED" then
      this:Hide()
    end

    if event == "MPWAITING_SET" then
      -- argPlayer, argTime
      this:Set(argPlayer, argTime)
      if #this.users then
        this:Show()
      else
        this:Hide()
      end
    end
  end,

  GetSlot = function(this, name)
    for i,v in ipairs(this.users) do
      if v.name == name then return i end
    end
  end,

  Set = function(this, uname, utime)
    local idx = this:GetSlot(uname)
    if utime then
      if idx then
        this.users[idx] = { name = uname, time = utime }
      else
        table.insert(this.users, { name = uname, time = utime })
      end
    else
      if idx then
        table.remove(this.users, idx)
      end
    end
    this.Waitinglist:SetList(this.users)
  end,
}

--
--
--

local npslot = uiwnd {
  virtual = true,
  size = {214,18},

  Icon = uiimg {
    hidden = true,
    size = {16,16},
    anchors = { LEFT = { 0,0 } },
    texture = "data/textures/ui/tab-icons.dds",
  },

  Text = uitext {
    size = {196,18},
    anchors = { LEFT = { "RIGHT", "Icon", 2,0 } },
    font = "Verdana,10b",
    halign = "LEFT",
  },

  SetName = function(this, name, color)
    this.name = name
    this.color = color
  end,

  SetStall = function(this, stall)
    this.stall = stall
  end,

  SetPing = function(this, ping)
    this.ping = ping
  end,

  SetCommander = function(this, dead)
    this.commander_dead = dead
  end,

  update = function(this)
    local showping = true
    if this.stall and this.stall == 1 then
      if this.Icon.last ~= 1 then
        this.Icon.last = 1
        this.Icon:SetTexture(nil, {0,16,16,32})  
      end
      if this.Icon:IsHidden() then 
        this.Icon:Show()
      end
      showping = false
    elseif this.commander_dead == true then
      if this.Icon.last ~= 0 then
        this.Icon.last = 0
        this.Icon:SetTexture(nil, {0,0,16,16})  
      end
      if this.Icon:IsHidden() then
        this.Icon:Show()
      end
    else 
      this.Icon:Hide()
    end

    local usercolor = "<color="..this.color[1]..","..this.color[2]..","..this.color[3]..">"

    local text = usercolor..this.name.."</>"
    if this.ping and showping then
      local pingcolor = "<color=255,255,255>"
      if this:GetParent().stall and this.stall and this.stall == 3 then
        pingcolor = "<color=255,0,0>"
      end
      text = text.." ("..pingcolor..this.ping.."ms</>"..")"
    end
    this.Text:SetStr(text)
  end,
}

NetworkPlayers = uiwnd {
  hidden = true,
  size = {230,130},
  anchors = { BOTTOMRIGHT = { "TOPRIGHT", "CollectedItemsBtn", 0,-10 } },
  
  DefCornerFrameImage {},
  
  slot_1 = npslot { anchors = { TOPLEFT = { 5,5 } } },
  slot_2 = npslot { anchors = { TOP = { "BOTTOM", "slot_1", 0,1 } } },
  slot_3 = npslot { anchors = { TOP = { "BOTTOM", "slot_2", 0,1 } } },
  
  slot_6 = npslot { anchors = { BOTTOMLEFT = { 5,-5 } } },
  slot_5 = npslot { anchors = { BOTTOM = { "TOP", "slot_6", 0,-1 } } },
  slot_4 = npslot { anchors = { BOTTOM = { "TOP", "slot_5", 0,-1 } } },

  OnShow = function(this) 
    this:RegisterEvent("MPSTALL_SET")
    this:RegisterEvent("MPSTALL_HIDE")
    this:RegisterEvent("MPSTALL_SHOW")
    game.GLStartBroadcasting(true)
  end,

  OnHide = function(this) 
    this:UnregisterEvent("MPSTALL_SET")
    this:UnregisterEvent("MPSTALL_HIDE")
    this:UnregisterEvent("MPSTALL_SHOW")
    game.GLStartBroadcasting(false)
  end,
  
  CheckVisibility = function(this)
    return false
  end,

  OnLoad = function(this)
    table.insert(GameUI.topWindows.any, this)
    this:RegisterEvent("MAP_LOADED")
    this:RegisterEvent("GL_PLAYERSET")
    this:RegisterEvent("GL_PINGSET")
    this:RegisterEvent("GL_COMMANDER")
    this:RegisterEvent("GL_FACTION")
  end,
  
 
  OnEvent = function(this, event)
    if event == "GL_FACTION" then
      local gametype = net.GLGetGameType()
      if gametype ~= "speciallocation" then
        --print("GL_FACTION:" .. argIndex .. "/" .. argDefeated)
        local slot = this["slot_"..argIndex]
        slot:SetCommander(argDefeated)
        slot:update()
      end
    end

    if event == "GL_COMMANDER" then
      local gametype = net.GLGetGameType()
      --print("GL_COMMANDER:" .. argIndex .. "/" .. argDead)
      if gametype == "speciallocation" then
        local slot = this["slot_"..argIndex]
        slot:SetCommander(argDead)
        slot:update()
      end
    end

    if event == "GL_PINGSET" then
      local slot = this["slot_"..argIndex]
      --print("GL_PINGSET:" .. argIndex .. "/" .. argPing)
      slot:SetPing(argPing)
      slot:update()
    end

    if event == "GL_PLAYERSET" then
      local slot = this["slot_"..argIndex]
      slot:SetName(argName, argColor)
      slot:update()
      slot:Show()
    end

    if event == "MAP_LOADED" then
      for i = 1,6 do
        local slot = this["slot_"..i]
        slot:Hide()
        slot:SetName("", {0,0,0})
        slot:SetCommander(false)
        slot:SetStall(0)
        slot:SetPing()
        slot:update()
      end
    end

    if event == "MPSTALL_SET" then
      --print("MPSTALL_SET" .. argIdx)
      local slot = this["slot_"..argIdx]
      slot:SetStall(argColorIdx)
      slot:update()
    end

    
    if event == "MPSTALL_SHOW" then
      --print("MPSTALL_SHOW")
      this.stall = true
      for i = 1,6 do
        local slot = this["slot_"..i]
        if not slot:IsHidden() then
          slot:update()
        end
      end
    end
    
    if event == "MPSTALL_HIDE" then
      --print("MPSTALL_HIDE")
      this.stall = nil
      for i = 1,6 do
        local slot = this["slot_"..i]
        if not slot:IsHidden() then
          slot:update()
        end
      end
      
    end
  end,
}
