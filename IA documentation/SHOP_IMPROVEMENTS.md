# PvP Shop Improvements - Problem Fixes

## Identified Problems
1. **Purchased items don't go to main inventory** - They went to temporary `REWARDS` repository
2. **Slots don't refresh after purchasing** - Empty slots remained until clicking "Get Offer"

## Implemented Solutions

### 1. **Correct Item Destination**
**File**: `data/db/ui/lobby.lua` (lines 686-694)

**Change**: Items now go directly to the player's main inventory based on their race:

```lua
local race = game.GetPlayerRace()
local targetRepo = "INVENTORY_H" -- Default to humans

-- Determine correct inventory based on player race
if race == "mutants" then
  targetRepo = "INVENTORY_M"
elseif race == "aliens" then
  targetRepo = "INVENTORY_A"
end

local res = this:MoveItem(targetRepo)
```

**Inventory Repositories**:
- **`INVENTORY_H`** - Human Inventory (65 slots)
- **`INVENTORY_M`** - Mutant Inventory (65 slots)
- **`INVENTORY_A`** - Alien Inventory (65 slots)

### 2. **Automatic Slot Refresh**
**File**: `data/db/ui/lobby.lua` (lines 704-705)

**Change**: After purchasing an item, the shop refreshes automatically:

```lua
-- Refresh the shop to show new items
shopView:RefreshShop()
```

**Functionality**:
- Calls `RefreshShop()` which executes `game.RerollPVPItemsOffer()`
- Updates Battle Points display
- Empty slots are immediately filled with new items

### 3. **Confirmation Messages**
**File**: `data/texts/en/ui;1.tsv` (lines 30-31)

**Added**: Success messages to confirm purchase:

```lua
-- Show success message
MessageBox:Alert(TEXT{"item_purchased"}, TEXT{"purchase_success"})
```

**Texts**:
- `item_purchased` - "Item purchased successfully!"
- `purchase_success` - "Purchase Successful"

## Improved Purchase Flow

### **Before**:
1. Click item → Goes to `REWARDS` (temporary)
2. Slot remains empty until clicking "Get Offer"
3. No purchase confirmation

### **After**:
1. Click item → Goes to player's main inventory
2. Slot refreshes automatically with new item
3. Purchase success confirmation message
4. Battle Points update in real-time

## Automatic Race Detection

### **Implemented Logic**:
```lua
local race = game.GetPlayerRace()
local targetRepo = "INVENTORY_H" -- Default to humans

if race == "mutants" then
  targetRepo = "INVENTORY_M"
elseif race == "aliens" then
  targetRepo = "INVENTORY_A"
end
```

### **Benefits**:
- **Automatic**: No manual configuration required
- **Correct**: Always goes to the player's race inventory
- **Robust**: Fallback to humans if there are issues

## Improved User Experience

### **Visual Feedback**:
✅ **Sound**: `game.PlaySnd(sounds.item_take)`  
✅ **Animation**: `ItemMoveNif:Show()`  
✅ **Confirmation**: Success message  
✅ **Refresh**: New item appears immediately  

### **System Feedback**:
✅ **Battle Points**: Updated in real-time  
✅ **Inventory**: Items go to correct location  
✅ **Slots**: Refresh automatically  
✅ **Errors**: Clear messages if purchase fails  

## Modified Files

1. **`data/db/ui/lobby.lua`** - Purchase logic and refresh
2. **`data/texts/en/ui;1.tsv`** - Confirmation messages

## Improvement Status

✅ **Correct Destination**: Items go to main inventory  
✅ **Automatic Refresh**: Slots fill immediately  
✅ **Confirmation**: Success messages added  
✅ **Race Detection**: Automatic and robust  
✅ **Improved Experience**: Complete user feedback  

The shop now provides a smooth and complete purchase experience, with items going directly to the main inventory and slots refreshing automatically.
