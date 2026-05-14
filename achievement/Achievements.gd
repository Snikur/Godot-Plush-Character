extends Node

var clear_achievements: bool = true
var dict: Dictionary
var already_played: bool = false
var original_file_path: String = "res://achievement/achievements.json"
var user_file_path: String = "user://achievements.json"

@onready var popup: PanelContainer = $Panel
@onready var title: Label = $Panel/VBoxContainer/Title
@onready var description: Label = $Panel/VBoxContainer/Description
@onready var timer: Timer = $Timer

func _ready() -> void:
	popup.visible = false
	read_achievements()

func read_achievements() -> void:
	if FileAccess.file_exists(user_file_path) and not clear_achievements:
		var file: FileAccess = FileAccess.open(user_file_path, FileAccess.READ)
		dict = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		var original_file: FileAccess = FileAccess.open(original_file_path, FileAccess.READ)
		var text: String = original_file.get_as_text()
		write_achievements(text)
		dict = JSON.parse_string(text)
		original_file.close()

func write_achievements(content: String) -> void:
	var file: FileAccess = FileAccess.open(user_file_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func modify_achievement(achievement: String, value: bool) -> void:
	if not dict.has(achievement):
		print("No achievement with id ", achievement)
		return
	if dict[achievement].completed:
		return
	if int(value) == 0:
		dict[achievement].current_amount = 0
	elif dict[achievement].current_amount < dict[achievement].needed_amount:
		dict[achievement].current_amount = min(dict[achievement].current_amount + 1, dict[achievement].needed_amount)
		if dict[achievement].current_amount >= dict[achievement].needed_amount:
			show_popup(dict[achievement].name, dict[achievement].description)
			dict[achievement].completed = true

func show_popup(new_title: String, new_description: String) -> void:
	title.text = new_title
	description.text = new_description
	popup.show()
	var tween: Tween = create_tween()
	tween.tween_property(popup, &"position", popup.position + Vector2(0, -300), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	timer.start()

func hide_popup() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(popup, &"position", popup.position + Vector2(0, 300), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(popup.hide)

func _on_timer_timeout() -> void:
	hide_popup()
