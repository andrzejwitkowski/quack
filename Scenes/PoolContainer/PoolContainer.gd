extends Node3D

func _ready() -> void:
	await get_tree().process_frame
	ObjectPool.init_pools(self)
