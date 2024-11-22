extends Node3D

var is_open: bool = false
var tween: Tween

@onready var door = $Door
@onready var secret = $SecretEntered

func _ready() -> void:
	await MM.connected
	if (multiplayer.is_server()):
		$Area3D.area_entered.connect(func(body: Node3D):
			if (body is Projectile):
				toggle_door()
		)
	$SecretEntered.body_entered.connect(func(body: Node3D):
		if (body is Player):
			if (body.id == multiplayer.get_unique_id()):
				$SecretAudio.play()
			if (multiplayer.is_server()):
				body.teleport_to.rpc_id(body.id, body.global_position + Vector3.UP * 42.0)
	)

func toggle_door():
	is_open = !is_open
	if (is_open):
		if (tween):
			tween.kill()
		tween = create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(door, "position:z", 1.0, 1.0).from(0.0)
		tween.tween_property(door, "position:x", -2.0, 1.0).from(0.0)
		tween.parallel().tween_property(door, "rotation:z", PI, 1.0).from(0.0)
	else:
		print("lukk sesamfrø")
