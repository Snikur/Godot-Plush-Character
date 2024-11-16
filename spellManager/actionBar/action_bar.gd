extends HBoxContainer

var slots: Array

func _ready():
	slots = get_children()
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			slots[i].change_key = str(i+1)
		
	slots[0].spell = FireballSpell.new(slots[0])
	slots[1].spell = FrostboltSpell.new(slots[1])
	slots[2].spell = ChainHeal.new(slots[2])
	slots[3].spell = BlinkSpell.new(slots[3])
	slots[4].spell = Thunderblast.new(slots[4])
	
