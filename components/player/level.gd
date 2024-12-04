extends Node3D
class_name LevelComponent

var level = 1
@onready var experience_bar: ProgressBar = $CanvasLayer/HBoxContainer/ExperienceBar
@onready var level_label: Label = $CanvasLayer/HBoxContainer/Level

func add_experience_points(points: int) -> void:
	experience_bar.value += points
	if (experience_bar.value > experience_bar.max_value):
		print("DING")
		level += 1
		level_label.text = "Level " + str(level)
		var rest = experience_bar.value - experience_bar.max_value
		print("value: ", experience_bar.value, " max: ", experience_bar.max_value, " rest: ", rest)
		experience_bar.value = 0
		add_experience_points(rest)
