extends Spell
class_name FireballSpell

func init(spell_button: SpellTextureButton):
	cooldown = 1.0
	texture = preload("res://spellManager/spells/Fireball/flobo.png")
	super.init(spell_button)

@rpc("authority", "call_local", "reliable")
func cast_spell(owner: SpellManager):
	if (is_instance_valid(owner.target)):
		super.cast_spell(owner)
		var fireball = preload("res://spellManager/spells/Fireball/fireball.tscn").instantiate()
		fireball.top_level = true
		fireball.target = owner.target
		owner.add_child(fireball)
		fireball.global_position = owner.global_position + Vector3(0.0, 0.5, 0.0)
