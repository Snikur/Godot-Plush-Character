extends TextureButton
class_name SpellTextureButton

@onready var cooldown = $Cooldown
@onready var key = $Key
@onready var time = $Time
@onready var timer = $Timer
@onready var charges = $Charges


var spell: SpellResource = null

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
	cooldown.max_value = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	self.pressed.connect(_on_pressed)
	set_process(false)

func _process(_delta):
	time.text = str(int(ceil(timer.time_left)))
	cooldown.value = timer.time_left

func _on_pressed():
	if spell != null:
		if spell.isActivateSpell && !spell.isActivated:
			spell.activate_spell(owner)
		else:
			spell.cast_spell(owner, owner.get_next_spell_index())
			cooldown.value = cooldown.max_value
			timer.start()
			
			if (spell.charges <= 1 || spell.maxCharges <= 1):
				disabled = true
				
			if spell.maxCharges > 1:
				spell.charges -= 1
				charges.text = str(spell.charges)
			
			set_process(true)

func _on_timer_timeout():
	disabled = false
	time.text = ""
	cooldown.value = 0
	set_process(false)
	
	if spell.maxCharges > 1:
		if spell.charges < spell.maxCharges:
			spell.charges += 1
			charges.text = str(spell.charges)
			if spell.charges != spell.maxCharges:
				timer.start()
				set_process(true)
			

func showCharges(value: bool):
	charges.visible = value
