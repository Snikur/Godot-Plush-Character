extends Node3D

var tween: Tween
var target: Enemy

func _ready():
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
		tween = create_tween()
	else:
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	if (is_instance_valid(target)):
		self.look_at(target.global_position)
		global_position = global_position.move_toward(target.global_position, delta * 10.0)
		if ((target.global_position - self.global_position).length() < 1.0):
			target.request_change.rpc_id(1, -10)
			queue_free()
	else:
		queue_free()

func tick():
	server_state.rpc(global_position)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
