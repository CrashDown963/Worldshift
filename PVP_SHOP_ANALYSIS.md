# PvP Shop System Analysis

## Overview
The PvP shop system appears after skirmish or PvP matches, allowing players to purchase items using Battle Points (BP). The system consists of several key components working together.

## Key Components

### 1. **DefPVPSlot** - Item Display Component
**Location**: `data/db/ui/victory.lua` (lines 149-197)

**Purpose**: Displays individual items in the PvP shop

**Key Features**:
- **Repository**: Uses `repo = "PVP"` (5 slots defined in `globals.dt`)
- **Visual Elements**:
  - `ItemMoveNif`: Animation effect when item is taken
  - `SelImage`: Selection highlight (`reward_chosen.dds`)
- **Interaction**: Click to purchase item directly
- **Size**: 57x57 pixels per slot

**Code Structure**:
```lua
local DefPVPSlot = Inventory.DefItemSlot { 
  virtual = true,
  repo = "PVP",
  
  ItemMoveNif = uinif {
    layer = "+10",
    hidden = true,
    size = {10,10},
    nif = "Data/Models/MiscObjects/Interface_item_effect.nif",
    anchors = {CENTER = {2, 0}},
    scale = 0.35,
  },	    
  
  SelImage = uiimg {
    layer = "+3",
    hidden = true,
    size = {57,57},
    texture = "data/textures/ui/reward_chosen.dds",
    coords = {0,0,64,64},
  },
  
  OnMouseDown = function(this)
    if this:GetItem() then
      local quality = this:GetItem().quality
      local res = this:MoveItem("REWARDS")
      -- Purchase logic...
    end
  end,
}
```

### 2. **Shop Layout** - 5 Item Slots
**Location**: `data/db/ui/victory.lua` (lines 729-757)

**Structure**:
- `Rew1` through `Rew5`: Five DefPVPSlot instances
- **Layout**: Horizontal arrangement with 15px spacing
- **Anchoring**: Each slot anchored to the previous one

```lua
Rew1 = DefPVPSlot {
  index = 0,
  ind = 0,
  anchors = { LEFT = { 0, 0 } },
},

Rew2 = DefPVPSlot {
  index = 1,
  ind = 1,
  anchors = { LEFT = { "RIGHT", "Rew1", 15, 0 } },
},
-- ... Rew3, Rew4, Rew5 follow same pattern
```

### 3. **Reroll Buttons** - Item Refresh System

#### **ChangeOfferBtn** - Main Reroll Button
**Location**: `data/db/ui/victory.lua` (lines 760-775)

**Purpose**: Rerolls all 5 items in the shop

**Functionality**:
```lua
ChangeOfferBtn = DefButton {
  size = {120,26},
  str = TEXT("chg_off_btn"), // "Change Offer" button
  
  OnClick = function(this)
    if game.RerollPVPItemsOffer() == 1 then
      local par = this:GetParent()
      par:UpdateBPText() // Update battle points display
    else
      MessageBox:Alert(TEXT{"no_bpoints"}, TEXT{"no_bpoints_ttl"})
    end
  end,
}
```

#### **GetOfferBtn** - Initial Offer Button
**Location**: `data/db/ui/victory.lua` (lines 854-875)

**Purpose**: Gets initial offer when player loses (no items shown initially)

**Functionality**:
```lua
GetOfferBtn = DefButton {
  size = {120,26},
  str = TEXT("get_off_btn"), // "Get Offer" button
  
  OnClick = function(this)
    if game.RerollPVPItemsOffer() == 1 then
      local par = this:GetParent()
      par:UpdateBPText()
      par.LostInfoTxt:Hide()
      par.GetOfferBtn:Hide()
      par.SkipLostBtn:Hide()
      
      // Show all 5 item slots
      par.Rew1:Show() par.Rew2:Show() par.Rew3:Show() 
      par.Rew4:Show() par.Rew5:Show()
      par.ChangeOfferBtn:Show() 
      par.SkipBtn:Show()   
    else
      MessageBox:Alert(TEXT{"no_bpoints"}, TEXT{"no_bpoints_ttl"})
    end   
  end
}
```

### 4. **Battle Points System**

#### **Battle Points Display**
**Location**: `data/db/ui/victory.lua` (lines 902-909)

**Function**:
```lua
UpdateBPText = function(this)
  local points = game.GetPlayerBattlePoints()
  this.BattlePointsNum.text:SetStr("<p>"..points)
end
```

#### **Battle Points Configuration**
**Location**: `data/db/pvp/pvp.dt` (lines 141-151)

**Costs**:
- `costoffer = 5` - Cost to reroll items (5 BP)
- `winpoints = 50` - BP gained on win
- `losspoints = 9` - BP gained on loss
- `maxpoints = 600` - Maximum BP cap

### 5. **Item Repository System**

#### **PVP Repository**
**Location**: `data/db/items/globals.dt` (line 8)

```dt
PVP { count = 5; accept_all = 1; }
```

#### **Item Sources**
**Location**: `data/db/items/loot index.tsv` and `drop.tsv`

**Key Loot Tables**:
- `10` - PVP GENERIC (50% common, 25% rare, 10% epic, 5% legendary, 1% unique)
- `40` - PvP Rewards (same distribution)

## System Flow

### **On Victory**:
1. Shop shows 5 items immediately
2. `ChangeOfferBtn` available for rerolling
3. `SkipBtn` to close shop

### **On Defeat**:
1. Shows `LostInfoTxt` and `GetOfferBtn`
2. No items visible initially
3. Player clicks "Get Offer" to reveal items
4. Then same as victory flow

### **Reroll Process**:
1. Check if player has enough BP (5 points)
2. Call `game.RerollPVPItemsOffer()`
3. Update BP display
4. Refresh all 5 item slots with new items

### **Purchase Process**:
1. Click on item slot
2. `MoveItem("REWARDS")` transfers item to inventory
3. Play sound effect and animation
4. Update BP display
5. Fill empty slot with new item

## Visual Elements

### **Item Slots**:
- **Size**: 57x57 pixels each
- **Spacing**: 15px between slots
- **Selection**: Blue highlight (`reward_chosen.dds`)
- **Animation**: Particle effect on purchase

### **Buttons**:
- **Size**: 120x26 pixels
- **Text**: Localized button labels
- **Position**: Bottom-right area of shop

### **Battle Points Display**:
- Shows current BP count
- Updates after each reroll/purchase
- Maximum of 600 BP

## Technical Notes

- **Repository System**: Uses `Inventory.DefItemSlot` base class
- **Item Movement**: `MoveItem("REWARDS")` transfers to player inventory
- **Animation System**: Uses `Transitions:CallOnce()` for smooth effects
- **Sound Effects**: `game.PlaySnd(sounds.item_take)` on purchase
- **Error Handling**: Shows alert if insufficient BP or purchase fails

This system provides a complete item shop experience with reroll mechanics, battle point economy, and smooth UI interactions.
