# Making Stats Modifiable via Items Guide

## Overview

This guide explains how to make unit attributes (like speed, armor, damage, etc.) modifiable through items in the TSV system. This is the **RECOMMENDED APPROACH** for making stats changeable.

## The Problem

By default, some stats like `speed` are hardcoded values that cannot be modified by items:

```dts
// This cannot be modified via items.tsv
speed = 450  
```

## The Solution: Convert to Stat

Make the attribute a **stat** instead of a hardcoded value. This allows items to modify it.

### Step 1: Define the stat in stats section

Add the attribute to the unit's `stats` section:

```dts
stats : {
  hp = 220
  armor = 5
  range = 1400
  damage = 6
  speed = 450  // Define speed as a stat
}
```

### Step 2: Reference the stat instead of hardcoding

Replace the hardcoded value with a stat reference:

**Before:**
```dts
speed = 450  // Hardcoded - cannot be modified
```

**After:**
```dts
speed = stat:speed  // References the stat - can be modified via items
```

### Step 3: Modify via items

Now you can modify the stat in `items.tsv`:

**Value-based modification:**
```
Trooper speed = 2250  // Sets speed to exactly 2250
```

**Percentage-based modification:**
```
Trooper speed = 400%  // +400% speed (5x total)
Trooper speed = 50%   // +50% speed (1.5x total)
```

## Complete Example: Trooper with Modifiable Speed

```dts
Trooper Trooper : BaseUnit {
  trooper_name = "Trooper"
  elite_name = "Elite Trooper"
  name_var = trooper_name
  
  descr = "DESCRIPTION"
  model = data/models/units/Trooper/Trooper.kfm
  race = humans
  icon = 1,1
  
  speed = stat:speed  // Use stat instead of hardcoded value
  take_auras : { RestorationCoreAura }
  
  sounds {
    // ... sound definitions ...
  }
  
  stats : {
    throw_grenade_chance = 3
    grenade_damage = 50
    grenade_radius = 170
    hp = 220
    armor = 5
    range = 1400
    damage = 6
    motivation = 0
    crit_chance_increase = 5
    speed = 450  // Define as stat
  }
  
  // ... rest of unit definition ...
}
```

## Item Modification Format

In `items.tsv`:

```tsv
<ID>	<Quality>	<Race>	<Type>	<ItemName>	<Target>	<Modifications>
```

### Examples

**Value-based modifications:**
```
68820	2	Humans	HUMAN_DEFENCE	Field Charged Bullets	Trooper	Trooper speed = 2250
68820	2	Humans	HUMAN_DEFENCE	Field Charged Bullets	Trooper	Trooper hp = 300
68820	2	Humans	HUMAN_DEFENCE	Field Charged Bullets	Trooper	Trooper damage = 15
```

**Percentage-based modifications:**
```
68820	2	Humans	HUMAN_DEFENCE	Fast Runner	Trooper	Trooper speed = 100%
68820	2	Humans	HUMAN_DEFENCE	Iron Trooper	Trooper	Trooper hp = 50%
68820	2	Humans	HUMAN_DEFENCE	Power Strike	Trooper	Trooper damage = 25%
```

**Multiple modifications per item:**
```
68820	2	Humans	HUMAN_DEFENCE	Elite Vest	Trooper	Trooper speed = 900	Trooper hp = 50%	Trooper armor = 10
```

## Speed Reference Values

### Value-Based (Trooper base speed: 450)

| Speed Value | Multiplier | Description |
|-------------|------------|-------------|
| 450 | 1x | Base speed |
| 675 | 1.5x | Slightly faster |
| 900 | 2x | Twice as fast |
| 1350 | 3x | Triple speed |
| 1800 | 4x | Four times speed |
| 2250 | 5x | Five times speed |
| 2700 | 6x | Six times speed |

### Percentage-Based

| Percentage | Result | Total Speed |
|------------|--------|-------------|
| 50% | +50% | 1.5x (675) |
| 100% | +100% | 2x (900) |
| 200% | +200% | 3x (1350) |
| 300% | +300% | 4x (1800) |
| 400% | +400% | 5x (2250) |
| 500% | +500% | 6x (2700) |

## Any Stat Can Be Made Modifiable

This technique works for **any attribute**, not just speed:

### Example: Making Armor Modifiable

**Before:**
```dts
armor = 5  // Hardcoded
```

**After:**
```dts
armor = stat:armor  // Can be modified

stats : {
  armor = 5  // Base value
}
```

Then in items:
```
Trooper armor = 15  // Sets armor to 15
Trooper armor = 50%  // +50% armor
```

### Example: Making Range Modifiable

**Before:**
```dts
range = 1400  // Hardcoded
```

**After:**
```dts
range = stat:range  // Can be modified

stats : {
  range = 1400  // Base value
}
```

Then in items:
```
Trooper range = 2000  // Extended range
Trooper range = 20%   // +20% range
```

## Advantages of This Method

1. **Simple**: No need for auras, abilities, or complex code
2. **Item-compatible**: Directly works with the TSV item system
3. **Flexible**: Easy to adjust values per item
4. **Multiple modifiers**: Multiple items can stack (if allowed)
5. **No visual overhead**: No unwanted particle effects
6. **Permanent**: Changes persist as long as the item is equipped
7. **Base values remain**: Base stat value is preserved in the unit definition

## When to Use This Method

**Use stat approach when:**
- You want to modify stats via items
- You need different stat values per item
- You want simple, permanent stat changes
- You want to make multiple stat modifications in one item
- You need predictable, exact values

**Use other methods (auras/abilities) when:**
- You need conditional effects (e.g., only in combat)
- You need temporary effects with durations
- You need visual effects with the stat changes
- You need proximity-based effects
- You need effects that activate on specific events

## Common Modifiable Stats

These stats are commonly made modifiable:

- `hp` - Hit points
- `armor` - Armor value
- `damage` - Attack damage
- `range` - Attack range
- `crit_chance` - Critical hit chance
- `hp_gen` - Health regeneration
- `psi_gen` - Power generation
- `speed` - Movement speed
- `psi` - Power/mana
- `precision` - Accuracy

## Important Notes

1. **Base values**: Always define a base value in the `stats` section
2. **Format**: Use `stat:statname` format when referencing
3. **Compatibility**: Not all stats can be made modifiable (check game limits)
4. **Stacking**: Multiple item modifiers will stack
5. **Testing**: Always test in-game to verify modifiers work as expected
6. **Performance**: Modifying stats via items has no performance impact

## File Locations

Example implementations:
- `data/db/units/humans/trooper.dt` - Stat-based speed modification
- `data/db/items/items.tsv` - Item modifications

## Related Files

- `data/db/units/unitbase.dt` - Base unit definition
- `data/texts/en/items.tsv` - List of modifiable stat names
- `IA documentation/AURA_IMPLEMENTATION_GUIDE.md` - Alternative method using auras

