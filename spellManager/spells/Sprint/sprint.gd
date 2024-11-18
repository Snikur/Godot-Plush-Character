extends Spell
class_name SprintSpell

func init(button: SpellTextureButton):
	cooldown = 0.5
	texture = preload("res://spellManager/spells/Sprint/trallgard.png")
	super.init(button)

func cast_spell(owner: SpellManager, index: int):
	super.cast_spell(owner, index)
	owner.source.speed_modifier += 2.0
	owner.get_tree().create_timer(2.0).timeout.connect(func():
		owner.source.speed_modifier -= 2.0
	)
