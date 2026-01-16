extends Node

class_name EnemyStateNode


var _sm: NodeStateMachine
var _enemy: EnemyBase
var _elapsed_time: float = 0.0

func set_machine(sm: NodeStateMachine) -> void:
	_sm = sm
	_enemy = sm.enemy
	
func enter_state() -> void:
	pass


func update_state(delta: float) -> void:
	pass


func exit_state() -> void:
	pass

func enemy_hit(accumulated_hit: int) -> void:
	pass

func animation_finished(anim_name: String) -> void:
	pass

func transition_to_path(node_path: NodePath) -> void:
	var n: Node = get_node_or_null(node_path)
	if n is EnemyStateNode: _sm.change_to_state(n)	
