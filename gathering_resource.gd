extends StaticBody3D
class_name GatheringResource

@onready var interact_key: Sprite3D = $InteractKey
@export var loot: ItemResource
@export var amount: int = 2

func _ready() -> void:
	interact_key.visible = false
	mouse_entered.connect(func(): 
		print("mouseover")
		interact_key.visible = true
	)
	mouse_exited.connect(func(): 
		print("mouseexited")
		interact_key.visible = false
	)
	input_event.connect(_input_event)

func _input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_indx: int):
	if (event is InputEventMouseButton):
		print(event)

@rpc("any_peer", "call_remote", "reliable")
func interact(player: Player) -> void:
	if (player.id == multiplayer.get_unique_id()):
		player.inventory.add_item(loot, amount)
