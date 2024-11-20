extends Node3D

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

var target_angle: float = 0.0
var movement_input: Vector2 = Vector2.ZERO

func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	if (Input.is_action_pressed("aim")):
		target_angle = parent.camera.global_rotation.y + PI
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
