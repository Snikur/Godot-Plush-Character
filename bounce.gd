extends Area3D

func _ready() -> void:
	body_entered.connect(func(body: Player) -> void:
		if body is Player and body.id == multiplayer.get_unique_id():
			var theta: float = randf() * 2 * PI
			var x: float = cos(theta)
			var z: float = sin(theta)
			var dir: Vector3 = Vector3(x, 1.0, z) * randf_range(15.0, 30.0)
			body.enter_knockback_state(dir)
	)
