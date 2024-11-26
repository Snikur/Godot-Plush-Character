extends CombatComponent

@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar

func update_label():
	super.update_label()
	health_bar.max_value = max_health
	health_bar.value = health
	mana_bar.max_value = max_mana
	mana_bar.value = mana
