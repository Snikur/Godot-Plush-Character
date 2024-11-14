extends Spell
class_name Thunderblast

func _init(target):
	cooldown = 45.0
	texture = preload("res://spellManager/spells/Thunderblast/trallgard.png")
	
	super._init(target)
	
func cast_spell(target):	
	super.cast_spell(target)
	print("FOKKEN THONDERBLÆST")
