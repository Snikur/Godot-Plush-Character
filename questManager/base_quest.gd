extends Node
class_name Quest

enum QuestStatus {
	AVAILABLE,
	STARTED,
	REACHED_GOAL,
	FINISHED,
}

var questName: String
var questDescription: String
var reachedGoalText: String
var questStatus: QuestStatus = QuestStatus.available


func startQuest() -> void:
	if questStatus == QuestStatus.available:
		questStatus = QuestStatus.started
		QuestManager.showQuest(questName, questDescription)


func updateQuest() -> void:
	if questStatus == QuestStatus.started:
		questStatus = QuestStatus.reachedGoal
		QuestManager.updateDescription(reachedGoalText)


func finishQuest() -> void:
	if questStatus == QuestStatus.reachedGoal:
		questStatus = QuestStatus.finished
		QuestManager.hideQuest()
