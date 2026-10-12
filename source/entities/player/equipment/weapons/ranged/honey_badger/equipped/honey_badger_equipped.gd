extends NetworkWeaponHitscan3D

@export_group("Dependencies")
@export var honey_badger: Node3D
@export var raycast: RayCast3D
@export var bullet_hole_scene: PackedScene

@export_group("Options")
@export var damage: int = 10
@export var rounds_per_minute: int = 800
@export var max_ammo: int = 30

@export_group("Cheats")
@export var infinite_ammo: bool = false

var ammo: int = max_ammo
var user_id: int = 1

var _last_fire_tick: int = 0


func use() -> void:
	fire()


func _can_fire() -> bool:
	return (
		NetworkTime.tick >= _last_fire_tick + _get_cooldown() * NetworkTime.tickrate
		and (ammo > 0 or infinite_ammo)
	)


func _on_fire() -> void:
	_play_fx()
	if multiplayer.is_server():
		for peer_id: int in multiplayer.get_peers():
			if peer_id != multiplayer.get_unique_id():
				_play_fx_remote.rpc_id(peer_id)


@rpc("authority", "call_remote", "reliable")
func _play_fx_remote() -> void:
	_play_fx()


func _play_fx() -> void:
	honey_badger.play_audio()
	honey_badger.play_animation()


func _after_fire() -> void:
	if not infinite_ammo:
		ammo -= 1

	_last_fire_tick = NetworkTime.tick


func _get_cooldown() -> float:
	return Constants.SECONDS_PER_MINUTE / rounds_per_minute


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
