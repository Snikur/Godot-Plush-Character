extends Node3D

signal picked_up

func _ready() -> void:
	$Area3D.body_entered.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			print("collected coin")
			Achievements.modifyAchievements("collect_coin", true)
			picked_up.emit()
			queue_free()
		)
