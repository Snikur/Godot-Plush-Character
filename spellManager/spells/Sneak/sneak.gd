extends Spell
class_name Sneak

func _init(target):
	cooldown = 30.0
	texture = preload("res://spellManager/spells/Sneak/snaik.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	print("Sneaky mcsneak DSHHHHHHHH")
