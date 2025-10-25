# Shop Cheats Implementation - Complete Guide

## Overview
Successfully implemented shop cheats to make the PvP shop more accessible and fun to use. All items are now free and players can easily get Battle Points.

## Changes Made

### 1. **Battle Points Limit Increased**
**File**: `data/db/pvp/pvp.dt` (line 150)

**Change**: Increased maximum Battle Points from 600 to 9999
```dt
maxpoints = 9999
```

**Benefits**:
- Players can accumulate much more BP
- No artificial cap limiting progression
- More flexibility for testing and gameplay

### 2. **All Item Costs Set to 0**
**File**: `data/db/pvp/pvp.dt` (lines 142-147)

**Changes**: All item costs reduced to 0 BP
```dt
costlvl1 = 0    -- Was 2
costlvl2 = 0    -- Was 8  
costlvl3 = 0    -- Was 20
costlvl4 = 0    -- Was 50
costlvl5 = 0    -- Was 90
costoffer = 0   -- Was 5 (reroll cost)
```

**Benefits**:
- **Free Items**: All items can be purchased without spending BP
- **Free Rerolls**: Changing item offers costs nothing
- **No Restrictions**: Players can buy any item regardless of BP

### 3. **Give BP Button Added**
**File**: `data/db/ui/lobby.lua` (lines 3124-3137)

**New Button**: "GIVE BP" button next to Refresh button

**Functionality**:
```lua
GiveBPBtn = DefButton {
  size = {120,26},
  layer = "+1",
  anchors = { LEFT = { "RIGHT", "RefreshBtn", 10, 0 } },
  str = TEXT{"give_bp"},
  
  OnClick = function(this)
    -- Give 9999 battle points to player
    game.AddPlayerBattlePoints(9999)
    local par = this:GetParent():GetParent()
    par.BattlePointsDisplay:UpdateBP()
    MessageBox:Alert("9999 Battle Points added!", "Battle Points Added")
  end,
},
```

**Features**:
- **Instant BP**: Adds 9999 Battle Points instantly
- **Visual Feedback**: Shows confirmation message
- **Real-time Update**: BP display updates immediately
- **Easy Access**: Located next to other shop controls

### 4. **Localized Text Added**
**File**: `data/texts/en/ui;1.tsv` (line 35)

**Added**: Text for the new button
```
give_bp	GIVE BP
```

## Shop Button Layout

### **Button Order** (left to right):
1. **Reroll** - Changes all items (now free)
2. **Refresh** - Updates shop display
3. **GIVE BP** - Adds 9999 Battle Points ← **NEW**

### **Button Features**:
- **Size**: 120x26 pixels each
- **Spacing**: 10px between buttons
- **Style**: Consistent with existing shop buttons
- **Position**: Bottom area of shop view

## How It Works

### **Free Shopping Experience**:
1. **Open Shop**: Click SHOP button in main menu
2. **Get BP**: Click "GIVE BP" to get 9999 Battle Points
3. **Buy Items**: Click any item to purchase (costs 0 BP)
4. **Reroll**: Click "Reroll" to change items (costs 0 BP)
5. **Refresh**: Click "Refresh" to update display

### **Battle Points System**:
- **Maximum**: 9999 BP (was 600)
- **Item Costs**: All items cost 0 BP
- **Reroll Cost**: 0 BP (was 5 BP)
- **Easy Access**: One-click to get 9999 BP

## Technical Implementation

### **Game Functions Used**:
- **`game.AddPlayerBattlePoints(9999)`**: Adds BP to player
- **`game.RerollPVPItemsOffer()`**: Refreshes item offers
- **`game.GetPlayerBattlePoints()`**: Gets current BP count

### **UI Integration**:
- **DefButton**: Uses standard button template
- **Anchoring**: Properly positioned relative to other buttons
- **Event Handling**: Integrated with shop view system
- **Display Updates**: Real-time BP counter updates

## Benefits

### **For Players**:
✅ **Free Items**: No BP restrictions on purchases  
✅ **Easy Testing**: Can test any item combination  
✅ **Quick Access**: One-click BP generation  
✅ **No Grinding**: Skip BP farming entirely  

### **For Development**:
✅ **Easy Testing**: Test shop functionality without restrictions  
✅ **Quick Iteration**: Rapidly test different item combinations  
✅ **Debug Friendly**: No BP-related debugging issues  
✅ **User Friendly**: Makes shop accessible to all players  

## Modified Files

1. **`data/db/pvp/pvp.dt`** - BP limits and costs
2. **`data/db/ui/lobby.lua`** - Give BP button
3. **`data/texts/en/ui;1.tsv`** - Button text

## Usage Instructions

### **For Players**:
1. Open the game and go to main menu
2. Click "SHOP" button
3. Click "GIVE BP" to get 9999 Battle Points
4. Click any item to purchase (it's free!)
5. Use "Reroll" to change items (also free!)

### **For Testing**:
- All shop functionality is now unrestricted
- Can test item combinations without BP limitations
- Easy to verify shop mechanics work correctly
- No need to play matches to earn BP

The shop is now completely accessible and fun to use, with all restrictions removed and easy BP generation available!
