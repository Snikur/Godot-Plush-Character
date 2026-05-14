@tool
extends Node

func _ready() -> void:
	if not Engine.is_editor_hint() and has_node(&"UI"):
		$UI.player = $Player
