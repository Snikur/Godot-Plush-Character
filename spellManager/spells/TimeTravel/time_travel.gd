extends SpellResource
class_name TimeTravelSpell

var originalPosition: Vector3

func init(button: SpellTextureButton):
	cooldown = 60.0
	isActivateSpell = true
	texture = preload("res://spellManager/spells/TimeTravel/craftingmarissa.png")
	activatedTexture = preload("res://spellManager/spells/TimeTravel/craftingmarissa_inverted.png")
	super.init(button)

func cast_spell(owner: SpellManager, index: int):
	super.cast_spell(owner, index)
	if is_instance_valid(owner.source):
		owner.source.global_position = originalPosition
	else:
		print("no owner target on blinkspell")

func activate_spell(owner: SpellManager):
	super.activate_spell(owner)
	if is_instance_valid(owner.source):
		originalPosition = owner.source.global_position
	else:
		print("no owner target on blinkspell")
	
