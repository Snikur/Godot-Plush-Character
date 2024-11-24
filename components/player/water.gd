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

func can_enter() -> bool:
	var shape_cast: ShapeCast3D = ShapeCast3D.new()
	self.add_child(shape_cast)
	shape_cast.add_exception(parent)
	shape_cast.shape = SphereShape3D.new()
	shape_cast.collide_with_areas = false
	shape_cast.collide_with_bodies = true
	shape_cast.position = Vector3(0.0, 0.0, 0.0)
	shape_cast.target_position = Vector3(0.0, -2.0, 0.0)
	shape_cast.force_shapecast_update()
	if (shape_cast.is_colliding()):
		for i in shape_cast.get_collision_count():
			print(shape_cast.get_collider(i))
	shape_cast.queue_free()
	if (water_ray.is_colliding() and water_ray.get_collider() is Terrain3D):
		print("collided with Terrain3D")
		return false
	else:
		print("can enter water")
		return true

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
	#parent.skin.tilt = move_toward(parent.skin.tilt, angle_diff, 2.0 * delta)
	parent.move_and_slide()
	var at_surface: bool = false
	if (parent.velocity.y > 0.0 and water_ray.is_colliding() and water_ray.get_collider() is WaterArea):
		var distance = water_ray.get_collision_point().distance_to(water_ray.global_position)
		if (distance > 0.1):
			parent.global_position.y -= distance
			at_surface = true
	
	if (swim_up and at_surface):
		parent.velocity.y = -parent.jump_velocity
		parent.state_chart.send_event("to_ground")
