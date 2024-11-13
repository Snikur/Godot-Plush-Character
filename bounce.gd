extends Area3D

func _ready() -> void:
	body_entered.connect(func(body: Player):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			var theta = randf() * 2 * PI
			var x = cos(theta)
			var z = sin(theta)
			var dir = Vector3(x, 1.0, z) * randf_range(15.0, 30.0)
			body.enter_knockback_state(dir)
	)
