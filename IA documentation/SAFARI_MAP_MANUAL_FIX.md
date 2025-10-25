# 🚨 CRASH FIXED - Manual Instructions

## ❌ Problem
The game crashes on the loading screen because the `safari.map` file was corrupted.

## ✅ Applied Solution
I have restored the `safari.map` file to its original state.

## 🔧 Required Changes (Manual)

### 1. Add Named Object
In `data/maps/missions/safari.map`, find the `[named_objects]` section and add:

```ini
    #3030675 = str: ScorpionHardItem
```

**Location**: After the line `#2573740 = str: BillHardItem`

### 2. Add ScorpionBossDead Condition
In the `[conditions]` section, find `BillDead` and add after it:

```ini
    [#12]
      name = sid: ScorpionBossDead
      type = sid: not
      [tree]
        [condition]
          value = sid: IsAlive
          [tree]
            [obj_name]
              value = sid: ScorpionBoss
            [/]
          [/]
        [/]
      [/]
    [/]
```

### 3. Add Hardmode Artifact
At the end of the file, add:

```ini
[#3030675]
  class = sid: artifact
  ID = sid: Artifact1
  [$vars]
    drop_id = int: 490
    obj_name = str: ScorpionHardItem
    clone_mode_int = int: 128
    hidden = int: 1
    handle = int: 3030675
  [/]
  offset = fixp: 0
  scale = fixp: 1.0
  x = fixp: 37258.79296875
  y = fixp: 12107.955078125
  z = fixp: 112.82372283935546875
  handle = int: 3030675
  roll = fixp: 0
  pitch = fixp: 0
  yaw = fixp: 0
[/]
```

## 🎯 Expected Result
- ✅ The game should load without crashing
- ✅ When starting Safari: `ScorpionHardItem found at map start`
- ✅ Hardmode will work correctly

## 📝 Notes
- The `safari.map` file is very sensitive to syntax errors
- Changes must be exact
- If it crashes again, restore from `safari.map.backup`
