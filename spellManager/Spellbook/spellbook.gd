extends PanelContainer

@onready var spellGridContainer = %SpellGridContainer
func _ready():
	self.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("spellbook_menu")):
		self.visible = !self.visible
		if self.visible:
			spellGridContainer.set_active_spell(0)
