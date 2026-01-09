extends Node3D

@onready var label_3d: Label3D = $Label3D
@onready var hit_box: HitBox = $HitBox
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	set_health()

func set_health() -> void:
	label_3d.text = str(hit_box.get_health())

func _on_hit_box_died() -> void:
	label_3d.text = "DEAD"
	mesh_instance_3d.hide()

func _on_hit_box_hit(damage_taken: int) -> void:
	set_health()
