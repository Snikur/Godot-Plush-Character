extends Node3D

@onready var animation_tree : AnimationTree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

var squash_and_stretch = 1.0 : set = _set_squash_and_stretch

func set_state(state_name : String) -> void:
	state_machine.travel(state_name)

func _set_squash_and_stretch(value : float) -> void:
	squash_and_stretch = value
	var negative = 1.0 + (1.0 - squash_and_stretch)
	scale = Vector3(negative, squash_and_stretch, negative)
