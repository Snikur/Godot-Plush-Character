extends Node3D

var target: Enemy

func _physics_process(delta: float) -> void:
	if (is_instance_valid(target)):
		self.look_at(target.global_position)
		global_position = global_position.move_toward(target.global_position, delta * 10.0)
		if ((target.global_position - self.global_position).length() < 1.0):
			target.request_change.rpc_id(1, -10)
			queue_free()
	else:
		queue_free()
