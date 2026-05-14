class_name WaterArea
extends Area3D

func _ready() -> void:
	body_entered.connect(func(body: Node3D) -> void:
		if body is Player and body.id == multiplayer.get_unique_id():
			body.request_water_state()
	)
	body_exited.connect(func(body: Node3D) -> void:
		if body is Player and body.id == multiplayer.get_unique_id():
			body.exit_water_state()
	)
