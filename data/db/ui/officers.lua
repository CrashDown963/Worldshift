--                                                                                                 
-- OFFICERS
--                                                                                                 

local TextOrder = "<p>"..TEXT{"textorder"}
local TextOfficer = "<p>"..TEXT{"textofficer"}
local TextOfficer_empty = "<p>"..TEXT{"textofficer_empty"}
local TextOfficer_empty_mis_sp = "<p>"..TEXT{"textofficer_empty_mis_sp"}

local icon_sz = {36, 46}
local prgs_sz = {36, 3}

local DefChoose = uibtn {
  virtual = true,
  size = icon_sz,
  
  Icon = uiimg {},

  Frame = DefUnitFrame { layer = "+1" },

  OnShow = function(this)
    local icon, class = game.GetActorIcon(this.unit_id)
    local x = (icon[1]-1) * unitIcons[class].size[1]
    local y = (icon[2]-1) * unitIcons[class].size[2]
    this.Icon:SetTexture(unitIcons[class].file, {x,y,x+unitIcons[class].size[1],y+unitIcons[class].size[2]} )
  end,
  OnClick = function(this) ChooseOfficer:Teleport(this) end,
	OnMouseEnter = function(this) OfficerTooltip(this) end,
  OnMouseLeave = function(this) Tooltip:Hide() end,
}

ChooseOfficer = uiwnd {
  layer = modallayer+1,
  hidden = true,
  size = {1,1},
 
  humans = { "Judge", "Surgeon", "Assassin", "Constructor", "Technician2" },
  aliens = {"Arbiter", "Dominator", "Manipulator", "Harvester", "BigMutant2" },
  mutants = {"Shaman", "Sorcerer", "Guardian", "StoneGhost", "Eji2"},
  
  Off_1 = DefChoose { anchors = { TOPLEFT = {} } },
  Off_2 = DefChoose { anchors = { LEFT = {"RIGHT", "Off_1", 3,0 } } },
  Off_3 = DefChoose { anchors = { LEFT = {"RIGHT", "Off_2", 3,0 } } },
  Off_4 = DefChoose { anchors = { LEFT = {"RIGHT", "Off_3", 3,0 } } },
  Off_5 = DefChoose { anchors = { LEFT = {"RIGHT", "Off_4", 4,0 } } },
  
  Back = DefCornerFrameImage2 { 
    anchors = { 
      TOPLEFT = { "TOPLEFT", "Off_1", -5,-5 },
      BOTTOMRIGHT = { "BOTTOMRIGHT", "Off_4", 5,5 },
    },
  },
}

local progress = uiwnd {
  virtual = true,
  hidden = true,
	size = prgs_sz,

	Back = uiimg { 
		size = prgs_sz,
		color = {255, 0, 0, 255},
	},
	
	Image = uiimg { 
	  layer = 1,
		size = prgs_sz,
		anchors = { LEFT = {} },
		color = {0, 255, 0, 255},
	},
	
  Set = function(this, val)
    if val < 0 then val = 0 end
    if val > 1 then val = 1 end
    local sz = this:GetSize()
    local x = sz.x * val
    this.Image:SetSize{ x, sz.y }
    this.Image:SetTexture(nil, { 0,0,x,6 } )
  end,
}

DefOfficer = uiwnd {
  virtual = true,
  mouse = true,
	size = {50,65},

  Back = uiimg {
    layer = 1,
    size = {50,65},
		texture = "data/textures/ui/officer_slot.dds",
		coords = {0,0,50,65},
  },
  
	Icon = uiimg {
	  hidden = true,
    size = {36,46},
	  layer = 2,
	  anchors = { TOPLEFT = {7,3} },
	},

	Dimmer = uiimg {
	  hidden = true,
    size = {36,46},
	  layer = 3,
	  color = {0,0,0,150},
	  anchors = { TOPLEFT = {7,3} },
	},
	
	Progress = progress {
	  layer = 4,
	  anchors = { TOP = { "BOTTOM", "Icon", 0, 1 } },
	},
  
	Health = progress {
	  layer = 4,
	  anchors = { TOP = { "BOTTOM", "Icon", 0, 1 } },
	},

	Energy = progress {
	  layer = 4,
    Back = uiimg { 
	    size = prgs_sz,
	    color = {7, 0, 58, 255},
    },

    Image = uiimg { 
      layer = 1,
	    size = prgs_sz,
	    anchors = { LEFT = {} },
	    color = {136, 56, 255, 255},
    },
	  anchors = { TOP = { "BOTTOM", "Health", 0, 1 } },
	},

  SetUnit = function(this, handle)
    if handle then
      this.handle = handle
      local icon, class = game.GetActorIcon(handle) --print("name:"..game.GetActorName(handle).." : class:"..class.." : icon:"..tostring(icon[1])..","..tostring(icon[2]))
      if not icon then icon = { 1,1 } end
      if class == "commander" and icon[2] > 2 then class = "officer" end  -- dirty Tharksh hack
      if not unitIcons[class] or not unitIcons[class].size then return end
      local x = (icon[1]-1) * unitIcons[class].size[1]
      local y = (icon[2]-1) * unitIcons[class].size[2]
      this.Icon:SetTexture(unitIcons[class].file, {x,y,x+unitIcons[class].size[1],y+unitIcons[class].size[2]} )
      this.Icon:Show()
      this.Energy:Show()
      this.Health:Show()
    else
      if this.handle then
        this.Icon:SetTexture("data/textures/ui/skull_mid.dds", {0,0,36,46} )
        this.Icon:Show()
        this.Health:Set(0)
        this.Health:Show()
        this.Energy:Set(0)
        this.Energy:Show()
      else
        this.Icon:Hide()
        this.Health:Hide()
        this.Energy:Hide()
      end
      this.handle = nil
      this.Dimmer:Hide()  
      this.Progress:Hide()
    end
  end,

  SetTeleportProgress = function(this, perc)
    local val = perc / 100
    this.Progress:Set(val)
    
    if perc >= 100 then
      this.Dimmer:Hide()
      this.Progress:Hide()
      this.Progress:Set(0)

      local idx = string.sub(this:GetName(), 9, 10)
      local officer = game.GetOfficer(idx)
      local info = game.GetActorInfo(officer)
      if info.max_health and info.max_health > 0 and info.health then
        this.Health:Set(info.health / info.max_health)
        this.Health:Show()
      else
        this.Health:Set(0)
        this.Health:Hide()
      end
      
      if info.max_power and info.max_power > 0 and info.power then 
        this.Energy:Set(info.power / info.max_power)
        this.Energy:Show()
      else
        this.Energy:Set(0)
        this.Energy:Hide()
      end
      this.teleport_id = nil
    else   
      if this.teleport_id then
        local icn, class = game.GetActorIcon(this.teleport_id)
        local x = (icn[1]-1) * unitIcons[class].size[1]
        local y = (icn[2]-1) * unitIcons[class].size[2]
        this.Icon:SetTexture(unitIcons[class].file, {x,y,x+unitIcons[class].size[1],y+unitIcons[class].size[2]} )
        this.Icon:Show()
      end
      
      this.Dimmer:Show()
      this.Health:Hide()
      this.Health:Set(0)
      this.Energy:Hide()
      this.Energy:Set(0)
      this.Progress:Show()
    end  
  end,
	
	OnMouseDown = function(this) 
    if argBtn == "RIGHT" then 
      return 
    end

	  local idx = string.sub(this:GetName(), 9, 10)
	  local officer = game.GetOfficer(idx)
    if officer and game.CheckActionExecute(officer) then return end
	  
	  if this:GetParent().teleporting then return end
	  if not officer then
      local maptype = game.GetMapType()
	    local commander = game.GetCommander()
      if commander and maptype ~= "mission" and maptype ~= "special_location" then 
        ChooseOfficer:Toggle(this) 
      end
	  else
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
	end,

	OnMouseEnter = function(this) 
    Tooltip:AttachTo(this:GetParent().Officer_2, "TOPLEFT", this:GetParent().Officer_2, "BOTTOMLEFT", {0,7})
    if this.handle then
      local info = game.GetActorInfo(this.handle)
      Tooltip.Title:SetStr(TEXT{(info.name_var or info.name)..".name"})
      Tooltip.Text:SetStr(TextOfficer)
    else  
      Tooltip.Title:SetStr(TEXT{"empty officer slot"})
      local maptype = game.GetMapType()
      if maptype ~= "mission" and maptype ~= "special_location" then 
        Tooltip.Text:SetStr(TextOfficer_empty)
      else  
        Tooltip.Text:SetStr(TextOfficer_empty_mis_sp)
      end  
    end
    local sz = Tooltip:GetSize()
    Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
    Tooltip:Show()
	end,
	
  OnMouseLeave = function(this) Tooltip:Hide() end,
}

function OfficerTooltip(btn)
  if not btn.unit_id then return end
  Tooltip:AttachTo(ChooseOfficer.Back, "TOPLEFT", ChooseOfficer.Back, "BOTTOMLEFT", {0,5})

  Tooltip.Title:SetStr(TEXT(btn.unit_id .. ".name"))
  local str = "<p>" .. TextOrder
  Tooltip.Text:SetStr(str)
  Tooltip:SetCost(id)
  
  Tooltip:SetCost(btn.unit_id)

  local sz = Tooltip:GetSize()
  Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
  Tooltip:Show()
end

DefOfficers = uiwnd {
  virtual = true,
	size = {150,150},
  
  max_map_officers = 4,
  officer_slots = 10,
  
  Officer_1 = DefOfficer { anchors = { TOPLEFT = { "TOPLEFT", -17,0 } }, },
  Officer_2 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_1", 0,0 } }, },
  Officer_3 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_2", 0,0 } }, },
  Officer_4 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_3", 0,0 } }, },
  Officer_5 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_4", 0,0 } }, },
  Officer_6 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_5", 0,0 } }, },
  Officer_7 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_6", 0,0 } }, },
  Officer_8 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_7", 0,0 } }, },
  Officer_9 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_8", 0,0 } }, },
  Officer_10 = DefOfficer { anchors = { LEFT = { "RIGHT", "Officer_9", 0,0 } }, },
  
  UpdateIcons = function(this)
    for i = 1,10 do
      local o = this["Officer_"..i]
      o:SetUnit(o.handle)
    end
  end,
}

--
-- DefOfficers
--
function DefOfficers:OnHide()
  ChooseOfficer:Hide()
end

function DefOfficers:OnLoad()
	this:RegisterEvent("UNIT_HEALTH")
	this:RegisterEvent("UNIT_POWER")
	this:RegisterEvent("UNIT_TELEPORTOFFICER")
	this:RegisterEvent("UNIT_OFFICERGONE")
	this:RegisterEvent("UNIT_OFFICERREGISTER")
  this:RegisterEvent("MAP_LOADED")
  this:RegisterEvent("CHECKPOINT_LOADED")

	this:RegisterEvent("UNIT_AREAACTIONSON")
	this:RegisterEvent("UNIT_AREAACTIONSOFF")
end

function DefOfficers:OnEvent(event)
  if event == "UNIT_AREAACTIONSON" then
    --for i = 1,this.max_map_officers do
      --local slot = this['Officer_' .. i]
	    --if slot.handle == argOfficer and slot.Frame then
	      --slot.Frame:SetColor(colors.red)
	    --end
    --end
  end
  
  if event == "UNIT_AREAACTIONSOFF" then
    --for i = 1,this.max_map_officers do
      --local slot = this['Officer_' .. i]
	    --if slot.handle == argOfficer and slot.Frame then
	      --slot.Frame:SetColor(colors.white)
	    --end
    --end
  end
  
  if event == "MAP_LOADED" or event == "CHECKPOINT_LOADED" then
    this.max_map_officers = game.GetMapMaxOfficers()
    for i = 1,this.officer_slots do 
      local slot = this['Officer_' .. i]
      if i <= this.max_map_officers then
        slot:Show()
      else
        slot:Hide()
      end
    end
    for i = 1,this.max_map_officers do
	    local h = game.GetOfficer(i)
	    if h then 
	      local slot = this['Officer_' .. i]
	      slot:SetUnit(h)
	      slot:SetTeleportProgress(100)
	    else
	      this['Officer_' .. i]:SetUnit(nil)  
	    end  
    end
  end
  
  if event == "UNIT_OFFICERGONE" then
    local slot = this['Officer_' .. argSlot] if not slot then return end
    slot:SetUnit(nil)
  end
  
  if event == "UNIT_OFFICERREGISTER" then
    local slot = this['Officer_' .. argSlot] if not slot then return end
    slot:SetUnit(argOfficer)
    slot:SetTeleportProgress(100)
  end
  
  if event == "UNIT_TELEPORTOFFICER" then
    local slot = this['Officer_' .. argSlot]
    if argAction == "BEGIN" then 
      this.teleporting = true 
    elseif argAction == "PROGRESS" then
      slot:SetTeleportProgress(argValue)
    elseif argAction == "CANCEL" then
      slot:SetUnit(nil)
      this.teleporting = nil
    elseif argAction == "END" then
      slot:SetTeleportProgress(100)
      local idx = string.sub(slot:GetName(), 9, 10)
      local h = game.GetOfficer(idx)
      slot:SetUnit(h)
      this.teleporting = nil
    end
  end
  
  if event == "UNIT_HEALTH" then      
  	for i = 1,this.max_map_officers do
  	  local slot = this['Officer_'..i]
  	  if argHandle == slot.handle then 
  	    slot.Health:Set(argHealth) 
  	  end
  	end
  end
  
  if event == "UNIT_POWER" then      
  	for i = 1,this.max_map_officers do
  	  local slot = this['Officer_'..i]
  	  if argHandle == slot.handle then
  	    slot.Energy:Set(argPower)
  	  end
  	end
  end                
end

function ChooseOfficer:Toggle(officer_btn)
  local race = game.GetPlayerRace()
  for i = 1,4 do 
    local name = this[race][i]
    this["Off_" .. i].unit_id = name
  end
  
  this.slot = nil
  this.idx = nil
  if this:IsHidden() then
    this:SetAnchor("TOPLEFT", officer_btn:GetParent().Officer_1, "BOTTOMLEFT", {25, 7} )
    this.idx = string.sub(officer_btn:GetName(), 9, 10)
    this.slot = officer_btn
    this:Show()
    Modal:SetLayer(modallayer)
    Modal:Show()
    return
  end  
  this:Hide()
  Modal:Hide()
end

function ChooseOfficer:Teleport(btn)
  if not btn.unit_id then return end
  local id = btn.unit_id
  local commander = game.GetCommander()
  if not commander or not this.idx or not id or not this.slot then return end

  local tbl = {} tbl[commander] = true
  game.SetSelection(tbl)

  if game.TeleportOfficer(this.idx, id) then
    this.slot.teleport_id = id
  end
  this:Hide()
  Modal:Hide()
end

