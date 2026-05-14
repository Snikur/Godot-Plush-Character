class_name InventorySlot
extends TextureButton

var inventory: Inventory
var amount: int = 1

@export var inventory_item: ItemResource = null

@onready var amount_label: Label = $MarginContainer/AmountLabel

func _ready() -> void:
	assert(amount <= inventory_item.max_stack, "Reduce the amount to below or equal the max stack")
	amount_label.text = str(amount)
	self.mouse_entered.connect(_mouse_entered)
	self.mouse_exited.connect(_mouse_exited)

func _mouse_entered() -> void:
	Tooltip.set_tooltip(inventory_item)

func _mouse_exited() -> void:
	if Tooltip.get_item() == inventory_item:
		Tooltip.set_tooltip(null)
