class_name ScenePool


const METHOD_IS_READY: String = "pool_is_ready"
const METHOD_POOL_ACTIVATE: String = "pool_activate"

var _scenes_list: Array[Node3D]
var _container: Node3D
var _packed_scene: PackedScene
var _name_prefix: String

func _init(
	start_scenes: int,
	packed: PackedScene,
	container: Node3D,
	name_prefix: String
) -> void:
	_container = container
	_name_prefix = name_prefix
	_packed_scene = packed
	for i in range(start_scenes):
		add_new_scene()

func add_new_scene() -> Node3D:
	var ns  = _packed_scene.instantiate()
	
	if !ns.has_method(METHOD_IS_READY):
		push_error("No methods %s is found" % METHOD_IS_READY)
		return
	if !ns.has_method(METHOD_POOL_ACTIVATE):
		push_error("No methods %s is found" % METHOD_IS_READY)
		return
		
	ns.name = "%s_%d" % [_name_prefix, _scenes_list.size()]
	
	_container.add_child(ns)
	
	_scenes_list.append(ns)
	
	return ns
	
func activate_next_scene(p_pos: Vector3) -> void:
	for i in range(_scenes_list.size()):
		var scene = _scenes_list[i]
		if scene.pool_is_ready():
			scene.pool_activate(p_pos)
			return
	var ns = add_new_scene()
	if ns: ns.pool_activate(p_pos)
	
