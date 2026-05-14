class_name SprintSpell
extends SpellResource

func init(button: SpellTextureButton) -> void:
	cooldown = 0.5
	name = &"Sprint"
	description = &"Double your run speed for 2 seconds."
	texture = preload("res://spellManager/spells/Sprint/trallgard.png")
	super.init(button)

func cast_spell(owner: SpellManager, index: int) -> void:
	super.cast_spell(owner, index)
	owner.source.speed_modifier += 2.0
	owner.get_tree().create_timer(2.0).timeout.connect(func() -> void:
		owner.source.speed_modifier -= 2.0
	)
