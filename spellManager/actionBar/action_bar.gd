extends HBoxContainer

@export var default_spells: Array[SpellResource]
@onready var spellbook_grid: GridContainer = %SpellGridContainer

var slots: Array[Node]

func _ready() -> void:
	init.call_deferred()

func init() -> void:
	slots = get_children()
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			slots[i].change_key = str(i + 1)

	for i in default_spells.size():
		slots[i].spell = default_spells[i]
		slots[i].spell.init(slots[i] as SpellTextureButton)
		spellbook_grid.add_spell(default_spells[i])

func add_spell(new_spell: SpellResource) -> void:
	for i in slots.size():
		if slots[i] is SpellTextureButton:
			if slots[i].spell == null:
				slots[i].spell = new_spell
				slots[i].spell.init(slots[i] as SpellTextureButton)
				spellbook_grid.add_spell(new_spell)
				break
