class_name GameUtils


enum SoundType { AmmoPickUp, HealthBoost }


enum PoolObjectNames {
	None,
	GrenadeExplosion,
	RocketImpact,
}


static func ValidPoolObject(n: PoolObjectNames): return n != PoolObjectNames.None


static func vanish_rigidbody(rb: RigidBody3D) -> void:
	rb.collision_layer = 0
	rb.collision_mask = 0
	rb.visible = false
	rb.constant_force = Vector3.ZERO
	rb.linear_velocity = Vector3.ZERO


static func toggle_area3d(area: Area3D, monitoring: bool, monitorable: bool) -> void:
	area.set_deferred("monitoring", monitoring)
	area.set_deferred("monitorable", monitorable)
