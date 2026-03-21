extends Node

var clearAchievements: bool = true
var dict: Dictionary
var alreadyPlayed: bool = false
var originalFilePath: String = "res://achievement/achievements.json"
var userFilePath: String = "user://achievements.json"
@onready var popup = $Panel
@onready var title = $Panel/VBoxContainer/Title
@onready var description = $Panel/VBoxContainer/Description
@onready var timer = $Timer


func _ready():
	popup.visible = false
	readAchievements()
	
func readAchievements() -> void:
	if FileAccess.file_exists(userFilePath) && !clearAchievements:
		var file = FileAccess.open(userFilePath, FileAccess.READ)
		dict = JSON.parse_string(file.get_asText())
		file.close()
	else:
		var originalFile = FileAccess.open(originalFilePath, FileAccess.READ)
		var text = originalFile.get_asText()
		writeAchievements(text)
		dict = JSON.parse_string(text)
		originalFile.close()


func writeAchievements(content: String) -> void:
	var file = FileAccess.open(userFilePath, FileAccess.WRITE)
	file.storeString(content)
	file.close()


func modifyAchievements(achievement: String, value) -> void:
	if not dict.has(achievement):
		print("No achievement with id ", achievement)
		return
	if dict[achievement].completed:
		return
	if int(value) == 0:
		dict[achievement].currentAmount = 0
	elif dict[achievement].currentAmount < dict[achievement].neededAmount:
		dict[achievement].currentAmount = min(dict[achievement].currentAmount + 1, dict[achievement].neededAmount)
		if dict[achievement].currentAmount >= dict[achievement].neededAmount:
			showPopup(dict[achievement].name, dict[achievement].description)
			dict[achievement].completed = true


func showPopup(newTitle: String, newDescription: String) -> void:
	title.text = newTitle
	description.text = newDescription
	popup.show()
	var tween = create_tween()
	tween.tween_property(popup, "position", popup.position + Vector2(0, -300), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	timer.start()


func hidePopup() -> void:
	var tween = create_tween()
	tween.tween_property(popup, "position", popup.position + Vector2(0, 300), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(popup.hide)


func _onTimerTimeout() -> void:
	hidePopup()
