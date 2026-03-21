extends Node3D
class_name SpellManager

var target: Enemy = null
var source: Player = null

var spell_index: int = -1

const SPELL_REGISTRY: Dictionary = {
	SpellResource.SPELLTYPE.PROJECTILE: {
		SpellResource.PROJECTILE_TYPE.FIREBALL: preload("res://spellManager/spells/Projectile/fireball_projectile_resource.tres"),
		SpellResource.PROJECTILE_TYPE.FROSTBOLT: preload("res://spellManager/spells/Projectile/frostbolt_projectile_resource.tres")
	}
}

@onready var action_bar : HBoxContainer = $UI/ActionBar

func add_spell(new_spell: SpellResource):
	action_bar.add_spell(new_spell)

@rpc("any_peer", "call_remote", "reliable")
func send_spell(type: int, projectile_type: int , index: int):
	print(multiplayer.get_remote_sender_id(), " want to cast type ", type, " projectile ", projectile_type)
	var casted_spell: SpellResource = get_spell(type, projectile_type)
	if (casted_spell):
		casted_spell.init(null)
		casted_spell.cast_spell(self, index)

func get_spell(type: int, projectile_type: int) -> SpellResource:
	var type_registry = SPELL_REGISTRY.get(type)
	if type_registry:
		return type_registry.get(projectile_type)
	return null

func get_next_spell_index() -> int:
	spell_index = spell_index + 1
	return spell_index
