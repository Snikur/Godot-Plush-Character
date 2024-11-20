extends GridContainer

@onready var spellIcon = $"../../SpellInformation/SpellIcon"
@onready var spellName = $"../../SpellInformation/SpellName"
@onready var spellCooldown = $"../../SpellInformation/SpellCooldown"
@onready var spellDescription = $"../../SpellInformation/SpellDescription"

var spells: Array[SpellResource]
var selectedSpellLocationInArray: int = 0

func add_spell(newSpell: SpellResource):
	spells.append(newSpell)
	
	var TB = TextureButton.new()
	TB.texture_normal = newSpell.texture

	self.add_child(TB)

func set_active_spell(spellLocationInArray: int):
	selectedSpellLocationInArray = spellLocationInArray;
	if selectedSpellLocationInArray >= spells.size():	
		selectedSpellLocationInArray = 0;

	spellIcon.texture = spells[selectedSpellLocationInArray].texture
	spellName.text = spells[selectedSpellLocationInArray].name
	spellDescription.text = spells[selectedSpellLocationInArray].description
	spellCooldown.text = "Cooldown: " + str(spells[selectedSpellLocationInArray].cooldown)
	
	
