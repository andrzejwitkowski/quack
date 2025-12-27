@tool
extends Area3D


class_name HitBox


signal died
signal hit(damage_taken: int)


@export var start_health: int = 100
@export var max_health: int = 100
@export var shape_resource: Shape3D


@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


var _current_health: int = 0
var _dead: bool = false


func get_health() -> int:
	return _current_health


func _update_components() -> void:
	collision_shape_3d.shape = shape_resource


func _notification(what: int):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_update_components()
		

func _ready() -> void:	
	_current_health = start_health
	_update_components()
	

func take_hit(dmg: int) -> void:
	_current_health -= dmg
	if _current_health <= 0: 
		_dead = true
		died.emit()
		GameUtils.toggle_area3d(self, false, false)
	else:
		hit.emit(dmg)


func give_bonus(b: int) -> void:
	_current_health += b
	_current_health = min(_current_health, _current_health, max_health)

