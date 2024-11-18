extends HBoxContainer

var slots: Array

func init():
	slots = get_children()
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			slots[i].change_key = str(i+1)
		
	slots[0].spell = FireballSpell.new()
	slots[0].spell.init(slots[0])
	checkAndHideCharges(slots[0])
	
func add_spell(newSpell: Spell):
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			if slots[i].spell == null:
				slots[i].spell = newSpell
				slots[i].spell.init(slots[i])
				checkAndHideCharges(slots[i])
				break

func checkAndHideCharges(slot: SpellTextureButton):
	print(slot.spell.maxCharges)
	if slot.spell.maxCharges <= 1:
		slot.showCharges(false)
	else:
		slot.showCharges(true)
