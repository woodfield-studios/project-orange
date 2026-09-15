class_name HealthComponent
extends Node

signal health_changed(new_health: int, max_health: int)
signal damage_taken(amount: int, source: Node3D)
signal depleted()

@export_group("Options")
@export var max_health: int = 100
@export var current_health: int = max_health:
	set(new_health):
		health_changed.emit(current_health, max_health)
		current_health = max(0, new_health)
		if current_health <= 0:
			_handle_depleted()

var is_depleted: bool = false


func take_damage(amount: int, source: Node3D = null) -> void:
	if is_depleted:
		return

	var actual_damage: int = max(0, amount)
	current_health = max(0, current_health - actual_damage)

	damage_taken.emit(actual_damage, source)


func heal(amount: int) -> void:
	if is_depleted:
		return

	var actual_heal: int = max(0, amount)
	current_health = min(max_health, current_health + actual_heal)


func _handle_depleted() -> void:
	if is_depleted:
		return

	is_depleted = true
	depleted.emit()
