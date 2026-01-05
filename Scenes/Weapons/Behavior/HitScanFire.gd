extends FireBahavior

class_name HitscanFire


@export var collision_bodies: bool = true
@export var collision_areas: bool = true
@export var max_distance: float = 200.0


func fire(parent: Node3D, muzzle_trfm: Transform3D) -> void:
	var space: PhysicsDirectSpaceState3D = parent.get_world_3d().direct_space_state
	var from: Vector3 = muzzle_trfm.origin
	var to: Vector3 = from + muzzle_trfm.basis.z * -max_distance
	
	var ray_cast_params: PhysicsRayQueryParameters3D =\
		PhysicsRayQueryParameters3D.create(from, to, damage_collision_mask)
	ray_cast_params.collide_with_areas = collision_areas
	ray_cast_params.collide_with_bodies = collision_bodies
	var hit: Dictionary = space.intersect_ray(ray_cast_params)
	if hit:
		var collider = hit.collider
		SignalHub.emit_on_hitscan_hit()
		print("Ray collided with %s at %s" % [collider.name, hit.position])
