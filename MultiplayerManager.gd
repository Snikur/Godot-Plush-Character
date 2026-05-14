extends Node

@onready var ip_address: String = "ws://localhost:25565" if OS.has_feature(&"debug") else "ws://game.reitan.dev"

var peer: WebSocketMultiplayerPeer
const PORT: int = 25565
const MAX_CLIENTS: int = 4095

var list_of_players: Array[Player] = []
@onready var player_prefab: PackedScene = preload("res://components/player/player.tscn")

signal tick
signal slow_tick
signal connected

@onready var tick_timer: Timer = $TickTimer
@onready var slow_tick_timer: Timer = $SlowTickTimer

func _ready() -> void:
	tick_timer.timeout.connect(tick.emit)
	slow_tick_timer.timeout.connect(slow_tick.emit)

func _process(_delta: float) -> void:
	if peer:
		peer.poll()

func host() -> void:
	peer = WebSocketMultiplayerPeer.new()
	peer.create_server(PORT, "*")
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(client_connected)
	multiplayer.peer_disconnected.connect(client_disconnected)
	var random_position: Vector3 = Vector3(randf_range(30.0, 40.0), 10.0, randf_range(30.0, 40.0))
	add_client(1, {"position": random_position})
	DisplayServer.window_set_title("HOST")
	connected.emit()

func add_client(id: int, data: Dictionary) -> void:
	var player: Player = player_prefab.instantiate()
	player.name = str(id)
	player.id = id
	player.data = data
	add_child(player)
	list_of_players.append(player)
	if multiplayer.is_server():
		DisplayServer.window_set_title("HOST Connections: " + str(list_of_players.size()))

@rpc("authority", "reliable", "call_remote")
func remote_add_client(id: int, data: Dictionary) -> void:
	print("added client ", id)
	add_client(id, data)

func client_connected(id: int) -> void:
	prints(str(id), "connected")

func client_disconnected(id: int) -> void:
	for player in list_of_players:
		if player.id == id:
			list_of_players.erase(player)
			player.remove.rpc()
			break
	if multiplayer.is_server():
		DisplayServer.window_set_title("HOST Connections: " + str(list_of_players.size()))

func join() -> void:
	peer = WebSocketMultiplayerPeer.new()
	peer.create_client(ip_address)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(func() -> void: print("Connection failed"))
	multiplayer.server_disconnected.connect(func() -> void: print("Server disconnected"))
	connected.emit()

func connected_to_server() -> void:
	DisplayServer.window_set_title("JOIN: Player " + str(multiplayer.get_unique_id()))
	var random_position: Vector3 = Vector3(randf_range(30.0, 40.0), 10.0, randf_range(30.0, 40.0))
	send_setup.rpc_id(1, {"position": random_position})

@rpc("any_peer", "reliable", "call_local")
func send_setup(data: Dictionary) -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	for player in list_of_players:
		if player.id == sender_id:
			return
	add_client(sender_id, data)
	for player in list_of_players:
		remote_add_client.rpc_id(sender_id, player.id, player.data)
		if not player.id == 1 and not player.id == sender_id:
			remote_add_client.rpc_id(player.id, sender_id, player.data)
