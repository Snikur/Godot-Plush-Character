extends Node
class_name Quest

enum QuestStatus {
	available,
	started,
	reached_goal,
	finished,
}

var quest_name: String
var quest_description: String
var reached_goal_text: String
var quest_status: QuestStatus = QuestStatus.available

func start_quest():
	if quest_status == QuestStatus.available:
		quest_status = QuestStatus.started
		QuestManager.show_quest(quest_name, quest_description)
	
func update_quest():
	if quest_status == QuestStatus.started:
		quest_status = QuestStatus.reached_goal
		QuestManager.update_description(reached_goal_text)
	
func finish_quest():
	if quest_status == QuestStatus.reached_goal:
		quest_status = QuestStatus.finished
		QuestManager.hide_quest()
