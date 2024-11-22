extends Area3D

@onready var anim: AnimationPlayer = $treasure_chest/AnimationPlayer
var is_open: bool = false
func _ready() -> void:
	body_entered.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			if (anim.is_playing()):
				return
			is_open != is_open
			anim.play("open" if is_open else "close")
	)
