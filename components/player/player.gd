class_name Player
extends CharacterBody3D

var id: int = -1
var tween: Tween
var data: Dictionary

var jump_height: float = 2.5
var jump_time_to_peak: float = 0.4
var jump_time_to_descent: float = 0.3

var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var acceleration: float = 128.0
var base_speed: float = 2.5
var run_speed: float = 7.0
var speed_modifier: float = 1.0

enum AnimationState {
	IDLE,
	WALK,
	RUN,
	FALL,
	JUMP,
	FISH
}

var current_state: AnimationState = AnimationState.IDLE

const JumpParticlesScene = preload("./vfx/jump_particles.tscn")
const LandParticlesScene = preload("./vfx/land_particles.tscn")

@onready var state_chart: StateChart = $StateChart
@onready var ground_state: GroundState = $Ground
@onready var climb_state: ClimbingState = $Climbing
@onready var water_state: WaterState = $Water
@onready var knockback_state: KnockbackState = $Knockback
@onready var visual_root: Node3D = %VisualRoot
@onready var skin: Node3D = $VisualRoot/Dude
@onready var movement_dust: GPUParticles3D = %MovementDust
@onready var foot_step_audio: AudioStreamPlayer3D = %FootStepAudio
@onready var impact_audio: AudioStreamPlayer3D = %ImpactAudio
@onready var combat: CombatComponent = $CombatComponent
@onready var spell_manager: SpellManager = $VisualRoot/Dude/AutoAttack/SpellManager
@onready var inventory: Inventory = $Inventory
@onready var camera: Camera3D = $OrbitView/Camera3D

func _ready() -> void:
	if data.has(&"position"):
		global_position = data[&"position"]

	if multiplayer.is_server():
		combat.died.connect(func() -> void:
			teleport_to.rpc_id(id, data[&"position"])
			combat.request_change.rpc(combat.max_health)
		)

	if multiplayer.get_unique_id() == id:
		camera.current = true
		MM.tick.connect(send_state)
		camera.fov = Global.get_fov()
		Global.fov_changed.connect(func(new_fov: int) -> void:
			camera.fov = new_fov
		)
	else:
		set_process_unhandled_input(false)
		$OrbitView.queue_free()
		$StateChart.queue_free()
		$Ground.queue_free()
		$Climbing.queue_free()
		$Water.queue_free()
		$Knockback.queue_free()
		$VisualRoot/Dude/AutoAttack.enabled = false
		$VisualRoot/Dude/AutoAttack/SpellManager/UI.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"fish"):
		transition_to(AnimationState.FISH)
		state_chart.send_event(&"to_fishing")

func send_state() -> void:
	if multiplayer.is_server():
		server_state.rpc(global_position, visual_root.rotation)
	else:
		client_state.rpc_id(1, global_position, visual_root.rotation)

func transition_to(state: AnimationState) -> void:
	if current_state == state:
		return
	send_transition_to.rpc(state)

@rpc("authority", "reliable", "call_local")
func teleport_to(destination: Vector3) -> void:
	global_position = destination

@rpc("any_peer", "reliable", "call_local")
func send_transition_to(state: AnimationState) -> void:
	movement_dust.emitting = false
	skin.left_hand.visible = false
	current_state = state
	match current_state:
		AnimationState.IDLE:
			skin.set_state(&"idle")
		AnimationState.WALK:
			skin.set_state(&"walk")
			movement_dust.emitting = true
		AnimationState.RUN:
			skin.set_state(&"run")
			movement_dust.emitting = true
		AnimationState.FALL:
			skin.set_state(&"fall")
		AnimationState.JUMP:
			skin.set_state(&"jump")
		AnimationState.FISH:
			skin.left_hand.visible = true
			skin.fish()
		_:
			skin.set_state(&"idle")

@rpc("any_peer", "unreliable_ordered", "call_remote")
func client_state(new_position: Vector3, new_rotation: Vector3) -> void:
	server_state.rpc(new_position, new_rotation)

@rpc("authority", "reliable", "call_local")
func remove() -> void:
	queue_free()

@rpc("authority", "unreliable_ordered", "call_local")
func server_state(new_position: Vector3, new_rotation: Vector3) -> void:
	if id == multiplayer.get_unique_id():
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, &"global_position", new_position, 0.1).from_current()
	tween.parallel().tween_property(visual_root, &"rotation", new_rotation, 0.1).from_current()

func enter_climb_state(climbing: Node3D) -> void:
	state_chart.send_event(&"to_climbing")
	climb_state.climbing_object = climbing

func exit_climb_state(climbing: Node3D) -> void:
	state_chart.send_event(&"to_ground")
	if climb_state.climbing_object == climbing:
		climb_state.climbing_object = null

func request_water_state() -> void:
	if water_state.can_enter():
		state_chart.send_event(&"to_water")

func exit_water_state() -> void:
	state_chart.send_event(&"to_ground")

func enter_knockback_state(force: Vector3) -> void:
	knockback_state.knockback_force = force
	state_chart.send_event(&"to_knockback")

func exit_knockback_state() -> void:
	state_chart.send_event(&"to_ground")
