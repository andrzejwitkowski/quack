extends EnemyStateNodeAttackBase

class_name EnemyStateNodeMelee


func update_state(delta: float) -> void:
	_enemy.velocity = Vector3.ZERO

func _enter_attack_animation() -> void:
	if _enemy.tree_sm_attack.get_current_node() == "Melee":
		_enemy.tree_sm_attack.start("Melee")
	else:
		_enemy.tree_sm_attack.travel("Melee")
