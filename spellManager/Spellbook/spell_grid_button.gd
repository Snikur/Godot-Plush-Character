extends TextureButton

var positionInGrid: int
var gridContainer: GridContainer

func _ready():
	pressed.connect(_on_pressed)

func setPositionInGrid(position: int):
	positionInGrid = position
	
func getPositionInGrid():
	return positionInGrid
	
func setGridContainer(grid: GridContainer):
	gridContainer = grid

func _on_pressed():
	gridContainer.set_active_spell(positionInGrid)
