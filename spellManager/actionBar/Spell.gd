extends Resource
class_name Spell

@export var cooldown: float = 0.0
@export var texture: Texture2D = null
@export var spell_scene: PackedScene

func init(spell_button: SpellTextureButton):
	spell_button.cooldown.max_value = cooldown
	spell_button.texture_normal = texture
	spell_button.timer.wait_time = cooldown

func cast_spell(owner: SpellManager):
	if is_instance_valid(owner.target):
		print("cast spell at ", owner.target.name)
