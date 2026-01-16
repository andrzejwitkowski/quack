extends EnemyStateNode

class_name EnemyStateNodeHurt

@export var to_idle: NodePath

func enter_state() -> void:
	_enemy.tree_sm.travel("Hurt")
	_enemy.play_pain_sound()
	_enemy.grunt_timer.stop()
	_enemy.accumulated_damage = 0
	
func animation_finished(_anim_name: String) -> void:
	transition_to_path(to_idle)

func update_state(_delta: float) -> void:
	_enemy.velocity = Vector3.ZERO

func exit_state() -> void:
	pass
