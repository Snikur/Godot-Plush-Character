extends HBoxContainer

var slots: Array

func _ready():
	slots = get_children()
	for i in get_child_count():
		slots[i].change_key = str(i+1)
		
	slots[0].skill = FireBall.new(slots[0])
	slots[1].skill = Frostbolt.new(slots[1])
	slots[2].skill = ChainHeal.new(slots[2])
	slots[3].skill = Sneak.new(slots[3])
	slots[4].skill = Thunderblast.new(slots[4])
	
