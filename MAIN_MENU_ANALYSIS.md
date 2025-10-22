# Main Menu System Analysis

## Overview
The main menu system in Worldshift is implemented through the `Lobby` UI component, which serves as the central navigation hub for all game modes and features. The system uses a tab-based interface with different views for each game mode.

## Core Components

### 1. **Lobby Main Window**
**Location**: `data/db/ui/lobby.lua` (lines 2683-2746)

**Purpose**: Central navigation hub with main menu buttons

**Key Buttons**:
- **MissionsBtn** - Campaign missions
- **SLocationBtn** - Special Locations (Cooperative)
- **PVPBtn** - PvP/Deathmatch
- **PracticeBtn** - Practice/Skirmish
- **SettingsBtn** - Game settings
- **StatsBtn** - Player statistics
- **FriendsBtn** - Chat/Friends
- **AbilityBtn** - Technology grid
- **ExitBtn** - Exit game

### 2. **DefLobbyBtn - Button Template**
**Location**: `data/db/ui/lobby.lua` (lines 599-658)

**Purpose**: Template for all lobby navigation buttons

**Properties**:
- **Size**: 137x44 pixels
- **Font**: Verdana,8b
- **Behavior**: `click_on_mouse_down = true`
- **Visual States**: Normal, High, Push with different textures

**Code Structure**:
```lua
local DefLobbyBtn = DefButton {
  virtual = true,
  size = {137,44},
  font = "Verdana,8b",
  click_on_mouse_down = true,
  
  checked = 0,
  
  NormalText = uitext { anchors = { CENTER = { 0,-4 } } },
  HighText  = uitext { anchors = { CENTER = { 0,-4 } } },
  PushText = uitext { anchors = { CENTER = { 0,-4 } } },
  
  OnClick = function(this)
    this:GetParent():OnLobbyBtnClicked(this)
  end,
}
```

### 3. **Navigation System - OnLobbyBtnClicked**
**Location**: `data/db/ui/lobby.lua` (lines 4712-4760)

**Purpose**: Central handler for all main menu button clicks

**Functionality**:
```lua
function Lobby:OnLobbyBtnClicked(btn)
  local view
  if btn == this.MissionsBtn then
    view = this.MissionsView 
    net.ExitLobby()
  elseif btn == this.SLocationBtn then
    local splocations = game.LoadUserData("SpecialLocations")
    if not splocations then
      MessageBox:Alert(TEXT_NO_SP_LOCATIONS, TEXT{"special locations"})
      return
    end
    view = this.SpecialLocView
    net.ExitLobby()
  elseif btn == this.PVPBtn then
    view = this.AutoPlayersView
    this.AutoPlayersView.creategame = this.AutoPlayersView:IsHidden()
    net.ExitLobby()
  elseif btn == this.PracticeBtn then
    view = this.PracticeView 
    net.ExitLobby()
  elseif btn == this.AbilityBtn then
    this:OnRightButton(btn)
    Settings:Hide()
    UserContacts:Hide()
    Stats:Hide()
    if TechGrid:IsHidden() then
      TechGrid:SetAnchor("TOPRIGHT", this, "TOPRIGHT", {-10, 60 })
      TechGrid:Show()
    else
      TechGrid:Hide()
    end
    return
  elseif btn == this.FriendsBtn then
    this:OnRightButton(btn)
    Settings:Hide()
    TechGrid:Hide()
    Stats:Hide()
    if UserContacts:IsHidden() then
      UserContacts:Show()
    else
      UserContacts:Hide()
    end
    return
  elseif btn == this.SettingsBtn then
    this:OnRightButton(btn)
    -- ... settings logic
  elseif btn == this.StatsBtn then
    this:OnRightButton(btn)
    -- ... stats logic
  end
  
  if view then
    this:HideAllViews()
    view:Show()
  end
end
```

## Game Mode Views

### 1. **MissionsView - Campaign Mode**
**Location**: `data/db/ui/lobby.lua` (lines 2767-2948)

**Purpose**: Displays campaign missions

**Components**:
- **ListBox**: Mission selection list
- **Info Panel**: Mission details and preview
- **Start Button**: Launch selected mission

**Features**:
- Mission list with completion status
- Mission preview images
- Mission descriptions and requirements

### 2. **SpecialLocView - Cooperative Mode**
**Location**: `data/db/ui/lobby.lua` (lines 3300-3600)

**Purpose**: Special locations for cooperative play

**Components**:
- **Location List**: Available special locations
- **Quick Join**: Join existing games
- **Create Game**: Host new cooperative game

**Features**:
- Special location selection
- Cooperative game creation
- Quick join functionality

### 3. **AutoPlayersView - PvP Mode**
**Location**: `data/db/ui/lobby.lua` (lines 3600-4000)

**Purpose**: PvP/Deathmatch game mode

**Components**:
- **Player Slots**: 6 slots for players (3v3)
- **Team Setup**: Team configuration
- **Game Creation**: PvP game setup

**Features**:
- Automatic player matching
- Team balance
- PvP game configuration

### 4. **PracticeView - Skirmish Mode**
**Location**: `data/db/ui/lobby.lua` (lines 2950-3300)

**Purpose**: Practice/Skirmish games

**Components**:
- **Game List**: Available practice games
- **Filters**: Game type filters (1v1, 2v2, 3v3, etc.)
- **Quick Join**: Join existing games
- **Create Game**: Host new practice game

**Features**:
- Game filtering by type
- Quick join functionality
- Practice game creation

## Button Layout and Anchoring

### **Top Row - Main Navigation**:
```lua
MissionsBtn = DefLobbyBtn {
  anchors = { TOPLEFT = { 10, 10 } },
  str = TEXT{"missions"},
},

SLocationBtn = DefLobbyBtn {
  anchors = { LEFT = { "RIGHT", "MissionsBtn", 2, 0 } },
  str = TEXT{"locations"},
},

PVPBtn = DefLobbyBtn {
  anchors = { LEFT = { "RIGHT", "SLocationBtn", 2, 0 } },
  str = TEXT{"pvp_caps"},
},

PracticeBtn = DefLobbyBtn {
  anchors = { LEFT = { "RIGHT", "PVPBtn", 2, 0 } },
  str = TEXT{"prac_caps"},
},
```

### **Top Right - Utility Buttons**:
```lua
SettingsBtn = DefLobbyBtn {
  anchors = { TOPRIGHT = { -10, 10 } },
  str = TEXT{"settings"},
},

StatsBtn = DefLobbyBtn {
  anchors = { RIGHT = { "LEFT", "SettingsBtn", -2, 0 } },
  str = TEXT{"stats_btn"},
},

FriendsBtn = DefLobbyBtn {
  anchors = { RIGHT = { "LEFT", "StatsBtn", -2, 0 } },
  str = TEXT{"chat btn lobby"},
},

AbilityBtn = DefLobbyBtn {
  anchors = { RIGHT = { "LEFT", "FriendsBtn", -2, 0 } },
  str = TEXT{"abilities btn"},
},
```

## View Management System

### **HideAllViews Function**:
```lua
function Lobby:HideAllViews()
  this.MissionsView:Hide()
  this.SpecialLocView:Hide()
  this.AutoPlayersView:Hide()
  this.PracticeView:Hide()
end
```

### **View Switching Logic**:
1. **Hide Current View**: Call `HideAllViews()`
2. **Show New View**: Show selected view
3. **Update Button States**: Highlight active button
4. **Network Operations**: `net.ExitLobby()` for game mode changes

## Tooltip System

### **Button Tooltips**:
Each button has hover tooltips with contextual information:

```lua
OnMouseEnter = function(this) 
  NTTooltip:DoShow("missions_btn_tip", this, "BOTTOMLEFT", "TOPLEFT", {0,10}) 
end,
OnMouseLeave = function(this) 
  NTTooltip:Hide() 
end,
```

**Tooltip Keys**:
- `missions_btn_tip` - Campaign missions
- `locations_btn_tip` - Special locations
- `deathmatch_btn_tip` - PvP mode
- `settings_btn_tip` - Game settings
- `stats_btn_tip` - Player statistics
- `chat_btn_tip` - Chat/Friends
- `ability_grid_btn_tip` - Technology grid

## Special Features

### **Demo Mode Restrictions**:
```lua
OnLoad = function(this) 
  if Login.demo then 
    this.demodisabled = true 
  end 
end,
```

Some buttons are disabled in demo mode (Missions, PvP).

### **Right Panel Toggle**:
Utility buttons (Settings, Stats, Friends, Abilities) toggle right-side panels instead of switching main views.

### **Network Integration**:
- `net.ExitLobby()` - Exits current lobby state
- `net.GLStatusClicked()` - Handles network status clicks
- Game mode changes trigger network state updates

## Visual Design

### **Button Appearance**:
- **Size**: 137x44 pixels
- **Font**: Verdana,8b (bold)
- **Spacing**: 2px between buttons
- **Colors**: Orange highlight (#FF8F33) for active states

### **Layout**:
- **Top Row**: Main game mode buttons (left-aligned)
- **Top Right**: Utility buttons (right-aligned)
- **Bottom Right**: Exit and Update buttons
- **Center**: Dynamic content area for selected view

This system provides a comprehensive navigation interface that handles all game modes, settings, and social features through a unified, tab-based interface.
