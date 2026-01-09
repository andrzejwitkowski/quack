extends RigidBody3D

class_name ThrowableBase

@export var impact_pool_object: GameUtils.PoolObjectNames = GameUtils.PoolObjectNames.None

@onready var land_effect: AudioStreamPlayer3D = $LandEffect
@onready var damage_area: Area3D = $DamageArea
@onready var instant_explode: Area3D = $InstantExplode


var _impulse_force: float = 2.0
var _angular_impulse: Vector3 = Vector3.ONE
var _damage: int = 0
var _damage_collision_mask: int = 0
var _instant_explode_collision_mask: int = 0
var _physics_collision_mask: int = 0

func _ready() -> void:
	go()

func go() -> void:
	damage_area.collision_mask = _damage_collision_mask
	instant_explode.collision_mask = _instant_explode_collision_mask
	collision_mask = _physics_collision_mask
	apply_central_impulse(-global_transform.basis.z.normalized() * _impulse_force)
	apply_torque_impulse(_angular_impulse)


func init(p_impulse: float, p_angular: Vector3, 
			damage: int, damage_collision_mask: int, 
			instant_explode_collision_mask: int, physics_collision_mask: int) -> void:
	_impulse_force = p_impulse
	_angular_impulse = p_angular
	_damage = damage
	_damage_collision_mask = damage_collision_mask
	_instant_explode_collision_mask = instant_explode_collision_mask
	_physics_collision_mask = physics_collision_mask

func blow_up() -> void:
	ObjectPool.activate(impact_pool_object, global_position)
	GameUtils.toggle_area3d(damage_area, true, true)
	GameUtils.vanish_rigidbody(self)
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()

func _on_damage_area_area_entered(area: Area3D) -> void:
	print("_on_damage_area_area_entered: ", area.name)
	if area is HitBox: area.take_hit(_damage)


func _on_instant_explode_area_entered(area: Area3D) -> void:
	print("_on_instant_explode_area_entered: ", area.name)
	blow_up()

func _on_explode_timer_timeout() -> void:
	blow_up()


func _on_body_entered(body: Node) -> void:
	if !land_effect.playing: land_effect.play()
