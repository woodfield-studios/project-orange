extends Node3D

@export_group("Dependencies")
@export var fireaxe: Node3D
@export var shapecast: ShapeCast3D

@export_group("Options")
@export var damage: int = 10
@export var attack_speed: int = 50


func use() -> void:
	_attack()


func _attack() -> void:
	if not _can_attack():
		return

	print("Attacking with fireaxe!")


func _can_attack() -> bool:
	return true
