extends Node3D

@export_group("Dependencies")
@export var honey_badger: Node3D
@export var raycast: RayCast3D
@export var bullet_hole_scene: PackedScene

@export_group("Options")
@export var damage: int


func use() -> void:
	var collider: Node3D = raycast.get_collider()
	if collider:
		_create_bullet_hole(collider)

		var health_component: HealthComponent = collider.get_node_or_null("HealthComponent")
		if health_component:
			health_component.take_damage(damage, honey_badger)

	honey_badger.play_audio()
	honey_badger.play_animation()


func _create_bullet_hole(collider: Node3D) -> void:
	var collision_normal: Vector3 = raycast.get_collision_normal()
	var collision_point: Vector3 = raycast.get_collision_point()
	var bullet_hole: Node3D = bullet_hole_scene.instantiate()

	collider.add_child(bullet_hole)

	bullet_hole.global_position = collision_point
	if collision_normal != Vector3.UP:
		var orientation_point: Vector3 = collision_point + collision_normal
		bullet_hole.look_at(orientation_point)
	else:
		bullet_hole.rotate_x(-90.0)
