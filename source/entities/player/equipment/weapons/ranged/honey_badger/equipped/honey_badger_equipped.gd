extends Node3D

@export var raycast: RayCast3D
@export var bullet_hole_scene: PackedScene


func use() -> void:
	var collider: Node3D = raycast.get_collider()
	if collider:
		var collision_normal: Vector3 = raycast.get_collision_normal()
		var collision_point: Vector3 = raycast.get_collision_point()
		var bullet_hole: Node3D = bullet_hole_scene.instantiate()
		var orientation_point: Vector3 = collision_point + collision_normal
		bullet_hole.look_at_from_position(collision_point, orientation_point)
		collider.add_child(bullet_hole)
