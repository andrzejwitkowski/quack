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


var _was_moving: bool = false
var _was_on_floor: bool = false
var _look_delta: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_delta = event.relative
		

#region Setup
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
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
