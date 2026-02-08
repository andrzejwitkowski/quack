extends VBoxContainer

const NAIL_GUN = preload("res://Assets/Images/NailGun.png")
const PISTOL = preload("res://Assets/Images/Pistol.png")
const ROCKET_LAUNCHER = preload("res://Assets/Images/RocketLauncher.png")
const GRENADE_LAUNCHER = preload("res://Assets/Images/GrenadeLauncher.png")

@export var weapon_type: WeaponBase.WeaponType = WeaponBase.WeaponType.Pistol

@onready var image: TextureRect = $Image
@onready var ammo_label: Label = $AmmoLabel

func _ready() -> void:
	match weapon_type:
		WeaponBase.WeaponType.Grenade: image.texture = GRENADE_LAUNCHER
		WeaponBase.WeaponType.RocketLauncher: image.texture = ROCKET_LAUNCHER
		WeaponBase.WeaponType.Pistol: image.texture = PISTOL
		WeaponBase.WeaponType.NailGun: image.texture = NAIL_GUN

func _enter_tree() -> void:
	SignalHub.on_ammo_updated.connect(on_ammo_updated)

func on_ammo_updated(wt: WeaponBase.WeaponType, amount: int) -> void:
	print("ammo for " % wt)
	if wt == weapon_type:
		image.self_modulate = Color(1,1,1,1)
		ammo_label.show()
		ammo_label.text = str(amount)
