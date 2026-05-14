class_name SearchQuest
extends Quest

@export var quest_information: QuestResource
@export var item_to_find: Node3D

func _ready() -> void:
	quest_name = quest_information.quest_name
	quest_description = quest_information.quest_description
	reached_goal_text = quest_information.reached_goal_text
	quest_status = QuestStatus.available
	if item_to_find:
		item_to_find.picked_up.connect(on_quest_item_pickup)

func start_quest() -> void:
	if quest_status == QuestStatus.available:
		quest_status = QuestStatus.started
		QuestManager.show_quest(quest_name, quest_description)

func on_quest_item_pickup(_body: Node3D) -> void:
	update_quest()
