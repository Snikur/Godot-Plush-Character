extends Node3D
class_name CombatComponent

@onready var status_label: Label3D = $Status
var level = 1
var experience: int = 0
var required_experience: int = 100
var max_health: int = 100
var health: int = 100
var max_mana: int = 100
var mana: int = 100
var changes_received: Dictionary = {}
var threat: Dictionary = {}
var evading: bool = false
signal died
signal health_changed(change)

var strength: int = 10
var agility: int = 10
var intelligenec: int = 10
var mp5: int = 10
var hp5: int = 10
var stamina: int = 13
var magic_resistance: int = 10
var poison_resistance: int = 10

func _ready():
	if (not get_parent() is Player): #TODO: hacky solution
		await MM.connected
	calculate_stats()
	update_label()
	if (multiplayer.is_server()):
		print("connect slow tick from ", get_parent().name)
		MM.slow_tick.connect(handle_changes)

func calculate_stats():
	max_health = floori(stamina * 10)

@rpc("authority", "reliable", "call_local")
func change_health(value: int):
	health = value
	update_label()
	health_changed.emit(health)

func update_label():
	status_label.text = "HP: " + str(health) + "/" + str(max_health)
	status_label.text += "\nMANA: " + str(mana) + "/" + str(max_mana)
	status_label.text += "\nLevel: " + str(level)

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
	update_label()
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

func add_experience_points(points: int) -> void:
	experience += points
	if (experience > required_experience):
		required_experience *= 1.23
		print("DING")
		level += 1
		var rest = experience - required_experience
		experience = 0
		calculate_stats()
		add_experience_points(rest)
	update_label()
