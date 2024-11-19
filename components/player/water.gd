extends Node3D
class_name WaterState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

@onready var water_ray: RayCast3D = $WaterRay

var speed: float = 8.0
var movement_input : Vector2 = Vector2.ZERO
var target_angle
func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down")
	var swim_up = Input.is_action_pressed("jump")
	var swim_down = Input.is_action_pressed("crouch")
	if (movement_input):
		var vel: Vector3 = parent.camera.global_basis.x * movement_input.x \
					+ parent.camera.global_basis.z * movement_input.y
		parent.velocity = vel * speed
	else:
		parent.velocity = Vector3.ZERO
	if (swim_up or swim_down):
		parent.velocity.y = (int(swim_up) - int(swim_down)) * speed
	target_angle = parent.camera.global_rotation.y + PI

	
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
	#var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	#parent.godot_plush_skin.tilt = move_toward(parent.godot_plush_skin.tilt, angle_diff, 2.0 * delta)
	parent.move_and_slide()
	var at_surface: bool = false
	if (water_ray.is_colliding() and water_ray.get_collider() is WaterArea):
		var distance = water_ray.get_collision_point().distance_to(water_ray.global_position)
		if (distance > 1.0):
			parent.global_position.y -= distance - 1.0
			at_surface = true
	
	if (swim_up and at_surface):
		parent.velocity.y = -parent.jump_velocity
		parent.state_chart.send_event("to_ground")
