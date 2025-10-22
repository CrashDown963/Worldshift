# Exact Modifications for safari.map

## 1. Add Named Object ScorpionHardItem

**Location**: Line 707, after `#2573740 = str: BillHardItem`

**Add this line**:
```
    #2573741 = str: ScorpionHardItem
```

**Result**:
```
    #2573740 = str: BillHardItem
    #2573741 = str: ScorpionHardItem
    #1886166 = str: Jack
```

## 2. Add ScorpionBossDead Condition

**Location**: Line 1144, after `[/]` of the ScorpionBossInCombat condition

**Add**:
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

## 3. Add Hardmode Artifact

**Location**: At the end of the file (after line 257085)

**Add**:
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
    name = str: Scorpion Hardmode Artifact
    descr = str: Hardmode artifact from ScorpionBoss - obtained by breaking 4 or fewer eggs
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

After applying these changes:
- **Normal artifact**: Red, small (0.7 scale)
- **Hardmode artifact**: **Blue, large (1.0 scale)**

## Important Notes

1. The hardmode artifact uses `Artifact1` (blue) instead of `Artifact2` (red)
2. The scale is `1.0` (large) instead of `0.7` (small)
3. The drop_id is `490` (hardmode)
4. The artifact appears at the same position as the normal artifact
5. It only appears if hardmode conditions are met (≤4 eggs broken)
