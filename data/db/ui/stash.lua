--
-- Stash UI
-- Static 5-tab stash: each tab has its own dedicated repo and slot set.
--

local stashLayer = 54
local stashTabs = 5
local stashCols = 15
local stashRows = 10
local stashDx = 6
local stashDy = 5

local function GetRepoName(race, tab)
  return "STASH_" .. tostring(tab)
end

local DefStashTab = DefButton {
  virtual = true,
  size = {52, 28},
  font = "Verdana,10b",
  selected = false,

  n_coords = {0, 0, 200, 28},
  h_coords = {0, 28, 200, 56},
  p_coords = {0, 56, 200, 84},
  s_clr = {0, 0, 0, 0},
  n_clr = {100, 100, 100, 255},
  d_clr = {50, 50, 50, 255},

  NormalImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  HighImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },
  PushImage = uiimg { texture = "data/textures/ui/techgrid_race_tab.dds" },

  SelectTab = function(this, select)
    this.selected = select
    if this.demodisabled then
      this.NormalImage:SetTexture(nil, this.n_coords)
      this.HighImage:SetTexture(nil, this.h_coords)
      this.PushImage:SetTexture(nil, this.h_coords)

      this.NormalText:SetColor(this.d_clr)
      this.HighText:SetColor(this.d_clr)
      this.PushText:SetColor(this.d_clr)
    else
      if select then
        this.NormalImage:SetTexture(nil, this.p_coords)
        this.HighImage:SetTexture(nil, this.p_coords)
        this.PushImage:SetTexture(nil, this.h_coords)
        this.NormalText:SetColor(this.s_clr)
        this.HighText:SetColor(this.s_clr)
        this.PushText:SetColor(this.s_clr)
      else
        this.NormalImage:SetTexture(nil, this.n_coords)
        this.HighImage:SetTexture(nil, this.h_coords)
        this.PushImage:SetTexture(nil, this.h_coords)
        this.NormalText:SetColor(this.n_clr)
        this.HighText:SetColor(this.n_clr)
        this.PushText:SetColor(this.n_clr)
      end
    end
  end,

  OnShow = function(this)
    this:SelectTab(this.selected)
  end,
}

local function MakeTab(idx, anchor)
  return DefStashTab {
    layer = stashLayer + 4,
    str = tostring(idx),
    anchors = anchor,
    tab_idx = idx,

    OnClick = function(this)
      if StashUI and StashUI.SetStashTab then
        StashUI:SetStashTab(this.tab_idx)
      end
    end,
  }
end

local stashDef = {
  layer = stashLayer,
  hidden = true,
  mouse = true,
  size = {728, 512},
  anchors = { BOTTOMLEFT = { 10, -10 } },
  race = "humans",
  activeTab = 1,

  BackFill = DefBigBackImage {
    layer = stashLayer - 3,
    anchors = { TOPLEFT = { 3, 3 }, BOTTOMRIGHT = { -3, -3 } },
  },

  Border = uiimg {
    layer = stashLayer - 1,
    texture = "data/textures/ui/big_menu.dds",
    tiled = {23,61,23,61},
    coords = {0, 0, 69, 213},
    anchors = { TOPLEFT = {}, BOTTOMRIGHT = {} },
  },

  Tab1 = MakeTab(1, { TOPLEFT = { 10, 6 } }),
  Tab2 = MakeTab(2, { LEFT = { "Tab1", "RIGHT", 4, 0 } }),
  Tab3 = MakeTab(3, { LEFT = { "Tab2", "RIGHT", 4, 0 } }),
  Tab4 = MakeTab(4, { LEFT = { "Tab3", "RIGHT", 4, 0 } }),
  Tab5 = MakeTab(5, { LEFT = { "Tab4", "RIGHT", 4, 0 } }),
}

local TabSlots = {}

local function BuildTabSlots(tab)
  if not Inventory or not Inventory.DefItemSlot then return end
  local repo = "STASH_" .. tostring(tab)
  local names = {}
  local idx = 1
  for r = 1, stashRows do
    for c = 1, stashCols do
      local slot = Inventory.DefItemSlot { hidden = true }
      slot.index = idx
      slot.repo = repo
      slot.soundItemIn = sounds.inv_item_in
      slot.soundItemOut = sounds.inv_item_out
      slot.layer = stashLayer + 3

      if slot.Empty then slot.Empty.layer = stashLayer + 2 end
      if slot.Level then slot.Level.layer = stashLayer + 3 end
      if slot.Frame then slot.Frame.layer = stashLayer + 4 end

      local slotName = repo .. "_slot" .. idx
      if idx == 1 then
        slot.anchors = { TOPLEFT = { 8, 34 } }
      elseif r == 1 then
        slot.anchors = { LEFT = { repo .. "_slot" .. (idx - 1), "RIGHT", stashDx, 0 } }
      else
        slot.anchors = { TOP = { repo .. "_slot" .. (idx - stashCols), "BOTTOM", 0, stashDy } }
      end

      stashDef[slotName] = slot
      names[idx] = slotName
      idx = idx + 1
    end
  end
  TabSlots[tab] = names
end

for t = 1, stashTabs do
  BuildTabSlots(t)
end

StashUI = uiwnd(stashDef)

function StashUI:OnLoad()
  this:RegisterEvent("MAP_LOADED")
end

function StashUI:OnEvent(event)
  if event == "MAP_LOADED" then
    this:Hide()
  end
end

function StashUI:SetRace(race)
  if race then this.race = race end
end

function StashUI:SetStashTab(tab)
  if type(tab) ~= "number" then return end
  if tab < 1 or tab > stashTabs then return end
  this.activeTab = tab
  this:UpdateTabButtons()
  this:RefreshSlotVisibility()
end

function StashUI:UpdateTabButtons()
  for i = 1, stashTabs do
    local btn = this["Tab" .. i]
    if btn then
      if btn.SelectTab then
        btn:SelectTab(i == this.activeTab)
      else
        btn.checked = (i == this.activeTab) and 1 or 0
        if btn.updatetextures then btn:updatetextures() end
      end
    end
  end
end

function StashUI:RefreshSlotVisibility()
  for t = 1, stashTabs do
    local names = TabSlots[t]
    if names then
      for _, slotName in ipairs(names) do
        local slot = this[slotName]
        if slot then slot:Hide() end
      end
    end
  end

  local repo = GetRepoName(this.race, this.activeTab)
  local names = TabSlots[this.activeTab]
  if not names then return end
  for _, slotName in ipairs(names) do
    local slot = this[slotName]
    if slot then
      slot.repo = repo
      slot:Show()
      slot:UpdateFrame()
    end
  end
end

function StashUI:GetActiveRepoName()
  return GetRepoName(this.race, this.activeTab)
end

function StashUI:ShowForRace(race)
  if race then this.race = race end
  this:UpdateTabButtons()
  this:RefreshSlotVisibility()
  uiwnd.Show(this)
end

function StashUI:Toggle(race)
  if this:IsHidden() then
    this:ShowForRace(race)
  else
    this:Hide()
  end
end
