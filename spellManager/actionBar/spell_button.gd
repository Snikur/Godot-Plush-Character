extends TextureButton
class_name SpellTextureButton

@onready var cooldown = $Cooldown
@onready var key = $Key
@onready var time = $Time
@onready var timer = $Timer

var spell: Spell = null

var change_key = "":
	set(value):
		change_key=value
		key.text = value
		
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
		
		shortcut.events = [input_key]
		
func _ready():
	change_key = "1"
	cooldown.max_value  = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	self.pressed.connect(_on_pressed)
	set_process(false)

func _process(_delta):
	time.text = str(int(ceil(timer.time_left)))
	cooldown.value = timer.time_left

@rpc("authority", "call_remote", "reliable")
func spawn_spell(type: int):
	print("spawn spell")

func _on_pressed():
	if spell != null:
		spell.cast_spell(owner)
		timer.start()
		disabled = true
		set_process(true)
		spawn_spell.rpc(spell.type)



func _on_timer_timeout():
	disabled = false
	time.text = ""
	cooldown.value = 0
	set_process(false)
