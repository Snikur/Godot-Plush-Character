extends Resource
class_name Skill

var cooldown : float
var texture : Texture2D

func _init(target):
	target.cooldown.max_value = cooldown
	target.texture_normal = texture
	target.timer.wait_time = cooldown

func cast_spell(target):
	pass
