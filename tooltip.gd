extends CanvasLayer

@onready var root: Control = $Control
@onready var panel: PanelContainer = $Control/PanelContainer

@onready var item_name = %Title
@onready var item_level = %ItemLevel
@onready var description = %Description
@onready var max_stack = %MaxStack
@onready var sell_price: RichTextLabel = %SellPrice
var item: ItemResource

var margin_offset: Vector2 = Vector2(24, 24)

func _ready():
	visible = false

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size: Vector2 = get_viewport().size
	root.position = mouse_pos - (panel.size / 2) - margin_offset #TODO: Check which quadrant the mouse is within, currently works for bottom-right

func set_tooltip(new_item: ItemResource):
	self.item = new_item
	if (not item):
		visible = false
		return
	visible = true
	self.item_name = new_item.item_name
	self.item_level = new_item.item_level
	self.description = new_item.description
	self.max_stack = new_item.max_stack
	self.sell_price.text = get_sell_price(new_item.sell_price)

func get_item() -> ItemResource:
	return item

func get_sell_price(value: int) -> String:
	var formated_string = "Sell Price: %d [color=gold]gold[/color] %d [color=silver]silver[/color] %d [color=orange]copper[/color]"
	var copper = 0
	var silver = 0
	var gold = 0
	if (value > 0):
		copper = value % 100
		value = value / 100
	if (value > 0):
		silver = value % 100
		value = value / 100
	if (value > 0):
		gold = value
	if (gold > 0):
		return formated_string % [gold, silver, copper]
	elif (silver > 0):
		formated_string = "Sell Price: %d [color=silver]silver[/color] %d [color=orange]copper[/color]"
		return formated_string % [silver, copper]
	formated_string = "Sell Price: %d [color=orange]copper[/color]"
	return formated_string % [copper]
