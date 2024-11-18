extends Area3D

var tween: Tween
var target: Enemy
@onready var vfx = $vfx_fireball
var ticks: int = 0

func _ready():
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
		body_entered.connect(func(body: Node3D):
			if (body is Enemy):
				body.combat.request_change.rpc(-10)
				delete.rpc()
		)
	else:
		set_physics_process(false)
		$CollisionShape3D.disabled = true

func _physics_process(delta: float) -> void:
	global_position = global_position + global_basis.z * delta * 10.0
	vfx.look_at(global_position + global_basis.x)

func tick():
	server_state.rpc(global_position)
	ticks = ticks + 1
	if (ticks > 50):
		delete.rpc()

@rpc("authority", "call_local", "reliable")
func delete():
	queue_free()

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	var dir: Vector3 = global_position + (global_position - new_position).rotated(Vector3.UP, -1.57)
	vfx.look_at(dir)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
