extends Spell
class_name FrostboltSpell

func init(button: SpellTextureButton):
	type = SPELLTYPE.FROSTBOLT
	cooldown = 3.0
	texture = preload("res://spellManager/spells/Frostbolt/Coldflake.png")
	spell_scene = preload("res://spellManager/spells/Frostbolt/frostbolt.tscn")
	super.init(button)

func cast_spell(owner: SpellManager, index: int):
	if (owner.source.id == owner.multiplayer.get_unique_id()):
		super.cast_spell(owner, index)
	var frostbolt = spell_scene.instantiate()
	frostbolt.top_level = true
	owner.add_child(frostbolt)
	frostbolt.global_rotation.y = owner.source.godot_plush_skin.global_rotation.y
	frostbolt.global_position = owner.global_position + Vector3(0.0, 0.5, 0.0)
	frostbolt.name = str(index)
