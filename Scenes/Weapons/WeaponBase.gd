extends Node3D


class_name WeaponBase


enum WeaponType { Grenade, Pistol, RocketLauncher, NailGun }

@export_group("General")
@export var weapon_type: WeaponType = WeaponType.Pistol

@export_group("Behaviour")
@export var fire_bahavior: FireBahavior

@onready var muzzle_flash: GPUParticles3D = $MuzzleFlash
@onready var muzzle: Node3D = $Muzzle
@onready var fire_sound: AudioStreamPlayer3D = $FireSound


func fire() -> void:
	fire_sound.play()
	fire_bahavior.fire(self, muzzle.global_transform)
	muzzle_flash.restart()
