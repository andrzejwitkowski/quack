extends FireBahavior

class_name ProjectileFire

@export_group("Scene")
@export var projectile_scene: PackedScene

@export_group("Settings")
@export var speed := 60.0


func fire(parent: Node3D, muzzle_trnsf: Transform3D) -> void:
	var p: ProjectileBase = projectile_scene.instantiate()
	p.global_transform = muzzle_trnsf
	p.collision_mask = damage_collision_mask
	p.init(damage, speed, muzzle_trnsf.basis.z * -1.0)
	parent.get_tree().current_scene.add_child(p)
