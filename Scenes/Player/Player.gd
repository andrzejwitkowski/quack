extends CharacterBody3D


class_name Player


const GROUP_NAME: String = "Player"


@export var speed = 5.0
@export var jump_speed = 15
@export var sensitivity: float = 0.0012
@export var gravity: float = -30.0


const CONCRETE_FOOTSTEPS_LOOP = preload("res://assets/Sounds/concrete-footsteps-6752.wav")
const CONCRETE_FOOTSTEPS_STOP = preload("res://assets/Sounds/concrete-footsteps-stop.wav")
const JUMP_SOUND = preload("res://assets/Sounds/667297_jump_05.wav")
const _469567__PLAYER_DIE = preload("res://assets/Sounds/469567__PlayerDie.wav")


@onready var walking_sound: AudioStreamPlayer3D = $WalkingSound
@onready var landing_sound: AudioStreamPlayer3D = $LandingSound
@onready var pains: AudioStreamPlayer3D = $Pains
@onready var hit_box: HitBox = $HitBox
@onready var camera_3d: Node3D = $Camera3D
@onready var pistol: WeaponBase = $Camera3D/GunHolder/Pistol
@onready var rocket_launcher: WeaponBase = $Camera3D/GunHolder/RocketLauncher
@onready var nail_gun: WeaponBase = $Camera3D/GunHolder/NailGun
@onready var grenade_luncher: WeaponBase = $Camera3D/GunHolder/GrenadeLuncher


var _was_moving: bool = false
var _was_on_floor: bool = false
var _look_delta: Vector2 = Vector2.ZERO
var _current_weapon: WeaponBase = null
var _collected_weapons: Array[WeaponBase] = []
var _current_weapon_index = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_delta = event.relative
		
	if event.is_action_pressed("shoot") and _current_weapon:
		_current_weapon.fire()
		
	if event.is_action_pressed("next_weapon"):
		switch_weapon(1)
	if event.is_action_pressed("prev_weapon"):
		switch_weapon(-1)
		

#region Setup
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	_collected_weapons.append(pistol)
	#_collected_weapons.append(rocket_launcher)
	#_collected_weapons.append(grenade_luncher)
	#_collected_weapons.append(nail_gun)
	
	await get_tree().process_frame
	set_current_weapon(0)

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
	SignalHub.on_player_shot.connect(on_player_shot)
	SignalHub.on_player_health_bonus.connect(on_player_health_bonus)

#endregion


#region Movement
func _physics_process(delta: float) -> void:
	handle_rotation()
	handle_gravity_and_jump(delta)
	handle_sounds()
	handle_movement(delta)	
	
	
func handle_rotation() -> void:
	rotate_y(-_look_delta.x * sensitivity)
	camera_3d.rotate_x(-_look_delta.y * sensitivity)
	camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-50), deg_to_rad(50))
	_look_delta = Vector2.ZERO
	
func handle_movement(delta: float) -> void:
	
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "back")
	var direction: Vector3 = (
		transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 6)
		velocity.z = lerp(velocity.z, 0.0, delta * 6)
	
	move_and_slide()
	
func handle_gravity_and_jump(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed 
	
#endregion

#region Sounds

func handle_sounds() -> void:
	var is_moving = is_on_floor() and velocity.length() > 0.5
	
	play_sounds(is_moving)
	
	_was_moving = is_moving
	_was_on_floor = is_on_floor()
	
func play_sounds(is_moving: bool) -> void:
	if !_was_on_floor and is_on_floor():
		landing_sound.play()
		if is_moving:
			play_footsteps()
	elif _was_on_floor and !is_on_floor():
		play_jump_sound()
	elif is_moving != _was_moving:
		if is_moving:
			play_footsteps()
		else:
			play_stop_sound()
		
	pass

func play_footsteps() -> void:
	walking_sound.stream = CONCRETE_FOOTSTEPS_LOOP
	walking_sound.play()


func play_stop_sound():
	walking_sound.stop()
	walking_sound.stream = CONCRETE_FOOTSTEPS_STOP
	walking_sound.play()


func play_jump_sound():
	walking_sound.stop()
	walking_sound.stream = JUMP_SOUND
	walking_sound.play()
#endregion

#region Weapons

func set_current_weapon(index: int) -> void:
	if _collected_weapons.is_empty():
		return
	
	if _current_weapon: _current_weapon.switch_out()
	
	_current_weapon_index = index % _collected_weapons.size()
	
	if _current_weapon_index < 0:
		_current_weapon_index = _collected_weapons.size() - 1
		
	_current_weapon = _collected_weapons[_current_weapon_index]
	_current_weapon.switch_in()
	
func switch_weapon(switch_direction: int) -> void:
	if _collected_weapons.is_empty():
		return
	set_current_weapon(_current_weapon_index + switch_direction)
	
#endregion


func on_player_shot(dmg: int, accuracy: float):
	if randf() < accuracy:
		hit_box.take_hit(dmg)

func _on_hit_box_hit(damage_taken: int) -> void:
	pains.play()
	SignalHub.emit_on_player_health_changed(hit_box._current_health)


func _on_hit_box_died() -> void:
	pains.stop()
	pains.stream = _469567__PLAYER_DIE
	pains.play()
	set_physics_process(false)
	
func on_player_health_bonus(amount: int) -> void:
	SignalHub.emit_on_play_sound(GameUtils.SoundType.HealthBoost)
	hit_box.give_bonus(amount)

func activate_weapon(wt: WeaponBase.WeaponType) -> void:
	for w in _collected_weapons:
		if w.weapon_type == wt: return
		
	match wt:
		WeaponBase.WeaponType.Pistol:
			_collected_weapons.append(pistol)
		WeaponBase.WeaponType.RocketLauncher:
			_collected_weapons.append(rocket_launcher)
		WeaponBase.WeaponType.Grenade:
			_collected_weapons.append(grenade_luncher)
		WeaponBase.WeaponType.NailGun:
			_collected_weapons.append(nail_gun)
			
	set_current_weapon(_collected_weapons.size() - 1)
	
func add_to_ammo(wt: WeaponBase.WeaponType, amount: int) -> bool:
	for w in _collected_weapons:
		if w.weapon_type == wt:
			print("adding ammo ", amount)
			w.add_ammo(amount)
			return true
	return false
