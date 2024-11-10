extends Control

@onready var main: VBoxContainer = $Main
@onready var quit_panel = $QuitPanel

@onready var join: Button = $Main/Join
@onready var host: Button = $Main/Host
@onready var exit: Button = $Main/Exit

@onready var exit_button = $QuitPanel/MarginContainer/VBoxContainer/HBoxContainer/ExitButton
@onready var cancel_button = $QuitPanel/MarginContainer/VBoxContainer/HBoxContainer/CancelButton


func _ready():
	exit.visible = not OS.has_feature("web")
	$Camera3D.fov = Global.get_fov()
	Global.fov_changed.connect(func(new_fov):
		$Camera3D.fov = new_fov
	)
	quit_panel.visible = false
	main.visible = true
	join.pressed.connect(join_server)
	host.pressed.connect(host_server)
	exit.pressed.connect(on_exit_pressed)
	exit_button.pressed.connect(func(): get_tree().quit())
	cancel_button.pressed.connect(func(): 
		main.visible = true
		quit_panel.visible = false
		)

func join_server():
	MM.join()
	visible = false

func host_server():
	MM.host()
	visible = false

func on_exit_pressed():
	main.visible = false
	quit_panel.visible = true
