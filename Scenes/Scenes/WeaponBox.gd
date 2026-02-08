extends Area3D


@export var weapon_type: WeaponBase.WeaponType = WeaponBase.WeaponType.Pistol


@onready var rocket_launcher_2: Node3D = $Pivot/RocketLauncher2
@onready var grenade_launcher_2: Node3D = $Pivot/GrenadeLauncher2
@onready var pistol_2: Node3D = $Pivot/Pistol2
@onready var nail_gun_2: Node3D = $Pivot/NailGun2
@onready var pivot: Node3D = $Pivot


func _ready() -> void:
	for c in pivot.get_children():
		c.hide()
	match weapon_type:
		WeaponBase.WeaponType.Pistol:
			pistol_2.show()
		WeaponBase.WeaponType.Grenade:
			grenade_launcher_2.show()
		WeaponBase.WeaponType.NailGun:
			nail_gun_2.show()
		WeaponBase.WeaponType.RocketLauncher:
			rocket_launcher_2.show()
			
			

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.activate_weapon(weapon_type)
		queue_free()
