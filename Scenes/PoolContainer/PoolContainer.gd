extends Node3D

const SoundsDict: Dictionary[GameUtils.SoundType, AudioStream] = {
	GameUtils.SoundType.AmmoPickUp: preload("res://assets/Sounds/AmmoCollect.wav"),
	GameUtils.SoundType.HealthBoost: preload("res://assets/Sounds/523655__powerup.wav"),
}

@onready var sounds: AudioStreamPlayer = $Sounds

func _ready() -> void:
	SignalHub.on_play_sound.connect(on_play_sound)
	await get_tree().process_frame
	ObjectPool.init_pools(self)

func on_play_sound(key: GameUtils.SoundType) -> void:
	sounds.stop()
	sounds.stream = SoundsDict[key]
	sounds.play()
