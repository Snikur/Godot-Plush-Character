extends Area3D

func _ready() -> void:
	body_entered.connect(func(body: Node3D):
		if (body.has_method("knockback")):
			var theta = randf() * 2 * PI
			var x = cos(theta)
			var z = sin(theta)
			var dir = Vector3(x, 1.0, z) * 15.0
			body.knockback(dir)
	)
