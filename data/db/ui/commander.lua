--                                                                                                 
-- COMMANDER                                                                               
--                                                                                                 

local commlayer = 0

Commander = uiwnd {
  hidden = true,
	size = {300,100},
	anchors = { TOPLEFT = { 0, 0 } },
   
  Info = uiwnd {     
  	size = {112,148},
		anchors = { TOPLEFT = {} },
  	
	  Icon = uiimg {
	    layer = commlayer-1,
	  	size = {75,96},
	  	anchors = { TOPLEFT = { 7,8 } },
	  	
	  	Set = function(this, handle)
	  	  if handle then
          local info = game.GetActorInfo(handle)
          local x = (info.icon[1]-1) * unitIcons[info.class].size[1]
          local y = (info.icon[2]-1) * unitIcons[info.class].size[2]
          this:SetTexture(unitIcons[info.class].file, {x,y,x+unitIcons[info.class].size[1],y+unitIcons[info.class].size[2]} )
        else
          this:SetTexture("data/textures/ui/skull_big.dds", {0,0,77,98} )
          local parent = this:GetParent()
          parent.Health:SetProgress(0)
          parent.Energy:SetProgress(0)
        end  
	  	end,
	  },
	  
	  Rank = uitext {
	    size = {250,20}, halign = "LEFT",
	    str = "XP:[#]",
			anchors = { TOPLEFT = { "BOTTOMLEFT" } },
			hidden = true,
	  },
	  
	  Frame = uiimg {          
	  	size = {111,147},
	    layer = commlayer,
			texture = "data/textures/ui/commander_frame_new.dds",
			coords = {0,0,111,147},
			anchors = { TOPLEFT = {} },
	  },

	  Button = uiwnd {          
	  	size = {75,96},
	  	layer = commlayer+2,
	  	mouse = true,
	  	anchors = { TOPLEFT = { 7,8 } },

      OnMouseEnter = function(this)
        Tooltip:AttachTo(this, "TOPLEFT", this, "BOTTOMLEFT", {10,50})
        local ttl,txt
        if game.GetCommander() then
          ttl = "<p>"..TEXT("leader_tooltip_ttl")
          txt = "<p>"..TEXT("leader_tooltip_txt")
        else
          ttl = "<p>"..TEXT("leaderdead_tooltip_ttl")
          txt = "<p>"..TEXT("leaderdead_tooltip_txt")
        end
        Tooltip.Title:SetStr(ttl)
        Tooltip.Text:SetStr(txt)
        local sz = Tooltip:GetSize()
        Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
        Tooltip:Show()
      end,

      OnMouseLeave = function(this)
        Tooltip:Hide()
      end,
	  },
	  
	  Health = uiwnd {
	  	size = {84,9},
	  	
	  	Back = uiimg { 
	  		size = {84,9},
	  		layer = commlayer+1,
	  		texture = "data/textures/ui/commander_under_health.dds",
	  		texture_auto_coords = true,
	  	},
	  	
	  	Image = uiimg {
	  		size = {84,9},
	  		layer = commlayer+2,
	  		texture = "data/textures/ui/commander_health.dds",
	  		texture_auto_coords = true,
	  		anchors = { LEFT = {} },
	  	},
	  	
	  	anchors = { TOPLEFT = { "BOTTOMLEFT", "Icon", -5, 7 } },
	  },

	  Energy = uiwnd {
	  	size = {84,9},
	  	
	  	Back = uiimg { 
	  		size = {84,9},
	  		layer = commlayer+1,
	  		texture = "data/textures/ui/commander_under_energy.dds",
	  		texture_auto_coords = true,
	  	},
	  	
	  	Image = uiimg { 
	  		size = {84,9},
	  		layer = commlayer+2,
	  		texture = "data/textures/ui/commander_energy.dds",
	  		texture_auto_coords = true,
	  		anchors = { LEFT = {} },
	  	},
	  	
	  	anchors = { TOP = { "Health", "BOTTOM", 0, 1 } },
	  },
  },
  
  Officers = DefOfficers { anchors = { TOPLEFT = { "TOPRIGHT", "Info" } }, },
}
        
function Commander:OnLoad()
  table.insert(GameUI.topWindows.humans, this)
end
        
--
-- Progress
--

function Commander.Info.Health:OnLoad()
	this:SetProgress(1)
end

function Commander.Info.Health:SetProgress( val )
  if val < 0 then val = 0 end
  if val > 1 then val = 1 end
	local sz = this:GetSize()                     
	local x = sz.x * val
	this.Image:SetSize{ x, sz.y }
	this.Image:SetTexture(nil, { 0,0,x,6 } )
end

function Commander.Info.Energy:OnLoad()
	this:SetProgress(1)
end

Commander.Info.Energy.SetProgress = Commander.Info.Health.SetProgress

--
-- Commander.Info.Button
--

function Commander.Info.Button:OnMouseDown()
  if argBtn == "RIGHT" then 
    return 
  end

  local officer = game.GetCommander() if not officer then return end
  if officer and game.CheckActionExecute(officer) then return end
  
  local time = game.GetAppTime() if not this.lastClickTime then this.lastClickTime = 0 end
  local dblclk = time - this.lastClickTime < 0.3
  this.lastClickTime = time
  
  if dblclk == true then
    game.SetCameraPos(officer)
  else
    if argMods.ctrl then
      local sametype = game.GetUnitsByType(officer)
      if argMods.shift then
        local allselected = true
        for h,_ in pairs(sametype) do
          if type(h) == "number" and not game.IsSelected(h) then
            allselected = false
            break
          end
        end
        local sel = game.GetSelection() if not sel then sel = {} end
        if allselected then
          for h,_ in pairs(sametype) do
            if type(h) == "number" then
              sel[h] = nil
            end
          end
        else
          for h,_ in pairs(sametype) do
            if type(h) == "number" then
              sel[h] = true
            end
          end
        end
        game.SetSelection(sel)
      else
        game.SetSelection(sametype)
      end
    elseif argMods.shift then
      local sel = game.GetSelection() if not sel then sel = {} end
      if sel[officer] then
        sel[officer] = nil  
      else
        sel[officer] = true
      end
      game.SetSelection(sel)
    else
      local tbl = {} tbl[officer] = true
      game.SetSelection(tbl)
    end
  end
end

--
-- Commander.Info
--
function Commander.Info:OnLoad()
	this:RegisterEvent("COMMANDER_XP_CHANGED")
	this:RegisterEvent("UNIT_HEALTH")
	this:RegisterEvent("UNIT_POWER")
	this:RegisterEvent("UNIT_OFFICERGONE")
	this:RegisterEvent("UNIT_OFFICERREGISTER")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("CHECKPOINT_LOADED")
	
	this:RegisterEvent("UNIT_AREAACTIONSON")
	this:RegisterEvent("UNIT_AREAACTIONSOFF")
end

function Commander.Info:OnEvent(event)
  if game.GetPlayerRace() ~= 'humans' then return end

  if event == "MAP_LOADED" or event == "CHECKPOINT_LOADED" then
    local commander = game.GetCommander()
    this.Icon:Set(commander)
	  local h,mh,m,mm = game.GetActorBriefInfo(commander)
	  if h and mh then
	    if mh == 0 then h = 0 mh = 1 end
	    this.Health:SetProgress(h/mh)
	  end  
	  if m and mm then
	    if mm == 0 then m = 0 mm = 1 end
  	  this.Energy:SetProgress(m/mm)
  	end  
    local xp = game.GetCommanderXP()
	  this.Rank:SetStrVals{xp}
  end

  if event == "UNIT_OFFICERGONE" and argSlot == 0 then
    this.Icon:Set(nil)
  end
  
  if event == "UNIT_OFFICERREGISTER" and argSlot == 0 then
    this.Icon:Set(argOfficer)
	  local h,mh,m,mm = game.GetActorBriefInfo(argOfficer)
	  if h and mh then
	    if mh == 0 then h = 0 mh = 1 end
	    this.Health:SetProgress(h/mh)
	  end  
	  if m and mm then
	    if mm == 0 then m = 0 mm = 1 end
  	  this.Energy:SetProgress(m/mm)
  	end  
    local xp = game.GetCommanderXP()
	  this.Rank:SetStrVals{xp}
  end

  if event == "UNIT_AREAACTIONSON" then
    if argOfficer == game.GetCommander() then
      --this.Frame:SetColor(colors.red)
    end
  end
  
  if event == "UNIT_AREAACTIONSOFF" then
    if argOfficer == game.GetCommander() then
      --this.Frame:SetColor(colors.white)
    end
  end

  if event == "COMMANDER_XP_CHANGED" then
    local xp = game.GetCommanderXP()
  	this.Rank:SetStrVals{xp}
  end
  
  if event == "UNIT_HEALTH" then      
  	local commander = game.GetCommander()
  	if argHandle == commander then 
  	  local h,mh,m,mm = game.GetActorBriefInfo(commander)
	    if h and mh then
	      if mh == 0 then h = 0 mh = 1 end
	      this.Health:SetProgress(h/mh)
	    end  
  	end
  end                
  
  if event == "UNIT_POWER" then      
  	local commander = game.GetCommander()
  	if argHandle == commander then 
  	  local h,mh,m,mm = game.GetActorBriefInfo(commander)
	    if m and mm then
	      if mm == 0 then m = 0 mm = 1 end
  	    this.Energy:SetProgress(m/mm)
  	  end  
  	end
  end                
end

