extends CanvasLayer

@onready var root: Control = $Control
@onready var panel: PanelContainer = $Control/PanelContainer

@onready var item_name: Label = %Title
@onready var item_level: Label = %ItemLevel
@onready var description: Label = %Description
@onready var max_stack: Label = %MaxStack
@onready var sell_price: RichTextLabel = %SellPrice

var item: ItemResource
var margin_offset: Vector2 = Vector2(24, 24)

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	root.position = mouse_pos - (panel.size / 2) - margin_offset

func set_tooltip(new_item: ItemResource) -> void:
	self.item = new_item
	if not item:
		visible = false
		return

	visible = true
	item_name.text = new_item.item_name
	item_level.text = str(new_item.item_level)
	description.text = new_item.description
	max_stack.text = str(new_item.max_stack)
	sell_price.text = get_sell_price(new_item.sell_price)

func get_item() -> ItemResource:
	return item

func get_sell_price(value: int) -> String:
	var copper: int = value % 100
	var silver: int = floori(value / 100.0) % 100
	var gold: int = floori(value / 10000.0)

	if gold > 0:
		return "Sell Price: %d [color=gold]gold[/color] %d [color=silver]silver[/color] %d [color=orange]copper[/color]" % [gold, silver, copper]
	elif silver > 0:
		return "Sell Price: %d [color=silver]silver[/color] %d [color=orange]copper[/color]" % [silver, copper]
	else:
		return "Sell Price: %d [color=orange]copper[/color]" % [copper]
