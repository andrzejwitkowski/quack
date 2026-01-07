extends Node

@onready var container: Node3D = $Container
const ROCKET_IMPACT = preload("res://Scenes/Vfx/RocketImpact.tscn")

var _sp: ScenePool

var c= 0
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		var image = get_viewport().get_texture().get_image()
		image.save_png("user://fps%d.png" % c)
		c+=1

func _ready() -> void:
	_sp = ScenePool.new(4, ROCKET_IMPACT, container, "Impact")
	pass
