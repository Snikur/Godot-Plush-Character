extends Resource
class_name SpellResource

enum SPELLTYPE {
	PROJECTILE,
	NONE
}
enum PROJECTILE_TYPE {
	FIREBALL,
	FROSTBOLT,
	NONE
}
@export var type: SPELLTYPE = SPELLTYPE.NONE
@export var projectile_type: PROJECTILE_TYPE = PROJECTILE_TYPE.NONE
@export var cooldown: float = 0.0
@export var maxCharges: int = 1
@export var isActivateSpell: bool = false
@export var texture: Texture2D = null
@export var activatedTexture: Texture2D = null
@export var spell_scene: PackedScene
@export var vfx_scene: PackedScene

var spell_button: SpellTextureButton
var charges: int = 0
var isActivated: bool = false

func init(button: SpellTextureButton):
	charges =  maxCharges if not isActivateSpell else 1
	spell_button = button
	if (spell_button != null):
		spell_button.cooldown.max_value = cooldown
		spell_button.texture_normal = texture
		spell_button.timer.wait_time = cooldown
		spell_button.charges.text = str(maxCharges)
		if maxCharges <= 1:
			spell_button.showCharges(false)
		else:
			spell_button.showCharges(true)

func cast_spell(owner: SpellManager, index: int):
	if isActivateSpell:
		isActivated = false
		spell_button.texture_normal = texture
	
	owner.send_spell.rpc(self.type, self.projectile_type, index)

func activate_spell(_owner: SpellManager):
	if isActivateSpell:
		isActivated = true
		spell_button.texture_normal = activatedTexture
