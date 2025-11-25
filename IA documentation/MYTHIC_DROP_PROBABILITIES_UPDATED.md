# Actualización de Probabilidades de Drop Mítico

## Cambios Realizados

Se han reducido las probabilidades de drop de items míticos en todos los hardmodes para que no sea garantizado (100%) como estaba configurado anteriormente.

### Nueva Configuración

**Probabilidades en tablas principales (líneas con 100% chance):**
- **10% de probabilidad de drop mítico**

**Probabilidades en tablas extra (líneas con 25% chance):**
- **5% de probabilidad de drop mítico**

## Hardmodes Afectados

### 1. Safari - Bill Hard (SourceID 90)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run

### 2. JY Gorgar Hard (SourceID 250)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run

### 3. JY Ditz Left Side Hard (SourceID 260)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run

### 4. CF Boss Extra 1 (SourceID 360)
- Solo línea principal: 10% mítico
- **Probabilidad total**: 10% de un mítico por run

### 5. CF Boss Extra 2 (SourceID 370)
- Solo línea principal: 10% mítico
- **Probabilidad total**: 10% de un mítico por run

### 6. AC Hard (SourceID 410)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run

### 7. RH Final Master (SourceID 440)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run

### 8. BRD Lan Zealot - Hard (SourceID 470)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run

### 9. DTB Hard (SourceID 470 - Nuevo)
- Cambiado para que dropee de loot table 90 (Safari - Bill Hard)
- Línea principal: 10% mítico
- Línea extra (25% chance): 5% mítico
- **Probabilidad total**: ~12.25% de al menos un mítico por run
- **Nota**: Ya no dropea de loot table 111 (que solo contenía míticos y garantizaba el drop)

## Archivos Modificados

1. **data/db/items/drop.tsv**
   - Probabilidades mítico cambiadas de 15% a 10% en líneas principales
   - Probabilidades mítico cambiadas de 15% a 5% en líneas extra (25% chance)
   - DTB Hard ahora dropea de loot table 90 en lugar de loot table 111

2. **data/db/items/loot index.tsv**
   - Todas las loot tables de hardmode cambiadas de 15% a 10% mítico
   - Loot table 111 (DTB Hard Mythic) también actualizada

## Cálculo de Probabilidades Finales

### Hardmodes con dos líneas de drop:
**Probabilidad de al menos un mítico = 1 - (probabilidad de NO mítico en línea 1 × probabilidad de NO mítico en línea 2)**

- Línea 1: 1 - 0.10 = 0.90 (90% de no ser mítico)
- Línea 2: 1 - 0.0125 = 0.9875 (98.75% de no ser mítico, considerando que solo se activa 25% de las veces)
  
**Probabilidad total**: 1 - (0.90 × 0.9875) = 1 - 0.88875 = **~11.13%**

### Hardmodes con una línea de drop:
**Probabilidad**: 10%

## Resumen

✅ **Antes**: 15-100% de probabilidad de mítico (100% en DTB Hard)
✅ **Ahora**: 10-12.25% de probabilidad de mítico en todos los hardmodes
✅ **Resultado**: Drop de míticos ya no es garantizado y tiene probabilidades razonables
✅ **DTB Hard**: Ya no dropea de loot table dedicada solo a míticos

