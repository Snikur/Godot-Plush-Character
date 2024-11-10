extends RayCast3D

@onready var swing_timer: Timer = $SwingTimer
var target: Enemy = null
var damage: int = 10

func _ready() -> void:
	swing_timer.timeout.connect(swing)

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if (collider is Enemy):
			target = collider
			swing_timer.start()
		else:
			target = null

func swing():
	if target:
		target.change_health(-damage)
