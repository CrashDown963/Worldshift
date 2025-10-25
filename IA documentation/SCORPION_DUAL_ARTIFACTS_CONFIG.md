# Dual Artifacts Configuration for ScorpionBoss

## Implemented System

### Normal Artifact (Always appears)
- **Drop ID**: 485
- **Name**: "ScorpionBoss Artifact"
- **Color**: Red (Artifact2)
- **Scale**: 0.7
- **Loot**: Normal (100% epic, 15% legendary)

### Hardmode Artifact (Only if ≤4 eggs broken)
- **Drop ID**: 490
- **Name**: "Scorpion Hardmode Artifact"
- **Color**: Blue (Artifact1)
- **Scale**: 1.0 (larger)
- **Loot**: Hardmode (100% legendary, 20% unique)

## Required Changes in safari.map

### 1. Add Named Objects
```
#2573741 = str: ScorpionHardItem
#2573742 = str: ScorpionNormalItem
```

### 2. Add ScorpionBossDead Condition
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

### 3. Add Normal Artifact
```
[#1006736]
  class = sid: artifact
  ID = sid: Artifact2
  [$vars]
    drop_id = int: 485
    obj_name = str: ScorpionNormalItem
    clone_mode_int = int: 128
    hidden = int: 1
    handle = int: 2573742
    name = str: ScorpionBoss Artifact
    descr = str: Normal artifact from ScorpionBoss
  [/]
  offset = fixp: 0
  scale = fixp: 0.7
  x = fixp: 46317.72265625
  y = fixp: 69897.84375
  z = fixp: 221.4005889892578125
  handle = int: 2573742
  roll = fixp: 0
  pitch = fixp: 0
  yaw = fixp: 0
[/]
```

### 4. Add Hardmode Artifact
```
[#1006737]
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

### Normal Combat
- **1 artifact**: Red, small (0.7 scale)
- **Loot**: Normal

### Hardmode Combat
- **2 artifacts**: 
  - Red, small (normal)
  - Blue, large (hardmode)
- **Loot**: Normal + Hardmode (better)

## Advantages of Dual System

1. **Visual Clarity**: Two artifacts = hardmode completed
2. **Guaranteed Loot**: You always get loot from ScorpionBoss
3. **Extra Reward**: Hardmode gives additional loot, doesn't replace
4. **Clear Feedback**: It's obvious when hardmode is completed
