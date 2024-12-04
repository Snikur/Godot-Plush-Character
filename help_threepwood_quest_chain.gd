extends Node3D

@onready var state_chart: StateChart = $SC
@onready var quest_marker: Label3D = $QuestMarker
@export var kill_target: Enemy
@export var pickup_coin: GoldCoin
@onready var pickup_zone: Area3D = $PickupZone
@onready var quest_panel: PanelContainer = $CanvasLayer/PanelContainer
@onready var accept_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AcceptButton
@onready var close_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var complete_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CompleteButton
@onready var quest_text: RichTextLabel = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/QuestText

var player: Player = null
var quest_reward_experience: int = 1337
var quest_start_text: String = "Target Dummy, the scourge of the seven seas, was known for his cunning and his love of gold.\n\nLegend has it that he buried his most prized possession, a golden coin imbued with mystical powers, inside this forest.\n\nThis coin, they say, could grant its holder untold riches and eternal youth. For centuries, treasure hunters have searched high and low for this elusive prize, but none have ever found it. Some believe the coin is still out there, waiting to be claimed by a worthy adventurer. Others doubt its existence, dismissing it as a pirate's tale.\n\nBut one thing is certain: the mystery of Target Dummy's Secret Golden Coin continues to captivate imaginations and drive explorers to the ends of the earth.\n\nWill you help me find his Legendary Coin and return it here?"
var quest_end_text: String = "You beat the dummy AND found his coin?\n\nAMAZING!"

func _ready() -> void:
	quest_panel.visible = false
	quest_text.text = quest_start_text
	await MM.connected
	quest_marker.text = "!"
	quest_marker.modulate = Color.YELLOW
	pickup_coin.set_visibility.call_deferred(false)
	$SC/CS/P/KillTargetDummy.state_entered.connect(kill_target_entered)
	$SC/CS/P/PickUpPirateCoin.state_entered.connect(pickup_coin_entered)
	$SC/CS/CollectReward.state_entered.connect(completed_objectives)
	$SC/CS/Completed.state_entered.connect(reward_collected)
	pickup_zone.body_entered.connect(entered_pickup_zone)
	pickup_zone.body_exited.connect(exited_pickup_zone)
	accept_button.pressed.connect(accept_pressed)
	close_button.pressed.connect(close_pressed)
	complete_button.pressed.connect(complete_pressed)
	
	complete_button.visible = false

func complete_pressed():
	state_chart.send_event("reward_collected")
	pickup_zone.body_entered.disconnect(finished_quest)
	quest_panel.visible = false
	if (is_instance_valid(player)):
		player.level.add_experience_points(quest_reward_experience)

func accept_pressed():
	quest_panel.visible = false
	print("started quest")
	QuestManager.show_quest("WANTED: Target Dummy and the secret Coin", "Kill the terrifying Target Dummy out in the open field and collect his hidden pirate coin.")
	quest_marker.text = "?"
	quest_marker.modulate = Color.GRAY
	state_chart.send_event("pickup_quest")
	pickup_zone.body_entered.disconnect(entered_pickup_zone)
	state_chart.set_expression_property("target_killed", false)
	state_chart.set_expression_property("item_picked_up", false)
	accept_button.visible = false

func close_pressed():
	quest_panel.visible = false

func exited_pickup_zone(body: Node3D) -> void:
	quest_panel.visible = false

func entered_pickup_zone(body: Node3D) -> void:
	if (body is Player and body.id == multiplayer.get_unique_id()):
		quest_panel.visible = true
		player = body

func kill_target_entered() -> void:
	print("kill target dummy")
	kill_target.combat.died.connect(func():
		QuestManager.update_description("You killed the Target Dummy! Now find his coin.")
		print("killed target dummy")
		state_chart.set_expression_property("target_killed", true)
		state_chart.send_event("to_reward")
	)

func pickup_coin_entered() -> void:
	print("pick up coin")
	pickup_coin.set_visibility.call_deferred(true)
	pickup_coin.picked_up.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
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
	complete_button.visible = true
	quest_text.text = quest_end_text

func finished_quest(body: Node3D) -> void:
	if (body is Player and body.id == multiplayer.get_unique_id()):
		quest_panel.visible = true

func reward_collected() -> void:
	QuestManager.hide_quest()
	quest_marker.visible = false
	print("thanks for helping Threepwood the Second")
