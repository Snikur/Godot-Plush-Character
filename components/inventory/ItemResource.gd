extends Resource
class_name ItemResource

enum Rarity {
	UNCOMMON,
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

@export var icon: Texture = null
@export var rarity: Rarity = Rarity.UNCOMMON
@export var item_name: String = "Minor Healing Potion"
@export var item_level: int = 5
@export var description: String = "Use: Restores 70 to 90 health. (2 Min Cooldown)"
@export var cooldown: int = 120
@export var max_stack: int = 5
@export var sell_price: int = 10507

func on_use() -> void:
	pass
