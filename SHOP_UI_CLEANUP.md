# Shop UI Cleanup - Removed Free Reroll Button and Added BP Tip

## Changes Made

### 1. **Removed FREE REROLL Button**
**File**: `data/db/ui/lobby.lua` (lines 3128-3143)

**Removed**: The entire `GiveBPBtn` component that provided free rerolls
- **Button Size**: 120x26 pixels
- **Functionality**: Called `game.RerollPVPItemsOffer()` without BP cost
- **Reason**: No longer needed since PvP matches give 9999 BP

### 2. **Added BP Tip Text**
**File**: `data/texts/en/ui;1.tsv` (line 35)

**Added**: Localized text for the BP tip
```
bp_tip	Tip: Play any Skirmish match to get 9999 Battle Points!
```

**File**: `data/db/ui/lobby.lua` (lines 3102-3110)

**Added**: Text component in the shop area
```lua
BPTipText = uitext {
  layer = "+1",
  size = {400, 40},
  anchors = { TOP = { "BOTTOM", "Rew1", 0, 5 } },
  color = {200, 200, 200},
  font = "Tahoma,9",
  halign = "CENTER",
  str = TEXT{"bp_tip"},
},
```

## Shop Layout Updated

### **Current Shop Components**:

#### **Top Section**:
- **Title**: "SHOP"
- **Battle Points Display**: Shows current BP count

#### **Middle Section**:
- **6 Item Slots**: Rew1 through Rew6
- **BP Tip Text**: "Tip: Play any Skirmish match to get 9999 Battle Points!" ← **NEW**

#### **Bottom Section**:
- **Reroll Button**: Changes all items (costs 1 BP)
- **Refresh Button**: Updates shop display

### **Removed Components**:
- ❌ **FREE REROLL Button**: No longer needed

## User Experience Improvements

### **Before**:
- Confusing FREE REROLL button
- No guidance on how to get BP
- Multiple ways to reroll items

### **After**:
- Clear tip on how to get BP
- Simplified button layout
- Natural progression through PvP matches

## Technical Details

### **Text Component Properties**:
- **Size**: 400x40 pixels
- **Position**: Below item slots, above buttons
- **Color**: Light gray (200, 200, 200)
- **Font**: Tahoma, 9pt
- **Alignment**: Centered

### **Layout Flow**:
1. **Title and BP Display** (top)
2. **6 Item Slots** (middle)
3. **BP Tip Text** (below slots)
4. **Reroll and Refresh Buttons** (bottom)

## Benefits

### **For Players**:
✅ **Clear Guidance**: Know exactly how to get BP  
✅ **Simplified UI**: Fewer confusing buttons  
✅ **Natural Progression**: Learn to play PvP for BP  
✅ **Better UX**: Cleaner, more intuitive interface  

### **For Development**:
✅ **Cleaner Code**: Removed unnecessary button logic  
✅ **Better UX Design**: Clear user guidance  
✅ **Maintainable**: Simpler shop interface  
✅ **Educational**: Teaches players about PvP rewards  

## Modified Files

1. **`data/db/ui/lobby.lua`** - Removed GiveBPBtn, added BPTipText
2. **`data/texts/en/ui;1.tsv`** - Added bp_tip text

## Current Shop Functionality

### **How to Get BP**:
1. **Play any Skirmish match** (win or lose)
2. **Receive 9999 BP** automatically
3. **Use BP in shop** for rerolls

### **Shop Usage**:
- **Items**: Free (0 BP cost)
- **Reroll**: 1 BP cost
- **Refresh**: Free display update

The shop now provides clear guidance to players on how to obtain Battle Points while maintaining a clean, simple interface focused on the core functionality.
