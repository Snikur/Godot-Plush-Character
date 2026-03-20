# Game Design Document - Godot Plush

## Overview
**Godot Plush** is a multiplayer action RPG featuring a plush character with state-machine-driven animations, combat, spells, inventory, quests, and achievements. Built in Godot 4.6 with multiplayer support via WebSocket.

## Core Gameplay Mechanics

### Character System
- **Player Class**: CharacterBody3D with state machine using `godot_state_charts` addon
- **Movement States**: Ground, Climbing, Water, Knockback, Fall, Jump
- **Animation States**: Idle, Walk, Run, Fall, Jump, Fish
- **Stats**: Health, Mana, Experience, Level system
- **Speed**: Base speed 2.5, Run speed 7.0, Acceleration 128.0

### Combat System
- **Health Management**: CombatComponent with health_changed signal
- **Attack Types**: Melee attacks with swing timers
- **Enemy AI**: Target Dummy with aggro area, pursuit, and evading behavior
- **Damage**: Player deals 45 damage per hit to enemies
- **Death**: Enemies reset health after evading period

### Spell System
- **Spell Types**: Projectile, Blink, Sprint, TimeTravel
- **Projectile Spells**: Fireball, Frostbolt with custom shaders
- **UI**: Action bar with 4+ spell slots, Spellbook grid menu (P key)
- **Cooldown Management**: Built-in cooldown tracking per spell
- **Visual Effects**: Particle systems for jumps, land, movement dust

### Inventory System
- **Slot System**: 16-slot inventory grid
- **Item Types**: Healing potions, resources
- **Item Actions**: On-use actions via `ItemOnUseBase` script
- **Item Resources**: `.tres` resources for configurable item data
- **Sell Mechanic**: Random sell prices for collected items

### Quest System
- **Quest Chain**: Help Threepwood quest (kill target dummy, find coin)
- **Quest States**: Accept, Active, Complete, Reward collected
- **Quest UI**: 3D markers, panel dialogs with accept/close/complete buttons
- **Progress Tracking**: State machine tracks objectives (target killed, item picked up)
- **Rewards**: Experience points (1399 XP example)

### Achievement System
- **Save System**: JSON-based achievements with user profile save
- **Achievement Types**: Collect coin, First spell, Example achievements
- **UI**: Popup notifications with title, description, timer animation
- **Progress Tracking**: Current amount vs needed amount

### Multiplayer
- **Architecture**: WebSocket server (port 25565)
- **Connection**: Up to 4095 clients, default 4-player demo
- **Sync**: Server authoritative, client state interpolation
- **RPCs**: Player teleport, state transitions, health changes, spell casting
- **Tick System**: Regular tick for state updates, slow tick for less frequent updates

## World & Environments

### Map Features
- **Cave Scene**: Large cave environment with puzzles
- **Floating Island**: Vertical exploration
- **Mini World**: Smaller testing area
- **Terrain**: Terrain3D addon for terrain generation
- **Interactive Elements**: Ladders, elevators, water areas, traps

### Interactive Objects
- **Treasure Chests**: Contain items, require interaction
- **Bounce Pads**: Launch players with random direction
- **Gathering Resources**: Collectible objects
- **Puzzle Cave**: Environmental puzzles
- **Crypt Generator**: Random generation system

## UI Systems

### HUD Elements
- **Health Bar**: ProgressBar with visual feedback
- **Mana Bar**: Resource management
- **Experience Bar**: Level progression
- **Level Display**: Current level number
- **Buff/Debuff Slots**: 2 buff slots, 4 debuff slots with duration bars
- **Tooltip System**: Item/ability descriptions on hover

### Menus
- **Main Menu**: Game start, settings
- **Option Panel**: FOV, sensitivity controls
- **Spellbook**: Grid-based spell selection (P key)
- **Inventory**: Grid container with item slots
- **Quest Panel**: Dialog with text and buttons

## Technical Architecture

### Component Pattern
```
Player (CharacterBody3D)
├── StateChart (godot_state_charts)
│   ├── GroundState
│   ├── ClimbingState
│   ├── WaterState
│   └── KnockbackState
├── CombatComponent
├── SpellManager
├── Inventory
└── VisualRoot (Node3D)
    └── Dude (AnimationTree)
```

### State Machine Pattern
- Uses `godot_state_charts` addon for finite state machines
- States communicate via events: `send_event("event_name")`
- Transitions trigger state changes
- Example: `state_chart.send_event("to_climbing")`

### Resource System
- **SpellResource**: Base class for spells with texture, cooldown, description
- **ItemResource**: Item data with actions array
- **QuestResource**: Quest configuration
- **ProjectileSpell**: Extends SpellResource with projectile logic

### Animation System
- **Mixamo Integration**: Retargeted animations via addon
- **AnimationTree**: State-based animation blending
- **Animation States**: Idle, Walk, Run, Jump, Fall, Fish, Swim, Dance, Wave
- **Procedural Tilt**: Visual root rotation based on movement

## NPCs & Enemies

### Target Dummy
- **Behavior**: Aggro on player proximity, pursuit, attack
- **Combat**: Swing timer, damage 45, health reset on evade
- **Quest Role**: Primary quest target

### NPC Types
- **QuestGiver**: NPCS/QuestGiver with dialogue system
- **BlackKnight**: Enemy type
- **Lumberjack**: NPC type
- **Threepwood**: Quest giver character

## Input System

### Key Bindings
- **Movement**: W/A/S/D or joystick
- **Jump**: Space / joystick button
- **Run**: Left Shift / joystick stick
- **Attack**: E or joystick trigger
- **Aim**: Right mouse button
- **Spellbook**: P key
- **Crouch**: Ctrl
- **Fish**: F key
- **Camera**: Mouse + zoom (wheel)

## Visual Style

### Art Direction
- **Character**: Plush toy aesthetic with Mixamo animations
- **Environments**: Colorful, cartoon-like
- **VFX**: Particle-based smoke, dust, spell effects
- **Shaders**: Custom fireball, frostbolt shaders

### Assets
- **Models**: Mixamo characters, custom props
- **Textures**: Kenney assets, custom textures
- **Sounds**: Audio from Kenney, custom SFX (secret_found.mp3)

## Progression System

### Level System
- **Experience**: Earned from quests, combat
- **Level Up**: Visual feedback via experience bar
- **Stats**: Health, mana scaling with level

### Achievement Progression
- Track completion of objectives
- Persistent save via JSON
- Unlock notifications

## Quest Examples

### Help Threepwood Quest Chain
1. **Accept**: Talk to quest giver
2. **Kill Target Dummy**: Combat objective
3. **Find Pirate Coin**: Exploration objective
4. **Return for Reward**: Complete quest, gain 1399 XP

## Demo Scenes
- **Demo Scene**: Player movement, enemy AI, navigation
- **Camera Demo**: First-person/third-person toggle
- **Navigation Demo**: Enemy pathfinding
- **Platformer Demo**: Godot state charts examples

## Future Features (Potential)
- More quest chains
- Additional spell types
- Boss battles
- Crafting system
- Trade/selling system
- Guild system
- PvP combat
- Raid dungeons

## Known Limitations
- 16-slot inventory limit
- Fixed spell slots (action bar size)
- Single-player focused quest system
- Basic enemy AI (no variety)
- Simple buff/debuff system (visual only)

## Development Notes
- Godot 4.6 with script-ide plugin
- TLS certificates for WebSocket (generated.crt, generated.key)
- Debug mode uses local server, release uses remote
- Async state transitions via `await`
- Tween-based UI animations
