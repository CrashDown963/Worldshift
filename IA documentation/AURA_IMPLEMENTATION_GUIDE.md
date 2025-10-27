# Aura Implementation Guide

## Overview

This guide explains how to implement persistent buffs/debuffs using **CEffectAura** in Worldshift. Auras are useful when you need effects that apply constantly to nearby units or to the unit itself.

## What are Auras?

Auras are continuous effects that automatically apply buffs or debuffs to eligible targets within a certain range. They're perfect for:
- Permanent passive effects
- Proximity-based buffs
- Self-applied constant bonuses

## Example: Speed Boost Aura

### Step 1: Add the stat to the unit

In the unit's stats section, define the effect parameter:

```dts
stats : {
  hp = 220
  armor = 5
  range = 1400
  damage = 6
  speed_boost_perc = 400  // 400% = 5x speed
}
```

### Step 2: Add CEffectAura to the unit

Add the aura definition to the unit, typically after the `abilities` line:

```dts
abilities : TrooperAbilities

CEffectAura TrooperSpeedBoostAura {
  range = 1
  faction = self
  effect = E_buff {
    id = TrooperSpeedBoost
    name = "Speed Boost"
    text = "Increased movement speed"
    icon = 1,11
    target_self = 1
    type = buff
    stats_change {
      speed_mod = { perc = stat:speed_boost_perc } 
    }
    duration = -1
    stack_count = 1
  }
}

animation {
  // ... rest of unit definition
}
```

### Configuration Parameters

**CEffectAura:**
- **`range`**: How far the aura reaches (use `1` for self-only)
- **`faction`**: 
  - `self` - Only affects the unit itself
  - `friendly` - Affects friendly units
  - `enemy` - Affects enemy units
- **`target_filter`**: Optional filter to target specific units:
  ```dts
  target_filter {
    def = Judge  // Only affects Judge units
  }
  ```

**E_buff:**
- **`id`**: Unique identifier for the buff
- **`name`**: Display name of the buff
- **`text`**: Description text
- **`icon`**: Icon coordinates (row, col)
- **`target_self`**: Set to `1` if applying to self
- **`type`**: Buff type (buff, debuff, slow, etc.)
- **`stats_change`**: The actual stat modifications
  - **`speed_mod = { perc = stat:speed_boost_perc }`**: Percentage modifier
- **`duration`**: 
  - `-1` = Permanent (never expires)
  - Number = Duration in seconds
- **`stack_count`**: Maximum number of times this buff can stack
- **`destroy_when_creator_dead`**: Set to `1` if the buff should be removed when the creator dies

### Visual Effects

Add visual reactions with the `react` parameter:

```dts
effect = E_buff {
  // ... buff definition ...
  react = overclock  // Uses the same visual effect as Ripper's Overclock
}
```

Common reactions:
- `overclock` - Golden aura
- `poison` - Green effect
- `fire` - Fire particles
- `discharge` - Energy effect

## Complete Example: Trooper Speed Boost

```dts
Trooper Trooper : BaseUnit {
  // ... other definitions ...
  
  stats : {
    hp = 220
    armor = 5
    range = 1400
    damage = 6
    speed_boost_perc = 400  // 400% = 5x speed
  }
  
  abilities : TrooperAbilities
  
  CEffectAura TrooperSpeedBoostAura {
    range = 1
    faction = self
    effect = E_buff {
      id = TrooperSpeedBoost
      name = "Speed Boost"
      text = "Increased movement speed"
      icon = 1,11
      target_self = 1
      type = buff
      stats_change {
        speed_mod = { perc = stat:speed_boost_perc } 
      }
      duration = -1
      stack_count = 1
    }
  }
  
  animation {
    // ... rest of definition ...
  }
}
```

Result: Trooper moves at **5x normal speed** permanently.

## Proximity-Based Aura Example

Aura that affects nearby friendly units:

```dts
CEffectAura SupportAura {
  range = 1000
  faction = friendly
  effect = E_buff {
    id = SupportBuff
    name = "Combat Support"
    text = "Bonus from nearby officer"
    icon = 3,12
    target_self = 0
    type = buff
    stats_change {
      damage = { perc = 10 }
      crit_chance = 5
    }
    duration = -1
    stack_count = 1
  }
  target_filter {
    def = Trooper  // Only affects Troopers
  }
}
```

## Conditional Aura Example

Aura that only affects enemies when certain conditions are met:

```dts
CEffectAura SlowPoisonAura {
  range = 500
  faction = enemy
  effect = E_debuff {
    id = SlowPoison
    name = "Paralyzing Poison"
    text = "Movement speed reduced"
    icon = 1,6
    type = slow
    stats_change {
      speed_mod = { perc = -50 } 
    }
    duration = -1
    stack_count = 1
    react = paralyze
  }
}
```

## When to Use Auras

**Use CEffectAura when:**
- You need proximity-based effects
- You want passive abilities that are always active
- You need conditional effects (e.g., only near certain units)
- You want visual effects with the stat changes
- You need temporary effects with specific durations
- You want to affect multiple units at once

**Don't use auras when:**
- You simply want to modify a stat directly
- You need to modify stats via items
- You want effects that activate on specific events (use abilities instead)
- You want one-time effects (use direct effects instead)

## Reference Values

**Speed Modifiers:**
- **50%** = 1.5x speed
- **100%** = 2x speed
- **200%** = 3x speed
- **300%** = 4x speed
- **400%** = 5x speed
- **500%** = 6x speed

**Range Examples:**
- `range = 1` - Self only
- `range = 300` - Close proximity
- `range = 1000` - Medium range
- `range = 2000` - Long range

## Important Notes

1. **Performance**: Auras constantly check for targets, so keep ranges reasonable
2. **Stacking**: Use `stack_count` to limit how many times a buff can stack
3. **Visual effects**: Add `react` for particle effects
4. **Testing**: Always test in-game as the range and effects may behave differently than expected
5. **Expiration**: Use `duration = -1` for permanent effects, or set a specific duration in seconds

## File Location

Example implemented in:
- `data/db/units/humans/trooper.dt`

## Related Files

- `data/db/units/unitbase.dt` - Base unit definition
- `data/db/units/humans/ripper.dt` - Example of ability-based speed buff (Overclock)
- `data/db/units/environment/xelrad.dt` - Example of enemy-affecting aura

