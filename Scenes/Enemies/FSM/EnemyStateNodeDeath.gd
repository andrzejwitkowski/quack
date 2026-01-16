extends EnemyStateNode

class_name EnemyStateNodeDeath

func enter_state() -> void:
	print("Entered death")
	_enemy.velocity = Vector3.ZERO
	_enemy.tree_sm.travel("Death")
	_enemy.grunt_timer.stop()
	_enemy.play_death_sound()
	GameUtils.toggle_area3d(_enemy.hit_box, false, false)
	
func animation_finished(anim_name: String) -> void:
	if anim_name == "Death": 
		_enemy.call_deferred("disable_all")
	
