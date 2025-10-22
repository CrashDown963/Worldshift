# ScorpionBoss Hardmode Configuration

## Overview
This document contains the configuration needed to implement a hardmode for the ScorpionBoss in Safari map, where the condition is that no more than 4 eggs are broken during the fight.

## Changes Made

### 1. Modified `data/maps/missions/safari.lua`

#### Added Variables
```lua
local ScorpionEggsBroken = 0
local ScorpionHardItem = GetNamedObject("ScorpionHardItem")
```

#### Modified `onConditionChanging` Function
```lua
elseif (name == "ScorpionBossDead") then
  -- Check if hardmode conditions are met (4 or fewer eggs broken)
  if ScorpionEggsBroken <= 4 then
    if actors.Actor.IsValid(ScorpionHardItem) then
      ScorpionHardItem:SetVar("hidden", 0)
    end
  end
end
```

#### Modified `onEggSpawn` Function
```lua
function onEggSpawn(spawn)
  table.insert(ScorpionBattleSpawns, spawn)
  -- Increment egg broken counter
  ScorpionEggsBroken = ScorpionEggsBroken + 1
  print("Scorpion eggs broken: " .. ScorpionEggsBroken)
end
```

### 2. Modified `data/db/units/environment/safariscorpionboss.dt`

#### Changed Drop Item
```dt
drop_item = 480  // Changed from 460
```

### 3. Modified `data/db/items/loot index.tsv`

#### Added Loot Tables
```
480	Safari - Scorpion	0	0	100	15	0
490	Safari - Scorpion Hard	0	0	0	100	25
```

### 4. Modified `data/db/items/drop.tsv`

#### Added Drop Tables
```
480	Safari - Scorpion	480	Safari - Scorpion	100	1	1			100		
480	Safari - Scorpion	480	Safari - Scorpion	25	1	1				100	
480	Safari - Scorpion	290	Common Low Boss	100	1	1					
490	Safari - Scorpion Hard	490	Safari - Scorpion Hard	100	1	1				100	
490	Safari - Scorpion Hard	490	Safari - Scorpion Hard	25	1	1					100
490	Safari - Scorpion Hard	20	Common Hard Boss	100	1	1					
490	Safari - Scorpion Hard	0	GENERIC	50	1	1					
```

## Required Map Configuration

### 1. Add to `data/maps/missions/safari.map`

#### Named Objects Section
```map
[named_objects]
  #2573736 = str: BillItem
  #1886124 = str: Queen
  #3030674 = str: ScorpionBoss
  #1886102 = str: Bill
  #2573740 = str: BillHardItem
  #2573741 = str: ScorpionHardItem  // ADD THIS LINE
  #1886166 = str: Jack
  #1886140 = str: Mech0
```

#### Conditions Section
```map
[#30]
  name = sid: ScorpionBossDead
  type = sid: not
  [tree]
    [condition]
      value = sid: IsAlive
      [tree]
        [obj_name]
          value = str: ScorpionBoss
        [/]
      [/]
    [/]
  [/]
[/]
```

#### Artifact Definition
```map
[#1006736]
  class = sid: artifact
  ID = sid: Artifact3
  [$vars]
    drop_id = int: 490
    obj_name = str: ScorpionHardItem
    clone_mode_int = int: 128
    hidden = int: 1
    handle = int: 2573741
  [/]
  offset = fixp: 0
  scale = fixp: 0.7
  x = fixp: 46317.72265625
  y = fixp: 69897.84375
  z = fixp: 221.4005889892578125
  handle = int: 2573741
  roll = fixp: 0
  pitch = fixp: 0
  yaw = fixp: 0
[/]
```

## How It Works

1. **Egg Counter**: The `ScorpionEggsBroken` variable tracks how many eggs have been broken during the fight
2. **Hardmode Condition**: When the ScorpionBoss dies, the system checks if 4 or fewer eggs were broken
3. **Artifact Spawn**: If the condition is met, the `ScorpionHardItem` artifact becomes visible
4. **Loot Quality**: The hardmode artifact provides better loot (100% epic, 25% legendary vs 15% legendary for normal)

## Loot Comparison

| Type | Epic | Legendary | Unique |
|------|------|-----------|--------|
| **Scorpion Normal** | 0% | 15% | 0% |
| **Scorpion Hard** | **100%** | **25%** | **0%** |

## Testing

To test the hardmode:
1. Start the Safari map
2. Fight the ScorpionBoss
3. Try to break as few eggs as possible (4 or fewer)
4. Kill the ScorpionBoss
5. Check if the hardmode artifact appears

## Notes

- The artifact uses `Artifact3` (gold color) to differentiate it from normal artifacts
- The hardmode artifact appears in addition to the normal ScorpionBoss artifact
- The egg counter resets each time the map is loaded
- Debug messages will show the current egg count in the console
