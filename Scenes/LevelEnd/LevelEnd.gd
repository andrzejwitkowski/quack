extends Node3D

var allowed: bool = false

@onready var label: Label3D = $label

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body is Player: return
	label.show()
	if allowed:
		label.text = "Blaster master!"
		get_tree().paused = true
	else:
		await get_tree().create_timer(2.0).timeout
		label.hide()
	

func _enter_tree() -> void:
	SignalHub.on_rune_collected.connect(on_rune_collected)
	

func on_rune_collected() -> void:
	allowed = true
