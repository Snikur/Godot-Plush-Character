extends Node

var clearAchivements: bool = true
var dict: Dictionary
var alreadyPlayed : bool = false
var originalFilePath : String = "res://achievement/achievements.json"
var userFilePath : String = "user://achievements.json"
@onready var popup = $Panel
@onready var title = $Panel/VBoxContainer/Title
@onready var description = $Panel/VBoxContainer/Description
@onready var timer = $Timer


func _ready():
	popup.visible = false
	readAchievements()
	
func readAchievements():
	if FileAccess.file_exists(userFilePath) and !clearAchivements:
		var file = FileAccess.open(userFilePath, FileAccess.READ)
		dict = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		var originalFile = FileAccess.open(originalFilePath, FileAccess.READ) 
		var text = originalFile.get_as_text()
		writeAchievements(text)
		dict = JSON.parse_string(text)
			
		originalFile.close()
		
func writeAchievements(content):
	var file = FileAccess.open(userFilePath, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func modifyAchievements(achievement, value):
	if (not dict.has(achievement)):
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
			
func showPopup(new_title, new_description):
	title.text = new_title
	description.text = new_description
	popup.show()
	var tween = create_tween()
	tween.tween_property(popup, "position", popup.position + Vector2(0, -300), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	timer.start()
	
func hidePopup():
	var tween = create_tween()
	tween.tween_property(popup, "position", popup.position + Vector2(0, 300), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(popup.hide)
	
func _on_timer_timeout():
	hidePopup()
