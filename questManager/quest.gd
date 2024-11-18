extends Node
class_name Quest

@export_group("Quest Settings")
@export var quest_name: String
@export var quest_description: String
@export var reached_goal_text: String

enum QuestStatus {
	available,
	started,
	reached_goal,
	finished,
}

@export var quest_status: QuestStatus = QuestStatus.available

@export_group("Rewards Settings")
@export var reward_amount: int
@export var xp_amount: int

func start_quest():
	QuestManager.show_quest(quest_name, quest_description)
	
func update_quest():
	QuestManager.update_description(reached_goal_text)
	
func finish_quest():
	QuestManager.hide_quest()
