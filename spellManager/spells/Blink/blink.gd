extends SpellResource
class_name BlinkSpell

func init(button: SpellTextureButton):
	cooldown = 3.0
	maxCharges = 2
	name = "Blink"
	description = "Instantly teleport 30 chimichangas."
	texture = preload("res://spellManager/spells/Blink/snaik.png")
	super.init(button)

func cast_spell(owner: SpellManager, index: int):
	super.cast_spell(owner, index)
	if is_instance_valid(owner.source):
		var target = owner.source.global_position + owner.source.godot_plush_skin.global_basis.z * 30.0
		var shape_cast: ShapeCast3D = ShapeCast3D.new()
		owner.source.godot_plush_skin.add_child(shape_cast)
		shape_cast.add_exception(owner.source)
		shape_cast.shape = SphereShape3D.new()
		shape_cast.collide_with_areas = true
		shape_cast.position = Vector3(0.0, 1.0, 0.0)
		shape_cast.target_position = Vector3(0.0, 0.0, 30.0)
		shape_cast.force_shapecast_update()
		if (shape_cast.is_colliding()):
			owner.source.global_position = shape_cast.get_collision_point(0) - owner.source.godot_plush_skin.global_basis.z
		else:
			owner.source.global_position = target
		shape_cast.queue_free()
	else:
		print("no owner target on blinkspell")
