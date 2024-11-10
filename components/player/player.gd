extends CharacterBody3D
class_name Player

var id: int = -1
var tween: Tween
var data: Dictionary

@export var jump_height : float = 2.5
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var base_speed = 4.5
@export var run_speed = 8.0

@onready var visual_root = %VisualRoot
@onready var godot_plush_skin = $VisualRoot/GodotPlushSkin
@onready var movement_dust = %MovementDust
@onready var foot_step_audio = %FootStepAudio
@onready var impact_audio = %ImpactAudio
@onready var wave_audio = %WaveAudio

@onready var coyote_timer: Timer = $CoyoteJump

var can_climb: bool = false

const JUMP_PARTICLES_SCENE = preload("./vfx/jump_particles.tscn")
const LAND_PARTICLES_SCENE = preload("./vfx/land_particles.tscn")

enum ANIMATION_STATE {
	IDLE,
	WALK,
	RUN,
	FALL,
	JUMP,
	WAVE
}

var current_state: ANIMATION_STATE = ANIMATION_STATE.IDLE

@onready var camera: Camera3D = $OrbitView/Camera3D
var movement_input : Vector2 = Vector2.ZERO
var target_angle : float = 0.0
var last_movement_input : Vector2 = Vector2.ZERO

func _ready():
	godot_plush_skin.waved.connect(wave_audio.play)
	move_and_slide()
	godot_plush_skin.footstep.connect(func(intensity : float = 1.0):
		foot_step_audio.volume_db = linear_to_db(intensity)
		foot_step_audio.play())
		
	if data.has("position"):
		global_position = data["position"]
	set_physics_process(multiplayer.get_unique_id() == id)
	set_process_unhandled_input(multiplayer.get_unique_id() == id)
	if multiplayer.get_unique_id() == id:
		camera.current = true
		MM.tick.connect(send_state)
	else:
		$OrbitView.queue_free()
		coyote_timer.queue_free()

func send_state():
	if multiplayer:
		if multiplayer.is_server():
			server_state.rpc(global_position, visual_root.rotation)
		else:
			client_state.rpc_id(1, global_position, visual_root.rotation)

func transition_to(state: ANIMATION_STATE):
	if current_state == state:
		return
	send_transition_to.rpc(state)

@rpc("any_peer", "reliable", "call_local")
func send_transition_to(state: ANIMATION_STATE):
	movement_dust.emitting = false
	current_state = state
	match(current_state):
		ANIMATION_STATE.IDLE:
			godot_plush_skin.set_state("idle")
		ANIMATION_STATE.WALK:
			godot_plush_skin.set_state("walk")
			movement_dust.emitting = true
		ANIMATION_STATE.RUN:
			godot_plush_skin.set_state("run")
			movement_dust.emitting = true
		ANIMATION_STATE.FALL:
			godot_plush_skin.set_state("fall")
		ANIMATION_STATE.JUMP:
			godot_plush_skin.set_state("jump")
		ANIMATION_STATE.WAVE:
			godot_plush_skin.wave()
		_:
			godot_plush_skin.set_state("idle")

@rpc("any_peer", "call_remote", "unreliable_ordered")
func client_state(new_position: Vector3, new_rotation: Vector3):
	server_state.rpc(new_position, new_rotation)

@rpc("authority", "call_local", "reliable")
func remove():
	queue_free()

@rpc("authority", "call_local", "unreliable_ordered")
func server_state(new_position: Vector3, new_rotation: Vector3):
	if id == multiplayer.get_unique_id():
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
	tween.parallel().tween_property(visual_root, "rotation", new_rotation, 0.1).from_current()

func _unhandled_input(event):
	if (event.is_action_pressed("wave")
		&& is_on_floor()
		&& !godot_plush_skin.is_waving()):
		transition_to(ANIMATION_STATE.WAVE)

func _physics_process(delta):
	if camera == null: return
	movement_input = Input.get_vector("left", "right", "up", "down").rotated(-camera.global_rotation.y)
	var is_running : bool = Input.is_action_pressed("run") && !godot_plush_skin.is_waving()
	var vel_2d = Vector2(velocity.x, velocity.z)
	
	if movement_input != Vector2.ZERO && !godot_plush_skin.is_waving():
		transition_to(ANIMATION_STATE.RUN if is_running else ANIMATION_STATE.WALK)
		var speed = run_speed if is_running else base_speed
		vel_2d += movement_input * speed * 8.0 * delta
		vel_2d = vel_2d.limit_length(speed)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		target_angle = -movement_input.orthogonal().angle()
	else:
		if is_on_floor():
			transition_to(ANIMATION_STATE.IDLE)
			#vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 8.0 * delta)
			velocity.x = 0.0#vel_2d.x
			velocity.z = 0.0#vel_2d.y
	
	visual_root.rotation.y = rotate_toward(visual_root.rotation.y, target_angle, 6.0 * delta)
	var angle_diff = angle_difference(visual_root.rotation.y, target_angle)
	godot_plush_skin.tilt = move_toward(godot_plush_skin.tilt, angle_diff, 2.0 * delta)
	
	if can_climb and not is_on_floor():
		velocity = Vector3(0.0, 10.0 if Input.is_action_pressed("up") else -10.0 if Input.is_action_pressed("down") else 0.0, 0.0)
	
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump") && !godot_plush_skin.is_waving():
			coyote_timer.stop()
			transition_to(ANIMATION_STATE.JUMP)
			velocity.y = -jump_velocity
			
			var jump_particles = JUMP_PARTICLES_SCENE.instantiate()
			add_sibling(jump_particles)
			jump_particles.global_transform = global_transform
			
			do_squash_and_stretch(1.2, 0.1)
	else:
		transition_to(ANIMATION_STATE.FALL)
		
	var gravity = 0.0 if can_climb else jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
	
	var in_the_air : bool = !is_on_floor()
	var was_on_floor: bool = is_on_floor()
	
	var previous_y_vel : float = velocity.y
	
	velocity = velocity.limit_length(fall_gravity)
	move_and_slide()
	
	if not is_on_floor() && was_on_floor and not Input.is_action_just_pressed("jump"):
		coyote_timer.start()
	
	if is_on_floor() && in_the_air:
		_on_hit_floor(previous_y_vel)

func _on_hit_floor(y_vel : float):
	y_vel = clamp(abs(y_vel), 0.0, fall_gravity)
	var floor_impact_percent : float = y_vel / fall_gravity
	impact_audio.volume_db = linear_to_db(remap(floor_impact_percent, 0.0, 1.0, 0.5, 2.0))
	impact_audio.play()
	var land_particles = LAND_PARTICLES_SCENE.instantiate()
	add_sibling(land_particles)
	land_particles.global_transform = global_transform
	do_squash_and_stretch(0.7, 0.08)

func do_squash_and_stretch(value : float, timing : float = 0.1):
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(godot_plush_skin, "squash_and_stretch", value, timing)
	t.tween_property(godot_plush_skin, "squash_and_stretch", 1.0, timing * 1.8)
