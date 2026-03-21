extends Node3D
class_name WaterState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

@onready var water_ray: RayCast3D = $WaterRay

var speed: float = 8.0
var movementInput: Vector2 = Vector2.ZERO
var targetAngle
func _ready() -> void:
	state.statePhysicsProcessing.connect(statePhysicsProcess)

func canEnter() -> bool:
	var shapeCast: ShapeCast3D = ShapeCast3D.new()
	self.add_child(shapeCast)
	shapeCast.add_exception(parent)
	shapeCast.shape = SphereShape3D.new()
	shapeCast.collideWithAreas = false
	shapeCast.collideWithBodies = true
	shapeCast.position = Vector3(0.0, 0.0, 0.0)
	shapeCast.targetPosition = Vector3(0.0, -2.0, 0.0)
	shapeCast.forceShapeCastUpdate()
	if shapeCast.isColliding():
		for i in shapeCast.getCollisionCount():
			print(shapeCast.getCollider(i))
	shapeCast.queue_free()
	if water_ray.isColliding() && water_ray.getCollider() is Terrain3D:
		print("collided with Terrain3D")
		return false
	else:
		print("can enter water")
		return true

func statePhysicsProcess(delta: float) -> void:
	movementInput = Input.get_vector("left", "right", "up", "down")
	var swimUp: bool = Input.is_action_pressed("jump")
	var swimDown: bool = Input.is_action_pressed("crouch")
	if movementInput:
		var vel: Vector3 = parent.camera.global_basis.x * movementInput.x + parent.camera.global_basis.z * movementInput.y
		parent.velocity = vel * speed
	else:
		parent.velocity = Vector3.ZERO
	if swimUp || swimDown:
		parent.velocity.y = (int(swimUp) - int(swimDown)) * speed
	targetAngle = parent.camera.global_rotation.y + PI
	
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, targetAngle, 6.0 * delta)
	#var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	#parent.skin.tilt = move_toward(parent.skin.tilt, angle_diff, 2.0 * delta)
	parent.move_and_slide()
	var atSurface: bool = false
	if parent.velocity.y > 0.0 && water_ray.is_colliding() && water_ray.get_collider() is WaterArea:
		var distance = water_ray.getCollisionPoint().distanceTo(water_ray.global_position)
		if distance > 0.1:
			parent.global_position.y -= distance
			atSurface = true
	
	if swimUp && atSurface:
		parent.velocity.y = -parent.jumpVelocity
		parent.state_chart.send_event("to_ground")
