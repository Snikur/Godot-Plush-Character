extends CharacterBody3D
class_name Enemy

var tween: Tween

@onready var aggro_area: Area3D = $AggroArea
@onready var spawn_position: Vector3 = global_position
@onready var combat: CombatComponent = $CombatComponent
@onready var swing_timer: Timer = $SwingTimer
var target: Player
var return_to_spawn: bool = false

func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
		aggro_area.body_entered.connect(func(body: Node3D):
			if (body is Player):
				target = body
		)
		aggro_area.body_exited.connect(func(body: Node3D):
			if (body is Player and target == body):
				target = null
				return_to_spawn = true
		)
		combat.die.connect(func():
			return_to_spawn = true
		)
	else:
		set_physics_process(false)
		$AggroArea/CollisionShape3D.disabled = true

func _physics_process(delta: float) -> void:
	if (target and not return_to_spawn):
		velocity = (target.global_position - self.global_position).limit_length()
		if (target.global_position.distance_to(global_position) < 2.0):
			if (swing_timer.is_paused()):
				swing_timer.set_paused(false)
			if (swing_timer.time_left == 0):
				target.combat.request_change.rpc(-45)
				swing_timer.start()
		else:
			swing_timer.set_paused(true)
	elif (return_to_spawn):
		combat.status_label.text = "Evading" #show only for server
		velocity = (spawn_position - self.global_position).limit_length()
		if (spawn_position.distance_to(global_position) < 1.0):
			return_to_spawn = false
			combat.request_change.rpc(combat.max_health)
	else:
		rotate_y(delta*0.5)
		velocity = global_basis.z * 2.0
	move_and_slide()

func tick():
	server_state.rpc(global_position)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
