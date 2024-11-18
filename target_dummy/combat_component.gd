extends Node3D
class_name CombatComponent

@onready var status_label: Label3D = $Status
var max_health: int = 100
var health: int = 100
var changes_received: Dictionary = {}
var threat: Dictionary = {}
var evading: bool = false
signal died
signal health_changed(change)

func _ready():
	if (not get_parent() is Player): # hacky solution
		await MM.connected
	if (multiplayer.is_server()):
		print("connect slow tick from ", get_parent().name)
		MM.slow_tick.connect(handle_changes)

@rpc("authority", "reliable", "call_local")
func change_health(value: int):
	health = value
	status_label.text = "HP: " + str(health) + "/" + str(max_health)
	health_changed.emit(health)

@rpc("any_peer", "reliable", "call_local")
func request_change(value: int):
	if (evading):
		return
	var id = multiplayer.get_remote_sender_id()
	if (health == 0):
		changes_received.clear()
	if changes_received.has(id):
		changes_received[id].append(value)
	else:
		changes_received[id] = [value]
	prints(get_parent().name, "changes for id", id, changes_received[id])

@rpc("authority", "reliable", "call_local")
func die():
	prints(get_parent().name, "died")
	threat = {}
	changes_received = {}
	health = 0
	status_label.text = "HP: " + str(health) + "/" + str(max_health)
	died.emit()

func reset():
	changes_received.clear()
	threat.clear()

func handle_changes():
	if (changes_received.size() == 0):
		return
	var new_health: int = health
	for key in changes_received.keys():
		for change in changes_received[key]:
			threat[key] = threat[key] + abs(change) if threat.has(key) else abs(change)
			new_health = max(min(new_health+change, max_health), 0)
		changes_received[key] = []
	if new_health == 0:
		change_health.rpc(new_health)
		die.rpc()
	else:
		change_health.rpc(new_health)
		changes_received = {}
	print("threat table: ", threat)
