extends NetworkWeaponHitscan3D

@export_group("Dependencies")
@export var honey_badger: Node3D
@export var raycast: RayCast3D
@export var bullet_hole_scene: PackedScene

@export_group("Options")
@export var damage: int = 10
@export var rounds_per_minute: int = 800
@export var max_ammo: int = 30

var ammo: int = max_ammo

var _cooldown_timer_seconds: float = Constants.SECONDS_PER_MINUTE / rounds_per_minute
var _on_cooldown: bool = false


func use() -> void:
	fire()


func _can_fire() -> bool:
	return not _on_cooldown and ammo > 0


func _on_fire() -> void:
	honey_badger.play_audio()
	honey_badger.play_animation()


func _after_fire() -> void:
	ammo -= 1

	_on_cooldown = true
	await get_tree().create_timer(_cooldown_timer_seconds).timeout
	_on_cooldown = false


func _on_hit(result: Dictionary) -> void:
	var collider: Node3D = result.collider
	if collider:
		_create_bullet_hole(collider)

		var health_component: HealthComponent = collider.get_node_or_null("HealthComponent")
		if health_component:
			health_component.take_damage(damage, honey_badger)


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
