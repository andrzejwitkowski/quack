extends AnimatableBody3D

const CLOSE_ENOUGH: float = 0.02

@export var top_y: float
@export var bottom_y: float
@export var speed: float = 2.0
@export var wait_min: float = 1.0
@export var wait_max: float = 3.0

@onready var sound: AudioStreamPlayer3D = $Sound

var _target_y: float
var _waiting: bool = false
var _wait_time_left: float = 0.0

func _ready() -> void:
	set_target() 


func _physics_process(delta: float) -> void:
	if _waiting:
		_wait_time_left -= delta
		if _wait_time_left < 0.0:
			set_target()
		return

	global_position.y = move_toward(global_position.y, _target_y, speed * delta)

	if abs(global_position.y - _target_y) < CLOSE_ENOUGH:
		start_wait()


func start_wait() -> void:
	_waiting = true
	_wait_time_left = randf_range(wait_min, wait_max)


func set_target() -> void:
	var d1: float = abs(global_position.y - top_y)
	var d2 : float = abs(global_position.y - bottom_y)
	_target_y = top_y if d1 > d2 else bottom_y
	_waiting = false
	sound.play()
