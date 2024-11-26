extends HBoxContainer

@export var default_spells: Array[SpellResource]
@onready var spellbook_grid = %SpellGridContainer

var slots: Array

func _ready():
	init.call_deferred()

func init():
	slots = get_children()
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			slots[i].change_key = str(i+1)
	
	for i in default_spells.size():
		slots[i].spell = default_spells[i]
		slots[i].spell.init(slots[i])
		spellbook_grid.add_spell(default_spells[i])
	
func add_spell(newSpell: SpellResource):
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			if slots[i].spell == null:
				slots[i].spell = newSpell
				slots[i].spell.init(slots[i])
				spellbook_grid.add_spell(newSpell)
				break
