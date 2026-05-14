class_name SpellManager
extends Node3D

var target: Enemy = null
var source: Player = null

var spell_index: int = -1

@onready var action_bar: HBoxContainer = $UI/ActionBar

func add_spell(new_spell: SpellResource) -> void:
	action_bar.add_spell(new_spell)

@rpc("any_peer", "reliable", "call_remote")
func send_spell(type: int, projectile_type: int, index: int) -> void:
	print(multiplayer.get_remote_sender_id(), " want to cast type ", type, " projectile ", projectile_type)
	var casted_spell: SpellResource = null
	match type:
		SpellResource.SpellType.PROJECTILE:
			match projectile_type:
				SpellResource.ProjectileType.FIREBALL:
					casted_spell = preload("res://spellManager/spells/Projectile/fireball_projectile_resource.tres")
				SpellResource.ProjectileType.FROSTBOLT:
					casted_spell = preload("res://spellManager/spells/Projectile/frostbolt_projectile_resource.tres")
				_:
					pass
		_:
			pass
	if casted_spell:
		casted_spell.init(null)
		casted_spell.cast_spell(self, index)

func get_next_spell_index() -> int:
	spell_index += 1
	return spell_index
