extends EnemyStateNode

class_name EnemyStateNodeAttackBase

@export var to_walk: NodePath
@export var debounce: float = 0.12

var _did_action: bool = false

func enter_state() -> void:
	_elapsed_time = 0.0
	_did_action = false
	_enemy.tree_sm.travel("Attack")
	_enter_attack_animation()
	print("entered, ", name)

func update_state(delta: float) -> void:
	_enemy.velocity = Vector3.ZERO
	_elapsed_time += delta
	if _elapsed_time > debounce and !_did_action:
		_do_action()
		_did_action = true
	
func _do_action() -> void:
	pass
	
func _enter_attack_animation() -> void:
	pass
	
func animation_finished(_anim_name: String) -> void:
	transition_to_path(to_walk)
