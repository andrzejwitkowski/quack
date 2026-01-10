extends CharacterBody3D


class_name EnemyBase


signal enemy_died
signal enemy_hit(accumulated_damage: int)


const WALKING_SPEED_SCALE_PARAM: String = "parameters/Walking/Speed/scale"
const HURT_SPEED_SCALE_PARAM: String = "parameters/Hurt/Speed/scale"
const MELEE_SPEED_SCALE_PARAM: String = "parameters/Attack/Melee/Speed/scale"
const SHOOT_SPEED_SCALE_PARAM: String = "parameters/Attack/Shoot/Speed/scale"
const THROW_SPEED_SCALE_PARAM: String = "parameters/Attack/Throw/Speed/scale"


@export_group("Movement")
@export var speed: float = 2.2
@export var walk_speed_scale: float = 1.5
@export var throw_speed_scale: float = 1.5
@export var shoot_speed_scale: float = 1.5
@export var melee_speed_scale: float = 1.5
@export var hurt_speed_scale: float = 1.0
@export var path_offset: float = 0.5


@export_group("Shooting")
@export var fire_behaviour: FireBahavior
@export var shoot_interval: float = 3.0
@export var shoot_accuracy: float = 0.7
@export var shoot_damage: int = 5
@export var melee_damage: int = 20
@export var melee_distance: float = 1.5


@export_group("Sounds")
@export var death_sound: AudioStream
@export var grunt_sound: AudioStream
@export var pain_sound: AudioStream
@export var shoot_sound: AudioStream


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var tree_sm: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var tree_sm_attack: AnimationNodeStateMachinePlayback = animation_tree["parameters/Attack/playback"]
@onready var nav_agent: NavigationAgent3D = $NavAgent
@onready var player_detect: RayCast3D = $PlayerDetect
@onready var hit_box: HitBox = $HitBox
@onready var sound_effects: AudioStreamPlayer3D = $SoundEffects
@onready var player_ref: PlayerRef = $PlayerRef
@onready var grunt_timer: Timer = $GruntTimer
@onready var label: Label = $CanvasLayer/Label


var accumulated_damage: int = 0:
	set(v):
		accumulated_damage = max(0, v)
	get: return accumulated_damage

func _ready() -> void:		
	nav_agent.path_height_offset = path_offset
	
	tree_sm.travel("Idle")
	animation_tree[WALKING_SPEED_SCALE_PARAM] = walk_speed_scale
	animation_tree[THROW_SPEED_SCALE_PARAM] = throw_speed_scale
	animation_tree[MELEE_SPEED_SCALE_PARAM] = melee_speed_scale
	animation_tree[SHOOT_SPEED_SCALE_PARAM] = shoot_speed_scale
	animation_tree[HURT_SPEED_SCALE_PARAM] = hurt_speed_scale

func player_detected() -> bool:
	return player_detect.is_colliding() and player_detect.get_collider() is Player

func safe_look_at(target: Vector3) -> void:
	target.y = global_position.y
	if (target - global_position).is_equal_approx(Vector3.ZERO):
		return
	look_at(target)

func _physics_process(_delta: float) -> void:
	player_detect.look_at(player_ref.player_pos)
	move_and_slide()
	if player_detected(): safe_look_at(player_ref.player_pos)
	
	var s = "player detected:%s\n" % player_detected()
	s += "health:%d" % hit_box.get_health()
	label.text = s
	


func play_effect(s: AudioStream) -> void:
	sound_effects.stop()
	sound_effects.stream = s
	sound_effects.play()


func play_death_sound() -> void:
	play_effect(death_sound)


func play_grunt_sound() -> void:
	play_effect(grunt_sound)


func play_pain_sound() -> void:
	play_effect(pain_sound)


func play_shoot_sound() -> void:
	play_effect(shoot_sound)


func _on_hit_box_died() -> void:
	print("died")
	enemy_died.emit()

func _on_hit_box_hit(damage_taken: int) -> void:
	print("HIT:", damage_taken)
	accumulated_damage += damage_taken
	enemy_hit.emit(accumulated_damage)


func _on_accumulated_damage_timer_timeout() -> void:
	accumulated_damage = 0


func _on_grunt_timer_timeout() -> void:
	play_grunt_sound()
