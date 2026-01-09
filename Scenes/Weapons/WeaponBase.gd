extends Node3D


class_name WeaponBase

const _730213__EMPTY_WEAPON = preload("res://Assets/Sounds/730213__empty weapon.wav")
const _159450__WEAPON_SWAP = preload("res://Assets/Sounds/159450__weapon_swap.wav")
const SWAP_TIME: float = 0.6

enum WeaponType { Grenade, Pistol, RocketLauncher, NailGun }

@export_group("General")
@export var weapon_type: WeaponType = WeaponType.Pistol

@export_group("Behaviour")
@export var fire_bahavior: FireBahavior
@export var fire_rate_ms = 500.0


@export_group("Ammo")
@export var start_ammo: int = 25
@export var max_ammo: int = 100

@onready var muzzle_flash: GPUParticles3D = $MuzzleFlash
@onready var muzzle: Node3D = $Muzzle
@onready var fire_sound: AudioStreamPlayer3D = $FireSound
@onready var activate_sound: AudioStreamPlayer3D = $ActivateSound

var _swapping: bool = false
var _current_ammo: int = 0
var _last_fire_time: float = 0

func _ready() -> void:
	_current_ammo = start_ammo

func fire() -> void:
	if _swapping: return
	
	if _current_ammo <= 0:
		play_empty()
		return
		
	if Time.get_ticks_msec() - fire_rate_ms < _last_fire_time:
		return
	
	_last_fire_time = Time.get_ticks_msec()
	fire_sound.play()
	fire_bahavior.fire(self, muzzle.global_transform)
	muzzle_flash.restart()
	_current_ammo -= 1


func switch_in() -> void:
	_swapping = true
	play_swap()
	show()
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", Vector3(360, 0, 0), SWAP_TIME - 0.1)
	await get_tree().create_timer(SWAP_TIME, false).timeout
	rotation_degrees = Vector3.ZERO
	_swapping = false
	
func switch_out() -> void:
	hide()
	
func play_swap() -> void:
	activate_sound.stream = _159450__WEAPON_SWAP
	activate_sound.play()
	
func play_empty() -> void:
	activate_sound.stream = _730213__EMPTY_WEAPON
	activate_sound.play()
