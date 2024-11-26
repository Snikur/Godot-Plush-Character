extends Node3D
class_name Inventory

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $CanvasLayer/PanelContainer/MarginContainer/GridContainer
@onready var parent: Player = get_parent()
@onready var combat: CombatComponent = parent.combat
const MAX_SLOTS: int = 16

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		var potion = preload("res://components/inventory/items/healing_potion.tres").duplicate()
		potion.sell_price = randi_range(0, 200)
		add_item(potion, randi_range(1, 5))
	if (Input.is_action_just_pressed("ui_text_submit")):
		var slots: Array[Node] = grid.get_children()
		if slots[0] is InventorySlot:
			for actions in slots[0].inventory_item.actions:
				actions.on_use(self)
			slots[0].queue_free()

func add_item(item: ItemResource, amount: int) -> bool:
	if (grid.get_child_count() >= MAX_SLOTS):
		return false
	var new_slot: InventorySlot = slot_scene.instantiate()
	new_slot.inventory_item = item
	new_slot.inventory = self
	new_slot.amount = amount
	grid.add_child(new_slot)
	return true
