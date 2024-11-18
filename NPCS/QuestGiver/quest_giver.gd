extends Node3D
class_name QuestGiver

@onready var quest: Quest = $Quest
@onready var trigger_area: Area3D = $Area3D

func _ready():
	trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if (body is Player and body.id == multiplayer.get_unique_id()):
		if quest.quest_status == quest.QuestStatus.available:
			quest.start_quest()
		elif quest.quest_status == quest.QuestStatus.reached_goal:
			quest.finish_quest()
