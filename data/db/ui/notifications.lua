--                                                                                             
-- NOTIFICATIONS                                                                               
--                                                                                             

local add_space = 5
local anim_time = 1

local DefNoteWnd = uiwnd {
	virtual = true,
	hidden = true,
	size = {255,50},
	uiimg { color = {0,0,0,80} },
	
	Image = uiimg {
		size = {45,45},
		anchors = { LEFT = { 5, 0 } },
	},
	
	Text = uitext {
		size = {195,45},
		halign = "LEFT", valign = "TOP",
		font = "Arial,10",
		anchors = { RIGHT = { -5, 0 } },
	},
	
	fader = uiwnd {},
}

Notifications = uiwnd {
  size = {250,215},
  anchors = { TOPLEFT = { 5, 120 } },
  
  Note_1 = DefNoteWnd {},
  Note_2 = DefNoteWnd {},
  Note_3 = DefNoteWnd {},
  Note_4 = DefNoteWnd {},
  Note_5 = DefNoteWnd {},
}

function Notifications:OnLoad()
  table.insert(GameUI.topWindows.humans, this)
	this.visible = {}
	this.hidden = {}
	this.space = this.Note_1:GetSize().y
    
  local i = 1  
	while 1 do
		local Note = this["Note_" .. i] if not Note then break end
		this.hidden[i] = Note
		i = i + 1
	end
	
	this.avatar_1 = "data/textures/avatars/def.bmp"
	this.avatar_2 = "data/textures/avatars/ceci1.bmp"
	this.avatar_3 = "data/textures/avatars/MishoBCrossEyed.bmp"
	this.avatar_4 = "data/textures/avatars/Oleg.bmp"
	this.avatar_5 = "data/textures/avatars/Otto.BMP"
	this.avatar_6 = "data/textures/avatars/veso.bmp"
end 

function Notifications:AddNote(avatar_idx, text)
	if this.elapsed then return end             
	if #this.hidden < 2 then this:HideNote() end
	local	Note = this.hidden[1]
	
	if avatar_idx == 0 then avatar_idx = math.random(1, 6) end
	
	Note.Image:SetTexture(this["avatar_" .. avatar_idx])
	Note.Text:SetStr(text)
	
	if #this.visible > 0 then 
		this.elapsed = 0 
		Note:SetAnchor("BOTTOM", this, "TOP")
		this.visible[1]:SetAnchor("TOP", Note, "BOTTOM", {0, add_space})
	else
		Note:SetAnchor("TOP", this, "TOP")
		this:ShowNote()
	end	
end

function Notifications:HideNote()
  local vcnt = #this.visible if vcnt == 0 then return end
  Transitions:Fade(this.visible[vcnt])
	table.insert(this.hidden, this.visible[vcnt])
	table.remove(this.visible, vcnt)
end

function Notifications:ShowNote()
	Transitions:Fade(nil, this.hidden[1])
	table.insert(this.visible, 1, this.hidden[1])
	table.remove(this.hidden, 1)                     
	local fader = this.visible[1].fader
	fader:Show()
	Transitions:Fade(fader, nil, function() Notifications:HideNote() end, 10)
end

function Notifications:OnUpdate()
	if not this.elapsed then return end     
	this.elapsed = this.elapsed + argElapsed
	local oy = (this.elapsed / anim_time) * this.space
	if oy > this.space then oy = this.space end
	this.hidden[1]:SetAnchor("BOTTOM", this, "TOP", {0,oy})
	if oy == this.space then
		this.elapsed = nil 
		this:ShowNote()
	end
end
