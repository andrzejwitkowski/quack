extends FireBahavior

class_name ThrowableFire

@export_category("Scene")
@export var throwable_scene: PackedScene


@export_category("Force")
@export var throw_force: float = 15.0
@export var angular_impulse: Vector3 = Vector3.ZERO

@export_category("Collision")
@export_flags_3d_physics var instant_explode_collision_mask: int = 0
@export_flags_3d_physics var physics_collision_mask: int = 0


func fire(parent: Node3D, muzzle_trfm: Transform3D) -> void:
	var tb: ThrowableBase = throwable_scene.instantiate()
	tb.global_transform = muzzle_trfm
	tb.init(
		throw_force,
		angular_impulse,
		damage,
		damage_collision_mask,
		instant_explode_collision_mask,
		physics_collision_mask
	)
	parent.get_tree().current_scene.add_child(tb)
	
