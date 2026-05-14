class_name TimeTravelSpell
extends SpellResource

var original_position: Vector3

func init(button: SpellTextureButton) -> void:
	cooldown = 60.0
	is_activate_spell = true
	name = &"Time Travel"
	description = &"You manipulate time by first marking a location and when cast again teleport back to the marked location."
	texture = preload("res://spellManager/spells/TimeTravel/craftingmarissa.png")
	activated_texture = preload("res://spellManager/spells/TimeTravel/craftingmarissa_inverted.png")
	super.init(button)

func cast_spell(owner: SpellManager, index: int) -> void:
	super.cast_spell(owner, index)
	if is_instance_valid(owner.source):
		owner.source.global_position = original_position
	else:
		print("no owner target on timetravel")

func activate_spell(owner: SpellManager) -> void:
	super.activate_spell(owner)
	if is_instance_valid(owner.source):
		original_position = owner.source.global_position
	else:
		print("no owner target on timetravel")
