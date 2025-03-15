--
-- Credits
--
local styles = {
  firm = { type = "text", height = 30, font = "Trebuchet MS,14b", color = {255,255,255} },
  position = { type = "text", height = 20, font = "Trebuchet MS,10b", color = {220,35,0} },
  default = { type = "text", height = 20, font = "Tahoma,11", color = {255,255,255} },
  url = { type = "text", height = 20, font = "Tahoma,11", color = {112,125,208} },
  dark = { type = "text", height = 20, font = "Tahoma,10", color = {130,130,130} },
  whiteline = { type = "image", width = 256, height = 2, texture = "data/textures/ui/white_line.dds", coords = {0,0,256,2} },
}

Credits = uiwnd {
  mouse = true,
  keyboard = true,
  
  Back = uiimg {
    layer = "-1",
    texture = "data/textures/ui/credits_back.dds",
    coords = {0,0,1280,960},
    anchors = { TOPLEFT = { 0,0 } , BOTTOMRIGHT = { 0,0 } },
  },
  
  FadeImage = uiimg {
    layer = "+1",
    texture = "data/textures/ui/credits_ontop.dds",
    coords = {0,0,1280,960},
    anchors = { TOPLEFT = { 0,0 } , BOTTOMRIGHT = { 0,0 } },
  },
}
                                              
function Credits:OnShow()
  this.sound = game.PlaySnd(sounds["credits_1"])
  local txtw = 700
  local initdy = 550
  if not this.Row_1 then
    local tbl = game.LoadCredits()
    this.totalheight = 0
    for i,v in ipairs(tbl) do
      local row
      local cs = styles[v.style]
      if cs.type == "image" then
        this.totalheight = this.totalheight + cs.height
        row = uiimg {
          size = {cs.width, cs.height},
          texture = cs.texture,
          coords = cs.coords,
        }
      else
        row = uitext {
          size = {txtw, cs.height},
          font = cs.font,
          color = cs.color,
        }
      end
      if i == 1 then
        row.dy = initdy
        row.anchors = { TOP = { "Credits", 0,row.dy } }
      else
        row.anchors = { TOP = { "BOTTOM", "Credits.Row_" .. (i-1), 0,0 } }
      end
      row.type = cs.type
      this["Row_"..i] = row
    end
    this:CreateChildren()
    
    for i,v in ipairs(tbl) do
      local row = this["Row_"..i]
      if row.type == "text" and v.text then
        row:SetStr("<p>"..v.text)
        --row:SetStr(v.text)
        local h = row:GetStrHeight()
        row:SetSize{txtw, h}
        this.totalheight = this.totalheight + h
      end
    end
  end
  this.Row_1.dy = initdy
  this.Row_1:SetAnchor("TOP", this, "TOP", {0,initdy})
  local sz = this:GetSize()
  Transitions:CallRepeat(animtext, ((1/90)*sz.y)/960)
end

function animtext(param, elapsed)
  if Credits.paused then return end
  Credits.Row_1.dy = Credits.Row_1.dy - 1
  Credits.Row_1:SetAnchor("TOP", Credits, "TOP", {0, Credits.Row_1.dy})
  --if -Credits.Row_1.dy > Credits.totalheight then
  --end
  if Credits:IsHidden() then 
    return 0
  end
end

function Credits:OnHide()
  game.StopSnd(this.sound) this.sound = nil
  this.paused = nil
  game.MapBaseToScreen(false)
  Login:Show()
end

function Credits:OnMouseDown()
  this:Hide()
end

function Credits:OnKeyDown(key)
  if argKey == "Space" then
    if this.paused then this.paused = nil else this.paused = true end
  end
  if argKey == "Escape" or argKey == "Return" then
    this:Hide()
  end
end
