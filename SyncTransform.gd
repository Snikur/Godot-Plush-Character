class_name SyncTransform
extends Node3D

@onready var parent: Node3D = get_parent()

var tween: Tween
var ticks: int = 0

signal tick(amount: int)

func _ready() -> void:
	if not parent is Projectile:
		await MM.connected
	if multiplayer.is_server():
		MM.tick.connect(_tick)

func _tick() -> void:
	server_state.rpc(parent.global_position)
	ticks += 1
	tick.emit(ticks)

@rpc("authority", "reliable", "call_local")
func delete() -> void:
	parent.queue_free()

@rpc("authority", "unreliable_ordered", "call_remote")
func server_state(new_position: Vector3) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(parent, &"global_position", new_position, 1.0).from_current()
