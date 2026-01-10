extends MeshInstance3D


func _physics_process(delta: float) -> void:
	position += Vector3(0.01 ,0 ,0)
	
