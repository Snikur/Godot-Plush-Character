extends Quest
class_name SearchQuest

@export var coin: GoldCoin

func _ready():
	quest_name = "Find the pirate coin"
	quest_description = "Search the island to find the pirate coin yarr!"
	reached_goal_text = "Return the pirate coin to Manbroom Fourpwood"
	quest_status = QuestStatus.available
	if (coin):
		coin.picked_up.connect(_on_gold_coin_picked_up)

func _on_gold_coin_picked_up() -> void:
	update_quest()
