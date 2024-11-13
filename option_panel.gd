extends PanelContainer

@onready var fov_slider: HSlider = $MarginContainer/VBox/Menu/FoVSlider
@onready var mouse_slider: HSlider = $MarginContainer/VBox/Menu/MouseSlider
@onready var joystick_slider: HSlider = $MarginContainer/VBox/Menu/JioystickSlider
@onready var fov_label: Label = $MarginContainer/VBox/Menu/FoV
@onready var mouse_label: Label = $MarginContainer/VBox/Menu/MouseSens
@onready var joystick_label: Label = $MarginContainer/VBox/Menu/JoystickSens

@onready var hide_button: Button = $MarginContainer/VBox/Hide
@onready var menu: VBoxContainer = $MarginContainer/VBox/Menu

func _ready() -> void:
	hide_button.pressed.connect(func():
		menu.visible = !menu.visible
		hide_button.text = "Hide" if menu.visible else "Show"
	)
	
	fov_label.text = "Field of View: " + str(Global.get_fov())
	mouse_label.text = "Mouse sensitivity: " + str(Global.get_mouse_sensitivity())
	joystick_label.text = "Joystick sensitivity: " + str(Global.get_joystick_sensitivity())
	
	fov_slider.drag_ended.connect(func(value_changed: bool):
		if (value_changed):
			Global.set_fov(int(fov_slider.value))
			fov_label.text = "Field of View: " + str(fov_slider.value)
		)
	mouse_slider.drag_ended.connect(func(value_changed: bool):
		if (value_changed):
			Global.set_mouse_sensitivity(mouse_slider.value)
			mouse_label.text = "Mouse sensitivity: " + str(mouse_slider.value)
		)
	joystick_slider.drag_ended.connect(func(value_changed: bool):
		if (value_changed):
			Global.set_joystick_sensitivity(joystick_slider.value)
			joystick_label.text = "Joystick sensitivity: " + str(joystick_slider.value)
		)
