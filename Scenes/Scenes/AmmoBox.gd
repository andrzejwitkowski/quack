extends Area3D

class_name AmmoBox

@export var ammo_type: WeaponBase.WeaponType = WeaponBase.WeaponType.Pistol
@export var amount: int = 40

@onready var rockets: Node3D = $Pivot/Rocket2
@onready var grenades: Node3D = $Pivot/Grenade
@onready var bullets: Node3D = $Pivot/Bullet2
@onready var nails: Node3D = $Pivot/AmmoBox2
@onready var pivot: Node3D = $Pivot

func _ready() -> void:
	for c in pivot.get_children(): c.hide()
	match ammo_type:
		WeaponBase.WeaponType.Pistol:
			bullets.show()
		WeaponBase.WeaponType.Grenade:
			grenades.show()
		WeaponBase.WeaponType.NailGun:
			nails.show()
		WeaponBase.WeaponType.RocketLauncher:
			rockets.show()




func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		print("Player picks up %s amount %d" % [
			WeaponBase.WeaponType.keys()[ammo_type],
			amount
		])
		if body.add_to_ammo(ammo_type, amount):
			SignalHub.emit_on_play_sound(GameUtils.SoundType.AmmoPickUp)
			queue_free()
