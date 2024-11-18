extends Resource
class_name Spell

enum SPELLTYPE {
	FIREBALL,
	FROSTBOLT,
	NONE
}
@export var type: SPELLTYPE = SPELLTYPE.NONE
@export var cooldown: float = 0.0
@export var maxCharges: int = 1
@export var texture: Texture2D = null
@export var spell_scene: PackedScene

var charges: int = 0

func init(spell_button: SpellTextureButton):
	charges = maxCharges
	if (spell_button != null):
		spell_button.cooldown.max_value = cooldown
		spell_button.texture_normal = texture
		spell_button.timer.wait_time = cooldown
		spell_button.charges.text = str(maxCharges)

func cast_spell(owner: SpellManager, index: int):
	owner.cast_spell.rpc(type, index)
