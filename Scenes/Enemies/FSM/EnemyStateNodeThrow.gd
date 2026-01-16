extends EnemyStateNodeAttackBase

class_name EnemyStateNodeThrow

func _enter_attack_animation() -> void:
	_enemy.tree_sm_attack.travel("Throw")
	
func _do_action() -> void:
	_enemy.throw_at_player()
