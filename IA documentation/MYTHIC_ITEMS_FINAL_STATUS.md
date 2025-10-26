# Estado Final de Items Míticos

## Cambios Aplicados

### 1. Probabilidades de Drop
**Todos los hardmodes tienen ahora 15% de probabilidad de dropear items míticos (tier 1)**

Hardmodes actualizados:
- Safari - Bill Hard (90)
- JY Gorgar Hard (250)
- JY Ditz Left Side Hard (260)
- CF Boss Extra 1 (360)
- CF Boss Extra 2 (370)
- AC Hard (410)
- RH Final Master (440)
- BRD Lan Zealot - Hard (470)
- DTB Hard (111) - Nueva loot table

### 2. Distribución de Items

#### Items en DTB Hard (Loot Table 111):
- 70000 - MYTHIC Godlike Command Core
- 70001 - MYTHIC Shadow of the Void
- 70003 - MYTHIC Celestial Healer
- 70010 - MYTHIC Cosmic Devastation
- 70013 - MYTHIC Harvester of Souls
- 70014 - MYTHIC Mystic Transcendence
- 70020 - MYTHIC Primal Ascension
- 70021 - MYTHIC Void Walker

#### Items añadidos a múltiples hardmodes:
- **70006 - MYTHIC Immortal Defender**: Safari - Bill Hard, CF Boss Extra 2, RH Final Master, BRD Lan Zealot - Hard
- **70007 - MYTHIC Neural God Matrix**: JY Gorgar Hard, JY Ditz Left Side Hard, AC Hard, RH Final Master
- **70013 - MYTHIC Harvester of Souls**: DTB Hard, CF Boss Extra 2, BRD Lan Zealot - Hard, RH Final Master
- **70017 - MYTHIC Corruption God Seed**: JY Gorgar Hard, BRD Lan Zealot - Hard, RH Final Master
- **70019 - MYTHIC Enigma of the Void**: CF Boss Extra 1, AC Hard, BRD Lan Zealot - Hard, RH Final Master
- **70001 - MYTHIC Shadow of the Void**: CF Boss Extra 1, AC Hard, RH Final Master, DTB Hard

### 3. Ubicaciones por Hardmode

**Safari - Bill Hard (90)** - 15% mítico:
- 70000 - MYTHIC Godlike Command Core
- 70006 - MYTHIC Immortal Defender
- 70010 - MYTHIC Cosmic Devastation
- 70020 - MYTHIC Primal Ascension

**JY Gorgar Hard (250)** - 15% mítico:
- 70005 - MYTHIC Master Engineer Core
- 70007 - MYTHIC Neural God Matrix
- 70011 - MYTHIC Eternal Guardian
- 70017 - MYTHIC Corruption God Seed
- 70023 - MYTHIC Titan Guardian Core

**JY Ditz Left Side Hard (260)** - 15% mítico:
- 70002 - MYTHIC Divine Justice
- 70007 - MYTHIC Neural God Matrix
- 70012 - MYTHIC Dominion Core
- 70021 - MYTHIC Void Walker

**CF Boss Extra 1 (360)** - 15% mítico:
- 70001 - MYTHIC Shadow of the Void
- 70008 - MYTHIC Legendary Arsenal
- 70016 - MYTHIC Astral God Core
- 70019 - MYTHIC Enigma of the Void
- 70025 - MYTHIC Psychic Overlord

**CF Boss Extra 2 (370)** - 15% mítico:
- 70004 - MYTHIC Supreme Overlord
- 70006 - MYTHIC Immortal Defender
- 70013 - MYTHIC Harvester of Souls
- 70018 - MYTHIC Dogma of Power
- 70022 - MYTHIC Legendary Destroyer

**AC Hard (410)** - 15% mítico:
- 70001 - MYTHIC Shadow of the Void
- 70003 - MYTHIC Celestial Healer
- 70007 - MYTHIC Neural God Matrix
- 70015 - MYTHIC Defiler of Worlds
- 70019 - MYTHIC Enigma of the Void
- 70024 - MYTHIC Phantom God Stone

**RH Final Master (440) - The Renegades' Hideout final boss** - 15% mítico:
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

**BRD Lan Zealot - Hard (470)** - 15% mítico:
- 70006 - MYTHIC Immortal Defender
- 70009 - MYTHIC Psionic God Core
- 70013 - MYTHIC Harvester of Souls
- 70014 - MYTHIC Mystic Transcendence
- 70017 - MYTHIC Corruption God Seed
- 70019 - MYTHIC Enigma of the Void
- 70026 - MYTHIC Blood God Essence

**DTB Hard (111)** - 15% mítico:
- 70000 - MYTHIC Godlike Command Core
- 70001 - MYTHIC Shadow of the Void
- 70003 - MYTHIC Celestial Healer
- 70010 - MYTHIC Cosmic Devastation
- 70013 - MYTHIC Harvester of Souls
- 70014 - MYTHIC Mystic Transcendence
- 70020 - MYTHIC Primal Ascension
- 70021 - MYTHIC Void Walker

---

## Items Verificados
Todos los 33 items míticos tienen ubicaciones de drop asignadas.

**Items en RH Final Master (440)** - Verificado:
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

## Probabilidades Calculadas

Con el 15% configurado en `loot index.tsv` y las columnas 8-10 en `drop.tsv`:

- **Probabilidad de al menos 1 item mítico por run**: ~15% (línea principal con 100% chance)
- **Probabilidad adicional**: Algunos hardmodes tienen línea secundaria con 25% chance, lo que añade ~3.75% adicional

**Probabilidad total aproximada**: 15-19% dependiendo del hardmode

---

## Archivos Modificados

1. **data/db/items/items.tsv** - 33 nuevos items míticos (IDs 70000-70032)
2. **data/db/items/loot.tsv** - Asignación de items a loot tables
3. **data/db/items/loot index.tsv** - Probabilidades de tier 1 (Mythic) al 15%
4. **data/db/items/drop.tsv** - Configuración de drops con columna 8 al 15%
5. **IA documentation/MYTHIC_ITEMS_REFERENCE.md** - Documentación actualizada

---

## Formato de Stats Corregido

Los items míticos ahora tienen el formato correcto con tabulaciones entre stats en lugar de espacios. Ejemplo:

```
70000	1	Humans	HUMAN_COMMANDER	MYTHIC Godlike Command Core	Commander	Commander damage = 50	Commander hp = 30%	Commander psi = 40%	Commander crit_chance = 15	Commander armor = 10
```

Este formato es el correcto para que el engine interprete los stats correctamente.
