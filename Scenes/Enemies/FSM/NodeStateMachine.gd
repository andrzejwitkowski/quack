extends Node

class_name NodeStateMachine

@export var enemy: EnemyBase
@export var initial_state_path: NodePath


var _states: Dictionary[String, EnemyStateNode] = {}
var _current: EnemyStateNode

func _ready() -> void:
	register_child_states()
	call_deferred("late_setup")
	
func late_setup() -> void:
	start_initial_state()
	connect_signals()
	
func connect_signals() -> void:
	enemy.enemy_hit.connect(on_enemy_hit)
	enemy.animation_tree.animation_finished.connect(animation_finished)

func register_child_states() -> void:
	_states.clear()
	for child in get_children():
		if child is EnemyStateNode:
			#if child is EnemyStateNodeDeath:
				#_death_state = child
			child.set_machine(self)
			_states[child.name] = child
			print("register_child_states(): ", child.name)
			

func start_initial_state() -> void:
	if !initial_state_path.is_empty():
		var n: Node = get_node_or_null(initial_state_path)
		if n is EnemyStateNode:
			change_to_state(n)
		else:
			push_error("Initial state is invalid")
	else:
		push_error("initial state is empty")
		
func change_to_state(next: EnemyStateNode) -> void:
	if _current == next: return
	if _current: _current.exit_state()
	_current = next
	_current.enter_state()
	
func on_enemy_hit(accumulated_hit: int) -> void:
	if _current: _current.enemy_hit(accumulated_hit)
	
func update(delta: float) -> void:
	if _current: _current.update_state(delta)
	
func animation_finished(anim_name: String) -> void:
	if _current: _current.animation_finished(anim_name)
