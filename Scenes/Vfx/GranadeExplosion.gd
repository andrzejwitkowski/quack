extends Node3D

var _done: bool = true
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	hide()

func pool_is_ready() -> bool:
	return _done

func pool_activate(p_pos: Vector3) -> void:
	show()
	global_position = p_pos
	_done = false
	gpu_particles_3d.restart()
	audio_stream_player_3d.play()


func _on_gpu_particles_3d_finished() -> void:
	hide()
	_done = true

func _on_audio_stream_player_3d_finished() -> void:
	_done = true
