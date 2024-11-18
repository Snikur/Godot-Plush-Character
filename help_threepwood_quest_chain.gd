extends Node3D

@onready var state_chart: StateChart = $SC
@onready var quest_marker: Label3D = $QuestMarker
@export var kill_target: Enemy
@export var pickup_coin: GoldCoin
@onready var pickup_zone: Area3D = $PickupZone

func _ready() -> void:
	await MM.connected
	quest_marker.text = "!"
	quest_marker.modulate = Color.YELLOW
	pickup_coin.set_visibility.call_deferred(false)
	$SC/CS/P/KillTargetDummy.state_entered.connect(kill_target_entered)
	$SC/CS/P/PickUpPirateCoin.state_entered.connect(pickup_coin_entered)
	$SC/CS/CollectReward.state_entered.connect(completed_objectives)
	$SC/CS/Completed.state_entered.connect(reward_collected)
	pickup_zone.body_entered.connect(entered_pickup_zone)

func entered_pickup_zone(body: Node3D) -> void:
	print("player tried starting quest")
	if (body is Player and body.id == multiplayer.get_unique_id()):
		print("started quest")
		QuestManager.show_quest("WANTED: Target Dummy and the secret Coin", "Kill the terrifying Target Dummy out in the open field and collect his hidden pirate coin.")
		quest_marker.text = "?"
		quest_marker.modulate = Color.GRAY
		state_chart.send_event("pickup_quest")
		pickup_zone.body_entered.disconnect(entered_pickup_zone)

func kill_target_entered() -> void:
	print("kill target dummy")
	kill_target.combat.die.connect(func():
		QuestManager.update_description("You killed the Target Dummy! Now find his coin.")
		print("killed target dummy")
		state_chart.set_expression_property("target_killed", true)
	)

func pickup_coin_entered() -> void:
	print("pick up coin")
	pickup_coin.set_visibility.call_deferred(true)
	pickup_coin.picked_up.connect(func():
		QuestManager.update_description("You found the coin! Now go and kill the Target Dummy.")
		print("picked up coin")
		state_chart.set_expression_property("item_picked_up", true)
		state_chart.send_event("to_reward")
	)

func completed_objectives() -> void:
	quest_marker.text = "?"
	quest_marker.modulate = Color.YELLOW
	QuestManager.update_description("You found the coin and killed the Target Dummy, go collect your reward!")
	print("objectives completed, go collect reward")
	pickup_zone.body_entered.connect(finished_quest)

func finished_quest(body: Node3D) -> void:
	if (body is Player and body.id == multiplayer.get_unique_id()):
			state_chart.send_event("reward_collected")
			pickup_zone.body_entered.disconnect(finished_quest)

func reward_collected() -> void:
	QuestManager.hide_quest()
	quest_marker.visible = false
	print("thanks for helping Threepwood the Second")
