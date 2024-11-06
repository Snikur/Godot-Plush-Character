extends Control

@onready var join: Button = $VBoxContainer/Join
@onready var host: Button = $VBoxContainer/Host
@onready var exit: Button = $VBoxContainer/Exit
@onready var panel = $Panel
@onready var exit_button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/ExitButton
@onready var cancel_button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/CancelButton


func _ready():
	panel.visible = false
	join.pressed.connect(join_server)
	host.pressed.connect(host_server)
	exit.pressed.connect(on_exit_pressed)
	exit_button.pressed.connect(func(): get_tree().quit())
	cancel_button.pressed.connect(func(): panel.visible = false)

func join_server():
	MM.join()
	visible = false

func host_server():
	MM.host()
	visible = false

func on_exit_pressed():
	panel.visible = true
