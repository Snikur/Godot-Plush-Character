extends CombatComponent

@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var experience_bar: ProgressBar = $CanvasLayer/HBoxContainer/ExperienceBar
@onready var level_label: Label = $CanvasLayer/HBoxContainer/Level

func update_label():
	super.update_label()
	health_bar.max_value = max_health
	health_bar.value = health
	mana_bar.max_value = max_mana
	mana_bar.value = mana
	
	level_label.text = "Level " + str(level)
	experience_bar.value = experience
	experience_bar.max_value = required_experience
