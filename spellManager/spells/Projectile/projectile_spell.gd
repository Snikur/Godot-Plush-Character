extends SpellResource
class_name ProjectileSpell

func init(button: SpellTextureButton):
	super.init(button)

func cast_spell(owner: SpellManager, index: int):
	var projectile: Projectile = spell_scene.instantiate()
	owner.add_child(projectile)
	projectile.top_level = true
	if (vfx_scene):
		var vfx = vfx_scene.instantiate()
		projectile.vfx.add_child.call_deferred(vfx)
	projectile.global_rotation.y = owner.source.godot_plush_skin.global_rotation.y
	projectile.global_position = owner.global_position + Vector3(0.0, 0.5, 0.0)
	projectile.name = str(index)
	if (owner.source.id == owner.multiplayer.get_unique_id()):
		super.cast_spell(owner, index)
