extends ItemOnUse
class_name ItemOnUseChangeResource

enum TYPE {
	HEALTH,
	MANA,
	ENERGY,
	RAGE
}

@export var type: TYPE = TYPE.HEALTH
@export var effect_range: Vector2i = Vector2i(70, 90)

func on_use(inventory: Inventory):
	var player: Player = inventory.parent
	var combat: CombatComponent = player.combat
	var change = randi_range(effect_range.x, effect_range.y)
	combat.request_change.rpc_id(1, change)
