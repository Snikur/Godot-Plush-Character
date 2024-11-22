extends Node3D

var is_open: bool = false
var tween: Tween

@onready var door = $Door

func _ready() -> void:
	$Area3D.area_entered.connect(func(body: Node3D):
		if (body is Projectile):
			toggle_door()
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
