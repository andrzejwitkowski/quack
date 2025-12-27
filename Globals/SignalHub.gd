extends Node



signal on_hitscan_hit
signal on_ammo_updated(wt: WeaponBase.WeaponType, amount: int)
signal on_play_sound(key: GameUtils.SoundType)
signal on_player_health_changed(health: int)
signal on_player_health_bonus(amount: int)
signal on_player_shot(dmg: int, accuracy: float)
signal on_rune_collected


func emit_on_rune_collected() -> void:
	on_rune_collected.emit()


func emit_on_player_shot(dmg: int, accuracy: float) -> void:
	on_player_shot.emit(dmg, accuracy)


func emit_on_hitscan_hit() -> void:
	on_hitscan_hit.emit()


func emit_on_ammo_updated(wt: WeaponBase.WeaponType, amount: int) -> void:
	on_ammo_updated.emit(wt, amount)


func emit_on_play_sound(key: GameUtils.SoundType) -> void:
	on_play_sound.emit(key)


func emit_on_player_health_bonus(amount: int) -> void:
	on_player_health_bonus.emit(amount)


func emit_on_player_health_changed(health: int) -> void:
	on_player_health_changed.emit(health)
	
