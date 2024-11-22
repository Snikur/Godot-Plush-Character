extends Node3D
class_name GoldCoin

@onready var collider = $Area3D/CollisionShape3D
@onready var area = $Area3D

signal picked_up(body)

func _ready() -> void:
	area.body_entered.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			picked_up.emit(body)
			queue_free()
		)

func set_visibility(on: bool):
	collider.disabled = not on
	visible = on
