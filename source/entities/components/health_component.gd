class_name HealthComponent
extends Node

signal health_changed(new_health: int, max_health: int)
signal damage_taken(amount: int, source: Node3D)
signal died()

@export var max_health: int = 100
@export var start_at_max: bool = true

var current_health: int = max_health
var is_alive: bool = true


func take_damage(amount: int, source: Node3D = null) -> void:
	if not is_alive:
		return

	var actual_damage = max(0, amount)
	current_health = max(0, current_health - actual_damage)

	damage_taken.emit(actual_damage, source)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		_handle_death()


func heal(amount: int) -> void:
	if not is_alive:
		return

	var actual_heal = max(0, amount)
	current_health = min(max_health, current_health + actual_heal)

	health_changed.emit(current_health, max_health)


func _handle_death() -> void:
	if not is_alive:
		return

	is_alive = false
	current_health = 0
	died.emit()
