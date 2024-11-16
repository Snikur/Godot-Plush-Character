extends Spell
class_name SprintSpell

func _init(spell_button: SpellTextureButton):
	cooldown = 0.5
	texture = preload("res://spellManager/spells/Sprint/trallgard.png")
	super._init(spell_button)
	
@rpc("authority", "call_local", "reliable")
func cast_spell(owner: SpellManager):
	super.cast_spell(owner)
	owner.source.speed_modifier += 2.0
	owner.get_tree().create_timer(2.0).timeout.connect(func():
		owner.source.speed_modifier -= 2.0
	)
