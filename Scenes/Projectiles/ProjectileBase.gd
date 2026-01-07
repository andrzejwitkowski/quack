extends Area3D

class_name ProjectileBase

@export var impact_pool_object: GameUtils.PoolObjectNames = GameUtils.PoolObjectNames.None
@onready var hit_sound: AudioStreamPlayer3D = $HitSound

var _damage = 0
var _velocity = Vector3.ZERO


func init(damage: int, speed: float, dir: Vector3) -> void:
	_damage = damage
	_velocity = dir.normalized() * speed

func _physics_process(delta: float) -> void:
	global_translate(_velocity * delta)
	

func blow_up() -> void:
	if GameUtils.ValidPoolObject(impact_pool_object):
		ObjectPool.activate(impact_pool_object, global_position)
	GameUtils.toggle_area3d(self, false, false)
	hide()
	set_physics_process(false)
	if hit_sound.stream:
		hit_sound.play()
		await hit_sound.finished
	queue_free()


func _on_area_entered(area: Area3D) -> void:
	blow_up()


func _on_body_entered(body: Node3D) -> void:
	blow_up()
