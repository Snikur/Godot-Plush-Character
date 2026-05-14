extends PanelContainer

@onready var spell_grid_container: GridContainer = %SpellGridContainer

func _ready() -> void:
	self.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"spellbook_menu"):
		self.visible = not self.visible
		if self.visible:
			spell_grid_container.set_active_spell(0)
