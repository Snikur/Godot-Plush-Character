extends StaticBody3D
class_name Enemy

@onready var status_label: Label3D = $Status
var max_health: int = 100
var health: int = 100:
	get:
		return health
	set(value):
		health = value
		status_label.text = "HP: " + str(health) + "/" + str(max_health)

func change_health(value: int):
	print("changed health: ", value)
	health = max(min(health+value, max_health), 0)
	if health == 0:
		health = max_health
