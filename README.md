# Worldshift Modding

## Quick Installation Guide

1. **Download the project**: Download the ZIP file from GitHub
2. **Extract the file**: Extract the ZIP contents to your desired location
3. **Run the game**: Open the `bin` folder and run `WorldShift.exe`

Ready! You can start playing now.

---

## New Features Added

### 🎮 New Units (6 official units)

**6 new official units** have been added to the game:

- **Engineer** (Humans) - Engineer specialized in turrets and defenses
- **Defender** (Humans) - Robot similar to Assault Bot that fires missiles
- **Psychic** (Mutants/Tribes) - Healer unit with support abilities
- **Elite Kai Rider** (Mutants/Tribes) - Sniper unit with long-range capabilities
- **Defiler** (Aliens) - Alien unit with corruption abilities
- **Psi Detonator** (Aliens) - Support unit specialized in mana regeneration

### 💎 Mythic Items System

A new **Mythic quality tier** (tier 1) superior to all others has been implemented:

- **33 unique mythic items** distributed among the 3 races
- **5% droprate** in hardmodes for **all races** (Humans, Aliens and Tribes)
- Items with significantly improved stats (50-100% superior to Unique items)
- Available in multiple hardmodes throughout the game

#### Examples of Mythic Items:
- **MYTHIC Godlike Command Core** (Commander)
- **MYTHIC Shadow of the Void** (Assassin)
- **MYTHIC Celestial Healer** (Surgeon)
- **MYTHIC Master Engineer Core** (Engineer)
- **MYTHIC Divine Justice** (Judge)
- **MYTHIC Supreme Overlord** (Constructor)
- And many more...

### 📦 New Item Slots

Two new item slots have been added for Humans:

- **Neuroscience Slot** - For items that enhance psionic and mental abilities
- **Engineer Slot** - For items that enhance engineering and turret capabilities

### 📊 Experience and Level System

Complete player progression system:

- **Level system**: Players gain experience by recycling items
- **Experience by quality** (only applies to Epic and Legendary items): 
  - Epic: 100 XP
  - Legendary: 250 XP
- **Levels**: Each level requires 1000 additional XP
- **Persistence**: Level and experience are saved between sessions
- **Visual feedback**: Notifications when you level up or gain experience

### 🌳 Ability Grid Rework (Skill Tree)

Completely revamped ability system:

- **Level-limited star system**: The maximum number of stars you can assign is limited by your level
  - **Formula**: 10 + floor(level / 10)
  - Example: Level 1-9 = 10 max stars, Level 10-19 = 11 max stars, Level 20-29 = 12 max stars, etc.
- **Gradual progression**: As you level up, you can assign more stars to your specializations

### 🛒 Main Menu Shop with Tokens

New shop accessible from the main menu:

- **"SHOP" button** in the main lobby menu
- **Token system**: Special currency to buy items
- **5 item slots**: Shows up to 5 random items of different qualities
- **Battle Points system**: Shows your current battle points
- **Item reroll**: Changes the item offer (costs Battle Points)
- **Direct purchase**: Click on an item to buy it with tokens
- **Race-separated inventory**: Items are automatically added to the correct inventory based on your race

#### Shop Features:
- Real-time display of Tokens and Battle Points
- Manual refresh button
- Full integration with the inventory system
- Token validation before purchasing

---

## Additional Information

### Important Installation Notes

**Note about ZIP files**: If you download the repository as a ZIP file and the game doesn't work, but it does work with `git clone`, this is due to **line ending differences**:

- **Git clone**: Automatically converts LF (Unix) to CRLF (Windows) during checkout
- **ZIP downloads**: Extracts files with their original line endings (typically LF)
- **The game expects CRLF**: WorldShift.exe reads files expecting Windows line endings (CRLF)

**Solution**: If you have issues, use `git clone` to ensure files have the correct line endings.

### Contributing

If you want to contribute changes:
1. Make your modifications
2. Add your changes: `git add .`
3. Commit your changes: `git commit -m "Your commit message"`
4. Push your changes: `git push origin main`

**Every push you make requires patch notes.**

---
