--                                                                                             
-- INVENTORY                                                                                   
--                                                                                             
local inventorylayer = 50
local sz_item_w = 42
local sz_item_h = 42

local DragingItem = false

local FrameByRepo = {
  ALIEN_POWER = 7,
  MUTANT_BLOOD = 7,
  HUMAN_DEFENCE = 7,

  ALIEN_CORRUPTION = 8,
  MUTANT_NATURE = 8,
  HUMAN_IMPLANTS = 8,

  ALIEN_DOGMA = 6,
  MUTANT_MIND = 6,
  HUMAN_WEAPONS = 6,

  ALIEN_ENIGMA = 10,
  MUTANT_SPIRIT = 10,
  HUMAN_NEUROSCIENCE = 10,

  ALIEN_HARVESTER = 5,
  MUTANT_STONEGHOST = 5,
  HUMAN_CONSTRUCTOR = 5,

  ALIEN_MANIPULATOR = 4,
  MUTANT_ADEPT = 4,
  HUMAN_ASSASSIN = 4,

  ALIEN_DEFILER = 9,
  MUTANT_PSYCHIC = 9,
  HUMAN_ENGINEER = 9,

  ALIEN_DOMINATOR = 3,
  MUTANT_SHAMAN = 3,
  HUMAN_SURGEON = 3,

  ALIEN_MASTER = 1,
  MUTANT_HIGHPRIEST = 1,
  HUMAN_COMMANDER = 1,

  ALIEN_ARBITER = 2,
  MUTANT_GUARDIAN = 2,
  HUMAN_JUDGE = 2,
}

Inventory = uiwnd {
  layer = inventorylayer,
  size = {626,234},
  hidden = true,
  mouse = true,

  Title = uiwnd {
  	uitext {
  	},
  },
  
	Recycle = uislot {
    layer = inventorylayer+1,
		size = {100,100}, 
	  repo = "RECYCLE",
	  --uiimg { color = {180,25,25,100} },
	  --uitext { str = "DEL" },
	  anchors = { TOPRIGHT = { "BOTTOMRIGHT", -10, 20 } },

    Effect = uinif {
      layer = "+10",
      nif = "Data/Models/MiscObjects/item_recycle_effect.nif",
      anchors = { CENTER = {50,50} },
      scale = 0.12,
  		size = {100,100}, 
    },

    OnMouseEnter = function(this)
      Tooltip:AttachTo(this, "TOPRIGHT", this, "TOPLEFT", {-20,0})
      Tooltip.Title:SetStr("<p>"..TEXT("trash_ttl"))
      Tooltip.Text:SetStr("<p>"..TEXT("trash_txt"))
      local sz = Tooltip:GetSize()
      Tooltip:SetSize{sz.x, Tooltip.Text:GetStrHeight() + 48}
      Tooltip:Show()
    end,

    OnMouseLeave = function(this)
      Tooltip:Hide()
    end,
	},
}

Inventory.DefItemSlot = uislot {
  layer = inventorylayer,
  virtual = true,
  keyboard = true,
  size = {sz_item_w, sz_item_h},

  frame_w = 81,
  frame_h = 81,

  aliens_top = 0,
  humans_top = 324,
  mutants_top = 648,
  
  lvl_aliens_top = 243,
  lvl_humans_top = 567,
  lvl_mutants_top = 891,

  frame_idx = 1, 

  Empty = uiimg { 
    layer = inventorylayer-2,
  	size = {sz_item_w, sz_item_h},
	  texture = "data/textures/ui/items_slot_empty.dds",
	  coords = {6,5,45,45},
 	},
  
  Level = uiimg { 
    hidden = true,
    size = {45,45},
    layer = inventorylayer+1,
  	texture = "data/textures/ui/item_frames.dds",
 	},

  Frame = uiimg { 
    hidden = true,
    size = {45,45},
    layer = inventorylayer+2,
  	texture = "data/textures/ui/item_frames.dds",
 	},

  OnLoad = function(this) Inventory.DefItemSlot_OnLoad(this) end,
  
  UpdateFrame = function(this)
    this.frame_top = nil
    this.lvl_top = nil

    local item = this:GetItem() 
    if item then
      this.frame_idx = FrameByRepo[item.repo[1]]
      if item.race == "mutants" then
        this.frame_top = this.mutants_top
        this.lvl_top = this.lvl_mutants_top
      end
      if item.race == "aliens" then
        this.frame_top = this.aliens_top
        this.lvl_top = this.lvl_aliens_top
      end
      if item.race == "humans" then
        this.frame_top = this.humans_top
        this.lvl_top = this.lvl_humans_top
      end
    else
      local repo = this:GetInfo()
      if string.sub(repo, 1, 7) == "MUTANT_" or string.sub(repo, 1, 15) == "INSPECT_MUTANT_" then
        this.frame_top = this.mutants_top
        this.lvl_top = this.lvl_mutants_top
      end
      if string.sub(repo, 1, 6) == "ALIEN_" or string.sub(repo, 1, 14) == "INSPECT_ALIEN_" then
        this.frame_top = this.aliens_top
        this.lvl_top = this.lvl_aliens_top
      end
      if string.sub(repo, 1, 6) == "HUMAN_" or string.sub(repo, 1, 14) == "INSPECT_HUMAN_" then
        this.frame_top = this.humans_top
        this.lvl_top = this.lvl_humans_top
      end
    end

    if not this.frame_top then 
      this.Frame:Hide()
      this.Level:Hide()
      return 
    end

    local left = (this.frame_idx-1) * this.frame_w
    if item then
      this.Frame:SetTexture(nil, {left, this.frame_top, left + this.frame_w, this.frame_top + this.frame_h})
    else
      local top = this.frame_top + (2*this.frame_h)
      this.Frame:SetTexture(nil, {left, top, left + this.frame_w, top + this.frame_h})
    end
    this.Frame:Show()

    if not item or not this.lvl_top then 
      this.Level:Hide()
      return
    end

    left = (this.frame_idx-1) * this.frame_w
    this.Level:SetTexture(nil, {left, this.lvl_top, left + this.frame_w, this.lvl_top + this.frame_h})
    this.Level:SetColor(ItemColors["h"..item.quality])
    this.Level:Show()
  end,

  OnMouseDown = function(this)
    if argMods.shift and argBtn == "LEFT" then
      DESKTOP:CreateItemLink(this:GetItem())
      return
    end
    
    local item = this:GetItem()
    if argBtn == "LEFT" then
      if item then DragingItem = true end
      return
    end
    
    if DragingItem then 
      game.CancelItemDrag() 
      return 
    end
    if TechGrid:IsHidden() then return end

    local src = this:GetInfo()
    local dst = "INVENTORY_"..Inventory.suff
    
    if src == "INVENTORY_"..Inventory.suff and item and item.repo then 
      dst = item.repo[1]
    end
    
    if dst == src then 
      this:UpdateFrame()
      return 
    end

    if string.sub(dst, 1, 7) == "MUTANT_" and TechGrid.MutantsInterface:IsHidden() then
      TechGrid:SelectRace(TechGrid.Mutants)
    end
    if string.sub(dst, 1, 6) == "ALIEN_" and TechGrid.AliensInterface:IsHidden() then
      TechGrid:SelectRace(TechGrid.Aliens)
    end
    if string.sub(dst, 1, 6) == "HUMAN_" and TechGrid.HumansInterface:IsHidden() then
      TechGrid:SelectRace(TechGrid.Humans)
    end

    if not this:MoveItem(dst) then 
      if src ~= "MISSION" then
        game.PlaySnd(sounds.item_reject) 
        ErrText:ShowText("strItemReject")
      end
      return 
    end
    
    ItemTooltip:Hide()
    
    if src == "INVENTORY_"..Inventory.suff then
      game.PlaySnd(sounds.unit_item_in)
    end
    
    if dst == "INVENTORY_"..Inventory.suff then
      game.PlaySnd(sounds.unit_item_out)
    end                         
    
    this:SlotLight(false)
    this:OnMouseLeave()
    this:UpdateFrame()
    
    --net.GLUserItemsChanged();
  end,
  
  SlotLight = function(this, dolight)
    if this.Frame:IsHidden() then return end
    local left = (this.frame_idx-1) * this.frame_w
    if dolight then
      local top = this.frame_top + this.frame_h
      this.Frame:SetTexture(nil, {left, top, left + this.frame_w, top + this.frame_h})
    else
      if this:GetItem() then
        this.Frame:SetTexture(nil, {left, this.frame_top, left + this.frame_w, this.frame_top + this.frame_h})
      else
        local top = this.frame_top + (2*this.frame_h)
        this.Frame:SetTexture(nil, {left, top, left + this.frame_w, top + this.frame_h})
      end
    end
  end,
}

function Inventory:Show(race)
  if not race then return end
  this.suff = nil
  if (race == "humans") then this.suff = "H" end
  if (race == "mutants") then this.suff = "M" end
  if (race == "aliens") then this.suff = "A" end
  if not this.suff then return end
  
  for _,slot in pairs(this) do
    if type(slot) == "table" and slot.GetType and slot:GetType() == "uislot" then
      local name = slot:GetName()
      if string.sub(name, 1, 10) == "INVENTORY_" and string.sub(name, 11, 11) == this.suff then
        slot:Show()
      else     
        slot:Hide()
      end  
    end
  end  
  
  uiwnd.Show(this)
end

function Inventory:OnLoad()
  this:RegisterEvent("MAP_LOADED") 
end

function Inventory:OnEvent(event)
  if event == "MAP_LOADED" then
    this:Hide()
  end
end

local function CreateSlots()
	for _,race in ipairs({"INVENTORY_H", "INVENTORY_M", "INVENTORY_A"}) do
	  local dx,dy = 6,6
	  local cols,rows = 13,5
	  local offx,offy = 4,3
	  local idx = 1
	  local r, c
	  for r = 1, rows do
		  for c = 1, cols do
  		
			  local slot = Inventory.DefItemSlot {}
			  slot.index = idx
		    slot.soundItemIn = sounds.inv_item_in
		    slot.soundItemOut = sounds.inv_item_out
		    slot.repo = race
  			
			  if idx == 1 then
				  slot.anchors = { TOPLEFT = { offx,offy } }
			  else
			    if r == 1 then 
			      slot.anchors = { LEFT = { race .. "_slot" .. (idx-1), "RIGHT", dx, 0 } } 
			    else 
			      slot.anchors = { TOP = { race .. "_slot" .. (idx-cols), "BOTTOM", 0, dy } } 
		  	  end
		    end	
        
        Inventory[race .. "_slot" .. idx] = slot
        idx = idx + 1
		  end
	  end
	end
end

CreateSlots()

function Inventory:OnShow()
	--Lobby.InvBtn:GetImagePanel():SetColor(colors.green)
end

function Inventory:OnHide()              
	--Lobby.InvBtn:GetImagePanel():SetColor(colors.white)
end

--
-- DefItemSlot
--

function Inventory.DefItemSlot_OnLoad(this)
  this:RegisterEvent("ITEM_DRAGBEGIN") 
  this:RegisterEvent("ITEM_DRAGEND")
  this:RegisterEvent("ITEM_REJECT")
  this:RegisterEvent("ITEM_UPDATE")
  this:RegisterEvent("MAP_LOADED")
  
  this.OnMouseEnter = function (this)
		local item = this:GetItem()
		if this.ShowTooltip then
		  this:ShowTooltip()
		else
		  ItemTooltip:SetItem(item, this, 0)
		end
    local repo = this:GetInfo()
    if string.sub(repo, 1, 10) == "INVENTORY_" then
      for race, interface in pairs{humans = TechGrid.HumansInterface, mutants = TechGrid.MutantsInterface, aliens = TechGrid.AliensInterface} do
        if not interface:IsHidden() then 
          for k,v in pairs(interface) do
            if type(v) == "table" and string.sub(tostring(k), 1, 9) == "ItemSlot_" and v:CanAccept(this) then
              if this.lightedtarget then this.lightedtarget:SlotLight(false) end
              this.lightedtarget = v
              this.lightedtarget:SlotLight(true)
            end
          end
        end
      end
    end
  end
  
  this.OnMouseLeave = function ()
		if this.HideTooltip then
		  this:HideTooltip()
		else
      ItemTooltip:Hide() 
    end
    if this.lightedtarget then 
      this.lightedtarget:SlotLight(false) 
      this.lightedtarget = nil
    end
  end
  
  this.OnEvent = function (this, event)
    if this.eventCallback then this:eventCallback(event) end
    
    if event == "MAP_LOADED" then
      Inventory.Recycle:Hide()
    end

    if event == "ITEM_UPDATE" then
      this:UpdateFrame()
    end
    
    if event == "ITEM_DRAGBEGIN" then
      DragingItem = true
      Inventory.Recycle:Show()
      this:OnMouseLeave()
      local item = argSlot:GetItem()
      local r,t = this:GetInfo()
      if argSlot == this then 
        game.PlaySnd(this.soundItemOut)
        this:SetColor(ItemColors.dragged)
      end
      if r == "INVENTORY_"..Inventory.suff or r == "REWARDS" then return end
      if (not t or item.type == t) and this:CanAccept(argSlot) then
        this:SlotLight(true)
        this.mark_accept = 1
      end
    end
    
    if event == "ITEM_DRAGEND" then
    	DragingItem = false
      Inventory.Recycle:Hide()
    	this.mark_accept = nil
      this:SlotLight(false)
      this:SetColor()
      local item = this:GetItem() 
      if not item then
        this:UpdateFrame()
        return 
      end
      if argSlot == this then 
				this:OnMouseEnter()
        game.PlaySnd(this.soundItemIn)
      end
      this:UpdateFrame()
    end
    
    if event == "ITEM_REJECT" then
      if argDestSlot == this then 
        game.PlaySnd(sounds.item_reject) 
        ErrText:ShowText("strItemReject")
        return 
      end
    end
  end   
end
