extends Node3D

@onready var parent: Player = get_parent()
@export var state_path: NodePath
@onready var state: AtomicState = get_node(state_path)

func _ready():
	state.state_physics_processing.connect(state_physics_process)

func state_physics_process(delta: float) -> void:
	print("on ground")
