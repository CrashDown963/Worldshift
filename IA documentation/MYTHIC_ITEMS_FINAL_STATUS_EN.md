# Final Status of Mythic Items

## Applied Changes

### 1. Drop Probabilities
**All hardmodes now have 15% chance to drop mythic items (tier 1)**

Updated hardmodes:
- Safari - Bill Hard (90)
- JY Gorgar Hard (250)
- JY Ditz Left Side Hard (260)
- CF Boss Extra 1 (360)
- CF Boss Extra 2 (370)
- AC Hard (410)
- RH Final Master (440) - The Renegades' Hideout final boss
- BRD Lan Zealot - Hard (470)
- DTB Hard (111) - New loot table

### 2. Item Distribution

#### Items in DTB Hard (Loot Table 111):
- 70000 - MYTHIC Godlike Command Core
- 70001 - MYTHIC Shadow of the Void
- 70003 - MYTHIC Celestial Healer
- 70010 - MYTHIC Cosmic Devastation
- 70013 - MYTHIC Harvester of Souls
- 70014 - MYTHIC Mystic Transcendence
- 70020 - MYTHIC Primal Ascension
- 70021 - MYTHIC Void Walker

#### Items added to multiple hardmodes:
- **70006 - MYTHIC Immortal Defender**: Safari - Bill Hard, CF Boss Extra 2, RH Final Master, BRD Lan Zealot - Hard
- **70007 - MYTHIC Neural God Matrix**: JY Gorgar Hard, JY Ditz Left Side Hard, AC Hard, RH Final Master
- **70013 - MYTHIC Harvester of Souls**: DTB Hard, CF Boss Extra 2, BRD Lan Zealot - Hard, RH Final Master
- **70017 - MYTHIC Corruption God Seed**: JY Gorgar Hard, BRD Lan Zealot - Hard, RH Final Master
- **70019 - MYTHIC Enigma of the Void**: CF Boss Extra 1, AC Hard, BRD Lan Zealot - Hard, RH Final Master
- **70001 - MYTHIC Shadow of the Void**: CF Boss Extra 1, AC Hard, RH Final Master, DTB Hard

### 3. Locations by Hardmode

**Safari - Bill Hard (90)** - 15% mythic:
- 70000 - MYTHIC Godlike Command Core
- 70006 - MYTHIC Immortal Defender
- 70010 - MYTHIC Cosmic Devastation
- 70020 - MYTHIC Primal Ascension

**JY Gorgar Hard (250)** - 15% mythic:
- 70005 - MYTHIC Master Engineer Core
- 70007 - MYTHIC Neural God Matrix
- 70011 - MYTHIC Eternal Guardian
- 70017 - MYTHIC Corruption God Seed
- 70023 - MYTHIC Titan Guardian Core

**JY Ditz Left Side Hard (260)** - 15% mythic:
- 70002 - MYTHIC Divine Justice
- 70007 - MYTHIC Neural God Matrix
- 70012 - MYTHIC Dominion Core
- 70021 - MYTHIC Void Walker

**CF Boss Extra 1 (360)** - 15% mythic:
- 70001 - MYTHIC Shadow of the Void
- 70008 - MYTHIC Legendary Arsenal
- 70016 - MYTHIC Astral God Core
- 70019 - MYTHIC Enigma of the Void
- 70025 - MYTHIC Psychic Overlord

**CF Boss Extra 2 (370)** - 15% mythic:
- 70004 - MYTHIC Supreme Overlord
- 70006 - MYTHIC Immortal Defender
- 70013 - MYTHIC Harvester of Souls
- 70018 - MYTHIC Dogma of Power
- 70022 - MYTHIC Legendary Destroyer

**AC Hard (410)** - 15% mythic:
- 70001 - MYTHIC Shadow of the Void
- 70003 - MYTHIC Celestial Healer
- 70007 - MYTHIC Neural God Matrix
- 70015 - MYTHIC Defiler of Worlds
- 70019 - MYTHIC Enigma of the Void
- 70024 - MYTHIC Phantom God Stone

**RH Final Master (440) - The Renegades' Hideout final boss** - 15% mythic:
- 70001 - MYTHIC Shadow of the Void
- 70006 - MYTHIC Immortal Defender
- 70007 - MYTHIC Neural God Matrix
- 70013 - MYTHIC Harvester of Souls
- 70017 - MYTHIC Corruption God Seed
- 70019 - MYTHIC Enigma of the Void
- 70027 - MYTHIC Nature God Seed
- 70028 - MYTHIC Mind God Matrix
- 70029 - MYTHIC Spirit God Core
- 70030 - MYTHIC Durable Frame
- 70031 - MYTHIC Bio Core
- 70032 - MYTHIC Eternal Core

**BRD Lan Zealot - Hard (470)** - 15% mythic:
- 70006 - MYTHIC Immortal Defender
- 70009 - MYTHIC Psionic God Core
- 70013 - MYTHIC Harvester of Souls
- 70014 - MYTHIC Mystic Transcendence
- 70017 - MYTHIC Corruption God Seed
- 70019 - MYTHIC Enigma of the Void
- 70026 - MYTHIC Blood God Essence

**DTB Hard (111)** - 15% mythic:
- 70000 - MYTHIC Godlike Command Core
- 70001 - MYTHIC Shadow of the Void
- 70003 - MYTHIC Celestial Healer
- 70010 - MYTHIC Cosmic Devastation
- 70013 - MYTHIC Harvester of Souls
- 70014 - MYTHIC Mystic Transcendence
- 70020 - MYTHIC Primal Ascension
- 70021 - MYTHIC Void Walker

---

## Verified Items
All 33 mythic items have assigned drop locations.

**Items in RH Final Master (440)** - Verified:
- 70001 - MYTHIC Shadow of the Void ✓
- 70006 - MYTHIC Immortal Defender ✓
- 70007 - MYTHIC Neural God Matrix ✓
- 70013 - MYTHIC Harvester of Souls ✓
- 70017 - MYTHIC Corruption God Seed ✓
- 70019 - MYTHIC Enigma of the Void ✓
- 70027 - MYTHIC Nature God Seed ✓
- 70028 - MYTHIC Mind God Matrix ✓
- 70029 - MYTHIC Spirit God Core ✓
- 70030 - MYTHIC Durable Frame ✓
- 70031 - MYTHIC Bio Core ✓
- 70032 - MYTHIC Eternal Core ✓

---

## Calculated Probabilities

With 15% configured in `loot index.tsv` and columns 8-10 in `drop.tsv`:

- **Probability of at least 1 mythic item per run**: ~15% (main line with 100% chance)
- **Additional probability**: Some hardmodes have a secondary line with 25% chance, which adds an additional ~3.75%

**Approximate total probability**: 15-19% depending on the hardmode

---

## Modified Files

1. **data/db/items/items.tsv** - 33 new mythic items (IDs 70000-70032)
2. **data/db/items/loot.tsv** - Item assignment to loot tables
3. **data/db/items/loot index.tsv** - Tier 1 (Mythic) probabilities set to 15%
4. **data/db/items/drop.tsv** - Drop configuration with column 8 set to 15%
5. **IA documentation/MYTHIC_ITEMS_REFERENCE.md** - Updated documentation

---

## Corrected Stats Format

Mythic items now have the correct format with tabulations between stats instead of spaces. Example:

```
70000	1	Humans	HUMAN_COMMANDER	MYTHIC Godlike Command Core	Commander	Commander damage = 50	Commander hp = 30%	Commander psi = 40%	Commander crit_chance = 15	Commander armor = 10
```

This format is the correct one for the engine to properly interpret the stats.

