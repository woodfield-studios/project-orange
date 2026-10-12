extends Node3D

@export_group("Dependencies")
@export var fireaxe: Node3D
@export var shapecast: ShapeCast3D

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

	for collider: Node3D in _get_colliders():
		_on_hit(collider)

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


func _on_hit(collider: Node3D) -> void:
	if collider:
		var health_component: HealthComponent = collider.get_node_or_null("HealthComponent")
		if health_component:
			health_component.take_damage(damage, fireaxe)


func _get_colliders() -> Array[Node3D]:
	shapecast.force_shapecast_update()

	var colliders: Array[Node3D] = []

	for collision_index: int in range(shapecast.get_collision_count()):
		var collider: Object = shapecast.get_collider(collision_index)
		colliders.push_back(collider)

	return colliders
