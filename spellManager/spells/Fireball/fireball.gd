extends MeshInstance3D

var target: Enemy

func _physics_process(delta: float) -> void:
	if (is_instance_valid(target)):
		global_position = global_position.move_toward(target.global_position, delta)
		if ((target.global_position - self.global_position).length() < 1.0):
			target.request_change(-10)
			queue_free()
	else:
		queue_free()
