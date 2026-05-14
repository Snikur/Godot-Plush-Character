class_name SpellResource
extends Resource

enum SpellType {
	PROJECTILE,
	NONE
}

enum ProjectileType {
	FIREBALL,
	FROSTBOLT,
	NONE
}

@export var type: SpellType = SpellType.NONE
@export var projectile_type: ProjectileType = ProjectileType.NONE
@export var cooldown: float = 0.0
@export var max_charges: int = 1
@export var is_activate_spell: bool = false
@export var name: String
@export var description: String
@export var texture: Texture2D = null
@export var activated_texture: Texture2D = null
@export var spell_scene: PackedScene
@export var vfx_scene: PackedScene

var spell_button: SpellTextureButton
var charges: int = 0
var is_activated: bool = false

func init(button: SpellTextureButton) -> void:
	charges = max_charges if not is_activate_spell else 1
	spell_button = button
	if spell_button != null:
		spell_button.cooldown.max_value = cooldown
		spell_button.texture_normal = texture
		spell_button.timer.wait_time = cooldown
		spell_button.charges.text = str(max_charges)
		if max_charges <= 1:
			spell_button.show_charges(false)
		else:
			spell_button.show_charges(true)

func cast_spell(owner: SpellManager, index: int) -> void:
	print("cast spell")
	if is_activate_spell:
		is_activated = false
		spell_button.texture_normal = texture

	owner.send_spell.rpc(self.type, self.projectile_type, index)

func activate_spell(_owner: SpellManager) -> void:
	if is_activate_spell:
		is_activated = true
		spell_button.texture_normal = activated_texture
