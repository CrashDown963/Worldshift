# Instructions to Add ScorpionBoss Hardmode Artifact

## File to Modify: `data/maps/missions/safari.map`

### Step 1: Add Named Object
Find the `[named_objects]` section (around line 702) and add:
```
#2573741 = str: ScorpionHardItem
```

**Exact location:**
```
[named_objects]
  #2573736 = str: BillItem
  #1886124 = str: Queen
  #3030674 = str: ScorpionBoss
  #1886102 = str: Bill
  #2573740 = str: BillHardItem
  #2573741 = str: ScorpionHardItem  ← ADD THIS LINE
  #1886166 = str: Jack
  #1886140 = str: Mech0
```

### Step 2: Add ScorpionBossDead Condition
Find the `[conditions]` section (around line 711) and add at the end:
```
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

### Step 3: Add Hardmode Artifact
Go to the end of the file (after line 257085) and add:
```
[#1006736]
  class = sid: artifact
  ID = sid: Artifact1
  [$vars]
    drop_id = int: 490
    obj_name = str: ScorpionHardItem
    clone_mode_int = int: 128
    hidden = int: 1
    handle = int: 2573741
  [/]
  offset = fixp: 0
  scale = fixp: 1.0
  x = fixp: 46317.72265625
  y = fixp: 69897.84375
  z = fixp: 221.4005889892578125
  handle = int: 2573741
  roll = fixp: 0
  pitch = fixp: 0
  yaw = fixp: 0
[/]
```

## Visual Result

### Before (Normal Artifact)
- **Color**: Red/Orange
- **Size**: Small (0.7)
- **ID**: Artifact2

### After (Hardmode Artifact)
- **Color**: Blue
- **Size**: Large (1.0)
- **ID**: Artifact1

## Verification
After applying the changes:
1. Start the game
2. Go to Safari map
3. Kill the ScorpionBoss breaking ≤4 eggs
4. You should see a blue and larger artifact

## Important Notes
- The hardmode artifact appears **in addition** to the normal artifact
- It only appears if hardmode conditions are met
- The artifact position is the same as the normal ScorpionBoss artifact
- The artifact uses `Artifact1` (blue) instead of `Artifact2` (red)
