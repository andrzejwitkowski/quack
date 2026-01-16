extends EnemyStateNode

class_name EnemyStateNodeIdle

@export var to_walking: NodePath


func enter_state() -> void:
	_enemy.tree_sm.travel("Idle")
	
func update_state(_delta: float) -> void:
	_enemy.velocity = Vector3.ZERO
	if _enemy.player_detected(): 
		print("Enemy spotted")
		transition_to_path(to_walking)
	

func enemy_hit(accumulated_hit: int) -> void:
	print("Idle enemy hit")
