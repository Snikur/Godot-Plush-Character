extends ShapeCast3D

@onready var swing_timer: Timer = $SwingTimer
@onready var spell_manager: SpellManager = $SpellManager
@export var parent_node: NodePath = ""
var damage: int = 10

func _ready() -> void:
	swing_timer.timeout.connect(swing)
	if (not parent_node.is_empty()):
		var player_node = get_node(parent_node)
		add_exception(player_node)
		spell_manager.source = player_node

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var collider = get_collider(0) #TODO: check if 1 collider is enough, odd-case might require a few more
		if (collider is Enemy):
			spell_manager.target = collider
			swing_timer.paused = false
			if (swing_timer.is_stopped()):
				swing_timer.start()
		else:
			spell_manager.target = null
			swing_timer.paused = true
	else:
		spell_manager.target = null
		swing_timer.paused = true

func swing():
	var distance = (spell_manager.target.global_position - self.global_position).length()
	if spell_manager.target:
		spell_manager.target.combat.request_change.rpc_id(1, -damage)
