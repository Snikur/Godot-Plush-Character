extends AnimatableBody3D

var tween: Tween
@export var destination_height: float = 5.5
@onready var original_height: float = global_position.y

func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
		tween = create_tween()
		tween.tween_property(self, "global_position:y", destination_height, 5.0).from(original_height).set_delay(2.0)
		tween.tween_property(self, "global_position:y", original_height, 5.0).from(destination_height).set_delay(2.0)
		tween.set_loops(0)

func tick():
	server_state.rpc(global_position)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
