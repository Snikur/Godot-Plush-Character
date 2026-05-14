extends Camera3D

@onready var line: Node3D = get_node(^"../../LineRenderer3D")
@onready var orbit: Node3D = get_node(^"../../Orbit")

var mouse_down: bool = false
var orbit_speed: float = 0.5
var orbit_dir: int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if orbit_dir == 0:
		orbit.rotate(Vector3(0, 1, 0), delta * orbit_speed)
	elif orbit_dir == 1:
		orbit.rotate(Vector3(0, 1, 0), -delta * orbit_speed)
	if orbit_dir == 2:
		orbit.rotate(Vector3(1, 0, 0), delta * orbit_speed)
	if orbit_dir == 3:
		orbit.rotate(Vector3(1, 0, 0), -delta * orbit_speed)

	if Input.is_action_just_pressed(&"ui_up"):
		orbit_dir = 3
	if Input.is_action_just_pressed(&"ui_down"):
		orbit_dir = 2
	if Input.is_action_just_pressed(&"ui_left"):
		orbit_dir = 1
	if Input.is_action_just_pressed(&"ui_right"):
		orbit_dir = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			var pick_length: float = 1
			var mouse_pos: Vector2 = event.position
			var from: Vector3 = project_ray_origin(mouse_pos)
			var to: Vector3 = from + project_ray_normal(mouse_pos) * pick_length

			line.points.append(to)
