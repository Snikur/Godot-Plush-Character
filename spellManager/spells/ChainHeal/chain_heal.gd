extends Spell
class_name ChainHeal

func _init(target):
	cooldown = 1.0
	texture = preload("res://spellManager/spells/ChainHeal/craftingmarissa.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
