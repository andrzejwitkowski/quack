extends CharacterBody3D


@onready var nav_agent: NavigationAgent3D = $NavAgent


@export var speed: float = 5.0
@export var camera: Camera3D 


@onready var label: Label = $CanvasLayer/Label


func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to, 1)
		var result = space_state.intersect_ray(query)
		
		if result:
			var target_pos = result.position
			nav_agent.set_target_position(target_pos)


func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame


func _process(delta: float) -> void:
	label.text = "Target:%s\nReachable:%s\nReached:%s\nDone:%s" % [
		nav_agent.target_position,
		nav_agent.is_target_reachable(),
		nav_agent.is_target_reached(),
		nav_agent.is_navigation_finished()
	]
	
func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished(): return
	
	var npp: Vector3 = nav_agent.get_next_path_position()
	var new_vel: Vector3 = global_position.direction_to(npp) * speed
	
	velocity = new_vel
	
	move_and_slide()
