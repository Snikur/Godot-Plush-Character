extends Node3D

@export var spell: SpellResource

func _ready() -> void:
	$Area3D.body_entered.connect(func(body: Node3D) -> void:
		if body is Player and body.id == multiplayer.get_unique_id():
			body.spell_manager.add_spell(spell)
			Achievements.modify_achievement(&"first_spell", true)
			queue_free()
		)
