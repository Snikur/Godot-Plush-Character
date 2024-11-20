extends CharacterBody3D
class_name Enemy

@onready var aggro_area: Area3D = $AggroArea
@onready var spawn_position: Vector3 = global_position
@onready var combat: CombatComponent = $CombatComponent
@onready var swing_timer: Timer = $SwingTimer
@onready var last_hit_timer: Timer = $LastHitTimer
var target: Player

func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		aggro_area.body_entered.connect(func(body: Node3D):
			if (body is Player):
				if (target == null):
					target = body
		)
		combat.died.connect(func():
			combat.evading = true
			combat.reset()
		)
		last_hit_timer.timeout.connect(func():
			combat.evading = true
			combat.reset()
		)
		combat.health_changed.connect(func(_change: int):
			last_hit_timer.start()
		)
	else:
		set_physics_process(false)
		$AggroArea/CollisionShape3D.disabled = true

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return
	if (target and not combat.evading):
		velocity = (target.global_position - self.global_position).limit_length()
		if (target.global_position.distance_to(global_position) < 2.0):
			if (swing_timer.is_paused()):
				swing_timer.set_paused(false)
			if (swing_timer.time_left == 0):
				target.combat.request_change.rpc(-45)
				swing_timer.start()
		else:
			swing_timer.set_paused(true)
	elif (combat.evading):
		velocity = (spawn_position - self.global_position).limit_length()
		if (spawn_position.distance_to(global_position) < 1.0):
			combat.evading = false
			combat.request_change.rpc(combat.max_health)
	else:
		rotate_y(delta*0.5)
		velocity = global_basis.z * 2.0
	velocity.y = -9.1
	rotation.y = atan2(velocity.x, velocity.z)
	move_and_slide()
