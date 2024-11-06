extends Node3D

func _ready() -> void:
	var anim: Animation = $AnimationPlayer.get_animation("SilverPirateCoint|PirateCoinAction")
	anim.loop_mode = Animation.LOOP_LINEAR
	$Area3D.body_entered.connect(func(body: Node3D):
		print("collected coin")
		queue_free()
		)
