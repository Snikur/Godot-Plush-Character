extends TextureButton

var position_in_grid: int
var grid_container: GridContainer

func _ready():
	pressed.connect(_on_pressed)

func set_position_in_grid(new_position: int):
	position_in_grid = new_position
	
func get_position_in_grid():
	return position_in_grid
	
func set_grid_container(grid: GridContainer):
	grid_container = grid

func _on_pressed():
	grid_container.set_active_spell(position_in_grid)
