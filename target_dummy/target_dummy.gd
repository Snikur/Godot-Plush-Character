extends StaticBody3D
class_name Enemy

@onready var status_label: Label3D = $Status
var max_health: int = 100
var health: int = 100

var changes_received: Array
func _ready() -> void:
	if (multiplayer.is_server()):
		MM.slow_tick.connect(handle_changes)

@rpc("authority", "reliable", "call_local")
func change_health(value: int):
	if (multiplayer.is_server()):
		if value == 0:
			health = max_health
			change_health.rpc(health)
	else:
		health = value
	status_label.text = "HP: " + str(health) + "/" + str(max_health)

@rpc("any_peer", "reliable", "call_local")
func request_change(value: int):
	changes_received.append(value)

func handle_changes():
	if (changes_received.size() == 0):
		return
	for change in changes_received:
		health = max(min(health+change, max_health), 0)
	change_health.rpc(health)
	changes_received.clear()
