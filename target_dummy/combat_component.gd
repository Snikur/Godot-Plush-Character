extends Node3D
class_name CombatComponent

@onready var status_label: Label3D = $Status
var max_health: int = 100
var health: int = 100
var changes_received: Array
signal die

func _ready():
	await MM.connected
	if (multiplayer.is_server()):
		MM.slow_tick.connect(handle_changes)

@rpc("authority", "reliable", "call_local")
func change_health(value: int):
	health = value
	status_label.text = "HP: " + str(health) + "/" + str(max_health)

@rpc("any_peer", "reliable", "call_local")
func request_change(value: int):
	changes_received.append(value)

func handle_changes():
	if (changes_received.size() == 0):
		return
	var new_health: int = 0
	for change in changes_received:
		new_health = max(min(health+change, max_health), 0)
	if new_health == 0:
		die.emit()
	change_health.rpc(new_health)
	changes_received.clear()
