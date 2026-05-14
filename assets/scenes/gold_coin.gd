class_name GoldCoin
extends Node3D

@onready var collider: CollisionShape3D = $Area3D/CollisionShape3D
@onready var area: Area3D = $Area3D

signal picked_up(body: Node3D)

func _ready() -> void:
	area.body_entered.connect(func(body: Node3D) -> void:
		if body is Player and body.id == multiplayer.get_unique_id():
			picked_up.emit(body)
			queue_free()
	)

func set_visibility(on: bool) -> void:
	collider.disabled = not on
	visible = on
