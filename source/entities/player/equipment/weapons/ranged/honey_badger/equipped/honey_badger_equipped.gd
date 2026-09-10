extends Node3D

@export var raycast: RayCast3D

func use() -> void:
	var collider: Node3D = raycast.get_collider()
	if collider:
		var collision_normal: Vector3 = raycast.get_collision_normal()
		var collision_pointer: Vector3 = raycast.get_collision_point()
