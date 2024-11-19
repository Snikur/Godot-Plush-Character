extends PathFollow3D
var tween: Tween

func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		MM.slow_tick.connect(tick)
		tween = create_tween()
		tween.tween_property(self, "progress_ratio", 0.8, 80.0).from(0.0)
		tween.tween_property(self, "progress_ratio", 1.0, 20.0).from(0.8).set_delay(10.0)
		tween.set_loops(0)

func tick():
	server_state.rpc(progress_ratio)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_progress_ratio: float):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "progress_ratio", new_progress_ratio, 0.6).from_current()
