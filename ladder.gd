extends Area3D


func _ready() -> void:
	body_entered.connect(enter_ladder)
	body_exited.connect(leave_ladder)

func enter_ladder(body: Node3D):
	if body is Player:
		body.enter_climb_state()

func leave_ladder(body: Node3D):
	if body is Player:
		body.leave_climb_state()
