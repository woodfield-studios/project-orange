extends CharacterBody3D

@export_group("Dependencies")
@export var navigation_agent: NavigationAgent3D
@export_group("Options")
@export var speed: float = 5.0

var is_alive: bool = true


func _rollback_tick(delta: float, _tick: int, _is_fresh: bool) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_alive:
		var target_player: CharacterBody3D = _find_closest_player()

		navigation_agent.target_position = target_player.global_position
		var next_navigation_point: Vector3 = navigation_agent.get_next_path_position()
		velocity = (next_navigation_point - global_position).normalized() * speed

	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor


func _find_closest_player() -> CharacterBody3D:
	var result: CharacterBody3D = get_tree().get_first_node_in_group("Players")
	for player: CharacterBody3D in get_tree().get_nodes_in_group("Players"):
		if global_position.distance_squared_to(player.global_position) < global_position.distance_squared_to(
			result.global_position
		):
			result = player
	return result


func _on_health_component_depleted() -> void:
	is_alive = false
	$Groan.play()
