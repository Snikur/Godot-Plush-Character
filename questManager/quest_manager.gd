extends Node3D
@onready var QuestBox: CanvasLayer = $UI
@onready var QuestTitle: RichTextLabel = $UI/Panel/QuestTitle
@onready var QuestDescription: RichTextLabel = $UI/Panel/QuestDescription

func show_quest(title: String, description: String):
	QuestTitle.text = title
	QuestDescription.text = description
	QuestBox.visible = true
	
func hide_quest():
	QuestBox.visible = false
	
func update_description(description):
	QuestDescription.text = description
