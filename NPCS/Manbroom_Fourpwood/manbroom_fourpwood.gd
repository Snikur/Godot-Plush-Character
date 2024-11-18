extends Area3D

@export var quest: SearchQuest
var coin := load("res://assets/scenes/gold_coin.tscn")

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if (body is Player and body.id == multiplayer.get_unique_id()):
		if quest.quest_status == quest.QuestStatus.available:
			quest.start_quest()
			
			var new_coin = coin.instantiate()
			add_child(new_coin)
			var spawnPoint =  $"../CoinSpawnPoint"
			new_coin.position = spawnPoint.position
			new_coin.picked_up.connect(quest.reached_goal)
	
	if quest.quest_status == quest.QuestStatus.reached_goal:
		quest.finish_quest()
