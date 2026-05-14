extends Node3D

@onready var duration_0: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Buffs/Slot/Duration
@onready var duration_1: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Buffs/Slot2/Duration
@onready var duration_2: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot/Duration
@onready var duration_3: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot2/Duration
@onready var duration_4: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot3/Duration
@onready var duration_5: TextureProgressBar = $CanvasLayer/PanelContainer/MarginContainer/Stack/Debuffs/Slot4/Duration

func _process(_delta: float) -> void:
	duration_0.value = duration_0.value + 0.1 if duration_0.value < 100 else 0.0
	duration_1.value = duration_1.value + 0.1 if duration_1.value < 100 else 0.0
	duration_2.value = duration_2.value + 0.1 if duration_2.value < 100 else 0.0
	duration_3.value = duration_3.value + 0.1 if duration_3.value < 100 else 0.0
	duration_4.value = duration_4.value + 0.1 if duration_4.value < 100 else 0.0
	duration_5.value = duration_5.value + 0.1 if duration_5.value < 100 else 0.0
