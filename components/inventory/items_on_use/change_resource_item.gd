class_name ItemOnUseChangeResource
extends ItemOnUse

enum Type {
	HEALTH,
	MANA,
	ENERGY,
	RAGE
}

@export var type: Type = Type.HEALTH
@export var effect_range: Vector2i = Vector2i(70, 90)

func on_use(inventory: Inventory) -> void:
	var player: Player = inventory.parent
	var combat: CombatComponent = player.combat
	var change: int = randi_range(effect_range.x, effect_range.y)
	combat.request_change.rpc_id(1, change)
