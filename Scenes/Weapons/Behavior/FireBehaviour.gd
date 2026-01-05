extends Resource

class_name FireBahavior

@export_category("Damage")
@export var damage: int = 20

@export_category("Collision")
@export_flags_3d_physics var damage_collision_mask: int = 0


func fire(parent: Node3D, muzzle_trfm: Transform3D) -> void:
	pass
