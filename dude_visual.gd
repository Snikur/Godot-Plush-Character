extends Node3D

@onready var animation_tree : AnimationTree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var left_hand: Node3D = $Skeleton/BoneAttachment3D/LeftAnchorPoint
@onready var left_mesh: MeshInstance3D = $Skeleton/BoneAttachment3D/LeftAnchorPoint/Mesh

var squash_and_stretch = 1.0 : set = _set_squash_and_stretch
signal fishing

func set_state(state_name : String) -> void:
	state_machine.travel(state_name)

func _set_squash_and_stretch(value : float) -> void:
	squash_and_stretch = value
	var negative = 1.0 + (1.0 - squash_and_stretch)
	scale = Vector3(negative, squash_and_stretch, negative)

func fish():
	fishing.emit()
	animation_tree.set("parameters/FishingOneShot/request", true)

func is_fishing() -> bool:
	return animation_tree.get("parameters/WaveOneShot/active")
