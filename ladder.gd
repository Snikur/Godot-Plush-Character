extends Area3D


func _ready() -> void:
	body_entered.connect(enter_ladder)
	body_exited.connect(leave_ladder)

func enter_ladder(body: Node3D):
	if body is Player:
		body.can_climb = true

func leave_ladder(body: Node3D):
	if body is Player:
		body.can_climb = false
