--                                                                                                 
-- HIGHPRIEST                                                                               
--                                                                                                 

local commlayer = 0

HighPriest = uiwnd {
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
          this:GetParent():Show()
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
	  	layer = commlayer+1,
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
	  
	  Workers = DefButton {
	    hidden = true,
	    size = {50,65},

      NormalImage = uiimg {hidden = true},
      HighImage = uiimg {hidden = true},
      PushImage = uiimg {hidden = true},

      Count = uitext  { layer = "+1", font = "Verdana,12b", shadow_ofs = {1,1}, color = {255,255,255}, anchors = { CENTER = { 12,18 } } },

      Back = uiimg {
        layer = "-2",
        size = {50,65},
		    texture = "data/textures/ui/officer_slot.dds",
		    coords = {0,0,50,65},
      },
      
	    Icon = uiimg {
        size = {36,55},
	      anchors = { TOPLEFT = {7,3} },
        texture = "data/textures/ui/workers.dds",
        coords = {0,0,36,55},
	    },

	    anchors = { TOPLEFT = { "HighPriest.Officers", "TOPRIGHT", 60, 0 } },

	    OnClick = function()
	      if argMods.shift then
	        game.SelectNextWorker(true)
	      else
	        game.SelectNextWorker()
	      end
	    end,

	    OnLoad = function(this) 
        this:RegisterEvent("MAP_LOADED") 
        this:RegisterEvent("WORKERS_UPDATE") 
      end,
	    OnEvent = function(this, event)
        if event == "MAP_LOADED" then
          this:Hide()
        end
	      if event == "WORKERS_UPDATE" then
	        if argWorkers > 0 then
	          this.Count:SetStr("<p>"..argWorkers)
	          this:Show()
	        else
	          this:Hide()
	        end
	      end
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
        

function HighPriest:OnLoad()
  table.insert(GameUI.topWindows.mutants, this)
end
        
--
-- Progress
--

function HighPriest.Info.Health:OnLoad()
	this:SetProgress(1)
end

function HighPriest.Info.Health:SetProgress( val )
  if val < 0 then val = 0 end
  if val > 1 then val = 1 end
	local sz = this:GetSize()                     
	local x = sz.x * val
	this.Image:SetSize{ x, sz.y }
	this.Image:SetTexture(nil, { 0,0,x,6 } )
end

function HighPriest.Info.Energy:OnLoad()
	this:SetProgress(1)
end

HighPriest.Info.Energy.SetProgress = HighPriest.Info.Health.SetProgress

--
-- HighPriest.Info.Button
--

function HighPriest.Info.Button:OnMouseDown()
  Commander.Info.Button:OnMouseDown()
end

--
-- Progress
--

function HighPriest.Info.Health:OnLoad()
	this:SetProgress(1)
end

function HighPriest.Info.Health:SetProgress( val )
  if val < 0 then val = 0 end
  if val > 1 then val = 1 end
	local sz = this:GetSize()                     
	local x = sz.x * val
	this.Image:SetSize{ x, sz.y }
	this.Image:SetTexture(nil, { 0,0,x,6 } )
end

function HighPriest.Info.Energy:OnLoad()
	this:SetProgress(1)
end

function HighPriest.Info.Energy:SetProgress( val )
  if val < 0 then val = 0 end
  if val > 1 then val = 1 end
	local sz = this:GetSize()
	local x = sz.x * val
	this.Image:SetSize{ x, sz.y }
	this.Image:SetTexture(nil, { 0,0,x,6 } )
end

--
-- HighPriest.Info
--

function HighPriest.Info:OnLoad()
	this:RegisterEvent("COMMANDER_XP_CHANGED")
	this:RegisterEvent("UNIT_HEALTH")
	this:RegisterEvent("UNIT_POWER")
	this:RegisterEvent("UNIT_OFFICERGONE")
	this:RegisterEvent("UNIT_OFFICERREGISTER")
  	this:RegisterEvent("MAP_LOADED")
	
	this:RegisterEvent("UNIT_AREAACTIONSON")
	this:RegisterEvent("UNIT_AREAACTIONSOFF")
end

function HighPriest.Info:OnShow()
  local xp = game.GetCommanderXP()
	this.Rank:SetStrVals{xp}
end
	
function HighPriest.Info:OnEvent(event)
  if game.GetPlayerRace() ~= 'mutants' then return end
  
  if event == "MAP_LOADED" then
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
