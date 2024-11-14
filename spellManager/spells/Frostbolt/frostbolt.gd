extends Skill
class_name Frostbolt

func _init(target):
	cooldown = 3.0
	texture = preload("res://spellManager/spells/Frostbolt/Coldflake.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	print("frostbolt brrrrr")
