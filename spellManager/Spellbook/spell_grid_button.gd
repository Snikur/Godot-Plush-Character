extends TextureButton

var position_in_grid: int
var grid_container: GridContainer

func _ready() -> void:
	pressed.connect(_on_pressed)

func set_position_in_grid(new_position: int) -> void:
	position_in_grid = new_position

func get_position_in_grid() -> int:
	return position_in_grid

func set_grid_container(grid: GridContainer) -> void:
	grid_container = grid

func _on_pressed() -> void:
	grid_container.set_active_spell(position_in_grid)
