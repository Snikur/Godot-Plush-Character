class_name SpellTextureButton
extends TextureButton

@onready var cooldown: TextureProgressBar = $Cooldown
@onready var key: Label = $Key
@onready var time: Label = $Time
@onready var timer: Timer = $Timer
@onready var charges: Label = $Charges
@onready var owner: SpellManager = get_node("../../..")

var spell: SpellResource = null

var change_key: String = "":
	set(value):
		change_key = value
		key.text = value

		shortcut = Shortcut.new()
		var input_key: InputEventKey = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)

		shortcut.events = [input_key]

func _ready() -> void:
	change_key = "1"
	cooldown.max_value = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	self.pressed.connect(_on_pressed)
	set_process(false)

func _process(_delta: float) -> void:
	time.text = str(int(ceil(timer.time_left)))
	cooldown.value = timer.time_left

func _on_pressed() -> void:
	if spell == null:
		return
	if spell.is_activate_spell and not spell.is_activated:
		spell.activate_spell(owner)
	else:
		spell.cast_spell(owner, owner.get_next_spell_index())
		cooldown.value = cooldown.max_value
		timer.start()

		if spell.charges <= 1 or spell.max_charges <= 1:
			disabled = true

		if spell.max_charges > 1:
			spell.charges -= 1
			charges.text = str(spell.charges)

		set_process(true)

func _on_timer_timeout() -> void:
	disabled = false
	time.text = ""
	cooldown.value = 0
	set_process(false)

	if spell.max_charges > 1:
		if spell.charges < spell.max_charges:
			spell.charges += 1
			charges.text = str(spell.charges)
			if spell.charges != spell.max_charges:
				timer.start()
				set_process(true)

func show_charges(value: bool) -> void:
	charges.visible = value
