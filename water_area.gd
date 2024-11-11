extends Area3D

func _ready() -> void:
	body_entered.connect(func(body: Node3D):
		print("enter ", body.name)
		if body is Player and body.id == multiplayer.get_unique_id():
			body.enter_water_state()
		)
	body_exited.connect(func(body: Node3D):
		print("exit ", body.name)
		if body is Player and body.id == multiplayer.get_unique_id():
			body.exit_water_state()
		)
