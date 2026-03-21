extends Node3D
class_name GroundState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

@onready var coyote_timer: Timer = $CoyoteJump
var target_angle: float = 0.0
var movement_input: Vector2 = Vector2.ZERO
var auto_run_input: Vector2 = Vector2.ZERO
var is_running: bool = true
var is_autorunning: bool = false
@onready var currentMaxSpeed: float = parent.runSpeed

func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down").rotated(-parent.camera.global_rotation.y)
	#var is_running: bool = Input.is_action_pressed("run") #hold to run
	if (Input.is_action_just_pressed("auto_run")):
		is_autorunning = not is_autorunning
		if (movement_input == Vector2.ZERO):
			auto_run_input = Vector2(0.0, -1.0).rotated(-parent.camera.global_rotation.y)
		else:
			auto_run_input = movement_input
	if (is_autorunning):
		if (movement_input == Vector2.ZERO):
			movement_input = auto_run_input
		else:
			is_autorunning = false
	if (Input.is_action_just_pressed("run")): #toggle run
		is_running = !is_running
	var vel2d = Vector2(parent.velocity.x, parent.velocity.z)
	if movement_input != Vector2.ZERO:
		if parent.is_on_floor():
			parent.transition_to(parent.ANIMATION_STATE.RUN if is_running else parent.ANIMATION_STATE.WALK)
		vel2d += movement_input * parent.acceleration * delta
		var desiredMaxSpeed: float = ((parent.runSpeed if is_running else parent.baseSpeed) * parent.speedModifier)
		currentMaxSpeed = desiredMaxSpeed # TODO: do some magic here
		vel2d = vel2d.limit_length(currentMaxSpeed)
		parent.velocity.x = vel2d.x
		parent.velocity.z = vel2d.y
		target_angle = -movement_input.orthogonal().angle() # TODO: fix 0.15 radians off center
	else:
		if parent.is_on_floor():
			parent.velocity.x = 0.0
			parent.velocity.z = 0.0
		else:
			parent.velocity.x = vel2d.x
			parent.velocity.z = vel2d.y
	if Input.is_action_pressed("aim"):
		target_angle = parent.camera.global_rotation.y + PI
	if parent.is_on_floor() || coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			coyote_timer.stop()
			parent.transition_to(parent.ANIMATION_STATE.JUMP)
			parent.velocity.y = -parent.jumpVelocity
			
			var jumpParticles = parent.JUMP_PARTICLES_SCENE.instantiate()
			add_sibling(jumpParticles)
			jumpParticles.global_transform = global_transform
			
			doSquashAndStretch(1.2, 0.1)
		
	var gravity = parent.jumpGravity if parent.velocity.y > 0.0 else parent.fallGravity
	parent.velocity.y -= gravity * delta
	
	var isInAir: bool = !parent.is_on_floor()
	var wasOnFloor: bool = parent.is_on_floor()
	
	var previousYVel: float = parent.velocity.y
	
	parent.velocity = parent.velocity.limit_length(parent.fallGravity)
	parent.move_and_slide()
	
	if not parent.is_on_floor() && wasOnFloor && not Input.is_action_just_pressed("jump"): # walked off a ledge
		parent.transition_to(parent.ANIMATION_STATE.FALL)
		coyote_timer.start()
	
	if parent.is_on_floor() && isInAir: # just hit floor
		_onHitFloor(previousYVel)
	
	if parent.velocity.is_equal_approx(Vector3.ZERO) && parent.is_on_floor():
		parent.transition_to(parent.ANIMATION_STATE.IDLE)
	
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
	#var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	#parent.skin.tilt = move_toward(parent.skin.tilt, angle_diff, 2.0 * delta)

func _onHitFloor(yVel: float) -> void:
	yVel = clamp(abs(yVel), 0.0, parent.fallGravity)
	var floorImpactPercent: float = yVel / parent.fallGravity
	parent.impactAudio.volume_db = linear_to_db(remap(floorImpactPercent, 0.0, 1.0, 0.5, 2.0))
	parent.impactAudio.play()
	var landParticles = parent.LAND_PARTICLES_SCENE.instantiate()
	add_sibling(landParticles)
	landParticles.global_transform = global_transform
	doSquashAndStretch(0.7, 0.08)


func doSquashAndStretch(value: float, timing: float = 0.1) -> void:
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(parent.skin, "squash_and_stretch", value, timing)
	t.tween_property(parent.skin, "squash_and_stretch", 1.0, timing * 1.8)
