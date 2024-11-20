extends GridContainer

@onready var spellIcon = %SpellIcon
@onready var spellName = %SpellName
@onready var spellCooldown = %SpellCooldown
@onready var spellDescription = %SpellDescription

const GridButton = preload("res://spellManager/Spellbook/spell_grid_button.tscn")

var spells: Array[SpellResource]
var selectedSpellLocationInArray: int = 0

func add_spell(newSpell: SpellResource):
	var newPosition = spells.size()
	spells.append(newSpell)
	print(spells)
	var TB = GridButton.instantiate()
	TB.texture_normal = newSpell.texture
	TB.setPositionInGrid(newPosition)
	TB.setGridContainer(self)
	self.add_child(TB)

func set_active_spell(spellLocationInArray: int):
	selectedSpellLocationInArray = spellLocationInArray;
	if selectedSpellLocationInArray >= spells.size():	
		selectedSpellLocationInArray = 0;
	print(selectedSpellLocationInArray)
	spellIcon.texture = spells[selectedSpellLocationInArray].texture
	spellName.text = spells[selectedSpellLocationInArray].name
	spellDescription.text = spells[selectedSpellLocationInArray].description
	spellCooldown.text = "Cooldown: " + str(spells[selectedSpellLocationInArray].cooldown)
	
	
