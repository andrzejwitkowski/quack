extends Node


var c= 0
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		var image = get_viewport().get_texture().get_image()
		image.save_png("user://fps%d.png" % c)
		c+=1
