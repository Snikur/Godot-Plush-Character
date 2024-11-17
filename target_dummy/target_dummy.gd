extends CharacterBody3D
class_name Enemy

var tween: Tween
@onready var status_label: Label3D = $Status
@onready var aggro_area: Area3D = $AggroArea
var max_health: int = 100
var health: int = 100
var target: Node3D
@onready var spawn_position: Vector3 = global_position
var return_to_spawn: bool = false

var changes_received: Array
func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		MM.slow_tick.connect(handle_changes)
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
	else:
		set_physics_process(false)
		$AggroArea/CollisionShape3D.disabled = true

func _physics_process(delta: float) -> void:
	if (target):
		velocity = (target.global_position - self.global_position).limit_length()
	elif (return_to_spawn):
		velocity = (spawn_position - self.global_position).limit_length()
		if (spawn_position.distance_to(global_position) < 1.0):
			return_to_spawn = false
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

@rpc("authority", "reliable", "call_local")
func change_health(value: int):
	health = value
	status_label.text = "HP: " + str(health) + "/" + str(max_health)

@rpc("any_peer", "reliable", "call_local")
func request_change(value: int):
	changes_received.append(value)

func handle_changes():
	if (changes_received.size() == 0):
		return
	var new_health: int = 0
	for change in changes_received:
		new_health = max(min(health+change, max_health), 0)
	if new_health == 0:
		new_health = max_health	
	change_health.rpc(new_health)
	changes_received.clear()
