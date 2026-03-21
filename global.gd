extends Node

signal fov_changed(new_value)
signal joystick_sensitivity_changed(new_value)
signal mouse_sensitivity_changed(new_value)

var _fov: int = 60
var _mouse_sensitivity: float = 0.005
var _joystick_sensitivity: float = 2.0

func set_fov(value: int):
	self._fov = value
	fov_changed.emit(_fov)

func get_fov() -> int:
	return _fov

func set_mouse_sensitivity(value: float):
	self._mouse_sensitivity = value
	mouse_sensitivity_changed.emit(_mouse_sensitivity)

func get_mouse_sensitivity() -> float:
	return _mouse_sensitivity

func set_joystick_sensitivity(value: float):
	self._joystick_sensitivity = value
	joystick_sensitivity_changed.emit(_joystick_sensitivity)

func get_joystick_sensitivity() -> float:
	return _joystick_sensitivity
