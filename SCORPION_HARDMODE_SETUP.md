# 🦂 ScorpionBoss Hardmode Setup

## 🚨 IDENTIFIED PROBLEM

The ScorpionBoss hardmode **DOES NOT WORK** because the hardmode artifact is missing from the map. The system is configured but the `ScorpionHardItem` artifact does not exist in `safari.map`.

## 🔧 REQUIRED SOLUTION

You need to **manually edit** the file `data/maps/missions/safari.map` to add the hardmode artifact.

### 📝 Steps to Follow:

1. **Open** `data/maps/missions/safari.map` in a text editor
2. **Find** the section where artifacts are defined (search for "BillHardItem")
3. **Add** the following code after `BillHardItem`:

```ini
ScorpionHardItem = {
  class = artifact
  ID = Artifact1
  pos = 0,0,0
  scale = 1.0
  hidden = 1
}
```

4. **Save** the file
5. **Restart** the game

### 🎯 Artifact Location

The artifact will appear at the **same position** as the ScorpionBoss when it dies. The position `0,0,0` is relative to the boss.

### 🔍 Verification

When you start the Safari map, you should see in the console:
- ✅ `ScorpionHardItem found at map start` (if configured)
- ❌ `WARNING: ScorpionHardItem not found at map start!` (if missing)

## 🐛 Counter Problem

**SOLVED**: The counter now counts **real eggs** (not spawns):
- 1 egg broken = 5 spawns = counter +1
- 2 eggs broken = 10 spawns = counter +2

## 📊 Hardmode Condition

- **Limit**: ≤8 eggs broken
- **Result**: 2 artifacts (normal + hardmode)
- **Loot**: Better loot in the hardmode artifact

## 🎮 How to Test

1. Kill the ScorpionBoss
2. Break ≤8 eggs during the fight
3. If configured correctly, 2 artifacts will appear
4. If only 1 artifact appears, `ScorpionHardItem` needs to be configured in `safari.map`

## 📁 Modified Files

- ✅ `data/maps/missions/safari.lua` - Hardmode logic
- ✅ `data/db/items/loot index.tsv` - Loot tables
- ✅ `data/db/items/drop.tsv` - Specific drops
- ✅ `data/db/units/environment/safariscorpionboss.dt` - Boss config
- ❌ `data/maps/missions/safari.map` - **NEEDS MANUAL CONFIGURATION**

---

**⚠️ IMPORTANT**: Without the artifact in `safari.map`, the hardmode will NOT work even if the logic is correct.
