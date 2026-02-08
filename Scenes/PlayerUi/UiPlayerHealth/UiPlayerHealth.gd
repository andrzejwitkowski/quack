extends VBoxContainer

const QUAKE_GUY_64_FACE_1 = preload("res://Assets/Images/QuakeGuy/QuakeGuy64Face1.png")
const QUAKE_GUY_64_FACE_2 = preload("res://Assets/Images/QuakeGuy/QuakeGuy64Face2.png")
const QUAKE_GUY_64_FACE_3 = preload("res://Assets/Images/QuakeGuy/QuakeGuy64Face3.png")
const QUAKE_GUY_64_FACE = preload("res://Assets/Images/QuakeGuy/QuakeGuy64Face.png")

@onready var image: TextureRect = $Image
@onready var health_label: Label = $HealthLabel


func _enter_tree() -> void:
	SignalHub.on_player_health_changed.connect(set_health)
	

func set_health(health: int) -> void:
	health_label.text = str(health)
	if health < 25:
		image.texture = QUAKE_GUY_64_FACE_3
	elif health < 50:
		image.texture = QUAKE_GUY_64_FACE_2
	elif health < 75:
		image.texture = QUAKE_GUY_64_FACE_1
	else:
		image.texture = QUAKE_GUY_64_FACE
