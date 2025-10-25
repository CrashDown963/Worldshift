# ScorpionBoss Hardmode Artifact Configuration

## Required Changes in safari.map

### 1. Add Named Object
In the `[named_objects]` section, add:
```
#2573741 = str: ScorpionHardItem
```

### 2. Add ScorpionBossDead Condition
In the `[conditions]` section, add:
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

### 3. Add Hardmode Artifact
At the end of the file, add:
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

## Visual Differences

### Normal Artifact (Bill)
- **ID**: Artifact2
- **Color**: Red/Orange
- **Scale**: 0.7
- **Drop ID**: 80

### Hardmode Artifact (ScorpionBoss)
- **ID**: Artifact1
- **Color**: Blue
- **Scale**: 1.0 (larger)
- **Drop ID**: 490

## Visual Result
- **Normal artifact**: Small and red
- **Hardmode artifact**: Large and blue (similar to Dunetown)
