extends Spell
class_name FireBall

func _init(target):
	cooldown = 5.0
	texture = preload("res://spellManager/spells/Fireball/flobo.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	print("fireball pew pew")
