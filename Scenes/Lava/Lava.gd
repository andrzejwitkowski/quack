extends Node3D

const LAVA_HIT: int = 10000

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is HitBox: area.take_hit(LAVA_HIT)
