extends Area3D

@onready var anim: AnimationPlayer = $chest/AnimationPlayer
@onready var particles: GPUParticles3D = $GPUParticles3D
var is_open: bool = false
func _ready() -> void:
	particles.emitting = is_open
	body_entered.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			if (anim.is_playing()):
				return
			is_open = not is_open
			if (is_open):
				anim.play("Armature|ArmatureAction")
			else:
				anim.play_backwards("Armature|ArmatureAction")
			particles.emitting = is_open
	)
