extends Node3D
class_name GroundState

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

@onready var coyote_timer: Timer = $CoyoteJump
var target_angle: float = 0.0
var movement_input: Vector2 = Vector2.ZERO
var is_running: bool = true

func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down").rotated(-parent.camera.global_rotation.y)
	#var is_running: bool = Input.is_action_pressed("run") #hold to run
	if (Input.is_action_just_pressed("run")): #toggle run
		is_running = !is_running
	var vel_2d = Vector2(parent.velocity.x, parent.velocity.z)
	if movement_input != Vector2.ZERO:
		if parent.is_on_floor():
			parent.transition_to(parent.ANIMATION_STATE.RUN if is_running else parent.ANIMATION_STATE.WALK)
		vel_2d += movement_input * parent.acceleration * delta
		vel_2d = vel_2d.limit_length((parent.run_speed if is_running else parent.base_speed) * parent.speed_modifier)
		parent.velocity.x = vel_2d.x
		parent.velocity.z = vel_2d.y
		target_angle = -movement_input.orthogonal().angle() #TODO: fix 0.15 radians off center
	else:
		if parent.is_on_floor():
			parent.velocity.x = 0.0
			parent.velocity.z = 0.0
		else:
			parent.velocity.x = vel_2d.x
			parent.velocity.z = vel_2d.y
	if (Input.is_action_pressed("aim")):
		target_angle = parent.camera.global_rotation.y + PI
	if parent.is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			coyote_timer.stop()
			parent.transition_to(parent.ANIMATION_STATE.JUMP)
			parent.velocity.y = -parent.jump_velocity
			
			var jump_particles = parent.JUMP_PARTICLES_SCENE.instantiate()
			add_sibling(jump_particles)
			jump_particles.global_transform = global_transform
			
			do_squash_and_stretch(1.2, 0.1)
		
	var gravity = parent.jump_gravity if parent.velocity.y > 0.0 else parent.fall_gravity
	parent.velocity.y -= gravity * delta
	
	var in_the_air : bool = !parent.is_on_floor()
	var was_on_floor: bool = parent.is_on_floor()
	
	var previous_y_vel : float = parent.velocity.y
	
	parent.velocity = parent.velocity.limit_length(parent.fall_gravity)
	parent.move_and_slide()
	
	if not parent.is_on_floor() && was_on_floor and not Input.is_action_just_pressed("jump"): #walked off a ledge
		parent.transition_to(parent.ANIMATION_STATE.FALL)
		coyote_timer.start()
	
	if parent.is_on_floor() && in_the_air: #just hit floor
		_on_hit_floor(previous_y_vel)
	
	if parent.velocity.is_equal_approx(Vector3.ZERO) and parent.is_on_floor():
		parent.transition_to(parent.ANIMATION_STATE.IDLE)
	
	parent.visual_root.rotation.y = rotate_toward(parent.visual_root.rotation.y, target_angle, 6.0 * delta)
	#var angle_diff = angle_difference(parent.visual_root.rotation.y, target_angle)
	#parent.godot_plush_skin.tilt = move_toward(parent.godot_plush_skin.tilt, angle_diff, 2.0 * delta)

func _on_hit_floor(y_vel : float):
	y_vel = clamp(abs(y_vel), 0.0, parent.fall_gravity)
	var floor_impact_percent : float = y_vel / parent.fall_gravity
	parent.impact_audio.volume_db = linear_to_db(remap(floor_impact_percent, 0.0, 1.0, 0.5, 2.0))
	parent.impact_audio.play()
	var land_particles = parent.LAND_PARTICLES_SCENE.instantiate()
	add_sibling(land_particles)
	land_particles.global_transform = global_transform
	do_squash_and_stretch(0.7, 0.08)

func do_squash_and_stretch(value : float, timing : float = 0.1):
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(parent.godot_plush_skin, "squash_and_stretch", value, timing)
	t.tween_property(parent.godot_plush_skin, "squash_and_stretch", 1.0, timing * 1.8)
