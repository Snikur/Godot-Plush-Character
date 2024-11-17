extends PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", 0.8, 60.0).from(0.0)
	tween.tween_property(self, "progress_ratio", 1.0, 60.0).from(0.8).set_delay(10.0)
	tween.set_loops(0)
