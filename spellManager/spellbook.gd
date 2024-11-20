extends Panel

@onready var spellGridContainer = $ScrollContainer/SpellGridContainer
func _ready():
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("spellbook_menu"):
		self.visible = !self.visible
		if self.visible:
			spellGridContainer.set_active_spell(0)
