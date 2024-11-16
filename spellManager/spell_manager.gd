extends Node3D
class_name SpellManager

var target: Enemy = null
var source: Player = null

@onready var action_bar : HBoxContainer = $UI/ActionBar

func add_spell(new_spell: Spell):
	action_bar.add_spell(new_spell)
