class_name SearchQuest
extends Quest

func start_quest() -> void:
	if quest_status == QuestStatus.available:
		quest_status = QuestStatus.started
		super.start_quest()

		
func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		quest_status = QuestStatus.reached_goal
		super.update_quest()
		
func finish_quest() -> void:
	if quest_status == QuestStatus.reached_goal:
		quest_status = QuestStatus.finished
		
		super.finish_quest()

		
		#rewards here
		#rewards here
		#rewards here
		
