extends AnimatableBody3D

var tween = create_tween()

func _ready() -> void:
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
		tween.tween_property(self, "global_position:y", 5.5, 5.0).from(0.5).set_delay(2.0)
		tween.tween_property(self, "global_position:y", 0.5, 5.0).from(5.5).set_delay(2.0)
		tween.set_loops(0)

func tick():
	server_state.rpc(global_position)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
