--                                                                                             
-- Tooltip                                                                                     
--                                                                                             

local tooltiplayer = 999999999
   
Tooltip = uiwnd {
  size = {300,100},
  layer = tooltiplayer,
  
  Frame = DefCornerFrameImage {
    layer = "-2",
  },

  TitleImg = uiwnd { 
    layer = "-1",
    size = {0,24},
    anchors = { 
      TOPLEFT = { 4, 4 },
      TOPRIGHT = { -4, 4 },
    },
  },
  
  Title = uitext { 
  	font = "Verdana,11b",
  	layer = "+1",
    anchors = { CENTER = { "TitleImg", 12, 2 } },
    color = {255,255,0},
    halign = "LEFT",
  },
  
  Cost = uitext {
  	hidden = true,
  	layer = "+1",
  	font = "verdana,9b",
    anchors = { LEFT = { "LEFT", "Title" } },
    color = {255,255,0},
    halign = "LEFT",
  },
  
  Text = uitext { 
    font = "Verdana,11",
  	layer = "+2",
    halign = "LEFT", valign = "TOP",
    anchors = { TOPLEFT = { "BOTTOMLEFT", "TitleImg", 7,10}, BOTTOMRIGHT = { -5,-2 } },
  },
}

function Tooltip:OnLoad()
  this:RegisterEvent("RES_CHANGE")
end

function Tooltip:OnHide()
	this.Cost:Hide()
	this.Cost:SetStr("")
	this.lastCost = nil
	this.creator = nil
  this.actionBtn = nil
end

function Tooltip:OnUpdate()
  if (this.creator and this.creator:IsHidden()) or (this.owner and this.owner:IsHidden()) then
    this:Hide()
  end
end

function Tooltip:OnEvent(event)
  if event == "RES_CHANGE" then
    this:SetCost(this.lastCost)
  end
end

function Tooltip:AttachTo(owner, point, target, targetPoint, offset)
  if owner then
  	this.owner = owner           
 	else
 		this.owner = target
 	end
  this:SetAnchor(point, target, targetPoint, offset)
end

function Tooltip:SetCost(cost)
	this.lastCost = cost
	if not cost then 
		this.Cost:Hide()
		return 
	end
	local sc,_,_,cd = game.GetFmtCost(cost)
	if not sc then this.Cost:Hide() return end
	if cd then
  	this.Cost:SetStr('(' .. sc .. ',' .. cd .. ')')
  else
  	this.Cost:SetStr('(' .. sc .. ')')
  end
	this.Cost:SetAnchor("LEFT", this.Title, "LEFT", { this.Title:GetStrWidth() + 5, 0 } )
	this.Cost:Show()
end

function Tooltip:SetRequirements(reqs)
  if reqs then
  	local s = this.Text:GetStr()
    s = s .. "<nl><color=200,200,0>Requires:</c>"
    for i,v in ipairs(reqs) do
      local c
      if string.sub(reqs[i], 1, 1) == "+" then
        c = colors.GetStr("requ_met")
      else
        c = colors.GetStr("requ_notmet")
      end
      s = s .. "<nl><color=" .. c .. ">  " .. TEXT{string.sub(reqs[i], 2)..".name"} .. "</>"
    end
    this.Text:SetStr(s)
  end
end  
   
--
-- Tooltip - no title
NTTooltip = uiwnd {
  size = {300,100},
  layer = tooltiplayer,
  
  Frame = DefCornerFrameImage {
    layer = "-1",
  },

  Text = uitext { 
    font = "Verdana,11",
  	layer = "+1",
    halign = "LEFT", valign = "TOP",
    anchors = { TOPLEFT = {7,7}, BOTTOMRIGHT = {-7,-7} },
  },

  DoShow = function(this, ttkey, tgui, tgpoint, ttpoint, offset)
    this.owner = tgui
    this:SetAnchor(ttpoint, tgui, tgpoint, offset)
    this.Text:SetStr("<p>"..TEXT{ttkey})
    local sz = this:GetSize()
    this:SetSize{sz.x, this.Text:GetStrHeight() + 15}
    this:Show()
  end,
  
  OnUpdate = function(this)
    if this.owner and this.owner:IsHidden() then
      this:Hide()
    end
  end,
}
