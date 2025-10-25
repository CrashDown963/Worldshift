# Shop Layout Fix - Centered Elements and Proper Spacing

## Problem Identified
The shop buttons and tip text were positioned incorrectly, causing them to overflow outside the shop window boundaries and not be properly centered.

## Layout Issues Fixed

### **Before (Problems)**:
- **BPTipText**: Positioned too close to Rew1, small size (400x40)
- **ChangeOfferBtn**: Anchored to Rew1, causing misalignment
- **RefreshBtn**: Only horizontally aligned to ChangeOfferBtn
- **Result**: Elements spilled outside the shop window

### **After (Solutions)**:

#### **1. BPTipText Improvements**
**File**: `data/db/ui/lobby.lua` (lines 3102-3110)

**Changes**:
- **Size**: Increased from 400x40 to 500x30 pixels
- **Position**: Better spacing from Rew1 (10px gap)
- **Alignment**: Centered horizontally with `halign = "CENTER"`

```lua
BPTipText = uitext {
  layer = "+1",
  size = {500, 30},  -- Increased width, reduced height
  anchors = { TOP = { "BOTTOM", "Rew1", 0, 10 } },  -- Better spacing
  color = {200, 200, 200},
  font = "Tahoma,9",
  halign = "CENTER",
  str = TEXT{"bp_tip"},
},
```

#### **2. Button Layout Restructure**
**File**: `data/db/ui/lobby.lua` (lines 3112-3136)

**ChangeOfferBtn Changes**:
- **Position**: Now anchored to BPTipText instead of Rew1
- **Spacing**: 15px gap from BPTipText
- **Vertical Alignment**: Properly positioned below the tip text

**RefreshBtn Changes**:
- **Position**: Anchored to both BPTipText (vertical) and ChangeOfferBtn (horizontal)
- **Spacing**: 15px gap from ChangeOfferBtn
- **Alignment**: Both buttons now properly aligned

```lua
ChangeOfferBtn = DefButton {
  size = {120,26},
  layer = "+1",
  anchors = { TOP = { "BOTTOM", "BPTipText", 0, 15 } },  -- Anchored to tip text
  str = TEXT{"chg_off_btn"},
  -- ... OnClick function
},

RefreshBtn = DefButton {
  size = {120,26},
  layer = "+1",
  anchors = { 
    TOP = { "BOTTOM", "BPTipText", 0, 15 },  -- Same vertical position as Reroll
    LEFT = { "RIGHT", "ChangeOfferBtn", 15, 0 }  -- Horizontal spacing
  },
  str = TEXT{"refresh"},
  -- ... OnClick function
},
```

## New Layout Structure

### **Vertical Layout** (top to bottom):
1. **Title**: "SHOP" (top-left)
2. **Battle Points Display**: "Battle Points: XXXX" (top-right)
3. **Item Slots**: Rew1 through Rew6 (middle, horizontal row)
4. **BP Tip Text**: "Tip: Play any Skirmish match to get 9999 Battle Points!" (below slots)
5. **Buttons**: Reroll and Refresh (below tip text, side by side)

### **Horizontal Layout** (left to right):
- **Reroll Button**: Left position
- **Refresh Button**: Right position (15px gap from Reroll)

## Spacing and Positioning

### **Element Spacing**:
- **Rew1 to BPTipText**: 10px gap
- **BPTipText to Buttons**: 15px gap
- **Button to Button**: 15px gap

### **Text Sizing**:
- **BPTipText**: 500x30 pixels (wider, shorter)
- **Buttons**: 120x26 pixels each

### **Alignment**:
- **BPTipText**: Centered horizontally
- **Buttons**: Aligned horizontally, positioned below tip text

## Benefits

### **Visual Improvements**:
✅ **Proper Centering**: All elements centered within shop window  
✅ **No Overflow**: Elements stay within shop boundaries  
✅ **Better Spacing**: Consistent gaps between elements  
✅ **Clean Layout**: Professional, organized appearance  

### **User Experience**:
✅ **Readable Text**: Tip text properly sized and positioned  
✅ **Accessible Buttons**: Buttons clearly visible and clickable  
✅ **Logical Flow**: Elements arranged in logical order  
✅ **Professional Look**: Clean, polished interface  

## Technical Details

### **Anchoring System**:
- **BPTipText**: Anchored to Rew1 (bottom) with 10px offset
- **ChangeOfferBtn**: Anchored to BPTipText (bottom) with 15px offset
- **RefreshBtn**: Dual anchoring (vertical to BPTipText, horizontal to ChangeOfferBtn)

### **Size Optimizations**:
- **BPTipText**: Increased width for better text display
- **Buttons**: Maintained standard size for consistency
- **Spacing**: Optimized for visual balance

## Modified Files

1. **`data/db/ui/lobby.lua`** - Updated BPTipText and button positioning

The shop now has a properly centered, well-spaced layout that keeps all elements within the shop window boundaries while maintaining a clean, professional appearance.
