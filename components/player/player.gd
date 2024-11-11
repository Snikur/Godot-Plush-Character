extends CharacterBody3D
class_name Player

var id: int = -1
var tween: Tween
var data: Dictionary

@onready var state_chart: StateChart = $StateChart
@onready var ground_state: GroundState = $Ground
@onready var climb_state: ClimbingState = $Climbing
@onready var water_state: WaterState = $Water

var jump_height : float = 2.5
var jump_time_to_peak : float = 0.4
var jump_time_to_descent : float = 0.3

var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var acceleration = 64.0
var base_speed = 4.5
var run_speed = 8.0

@onready var visual_root = %VisualRoot
@onready var godot_plush_skin = $VisualRoot/GodotPlushSkin
@onready var movement_dust = %MovementDust
@onready var foot_step_audio = %FootStepAudio
@onready var impact_audio = %ImpactAudio

const JUMP_PARTICLES_SCENE = preload("./vfx/jump_particles.tscn")
const LAND_PARTICLES_SCENE = preload("./vfx/land_particles.tscn")

enum ANIMATION_STATE {
	IDLE,
	WALK,
	RUN,
	FALL,
	JUMP
}

var current_state: ANIMATION_STATE = ANIMATION_STATE.IDLE

@onready var camera: Camera3D = $OrbitView/Camera3D

func _ready():
	move_and_slide()
	godot_plush_skin.footstep.connect(func(intensity : float = 1.0):
		foot_step_audio.volume_db = linear_to_db(intensity)
		foot_step_audio.play())
		
	if data.has("position"):
		global_position = data["position"]
	set_process_unhandled_input(multiplayer.get_unique_id() == id)
	if multiplayer.get_unique_id() == id:
		camera.current = true
		MM.tick.connect(send_state)
		camera.fov = Global.get_fov()
		Global.fov_changed.connect(func(new_fov):
			camera.fov = new_fov
		)
	else:
		$OrbitView.queue_free()
		$StateChart.queue_free()
		$Ground.queue_free()
		$Climbing.queue_free()

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

func enter_climb_state(climbing: Node3D):
	state_chart.send_event("to_climbing")
	climb_state.climbing_object = climbing

func exit_climb_state(climbing: Node3D):
	state_chart.send_event("to_ground")
	climb_state.climbing_object = null

func enter_water_state():
	state_chart.send_event("to_water")

func exit_water_state():
	state_chart.send_event("to_ground")
