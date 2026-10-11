extends Node3D

@export_group("Dependencies")
@export var fireaxe: Node3D
@export var shapecast_shape: Shape3D

@export_group("Options")
@export var damage: int = 10
@export var cooldown: float = 0.25

@export_flags_3d_physics var collision_mask: int = 0xFFFFFFFF
@export var exclude: Array[RID] = []

var _on_cooldown: bool = false


func use() -> void:
	attack()


func attack() -> bool:
	if not _can_attack():
		return false

	_apply_data(_get_data())

	_on_attack()
	_after_attack()
	return true


func _can_attack() -> bool:
	return not _on_cooldown


func _on_attack() -> void:
	fireaxe.play_audio()
	fireaxe.play_animation()


func _after_attack() -> void:
	_on_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	_on_cooldown = false


func _on_hit(result: Dictionary) -> void:
	var collider: Node3D = result.collider
	if collider:
		var health_component: HealthComponent = collider.get_node_or_null("HealthComponent")
		if health_component:
			health_component.take_damage(damage, fireaxe)


func _get_data() -> Dictionary:
	# Collect data needed to synchronize the attacking event.
	# We need to do this so that all peers agree on data to act upon.
	# Otherwise, each peer would act upon its local data, which could result in discrepancies.
	return {
		"origin": global_transform.origin,
		"direction": -global_transform.basis.z, # Assuming forward direction.
	}


func _apply_data(data: Dictionary) -> void:
	# Reproduces the firing event on all peers.
	var origin: Vector3 = data["origin"] as Vector3
	var direction: Vector3 = data["direction"] as Vector3

	# Perform the shapecast from origin in the given direction.
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	var shape_query_shape: Shape3D = BoxShape3D.new()
	shape_query_shape.size = Vector3(1.0, 0.5, 1.0)

	# Create a PhysicsShapeQueryParameters3D object.
	var shape_params: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	shape_params.shape = shape_query_shape
	shape_params.transform.origin = origin + direction.normalized()

	# Set collision masks or exclude objects:
	shape_params.collision_mask = collision_mask
	shape_params.exclude = exclude

	var results: Array[Dictionary] = space_state.intersect_shape(shape_params)

	var results_filtered: Array[Dictionary] = results.filter(
		func(result: Dictionary) -> bool:
			return result.collider is Node3D,
	)

	for result: Dictionary in results_filtered:
		_on_hit(result)

	# Play attacking effects on all peers.
	_on_attack()
