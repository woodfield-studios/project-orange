class_name HungerComponent
extends Node

signal hunger_changed(new_hunger: int, max_hunger: int)
signal tick_hunger_damage()

@export var max_hunger: int = 100
@export var hunger_rate: float = 0.1

var current_hunger: int = max_hunger
var time_elapsed: float = 0.0


func _process(delta: float) -> void:
	time_elapsed += delta

	if time_elapsed >= 1.0 / hunger_rate:
		tick_hunger()
		time_elapsed = 0.0


func tick_hunger() -> void:
	if current_hunger <= 0:
		tick_hunger_damage.emit()
	else:
		current_hunger = max(0, current_hunger - 1)
		hunger_changed.emit(current_hunger, max_hunger)
