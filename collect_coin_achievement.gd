extends Node3D

func _on_gold_coin_picked_up(_body: Node3D) -> void:
	Achievements.modifyAchievements("collect_coin", true)
