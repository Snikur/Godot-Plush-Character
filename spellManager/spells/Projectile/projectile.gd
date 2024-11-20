extends Area3D
class_name Projectile

@onready var vfx: Node3D = $vfx
@onready var sync: SyncTransform = $SyncTransform
var tween: Tween
var target: Enemy
var ticks: int = 0

func _ready():
	if (multiplayer.is_server()):
		sync.tick.connect(func(amount: int):
			if (amount > 50):
				sync.delete.rpc()
		)
		body_entered.connect(func(body: Node3D):
			if (body is Enemy):
				body.combat.request_change(-10)
				sync.delete.rpc()
		)
	else:
		set_physics_process(false)
		$CollisionShape3D.disabled = true

func _physics_process(delta: float) -> void:
	global_position = global_position + global_basis.z * delta * 10.0
	vfx.look_at(global_position - global_basis.z)
