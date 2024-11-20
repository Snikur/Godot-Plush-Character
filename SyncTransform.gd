extends Node3D
class_name SyncTransform

@onready var parent: Node3D = get_parent()
var tween: Tween
var ticks: int = 0

signal tick(amount: int)

func _ready() -> void:
	if (not parent is Projectile):
		await MM.connected
	if (multiplayer.is_server()):
		MM.tick.connect(_tick)

func _tick():
	server_state.rpc(parent.global_position)
	ticks = ticks + 1
	tick.emit(ticks)

@rpc("authority", "call_local", "reliable")
func delete():
	parent.queue_free()

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(parent, "global_position", new_position, 0.1).from_current()
