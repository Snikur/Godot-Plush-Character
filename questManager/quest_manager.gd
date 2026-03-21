extends Node3D
@onready var quest_box: CanvasLayer = $UI
@onready var quest_title: Label = %QuestTitle
@onready var quest_description: Label = %QuestDescription

func showQuest(title: String, description: String) -> void:
	questTitle.text = title
	questDescription.text = description
	questBox.visible = true


func hideQuest() -> void:
	questBox.visible = false


func updateDescription(description: String) -> void:
	questDescription.text = description
