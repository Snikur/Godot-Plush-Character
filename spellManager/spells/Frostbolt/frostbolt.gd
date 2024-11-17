extends Node3D

var tween: Tween
var target: Enemy
@onready var vfx = $vfx_frostbolt

func _ready():
	if (multiplayer.is_server()):
		MM.tick.connect(tick)
	else:
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	global_position = global_position + global_basis.z * delta * 10.0
	vfx.look_at(global_position + global_basis.x)

func tick():
	server_state.rpc(global_position)

@rpc("authority", "call_remote", "unreliable_ordered")
func server_state(new_position: Vector3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", new_position, 0.1).from_current()
