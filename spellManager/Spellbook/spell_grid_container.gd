extends GridContainer

@onready var spell_icon: TextureRect = %SpellIcon
@onready var spell_name: Label = %SpellName
@onready var spell_cooldown: Label = %SpellCooldown
@onready var spell_description: RichTextLabel = %SpellDescription

const GridButton = preload("res://spellManager/Spellbook/spell_grid_button.tscn")

var spells: Array[SpellResource]
var selected_spell_index: int = 0

func add_spell(new_spell: SpellResource) -> void:
	var new_position: int = spells.size()
	spells.append(new_spell)

	var tb: TextureButton = GridButton.instantiate()
	tb.texture_normal = new_spell.texture
	tb.set_position_in_grid(new_position)
	tb.set_grid_container(self)
	self.add_child(tb)

func set_active_spell(spell_index: int) -> void:
	selected_spell_index = spell_index
	if selected_spell_index >= spells.size():
		selected_spell_index = 0

	spell_icon.texture = spells[selected_spell_index].texture
	spell_name.text = spells[selected_spell_index].name
	spell_description.text = spells[selected_spell_index].description
	spell_cooldown.text = "Cooldown: " + str(spells[selected_spell_index].cooldown)
