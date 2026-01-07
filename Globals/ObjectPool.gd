extends Node

const ROCKET_IMPACT = preload("res://Scenes/Vfx/RocketImpact.tscn")
const GRANADE_EXPLOSION = preload("res://Scenes/Vfx/GranadeExplosion.tscn")

var pools: Dictionary[GameUtils.PoolObjectNames, ScenePool] = {}

func init_pools(container: Node3D) -> void:
	pools.clear()
	pools[GameUtils.PoolObjectNames.RocketImpact] = \
	ScenePool.new(3, ROCKET_IMPACT, container, "ROCKET_IMPACT")
	pools[GameUtils.PoolObjectNames.GrenadeExplosion] = \
	ScenePool.new(3, GRANADE_EXPLOSION, container, "GRANADE_EXPLOSION")


func activate(pool: GameUtils.PoolObjectNames, p_pos: Vector3) -> void:
	if pools.has(pool): pools[pool].activate_next_scene(p_pos)
