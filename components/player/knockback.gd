extends Node3D
class_name KnockbackState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

var knockback_force: Vector3
var target_angle: float = 0.0

func _ready():
	state.state_physics_processing.connect(state_physics_process)
	state.state_entered.connect(state_entered)

func state_entered():
	parent.velocity = knockback_force

func state_physics_process(delta: float) -> void:
	target_angle = parent.camera.global_rotation.y + PI
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
	var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	parent.skin.tilt = move_toward(parent.skin.tilt, angle_diff, 2.0 * delta)
	var was_in_air: bool = not parent.is_on_floor()
	parent.velocity.y -= parent.fall_gravity * delta
	parent.move_and_slide()
	if (was_in_air && parent.is_on_floor()):
		parent.state_chart.send_event("to_ground")
