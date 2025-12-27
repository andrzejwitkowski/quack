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


var _was_moving: bool = false
var _was_on_floor: bool = false


func _unhandled_input(event: InputEvent) -> void:
	pass
		

#region Setup
func _ready() -> void:
	pass


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
#endregion


#region Movement
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
#endregion


#region Sounds
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
