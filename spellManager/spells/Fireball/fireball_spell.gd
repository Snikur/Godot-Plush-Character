extends Spell
class_name FireballSpell

func init(spell_button: SpellTextureButton):
	type = SPELLTYPE.FIREBALL
	cooldown = 1.0
	texture = preload("res://spellManager/spells/Fireball/flobo.png")
	spell_scene = preload("res://spellManager/spells/Fireball/fireball.tscn")
	super.init(spell_button)

func cast_spell(owner: SpellManager, index: int):
	if (owner.source.id == owner.multiplayer.get_unique_id()):
		super.cast_spell(owner, index)
	var fireball = spell_scene.instantiate()
	fireball.top_level = true
	owner.add_child(fireball)
	fireball.global_rotation.y = owner.source.godot_plush_skin.global_rotation.y
	fireball.global_position = owner.global_position + Vector3(0.0, 0.5, 0.0)
	fireball.name = str(index)
