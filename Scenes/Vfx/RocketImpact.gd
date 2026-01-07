extends GPUParticles3D

var _done: bool = true

func _ready() -> void:
	hide()

func pool_is_ready() -> bool:
	return _done

func pool_activate(p_pos: Vector3) -> void:
	show()
	global_position = p_pos
	_done = false
	restart()

func _on_finished() -> void:
	hide()
	_done = true
