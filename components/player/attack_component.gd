extends ShapeCast3D

@onready var swing_timer: Timer = $SwingTimer
@export var parent_node: NodePath = ""
var target: Enemy = null
var damage: int = 10

func _ready() -> void:
	swing_timer.timeout.connect(swing)
	if (not parent_node.is_empty()):
		add_exception(get_node(parent_node))

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var collider = get_collider(0) #TODO: check if 1 collider is enough, odd-case might require a few more
		if (collider is Enemy):
			target = collider
			swing_timer.paused = false
			if (swing_timer.is_stopped()):
				swing_timer.start()
		else:
			target = null
			swing_timer.paused = true
	else:
		target = null
		swing_timer.paused = true

func swing():
	print("Swing")
	if target:
		target.change_health(-damage)
