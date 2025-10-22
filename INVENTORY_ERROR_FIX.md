# inventory.lua Error Fix

## Identified Problem
The game showed the error:
```
[string "data/db/ui/inventory.lua"]:157: bad argument #1 to 'sub' (string expected, got nil)
```

## Error Cause
In line 157 of `inventory.lua`, the `string.sub()` function was being called with a `nil` value instead of a string. This occurred when `this:GetInfo()` returned `nil` for empty inventory slots.

## Original Problematic Code
```lua
else
  local repo = this:GetInfo()
  if string.sub(repo, 1, 7) == "MUTANT_" or string.sub(repo, 1, 15) == "INSPECT_MUTANT_" then
    -- ... code ...
  end
  -- ... more string.sub() checks ...
end
```

## Implemented Solution

### **Safety Verification**
**File**: `data/db/ui/inventory.lua` (lines 156-170)

Added a verification to ensure `repo` is a valid string before using `string.sub()`:

```lua
else
  local repo = this:GetInfo()
  if repo and type(repo) == "string" then
    if string.sub(repo, 1, 7) == "MUTANT_" or string.sub(repo, 1, 15) == "INSPECT_MUTANT_" then
      this.frame_top = this.mutants_top
      this.lvl_top = this.lvl_mutants_top
    end
    if string.sub(repo, 1, 6) == "ALIEN_" or string.sub(repo, 1, 14) == "INSPECT_ALIEN_" then
      this.frame_top = this.aliens_top
      this.lvl_top = this.lvl_aliens_top
    end
    if string.sub(repo, 1, 6) == "HUMAN_" or string.sub(repo, 1, 14) == "INSPECT_HUMAN_" then
      this.frame_top = this.humans_top
      this.lvl_top = this.lvl_humans_top
    end
  end
end
```

## Changes Made

### **1. Existence Verification**
- **Added**: `if repo and type(repo) == "string" then`
- **Purpose**: Verify that `repo` exists and is a string before using `string.sub()`

### **2. Nil Protection**
- **Problem**: `string.sub(nil, 1, 7)` caused the error
- **Solution**: Only execute `string.sub()` if `repo` is valid

### **3. Functionality Maintenance**
- **Behavior**: If `repo` is `nil`, simply don't execute the verifications
- **Result**: Empty slots don't cause errors

## Error Context

### **When It Occurs**
This error was likely triggered when:
1. The shop was opened from the lobby
2. PvP inventory slots were empty
3. The system tried to determine the correct frame for empty slots

### **Relationship with DefPVPSlot**
- `DefPVPSlot` uses the inventory system
- PvP slots can be empty initially
- `GetInfo()` returns `nil` for empty slots

## Fix Status

✅ **Error Resolved**: `string.sub()` no longer receives `nil` values  
✅ **Correct Syntax**: No linting errors  
✅ **Functionality Maintained**: Normal behavior is preserved  
✅ **Protection Added**: Type verification to prevent future errors  

## Additional Benefits

### **Robustness**
- The code is now more resistant to unexpected values
- Prevents similar errors in the future

### **Compatibility**
- Maintains existing functionality
- Doesn't affect normal inventory behavior

The shop button should now work without errors related to the inventory system.
