extends Node

@onready var IP_ADDRESS = "ws://localhost:25565" if OS.has_feature("debug") else "ws://game.reitan.dev"
var peer: WebSocketMultiplayerPeer
const PORT: int = 25565
const MAX_CLIENTS: int = 4095

var entities_spawned: int = 0

var list_of_players: Array[Player] = []
@onready var player_prefab := preload("res://components/player/player.tscn")

signal tick
signal slow_tick
@onready var tick_timer: Timer = $TickTimer
@onready var slow_tick_timer: Timer = $SlowTickTimer

signal connected

func _ready():
	tick_timer.timeout.connect(tick.emit)
	slow_tick_timer.timeout.connect(slow_tick.emit)

func _process(_delta):
	if peer:
		peer.poll()

func host():
	peer = WebSocketMultiplayerPeer.new()
	#var server_certs = load("res://generated.crt")
	#var server_key = load("res://generated.key")
	#var server_tls_options = TLSOptions.server(server_key, server_certs)
	
	peer.create_server(PORT, "*")#server_tls_options)
	#peer.max_queued_packets = 8192
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(client_connected)
	multiplayer.peer_disconnected.connect(client_disconnected)
	var random_position: Vector3 = Vector3(randf_range(30.0, 40.0), 10.0, randf_range(30.0, 40.0))
	add_client(1, {"position": random_position})
	DisplayServer.window_set_title(str("HOST"))
	connected.emit()

func add_client(id: int, data: Dictionary):
	var player: Player = player_prefab.instantiate()
	player.name = str(id)
	player.id = id
	player.data = data
	add_child(player)
	list_of_players.append(player)
	if multiplayer.is_server():
		DisplayServer.window_set_title(str("HOST Connections: ", list_of_players.size()))

@rpc("authority", "reliable", "call_remote")
func remote_add_client(id: int, data: Dictionary):
	print("added client ", id)
	add_client(id, data)

func client_connected(id: int):
	prints(str(id), "connected")

func client_disconnected(id: int):
	for player in list_of_players:
		if player.id == id:
			list_of_players.erase(player)
			player.remove.rpc()
			break
	if multiplayer.is_server():
		DisplayServer.window_set_title(str("HOST Connections: ", list_of_players.size()))

func join():
	print("IP: ", IP_ADDRESS)
	peer = WebSocketMultiplayerPeer.new()
	#var client_trusted_cas = load("res://generated.crt")
	#var client_tls_options = TLSOptions.client(client_trusted_cas)
	peer.create_client(IP_ADDRESS)#, client_tls_options)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(func(): print("Connection failed"))
	multiplayer.server_disconnected.connect(func(): print("Server disconnected"))
	connected.emit()

func connected_to_server():
	DisplayServer.window_set_title(str("JOIN: Player ", multiplayer.get_unique_id()))
	var random_position: Vector3 = Vector3(randf_range(30.0, 40.0), 10.0, randf_range(30.0, 40.0))
	send_setup.rpc_id(1, {"position": random_position})

@rpc("any_peer", "reliable", "call_local")
func send_setup(data: Dictionary):
	var sender_id = multiplayer.get_remote_sender_id()
	add_client(sender_id, data)
	for player in list_of_players:
		remote_add_client.rpc_id(sender_id, player.id, player.data)
		if not player.id == 1 and not player.id == sender_id:
			remote_add_client.rpc_id(player.id, sender_id, player.data)

func get_next_id() -> int:
	entities_spawned = entities_spawned + 1
	return entities_spawned
