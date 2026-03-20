# AGENTS.md - Godot 4 Project Guidelines

## Project Overview
This is a Godot 4.6 multiplayer action RPG game with state machine-based character animations, inventory, quests, spells, and combat systems.

## Build/Lint/Test Commands
- **Run Game**: `godot --path . --debug` or use Godot Editor
- **Run Specific Scene**: `godot --path . --scene res://MainMenu.tscn`
- **Export**: Use Godot Editor → Project → Export presets
- **Lint**: No dedicated linter; use script-ide plugin for type checking
- **Test**: No automated tests; verify via demo scenes in `demo/` folder
- **Run Single Test**: Launch demo scenes (e.g., `demo/src/Demo.tscn`)

## Code Style Guidelines

### Imports & Preloading
- Use `preload()` for scenes and resources: `const MY_SCENE = preload("res://path/to/scene.tscn")`
- Import scripts at top of scene files when needed
- Use `class_name` for reusable scripts (e.g., `class_name Player`)

### Formatting & Indentation
- 4-space indentation
- No trailing whitespace
- One blank line between functions
- Maximum 100 characters per line when possible

### Naming Conventions
- **Scripts**: `snake_case.gd` (e.g., `player.gd`, `spell_manager.gd`)
- **Classes/Variables**: `camelCase` (e.g., `jumpHeight`, `spellIndex`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `MOVE_SPEED`, `JUMP_VELOCITY`)
- **Signals**: `snake_case` (e.g., `body_entered`, `quest_completed`)
- **Functions**: `snake_case` (e.g., `_ready`, `cast_spell`, `send_transition_to`)
- **Nodes**: PascalCase in scenes (e.g., `VisualRoot`, `CombatComponent`)

### Type Hints
- Godot 4 uses native types: `int`, `float`, `String`, `bool`, `Vector2`, `Vector3`, `Node`, `Node3D`
- Always type function parameters and return values: `func _ready() -> void:`
- Use `@export` for inspector-exposed variables
- Use `@onready` for cached node references

### Error Handling
- Check conditions before accessing nodes: `if node:`
- Use `queue_free()` for safe node removal
- Handle multiplayer RPCs with proper authority checks
- Use `move_toward()` for smooth transitions

### Multiplayer
- Check `multiplayer.is_server()` and `multiplayer.get_unique_id()`
- Use `@rpc` decorators with proper parameters: `@rpc("authority", "reliable", "call_local")`
- Server authoritative for state changes
- Use `rpc_id()` for peer-specific calls

### State Machines
- Uses `godot_state_charts` addon for state patterns
- Send events via `state_chart.send_event("event_name")`
- Separate concerns: GroundState, ClimbingState, WaterState, etc.
- Transitions trigger via event handling

### Common Patterns
- **Component Architecture**: CombatComponent, Inventory, SpellManager as separate nodes
- **Resource-based**: Use `.tres` resources for configurable data
- **VFX/Audio**: Use `%` node names for shortcuts in scenes
- **Tweening**: Use `create_tween()` for animations
- **Signals**: Connect signals for decoupled communication

### File Organization
- `components/`: Reusable player components
- `spellManager/`: Spell system with resources and scenes
- `questManager/`: Quest system with resources
- `achievement/`: Achievement tracking
- `demo/`: Demo scenes for testing
- `addons/`: Third-party plugins (state charts, terrain, etc.)

### Godot 4 Specifics
- `move_and_slide()` replaces 3.x versions
- `@onready` saves node lookups
- `@export` replaces `export` keyword
- `signal` keyword for signals
- `-> void` for return types
- `tscn` for scenes, `tres` for resources, `gd` for scripts
