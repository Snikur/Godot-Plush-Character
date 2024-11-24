extends Area3D
class_name WaterArea

func _ready() -> void:
	body_entered.connect(func(body: Node3D):
		if body is Player and body.id == multiplayer.get_unique_id():
			body.request_water_state()
		)
	body_exited.connect(func(body: Node3D):
		if body is Player and body.id == multiplayer.get_unique_id():
			body.exit_water_state()
		)
