# Mythic Tier Implementation Guide

## Overview

This document outlines a comprehensive plan to implement a new "Mythic" tier (quality 6) superior to Legendary items in Worldshift. The implementation involves converting the existing tier system to make tier 1 (Common) the new Mythic tier, avoiding engine limitations while maintaining full functionality.

## Current System Analysis

### ✅ Existing Tier System

The game currently has **5 quality levels** defined:

| Quality | Name | Color RGB | Base Probability |
|---------|------|-----------|------------------|
| **1** | Common | 183,187,200 (Gray) | 50% |
| **2** | Rare | 119,224,80 (Green) | 25% |
| **3** | Epic | 255,255,0 (Yellow) | 10% |
| **4** | Legendary | 255,172,49 (Orange) | 5% |
| **5** | Unique | 204,0,204 (Purple) | 1% |

**Important Note**: `q6` and `h6` already exist in `colors.lua` (line 24) with red color (255,0,0), but are not currently used.

### 📁 Key System Files

#### **1. Item Definition** (`data/db/items/items.tsv`)
- **Format**: `ItemID | Quality | Race | Slot | Name | Targets | Stats | Description | Extra`
- **Example**: `40120	5	Humans	HUMAN_ASSASSIN	DNA Solution	Assassin	Assassin hp_gen = 68...`
- **Quality**: Column 2 (values 1-5 currently)

#### **2. Loot Tables** (`data/db/items/loot index.tsv`)
- **Format**: `DropID | Name | Common% | Rare% | Epic% | Legendary% | Unique%`
- **Example**: `90	Safari - Bill Hard	0	0	0	100	20`
- **Columns 3-7**: Probabilities for each tier

#### **3. Drop Configuration** (`data/db/items/drop.tsv`)
- **Format**: `SourceID | SourceName | TargetID | TargetName | Chance | MinItems | MaxItems | Common% | Rare% | Epic% | Legendary% | Unique%`
- **Links** bosses/events with specific loot tables

#### **4. Specific Loot** (`data/db/items/loot.tsv`)
- **Format**: `DropID | DropName | ItemID | ... | ItemName`
- **Assigns** specific items to each loot table

#### **5. UI Colors** (`data/db/ui/colors.lua`)

```lua
ItemColors = {
  q1 = { 183,187,200 }, -- Common (Gray)
  q2 = { 119,224,80 },  -- Rare (Green)
  q3 = { 255,255,0 },   -- Epic (Yellow)
  q4 = { 255,172,49 },  -- Legendary (Orange)
  q5 = { 204,0,204 },   -- Unique (Purple)
  q6 = { 255, 0, 0 },   -- ALREADY EXISTS! (Red) - NOT USED
  
  h1 = { 183,187,200 }, -- Highlight colors
  h2 = { 119,224,80 },
  h3 = { 255,255,0 },
  h4 = { 255,172,49 },
  h5 = { 130,5,177 },   -- Unique highlight (Dark Purple)
  h6 = { 255, 0, 0 },   -- ALREADY EXISTS! (Red) - NOT USED
}
```

#### **6. Color Usage** (`data/db/ui/inventory.lua`)
- Line 195: `this.Level:SetColor(ItemColors["h"..item.quality])`
- **Dynamic system**: Uses `item.quality` to select color

## 🚫 Engine Limitation Discovered

### Problem Identified
During previous implementation attempts, we discovered that the **C++ game engine has a fundamental limitation**:

1. **Does not support 7th column** in `loot index.tsv` for quality 6
2. **Always interprets quality 6 as weight 0**, regardless of what we write
3. **Automatically corrects** quality 6 weight to 1 when items are detected
4. **Shows warning messages** but doesn't crash the game

### Error Messages Encountered
```
"Items list 290(Common Low Boss) has 0 weight for quality 6 but contains items, weight changed to 1"
```

This confirms the engine limitation and makes traditional quality 6 implementation problematic.

## 💡 Solution: Tier Conversion Approach

### Core Concept
Instead of adding a new tier 6, **convert the existing tier system**:

1. **Tier 1 (Common) → Mythic** (Red, extremely rare)
2. **Tier 2 (Rare) → New Common** (Green, most common)
3. **Tier 3 (Epic) → New Rare** (Yellow)
4. **Tier 4 (Legendary) → New Epic** (Orange)
5. **Tier 5 (Unique) → New Legendary** (Purple)

### ✅ Advantages of This Approach

1. **✅ Avoids engine limitation** - No need for 7th column
2. **✅ Fully functional system** - Engine already supports tier 1
3. **✅ Complete control** - Can easily adjust probabilities
4. **✅ No errors** - No engine warnings
5. **✅ Simple implementation** - Only change probabilities
6. **✅ Maintains balance** - Items become more powerful overall

## 📋 Implementation Plan

### **Phase 1: Clean Current Changes**

**Objective**: Remove all current Mythic tier attempts to start fresh

**Files to revert**:
- `data/db/items/items.tsv` - Remove quality 6 items, revert Ion-Core Shells
- `data/db/items/loot.tsv` - Remove Mythic items from loot tables
- `data/db/items/loot index.tsv` - Remove 7th column attempts
- `data/db/items/drop.tsv` - Remove Mythic% column attempts
- `data/db/ui/lobby.lua` - Remove Mythic shop implementation

### **Phase 2: Update Color System**

**File**: `data/db/ui/colors.lua`

```lua
ItemColors = {
  q1 = { 255, 0, 0 },   -- Mythic (Red) - Was Common
  q2 = { 119,224,80 },  -- Common (Green) - Was Rare
  q3 = { 255,255,0 },   -- Rare (Yellow) - Was Epic
  q4 = { 255,172,49 },  -- Epic (Orange) - Was Legendary
  q5 = { 204,0,204 },   -- Legendary (Purple) - Was Unique
  
  h1 = { 255, 0, 0 },   -- Mythic highlight (Red)
  h2 = { 119,224,80 },  -- Common highlight (Green)
  h3 = { 255,255,0 },   -- Rare highlight (Yellow)
  h4 = { 255,172,49 },  -- Epic highlight (Orange)
  h5 = { 130,5,177 },   -- Legendary highlight (Purple)
}
```

### **Phase 3: Migrate Existing Items**

**File**: `data/db/items/items.tsv`

**Migration strategy**:
- **All current quality 1 items** → Change to quality 2 (new Common)
- **All current quality 2 items** → Change to quality 3 (new Rare)
- **All current quality 3 items** → Change to quality 4 (new Epic)
- **All current quality 4 items** → Change to quality 5 (new Legendary)
- **All current quality 5 items** → Keep as quality 5 (now Legendary)

**Example migration**:
```tsv
# Before
57840	1	Humans	HUMAN_CONSTRUCTOR	Ion-Core Shells	Constructor	Constructor overcharge_chance = 1

# After
57840	2	Humans	HUMAN_CONSTRUCTOR	Ion-Core Shells	Constructor	Constructor overcharge_chance = 1
```

### **Phase 4: Create New Mythic Items**

**File**: `data/db/items/items.tsv`

**Create items with quality 1** (new Mythic tier):

```tsv
# ItemID	Quality	Race	Slot	Name	Targets	Stats	Description	Extra
70000	1	Humans	HUMAN_COMMANDER	Godlike Command Core	Commander	Commander damage = 50 Commander hp = 30% Commander psi = 40%	The ultimate command authority
70001	1	Humans	HUMAN_ASSASSIN	Shadow of the Void	Assassin	Assassin damage = 45 Assassin hp = 25% Assassin armor = 15	Master of shadows
70002	1	Aliens	ALIEN_MASTER	Cosmic Devastation	Master	Master damage = 60 Master hp_gen = 200 Master psi = 30%	Harness the cosmos
70003	1	Tribes	MUTANT_HIGHPRIEST	Primal Ascension	HighPriest	HighPriest lightning_damage = 150% HighPriest hp = 35%	Ancient godhood
70004	1	Humans	HUMAN_DEFENCE	Divine Wrath	Trooper	Trooper damage = 40 Trooper armor = 20 Trooper hp = 25%	Wrath of the gods
70005	1	Aliens	ALIEN_ARBITER	Eternal Guardian	Arbiter	Arbiter hp = 40% Arbiter armor = 25 Arbiter healing_taken_mod = 50%	Guardian of eternity
70006	1	Tribes	MUTANT_SHAMAN	Void Walker	Shaman	Shaman damage = 50 Shaman hp = 30% Shaman psi_gen = 300	Walker between worlds
70007	1	Humans	HUMAN_CONSTRUCTOR	Supreme Overlord	Constructor	Constructor damage = 35 Constructor hp_gen = 100 Constructor repairdrones_heal_radius = 20%	Supreme authority
70008	1	Aliens	ALIEN_MANIPULATOR	Mystic Transcendence	Manipulator	Manipulator life_leech_boost = 30 Manipulator healing_taken_mod = 40%	Transcend mortal limits
70009	1	Tribes	MUTANT_ADEPT	Legendary Destroyer	Sorcerer	Sorcerer damage = 55 Sorcerer hp = 35% Sorcerer psi = 50%	Destroyer of legends
```

**Characteristics**:
- **Stats**: 50-100% superior to current Unique items
- **Multiple effects**: 3-5 stats per item
- **Epic names**: Reflect extreme rarity
- **Quality 1**: Will appear in red (Mythic)

### **Phase 5: Update Loot Tables**

**File**: `data/db/items/loot index.tsv`

**New probability distribution**:

```tsv
# DropID	Name	Mythic%	Common%	Rare%	Epic%	Legendary%
0	GENERIC	0	50	25	10	5		# No Mythic in generic drops
10	PVP GENERIC	0	50	25	10	5		# No Mythic in PvP generic
20	Common Hard Boss	0	0	20	5	1		# No Mythic in common bosses
90	Safari - Bill Hard	1	0	0	100	20		# 1% Mythic chance
280	JY Xessk	5	0	0	0	100		# 5% Mythic chance
290	Common Low Boss	0	100	75	50	25		# No Mythic in common low boss
440	RH Final Master	10	0	0	10	100		# 10% Mythic chance
```

**Recommended Mythic probabilities**:
- **Normal bosses**: 0% Mythic
- **Hard bosses**: 1-2% Mythic
- **Final bosses**: 5-10% Mythic
- **Special events**: 10-20% Mythic

### **Phase 6: Update Drop Tables**

**File**: `data/db/items/drop.tsv`

**Update probabilities to match new tier system**:

```tsv
# SourceID	SourceName	TargetID	TargetName	Chance	MinItems	MaxItems	Mythic%	Common%	Rare%	Epic%	Legendary%
90	Safari - Bill Hard	90	Safari - Bill Hard	100	1	1	1	0	0	100	20
280	JY Xessk	280	JY Xessk	100	1	1	5	0	0	0	100
440	RH Final Master	440	RH Final Master	100	1	1	10	0	0	10	100
```

### **Phase 7: Add Mythic Items to Loot Tables**

**File**: `data/db/items/loot.tsv`

**Add Mythic items to appropriate loot tables**:

```tsv
# DropID	DropName	ItemID	...	ItemName
90	Safari - Bill Hard	70000			Godlike Command Core
90	Safari - Bill Hard	70001			Shadow of the Void
280	JY Xessk	70002			Cosmic Devastation
280	JY Xessk	70003			Primal Ascension
440	RH Final Master	70004			Divine Wrath
440	RH Final Master	70005			Eternal Guardian
```

### **Phase 8: Configure Bosses for Mythic Drops**

**Recommended bosses for Mythic drops**:

| Boss | Drop ID | Mythic% | Justification |
|------|---------|---------|---------------|
| **JY Xessk** | 280 | 5% | Final boss, most difficult |
| **RH Final Master** | 440 | 10% | Final campaign boss |
| **Safari - Bill Hard** | 90 | 1% | Hardmode Safari |
| **CF Boss Extra 1/2** | 360/370 | 15% | Optional extra bosses |

### **Phase 9: Testing and Validation**

**Testing checklist**:
- ✅ Items appear with correct colors
- ✅ Tooltips show stats correctly
- ✅ Items can be equipped
- ✅ Stats apply correctly
- ✅ Drops work on configured bosses
- ✅ No crashes or bugs
- ✅ No engine warnings

**Test scenarios**:
1. **Color verification**: Check that quality 1 items appear in red
2. **Drop testing**: Verify Mythic items drop from configured bosses
3. **Stat verification**: Confirm Mythic items have superior stats
4. **Balance testing**: Ensure game remains challenging

## 🎨 Alternative Color Schemes

If red doesn't appeal, consider these alternatives:

### **Cyan Brilliant**
```lua
q1 = { 0, 255, 255 },   -- Mythic (Brilliant Cyan)
h1 = { 0, 200, 200 },   -- Mythic highlight (Dark Cyan)
```

### **Gold**
```lua
q1 = { 255, 215, 0 },   -- Mythic (Gold)
h1 = { 200, 170, 0 },   -- Mythic highlight (Dark Gold)
```

### **White Brilliant**
```lua
q1 = { 255, 255, 255 }, -- Mythic (Brilliant White)
h1 = { 200, 200, 200 }, -- Mythic highlight (Light Gray)
```

## ⚠️ Risks and Mitigations

### **Risk 1: Game Balance Disruption**
- **Probability**: Medium
- **Impact**: Medium
- **Mitigation**: Conservative stats, very low probabilities

### **Risk 2: Player Confusion**
- **Probability**: Low
- **Impact**: Low
- **Mitigation**: Clear documentation, gradual rollout

### **Risk 3: Migration Complexity**
- **Probability**: Medium
- **Impact**: Medium
- **Mitigation**: Systematic approach, thorough testing

## 📊 Files to Modify

| File | Changes | Criticality |
|------|---------|-------------|
| `data/db/ui/colors.lua` | Update color definitions | High |
| `data/db/items/items.tsv` | Migrate existing items + create Mythic items | High |
| `data/db/items/loot index.tsv` | Update probability distributions | High |
| `data/db/items/drop.tsv` | Update drop probabilities | High |
| `data/db/items/loot.tsv` | Add Mythic items to loot tables | Medium |

## 🚀 Implementation Steps

### **Step 1: Clean Current State**
1. Revert all current Mythic tier changes
2. Remove quality 6 items
3. Remove 7th column attempts
4. Clean up shop implementation

### **Step 2: Update Color System**
1. Modify `colors.lua` to make tier 1 red (Mythic)
2. Update tier 2-5 colors accordingly
3. Test color changes

### **Step 3: Migrate Existing Items**
1. Change all quality 1 → quality 2
2. Change all quality 2 → quality 3
3. Change all quality 3 → quality 4
4. Change all quality 4 → quality 5
5. Keep quality 5 as quality 5

### **Step 4: Create Mythic Items**
1. Create 10 new items with quality 1
2. Design epic names and stats
3. Add to appropriate loot tables

### **Step 5: Update Loot System**
1. Modify `loot index.tsv` probabilities
2. Update `drop.tsv` probabilities
3. Add Mythic items to loot tables

### **Step 6: Testing**
1. Test color system
2. Test item migration
3. Test Mythic drops
4. Test game balance

## ✅ Conclusion

**This approach is HIGHLY RECOMMENDED** because:

1. **Avoids engine limitations** - No 7th column needed
2. **Fully functional** - Engine already supports tier 1
3. **Complete control** - Easy probability adjustment
4. **No errors** - No engine warnings
5. **Simple implementation** - Only change numbers
6. **Maintains balance** - Items become more powerful overall

**Recommendation**: Proceed with this tier conversion approach for a clean, functional Mythic tier implementation.

## 📝 Next Steps

1. **Clean current changes** - Remove all quality 6 attempts
2. **Start with Phase 1** - Update color system
3. **Systematic migration** - Follow the phases in order
4. **Thorough testing** - Validate each phase before proceeding
5. **Documentation** - Keep track of all changes made

This approach provides a robust, engine-compatible solution for implementing a Mythic tier while avoiding the limitations discovered in previous attempts.
