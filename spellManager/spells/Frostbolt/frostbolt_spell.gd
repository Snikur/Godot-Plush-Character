extends Spell
class_name FrostboltSpell

func _init(spell_button: SpellTextureButton):
	cooldown = 3.0
	texture = preload("res://spellManager/spells/Frostbolt/Coldflake.png")
	super._init(spell_button)
	
@rpc("authority", "call_local", "reliable")
func cast_spell(owner: SpellManager):
	if (is_instance_valid(owner.target)):
		super.cast_spell(owner)
		var frostbolt = preload("res://spellManager/spells/Frostbolt/frostbolt.tscn").instantiate()
		frostbolt.top_level = true
		frostbolt.target = owner.target
		owner.add_child(frostbolt)
		frostbolt.global_position = owner.global_position + Vector3(0.0, 0.5, 0.0)
