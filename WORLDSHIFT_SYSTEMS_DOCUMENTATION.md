# Worldshift - Game Systems Documentation

## Table of Contents
1. [Artifacts and Hardmode System](#artifacts-and-hardmode-system)
2. [UI and HUD System](#ui-and-hud-system)
3. [Boss System](#boss-system)
4. [Loot System](#loot-system)
5. [Game Architecture](#game-architecture)
6. [File Structure](#file-structure)

---

## Artifacts and Hardmode System

### General Concepts

Worldshift implements a **conditional difficulty system** through boss variants and special artifacts, not a traditional "hard mode".

### Base Artifact Types

Defined in `data/db/etc/artifacts.dt`:

#### Artifact1 (Blue)
```dt
artifact Artifact1 {
  model = data/models/artifacts/artifact1/Artefact.kfm
  emit = 0,137,255  // Bright blue
  scale = 1.0       // Normal size
}
```

#### Artifact2 (Red)
```dt
artifact Artifact2 {
  model = data/models/artifacts/artifact1/Artefact.kfm
  emit = 100,10,0   // Red/orange
  scale = 0.7       // 70% of normal size
}
```

#### Artifact3 (Gold)
```dt
artifact Artifact3 {
  model = data/models/artifacts/artifact1/Artefact.kfm
  emit = 255,128,0  // Gold/bright orange
  scale = 1.0       // Normal size
}
```

### Safari Hardmode System

#### Activation Conditions
The hardmode is activated through the `SpawnBillHardItem` condition:

```lua
SpawnBillHardItem = BillDead AND (QueenAlive OR Mech0Alive)
```

**Translated to gameplay:**
- You must **kill Bill FIRST**
- But you **must NOT have killed** Queen OR Mech0 (or both)
- If you meet these conditions, `BillHardItem` appears

#### Safari Artifacts

**BillItem (Normal)**
- **Drop ID**: 80 ("Safari - Bill")
- **Scale**: 0.7 (70% of size)
- **State**: Initially hidden (`hidden = 1`)
- **Loot**: Basic items (0% epic, 10% legendary)

**BillHardItem (Hardmode)**
- **Drop ID**: 90 ("Safari - Bill Hard")
- **Scale**: 0.7 (70% of size - **SAME SIZE**)
- **State**: Initially hidden (`hidden = 1`)
- **Location**: Different position on the map
- **Loot**: Premium items (100% epic, 20% legendary)

### Visual Differentiation

**IMPORTANT**: Normal and hardmode artifacts have **NO obvious visual differences**:
- **Same size** (both 0.7 scale)
- **Same base model**
- **Same emission color**
- **Differentiation by location** and **activation conditions**

### Other Hardmode Examples

From analysis of `loot index.tsv`:
- **Gorgar Hard** (Junkyard): Hard variant of Gorgar boss
- **Lan Zealot Hard** (Bloodsport Arena): Hard variant of Lan Zealot  
- **AC Hard** (Ascent): Hard variant in Ascent map
- **CF Boss Extra 1 & 2**: Additional boss variants
- **Scorpion Hard** (Safari): Hard variant of ScorpionBoss (4 or fewer eggs broken)

### System Mechanics

#### Artifact Activation
1. **Boss dies** → Normal artifact appears (always)
2. **If hardmode conditions are met** → Additional hardmode artifact appears
3. **Both can coexist** on the map simultaneously

#### Loot System
- **Specific Drop ID**: Each artifact has its unique loot table
- **Visual color** is determined by the quality of loot obtained
- **Better ratios** for hardmode variants

---

## UI and HUD System

### Boss Health Bars

**File**: `data/db/ui/bossfight.lua`

#### Implemented Modification
**Line 185**: Changed from percentage only to full format:

```lua
// BEFORE
this.Text:SetStr("<p>"..math.floor((val/max)*100).."%")

// AFTER  
this.Text:SetStr("<p>"..math.floor(val).."/"..math.floor(max).." ("..math.floor((val/max)*100).."%)")
```

**Result**: `"15000/20000 (75%)"` instead of just `"75%"`

### Enemy Unit HUD

**File**: `data/db/ui/selection.lua`

#### Implemented Modifications

**For Mobs (enemy creatures):**
- **Line 1250**: Health - `"CURRENT_HP/MAX_HP (PERCENTAGE%)"`
- **Line 1253**: Energy - `"CURRENT_ENERGY/MAX_ENERGY (PERCENTAGE%)"`
- **Line 1261**: Shield - `"CURRENT_SHIELD/MAX_SHIELD (PERCENTAGE%)"`

**For Buildings (enemy buildings):**
- **Line 1821**: Health - `"CURRENT_HP/MAX_HP (PERCENTAGE%)"`
- **Line 1824**: Energy - `"CURRENT_ENERGY/MAX_ENERGY (PERCENTAGE%)"`
- **Line 1836**: Shield - `"CURRENT_SHIELD/MAX_SHIELD (PERCENTAGE%)"`

#### Differences with Player Units
- **Player units**: Already showed numerical values (`info.health..'/'..info.max_health`)
- **Enemy units**: Only showed percentage before modification

---

## Boss System

### Safari Map Bosses

#### 1. Queen
- **Type**: Alien boss
- **HP**: 30,000
- **Armor**: 50
- **Damage**: 100
- **Range**: 250
- **Abilities**: Summons Queen Protectors, area attacks
- **Boss icon**: 4,1

#### 2. Mech0
- **Type**: Mechanical boss
- **HP**: 40,000
- **Armor**: 75
- **Damage**: 80 (basic) + 150 (rockets)
- **Range**: 1,600
- **Abilities**: Launches drones, long-range rockets, self-destruction
- **Boss icon**: 4,2

#### 3. Jack the Crank
- **Type**: Giant mutant
- **HP**: 30,000
- **Armor**: 25
- **Damage**: Variable (special projectiles)
- **Range**: 2,500
- **Abilities**: Green energy projectiles, immune to PlaguedCorrosion
- **Boss icon**: 5,1

#### 4. Bill
- **Type**: One-handed mutant
- **HP**: 50,000
- **Armor**: 25
- **Damage**: 350
- **Range**: 250
- **Abilities**: "Stomp" attack with chain, area damage, stun
- **Scale**: 2.5x (very large)
- **Boss icon**: 1,2

#### 5. ScorpionBoss
- **Type**: Giant alien scorpion
- **HP**: 70,000
- **Armor**: 25
- **Damage**: 250
- **Range**: 250
- **Speed**: 600
- **Abilities**: HatchEggAbi (summons eggs when low on health)
- **Boss icon**: 1,4
- **Hardmode**: Available if 4 or fewer eggs are broken during the fight
- **Hardmode Artifact**: Blue color (Artifact1), larger size (1.0 scale)

### Safari Map Special Mechanics

- **Ping System**: All bosses are automatically marked every 25 seconds
- **Egg System**: ScorpionBoss has a complex system where it summons eggs
- **Objectives**: The map has exploration and combat objectives
- **Map Type**: Special Location with up to 6 officers and 18 recruitment points

---

## Loot System

### Rarity Levels

The game has **5 rarity levels** for items:
- **Common** (50% chance)
- **Rare** (25% chance) 
- **Epic** (10% chance)
- **Legendary** (5% chance)
- **Unique** (1% chance)

### Boss Loot Tables

**Safari Bosses:**

| Boss | Loot ID | Epic | Legendary | Unique |
|------|---------|------|-----------|--------|
| **Queen** | 50 | 100% | 5% | 0% |
| **Mech0** | 60 | 100% | 5% | 0% |
| **Jack** | 70 | 100% | 10% | 0% |
| **Bill Normal** | 80 | 0% | 10% | 0% |
| **Bill Hard** | 90 | **100%** | **20%** | **0%** |
| **Scorpion Normal** | 480 | 0% | 15% | 0% |
| **Scorpion Hard** | 490 | **100%** | **25%** | **0%** |

### Loot Files

- **`data/db/items/loot index.tsv`**: Defines loot tables by ID
- **`data/db/items/drop.tsv`**: Defines specific drop probabilities
- **`data/db/items/loot.tsv`**: Contains specific items per table

---

## Game Architecture

### Base Engine
- **Engine**: Proprietary C++ with Lua scripting
- **Physics**: NVIDIA PhysX 2.4.0
- **Rendering**: DirectX (Vertex/Pixel Shader 2.0)
- **Animations**: NetImmerse/Gamebryo (`.nif`, `.kf`, `.kfm`)

### Data-Driven Design
- **`.dt` files**: Declarative definitions with inheritance
- **Actor System**: `BaseUnit`/`BaseBuilding` hierarchy
- **Lua Scripts**: Extensive game logic

### Main Systems

#### Actor System
- **Hierarchy**: `BaseUnit`/`BaseBuilding` for Humans, Mutants, Aliens
- **Properties**: Stats, movement, sight, actions, abilities
- **C++ Controllers**: For specific behavior

#### Combat System
- **Weapons**: Instant, projectiles, area
- **Damage Types**: Explosion, fire, poison
- **Armor**: Damage reduction
- **Critical Hits**: Probability and multiplier

#### Action System
- **Defined in `.dt`**: Linked to Lua programs
- **Key Binding**: Command pattern
- **Example**: `bind B action Barrage, ProduceAssaultBot, ProduceBrute`

#### AI System
- **Lua-based AI**: Unit production, force assignment
- **Force Compositions**: Predefined in `data/db/ai/ai.dt`
- **Think Interval**: 1 second

---

## File Structure

### Main Directories

```
data/
├── db/                    # Game database
│   ├── ui/               # User interfaces
│   ├── units/            # Unit definitions
│   ├── buildings/        # Building definitions
│   ├── actions/          # Action definitions
│   ├── effects/          # Game effects
│   ├── items/            # Items and loot system
│   ├── scripts/          # System Lua scripts
│   └── etc/              # General configurations
├── maps/                 # Game maps
│   └── missions/         # Specific missions
└── texts/                # Localized texts
```

### Key Files by System

#### UI and HUD
- `data/db/ui/bossfight.lua` - Boss health bars
- `data/db/ui/selection.lua` - Unit selection HUD
- `data/db/ui/gameui.lua` - Main game UI
- `data/db/ui/resources.lua` - Resource display

#### Artifact System
- `data/db/etc/artifacts.dt` - Artifact definitions
- `data/maps/missions/safari.map` - Safari map configuration
- `data/maps/missions/safari.lua` - Safari map logic

#### Loot System
- `data/db/items/loot index.tsv` - Loot table index
- `data/db/items/drop.tsv` - Drop probabilities
- `data/db/items/loot.tsv` - Specific items

#### Configuration
- `data/db/etc/earth.dt` - General game configuration
- `data/db/etc/globals.dt` - Global constants
- `data/db/pvp/pvp.dt` - PvP configuration

### Naming Conventions

#### Definition Files (.dt)
- **Units**: `data/db/units/[race]/[name].dt`
- **Buildings**: `data/db/buildings/[name].dt`
- **Actions**: `data/db/actions/[name].dt`
- **Effects**: `data/db/effects/[name].dt`

#### Script Files (.lua)
- **UI**: `data/db/ui/[name].lua`
- **Actors**: `data/db/scripts/actors/[name].lua`
- **AI**: `data/db/scripts/ai/[name].lua`
- **Maps**: `data/maps/missions/[name].lua`

#### Data Files (.tsv)
- **Loot**: `data/db/items/[type].tsv`
- **Texts**: `data/texts/[language]/[type].tsv`

---

## Developer Notes

### Common Modifications

#### Change Boss Values
1. Edit boss `.dt` file in `data/db/units/environment/`
2. Modify stats: `hp`, `armor`, `damage`, `range`
3. Restart game to apply changes

#### Add New Artifacts
1. Define in `data/db/etc/artifacts.dt`
2. Create loot table in `data/db/items/loot index.tsv`
3. Configure in corresponding map

#### Modify UI
1. Edit `.lua` files in `data/db/ui/`
2. Use `this.Text:SetStr()` to change text
3. Use `math.floor()` to round numbers

### Technical Considerations

- **Inheritance**: `.dt` files support inheritance with `:`
- **Variables**: Use `stat:` to reference statistics
- **Conditions**: Complex condition system in `.map` files
- **Lua**: Extensive scripts for game logic

### Debugging

- **Logs**: Lua scripts print debug information
- **Conditions**: Condition logging system in `safari.lua`
- **Variables**: Access object variables with `GetVar()`

---

*Document updated: [Current Date]*
*Version: 1.0*
