extends Node3D
@onready var duration0: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Buffs/Slot/Duration
@onready var duration1: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Buffs/Slot2/Duration
@onready var duration2: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot/Duration
@onready var duration3: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot2/Duration
@onready var duration4: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot3/Duration
@onready var duration5: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot4/Duration

func _process(_delta: float) -> void:
	duration0.value = (duration0.value + 0.1) if duration0.value < 100 else 0
	duration1.value = duration1.value + 0.1 if duration1.value < 100 else 0
	duration2.value = duration2.value + 0.1 if duration2.value < 100 else 0
	duration3.value = duration3.value + 0.1 if duration3.value < 100 else 0
	duration4.value = duration4.value + 0.1 if duration4.value < 100 else 0
	duration5.value = duration5.value + 0.1 if duration5.value < 100 else 0
