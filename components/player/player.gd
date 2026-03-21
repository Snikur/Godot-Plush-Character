extends CharacterBody3D
class_name Player

var id: int = -1
var tween: Tween
var data: Dictionary

@onready var state_chart: StateChart = $StateChart
@onready var ground_state: GroundState = $Ground
@onready var climb_state: ClimbingState = $Climbing
@onready var water_state: WaterState = $Water
@onready var knockback_state: KnockbackState = $Knockback

var jumpHeight: float = 2.5
var jumpTimeToPeak: float = 0.4
var jumpTimeToDescent: float = 0.3

var jumpVelocity: float = ((2.0 * jumpHeight) / jumpTimeToPeak) * -1.0
var jumpGravity: float = ((-2.0 * jumpHeight) / (jumpTimeToPeak * jumpTimeToPeak)) * -1.0
var fallGravity: float = ((-2.0 * jumpHeight) / (jumpTimeToDescent * jumpTimeToDescent)) * -1.0

var acceleration: float = 128.0
var baseSpeed: float = 2.5
var runSpeed: float = 7.0
var speedModifier: float = 1.0

@onready var visual_root = %VisualRoot
@onready var skin = $VisualRoot/Dude
@onready var movement_dust = %MovementDust
@onready var foot_step_audio = %FootStepAudio
@onready var impact_audio = %ImpactAudio
@onready var combat: CombatComponent = $CombatComponent
@onready var spell_manager: SpellManager = $VisualRoot/Dude/AutoAttack/SpellManager
@onready var inventory: Inventory = $Inventory


const JUMP_PARTICLES_SCENE = preload("./vfx/jump_particles.tscn")
const LAND_PARTICLES_SCENE = preload("./vfx/land_particles.tscn")

enum ANIMATION_STATE {
	IDLE,
	WALK,
	RUN,
	FALL,
	JUMP,
	FISH
}

var currentState: ANIMATION_STATE = ANIMATION_STATE.IDLE

@onready var camera: Camera3D = $OrbitView/Camera3D

func _ready() -> void:
	move_and_slide()
	
	if data.has("position"):
		global_position = data["position"]
	if multiplayer.is_server():
		combat.died.connect(func():
			teleport_to.rpc_id(id, data["position"])
			combat.request_change.rpc(combat.max_health)
		)
	if multiplayer.get_unique_id() == id:
		camera.current = true
		MM.tick.connect(send_state)
		camera.fov = Global.get_fov()
		Global.fov_changed.connect(func(new_fov: float):
			camera.fov = new_fov
		)
	else: # if other clients and server
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
	if (event.is_action_released("fish")):
		transition_to(ANIMATION_STATE.FISH)
		state_chart.send_event("to_fishing")

func send_state() -> void:
	if multiplayer:
		if multiplayer.is_server():
			server_state.rpc(global_position, visual_root.rotation)
		else:
			client_state.rpc_id(1, global_position, visual_root.rotation)


func transition_to(state: ANIMATION_STATE) -> void:
	if currentState == state:
		return
	send_transition_to.rpc(state)


@rpc("authority", "reliable", "call_local")
func teleport_to(destination: Vector3) -> void:
	global_position = destination


@rpc("any_peer", "reliable", "call_local")
func send_transition_to(state: ANIMATION_STATE) -> void:
	movement_dust.emitting = false
	skin.left_hand.visible = false
	currentState = state
	match (currentState):
		ANIMATION_STATE.IDLE:
			skin.set_state("idle")
		ANIMATION_STATE.WALK:
			skin.set_state("walk")
			movement_dust.emitting = true
		ANIMATION_STATE.RUN:
			skin.set_state("run")
			movement_dust.emitting = true
		ANIMATION_STATE.FALL:
			skin.set_state("fall")
		ANIMATION_STATE.JUMP:
			skin.set_state("jump")
		ANIMATION_STATE.FISH:
			skin.left_hand.visible = true
			skin.fish()
		_:
			skin.set_state("idle")


@rpc("any_peer", "call_remote", "unreliable_ordered")
func client_state(new_position: Vector3, new_rotation: Vector3) -> void:
	server_state.rpc(new_position, new_rotation)


@rpc("authority", "call_local", "reliable")
func remove() -> void:
	queue_free()


@rpc("authority", "call_local", "unreliable_ordered")
func server_state(new_position: Vector3, new_rotation: Vector3) -> void:
	if id == multiplayer.get_unique_id():
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
	tween.parallel().tween_property(visual_root, "rotation", new_rotation, 0.1).from_current()

func enter_climb_state(climbing: Node3D) -> void:
	state_chart.send_event("to_climbing")
	climb_state.climbing_object = climbing


func exit_climb_state(climbing: Node3D) -> void:
	state_chart.send_event("to_ground")
	if climb_state.climbing_object == climbing:
		climb_state.climbing_object = null


func request_water_state() -> void:
	if water_state.can_enter():
		state_chart.send_event("to_water")


func exit_water_state() -> void:
	state_chart.send_event("to_ground")


func enter_knockback_state(force: Vector3) -> void:
	knockback_state.knockback_force = force
	state_chart.send_event("to_knockback")


func exit_knockback_state() -> void:
	state_chart.send_event("to_ground")
