extends Resource
class_name Spell

enum SPELLTYPE {
	FIREBALL,
	FROSTBOLT,
	NONE
}
@export var type: SPELLTYPE = SPELLTYPE.NONE
@export var cooldown: float = 0.0
@export var texture: Texture2D = null
@export var spell_scene: PackedScene

func init(spell_button: SpellTextureButton):
	if (spell_button != null):
		spell_button.cooldown.max_value = cooldown
		spell_button.texture_normal = texture
		spell_button.timer.wait_time = cooldown

func cast_spell(owner: SpellManager, index: int):
	owner.cast_spell.rpc(type, index)
