extends Node3D
class_name ClimbingState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

var climbing_object: Node3D = null
var attach_speed: float = 8.0
var target_angle : float = 0.0
var climb_speed: float = 4.0

func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	if (is_instance_valid(climbing_object)):
		parent.transition_to(parent.ANIMATION_STATE.IDLE)
		target_angle = climbing_object.global_rotation.y
		parent.global_position.x = move_toward(parent.global_position.x, climbing_object.global_position.x, delta * attach_speed)
		parent.global_position.z = move_toward(parent.global_position.z, climbing_object.global_position.z, delta * attach_speed)
	parent.velocity = Vector3(0.0, climb_speed if Input.is_action_pressed("up") else -climb_speed if Input.is_action_pressed("down") else 0.0, 0.0)
	if Input.is_action_just_pressed("jump"):
		parent.state_chart.send_event("to_ground")
	
	var was_in_air: bool = not parent.is_on_floor()
	parent.move_and_slide()
	if (was_in_air && parent.is_on_floor()):
		parent.state_chart.send_event("to_ground")
	
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
	var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	parent.godot_plush_skin.tilt = move_toward(parent.godot_plush_skin.tilt, angle_diff, 2.0 * delta)
