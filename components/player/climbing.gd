extends Node3D

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	if not parent.is_on_floor():
		parent.velocity = Vector3(0.0, 10.0 if Input.is_action_pressed("up") else -10.0 if Input.is_action_pressed("down") else 0.0, 0.0)
		if Input.is_action_just_pressed("jump"):
			parent.state_chart.send_event("to_ground")
		parent.move_and_slide()
	else:
		parent.state_chart.send_event("to_ground")
