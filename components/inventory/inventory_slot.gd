extends TextureButton
class_name InventorySlot

@export var inventory_item: ItemResource = null
@export var amount: int = 1
@onready var amount_label: Label = $MarginContainer/AmountLabel

func _ready() -> void:
	assert(amount <= inventory_item.max_stack, "Reduce the amount to below or equal the max stack")
	amount_label.text = str(amount)
	self.mouse_entered.connect(_mouse_entered)
	self.mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	Tooltip.set_tooltip(inventory_item)

func _mouse_exited():
	if (Tooltip.get_item() == inventory_item):
		Tooltip.set_tooltip(null)
