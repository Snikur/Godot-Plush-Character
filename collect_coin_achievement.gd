extends Node3D

func _on_gold_coin_picked_up() -> void:
	Achievements.modifyAchievements("collect_coin", true)
