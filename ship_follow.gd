extends PathFollow3D
var tween: Tween

func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
		tween = create_tween()
		tween.tween_property(self, "progress_ratio", 0.8, 60.0).from(0.0)
		tween.tween_property(self, "progress_ratio", 1.0, 60.0).from(0.8).set_delay(10.0)
		tween.set_loops(0)
	else:
		print("client")

func tick():
	server_state.rpc(progress_ratio)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(progress_ratio: float):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "progress_ratio", progress_ratio, 0.1).from_current()
