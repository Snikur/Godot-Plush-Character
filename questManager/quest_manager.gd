extends Node3D
@onready var quest_box: CanvasLayer = $UI
@onready var quest_title: RichTextLabel = $UI/Panel/QuestTitle
@onready var quest_description: RichTextLabel = $UI/Panel/QuestDescription

func show_quest(title: String, description: String):
	quest_title.text = title
	quest_description.text = description
	quest_box.visible = true
	
func hide_quest():
	quest_box.visible = false
	
func update_description(description: String):
	quest_description.text = description
