extends Node3D

var quest: SearchQuest

func _ready() -> void:
	var anim: Animation = $AnimationPlayer.get_animation("SilverPirateCoint|PirateCoinAction")
	anim.loop_mode = Animation.LOOP_LINEAR
	$Area3D.body_entered.connect(func(body: Node3D):
		if (body is Player and body.id == multiplayer.get_unique_id()):
			print("collected coin")
			Achievements.modifyAchievements("collect_coin", true)
			quest.reached_goal()
			queue_free()
		)
