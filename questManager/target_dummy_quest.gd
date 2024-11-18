extends Quest
class_name WantedTargetDummyQuest

@export var wanted_target: Enemy

func _ready():
	quest_name = "WANTED: Kill Target Dummy"
	quest_description = "Search the island to find Target Dummy"
	reached_goal_text = "Return to Manbrush Twowood to collect your reward"
	quest_status = QuestStatus.available
	if (wanted_target):
		wanted_target.combat.died.connect(_on_killed_target)

func _on_killed_target() -> void:
	update_quest()
