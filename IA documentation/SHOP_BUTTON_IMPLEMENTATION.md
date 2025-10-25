# PvP Shop Button - Complete Implementation

## Summary
Successfully added a PvP shop button to the game's main menu, allowing players to directly access the shop to buy and reroll items using Battle Points.

## Implemented Changes

### 1. **Shop Button in Main Lobby**
**File**: `data/db/ui/lobby.lua` (lines 2712-2717)

```lua
ShopBtn = DefLobbyBtn {
  anchors = { LEFT = { "RIGHT", "PracticeBtn", 2, 0 } },
  str = TEXT{"shop"},
  OnMouseEnter = function(this) NTTooltip:DoShow("shop_btn_tip", this, "BOTTOM", "TOP", {0,10}) end,
  OnMouseLeave = function(this) NTTooltip:Hide() end,
},
```

**Features**:
- **Position**: Between PracticeBtn and SettingsBtn
- **Size**: 137x44 pixels (standard DefLobbyBtn)
- **Tooltip**: Information about shop functionality

### 2. **Complete Shop View**
**File**: `data/db/ui/lobby.lua` (lines 2957-3073)

**Components**:
- **Title**: "SHOP" with consistent styling
- **Battle Points Display**: Shows player's current points
- **5 Item Slots**: Using DefPVPSlot (same system as post-game shop)
- **Reroll Button**: Changes item offer (costs 5 BP)
- **Refresh Button**: Manually updates the shop

**Functionalities**:
```lua
RefreshShop = function(this)
  -- Force refresh of PvP items
  game.RerollPVPItemsOffer()
  this.BattlePointsDisplay:UpdateBP()
end,

OnShow = function(this)
  this.BattlePointsDisplay:UpdateBP()
  this:RefreshShop()
end,
```

### 3. **Navigation Logic**
**File**: `data/db/ui/lobby.lua` (lines 4860-4862)

```lua
elseif btn == this.ShopBtn then
  view = this.ShopView
  net.ExitLobby()
```

**Integration**:
- Integrates perfectly with existing navigation system
- Uses same pattern as other main buttons
- Automatically handles hide/show views

### 4. **Localized Texts**

#### **Main Button**:
**File**: `data/texts/en/ui.tsv` (line 47)
```
shop	SHOP
```

#### **Tooltip**:
**File**: `data/texts/en/ui;2.tsv` (line 32)
```
shop_btn_tip	Buy and reroll items using Battle Points
```

#### **Refresh Button**:
**File**: `data/texts/en/ui;1.tsv` (line 32)
```
refresh	REFRESH
```

## Shop Functionalities

### **Item System**:
- **5 item slots** using the same system as post-game shop
- **PVP repository** with items of different qualities
- **Direct click** to buy items

### **Battle Points System**:
- **Real-time display** of current BP
- **Reroll cost**: 5 Battle Points
- **Validation**: Checks if there are enough BP before rerolling

### **Control Buttons**:
- **Reroll**: Changes all items (costs BP)
- **Refresh**: Updates shop without cost

## Integration with Existing Systems

### **Component Reuse**:
- **DefPVPSlot**: Same component as post-game shop
- **DefLobbyBtn**: Same style as other lobby buttons
- **Navigation system**: Integrated with OnLobbyBtnClicked

### **Visual Consistency**:
- **Colors**: Orange (#FF8F33) for titles and active elements
- **Fonts**: Verdana for titles, Tahoma for text
- **Layout**: Same pattern as other lobby views

### **Game Functions**:
- **`game.GetPlayerBattlePoints()`**: Gets current BP
- **`game.RerollPVPItemsOffer()`**: Rerolls PvP items
- **`MessageBox:Alert()`**: Shows errors if not enough BP

## Menu Location

### **Button Order**:
1. **Missions** (Campaign)
2. **Locations** (Cooperative)
3. **PvP** (Deathmatch)
4. **Practice** (Skirmish)
5. **Shop** (Shop) ← **NEW**
6. **Settings** (Settings)
7. **Stats** (Statistics)
8. **Friends** (Chat)
9. **Abilities** (Ability Grid)

## Implementation Advantages

### **Direct Access**:
- Players can access the shop without needing to play matches
- Allows item management at any time

### **Consistency**:
- Uses exactly the same system as post-game shop
- Maintains the same user experience

### **Flexibility**:
- Easy to extend with new functionalities
- Integrated with existing navigation system

## Modified Files

1. **`data/db/ui/lobby.lua`** - Main logic and shop view
2. **`data/texts/en/ui.tsv`** - Button text
3. **`data/texts/en/ui;2.tsv`** - Button tooltip
4. **`data/texts/en/ui;1.tsv`** - Refresh button text

## Implementation Status

✅ **Completed**:
- Button added to lobby layout
- Shop view created with all components
- Navigation logic implemented
- Localized texts added
- Integration with existing systems

The implementation is ready to use and provides complete access to PvP shop functionality from the main menu.
