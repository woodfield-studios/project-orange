extends Node3D

@export_group("Dependencies")
@export var fireaxe: Node3D
@export var shapecast: ShapeCast3D

@export_group("Options")
@export var damage: int = 10
@export var attack_speed: int = 50


func use() -> void:
	attack()


func attack() -> bool:
	if not _can_attack():
		return false

	_on_attack()
	_after_attack()
	return true


func _can_attack() -> bool:
	return true


func _on_attack() -> void:
	pass


func _after_attack() -> void:
	pass
