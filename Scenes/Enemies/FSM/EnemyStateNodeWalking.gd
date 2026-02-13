extends EnemyStateNode


class_name EnemyStateNodeWalking

@export var to_idle: NodePath
@export var to_hurt: NodePath
@export var to_shoot_or_throw: NodePath
@export var to_melee: NodePath
@export var hit_threashold: float = 10


func enter_state() -> void:
	print("entered_state():", name)
	_enemy.tree_sm.travel("Walking")
	_enemy.play_grunt_sound()
	_enemy.grunt_timer.start()
	_enemy.set_target_to_player()
	_elapsed_time = 0.0


func update_state(delta: float) -> void:
	_elapsed_time += delta
	if _enemy.player_detected(): _enemy.set_target_to_player()
	
	if to_melee:
		if _elapsed_time > _enemy.melee_interval and _enemy.can_melee():
			transition_to_path(to_melee)
			return
	
	if to_shoot_or_throw:
		if _elapsed_time > _enemy.shoot_interval:
			if _enemy.player_detected():
				transition_to_path(to_shoot_or_throw)
				return
	
	if _enemy.nav_agent.is_navigation_finished() and !_enemy.player_detected():
		transition_to_path(to_idle)
	elif _enemy.can_nav():
		print("walking")
		var npp: Vector3 = _enemy.nav_agent.get_next_path_position()
		_enemy.velocity = _enemy.global_position.direction_to(npp) * _enemy.speed
		_enemy.safe_look_at(npp)
		
	
func enemy_hit(accumulated_hit: int) -> void:
	if _enemy.accumulated_damage >= hit_threashold:
		transition_to_path(to_hurt)

func exit_state() -> void:
	print("exit_state():", name)
	_enemy.grunt_timer.stop()
