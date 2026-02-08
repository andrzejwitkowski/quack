extends Area3D

class_name HealthPickup

@export var bonus: int = 25


func _on_body_entered(body: Node3D) -> void:
	hide()
	GameUtils.toggle_area3d(self, false, false)
	SignalHub.emit_on_player_health_bonus(bonus)
	queue_free()
