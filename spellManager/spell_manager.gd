extends Node3D

@export var spell_slot_1 : PackedScene

func activate_spell_slot_1(): 
	var test = spell_slot_1.instantiate()
	
