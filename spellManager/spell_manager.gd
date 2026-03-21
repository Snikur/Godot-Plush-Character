extends Node3D
class_name SpellManager

var target: Enemy = null
var source: Player = null

var spellIndex: int = -1

@onready var action_bar : HBoxContainer = $UI/ActionBar

func addSpell(newSpell: SpellResource) -> void:
	action_bar.addSpell(newSpell)

@rpc("any_peer", "call_remote", "reliable")
func sendSpell(type: int, projectileType: int, index: int) -> void:
	print(multiplayer.get_remote_sender_id(), " want to cast type ", type, " projectile ", projectileType)
	var castedSpell: SpellResource = null
	match (type):
		SpellResource.SPELLTYPE.PROJECTILE:
			match (projectileType):
				SpellResource.PROJECTILE_TYPE.FIREBALL:
					castedSpell = preload("res://spellManager/spells/Projectile/fireball_projectile_resource.tres")
				SpellResource.PROJECTILE_TYPE.FROSTBOLT:
					castedSpell = preload("res://spellManager/spells/Projectile/frostbolt_projectile_resource.tres")
				_:
					pass
		_:
			pass
	if castedSpell:
		castedSpell.init(null)
		castedSpell.castSpell(self, index)


func getNextSpellIndex() -> int:
	spellIndex = spellIndex + 1
	return spellIndex
