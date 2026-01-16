extends EnemyStateNodeAttackBase

class_name EnemyStateNodeShoot

func _do_action() -> void:
	_enemy.shoot_at_player()
	
func _enter_attack_animation() -> void:
	_enemy.tree_sm_attack.travel("Shoot")
