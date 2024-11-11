extends Node3D
class_name WaterState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

var speed: float = 8.0
var movement_input : Vector2 = Vector2.ZERO
var target_angle
func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down")
	var swim_up = Input.is_action_pressed("jump")
	if (movement_input or swim_up):
		var vel: Vector3 = parent.camera.global_basis.x * movement_input.x \
					+ parent.camera.global_basis.z * movement_input.y \
					+ parent.camera.global_basis.y * int(swim_up)
		parent.velocity = vel * speed
	else:
		parent.velocity = Vector3.ZERO
	target_angle = parent.camera.global_rotation.y + PI

	
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
	var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	parent.godot_plush_skin.tilt = move_toward(parent.godot_plush_skin.tilt, angle_diff, 2.0 * delta)
	parent.move_and_slide()
