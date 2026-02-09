extends Area3D

@onready var sound: AudioStreamPlayer3D = $Sound


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		SignalHub.emit_on_rune_collected()
		hide()
		GameUtils.toggle_area3d(self, false, false)
		sound.play()
		await sound.finished
		queue_free()
