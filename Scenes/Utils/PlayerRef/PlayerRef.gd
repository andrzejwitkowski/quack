extends Node


class_name PlayerRef


var _player_ref: Player


var player: Player:
	get: return _player_ref


var player_x: float: 
	get: return _player_ref.global_position.x if _player_ref else 0.0


var player_y: float: 
	get: return _player_ref.global_position.y if _player_ref else 0.0


var player_z: float: 
	get: return _player_ref.global_position.z if _player_ref else 0.0


var player_pos: Vector3: 
	get: return _player_ref.global_position if _player_ref else Vector3.ZERO
	
	
func player_pos_set_y(y: float) -> Vector3:
	return Vector3(_player_ref.global_position.x, y, _player_ref.global_position.z)


func direction_to_player(our_pos: Vector3) -> Vector3:
	return our_pos.direction_to(_player_ref.global_position)
	

func player_too_close(our_pos: Vector3) -> bool:
	return our_pos.distance_to(_player_ref.global_position) < 0.05



func player_less_than_distance(our_pos: Vector3, distance: float) -> bool:
	return our_pos.distance_to(_player_ref.global_position) < distance


func _ready() -> void:
	find_ref()


func find_ref() -> void:
	_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_ref:
		get_parent().queue_free()
