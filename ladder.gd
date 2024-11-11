extends Area3D


func _ready() -> void:
	body_entered.connect(enter_ladder)
	body_exited.connect(leave_ladder)

func enter_ladder(body: Node3D):
	if body is Player and body.id == multiplayer.get_unique_id():
		body.enter_climb_state(self)

func leave_ladder(body: Node3D):
	if body is Player and body.id == multiplayer.get_unique_id():
		body.exit_climb_state(self)
