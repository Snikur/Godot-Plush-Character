extends Node3D
class_name SpellManager

var target: Enemy = null
var source: Player = null

var spell_index: int = -1

@onready var action_bar : HBoxContainer = $UI/ActionBar

func add_spell(new_spell: Spell):
	action_bar.add_spell(new_spell)

@rpc("any_peer", "call_remote", "reliable")
func cast_spell(type: int, index: int):
	prints("spell manager want to cast", type, index)
	match(type):
		Spell.SPELLTYPE.FIREBALL:
			var spell = FireballSpell.new()
			spell.init(null)
			spell.cast_spell(self, index)
			pass
		Spell.SPELLTYPE.FROSTBOLT:
			var spell = FrostboltSpell.new()
			spell.init(null)
			spell.cast_spell(self, index)
			pass
		_:
			print("not spell vfx to spawn")

func setup_action_bar():
	action_bar.init()

func get_next_spell_index() -> int:
	spell_index = spell_index + 1
	return spell_index
