extends Node3D
class_name GoldCoin

signal picked_up

func _ready() -> void:
	$Area3D.body_entered.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			picked_up.emit()
			queue_free()
		)
