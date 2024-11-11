extends SpringArm3D

var active : bool = true : set = set_active

var min_limit_x : float = -PI/2.0
var max_limit_x : float = PI/2.0
var zoom_maximum: float = 7.0
var zoom_minimum: float = 2.0
var zoom_sensitivity: float = 10.0
var mouse_sensitivity: float
var joystick_sensitivity: float

func _ready():
	mouse_sensitivity = Global.get_mouse_sensitivity()
	Global.mouse_sensitivity_changed.connect(func(new_sens):
		mouse_sensitivity = new_sens
	)
	joystick_sensitivity = Global.get_joystick_sensitivity()
	Global.joystick_sensitivity_changed.connect(func(new_sens):
		joystick_sensitivity = new_sens
	)
	set_active(active)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton && event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func set_active(state : bool):
	active = state
	set_process_input(active)
	set_process(active)

func _input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	if event is InputEventMouseMotion: 
		rotate_from_vector(event.relative * mouse_sensitivity)

func _process(delta):
	var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	rotate_from_vector(joy_dir * joystick_sensitivity * delta)
	var zoom_input = int(Input.is_action_just_released("zoom_camera_out")) - int(Input.is_action_just_released("zoom_camera_in"))
	spring_length += zoom_input * delta * zoom_sensitivity
	spring_length = clamp(spring_length, zoom_minimum, zoom_maximum)

func rotate_from_vector(v : Vector2):
	if v.length() == 0: return
	rotation.y -= v.x
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
