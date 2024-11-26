extends Node3D
class_name SpellManager

var target: Enemy = null
var source: Player = null

var spell_index: int = -1

@onready var action_bar : HBoxContainer = $UI/ActionBar

func add_spell(new_spell: SpellResource):
	action_bar.add_spell(new_spell)

@rpc("any_peer", "call_remote", "reliable")
func send_spell(type: int, projectile_type: int , index: int):
	print("want to cast type ", type, " projectile ", projectile_type)
	var casted_spell: SpellResource = null
	match(type):
		SpellResource.SPELLTYPE.PROJECTILE:
			match(projectile_type):
				SpellResource.PROJECTILE_TYPE.FIREBALL:
					casted_spell = preload("res://spellManager/spells/Projectile/fireball_projectile_resource.tres")
				SpellResource.PROJECTILE_TYPE.FROSTBOLT:
					casted_spell = preload("res://spellManager/spells/Projectile/frostbolt_projectile_resource.tres")
				_:
					pass
		_:
			pass
	if (casted_spell):
		casted_spell.init(null)
		casted_spell.cast_spell(self, index)

func get_next_spell_index() -> int:
	spell_index = spell_index + 1
	return spell_index
