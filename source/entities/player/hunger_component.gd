class_name HungerComponent
extends Node

signal hunger_changed(new_hunger: int, max_hunger: int)
signal tick_starve(starve_damage: int)

@export var max_hunger: int = 100
@export var hunger_rate: float = 0.1
@export var starve_damage: int = 1

var current_hunger: int = max_hunger
var time_elapsed: float = 0.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		sate(10)

	time_elapsed += delta

	if time_elapsed >= 1.0 / hunger_rate:
		tick_hunger()
		time_elapsed = 0.0


func tick_hunger() -> void:
	if current_hunger <= 0:
		tick_starve.emit(starve_damage)
	else:
		current_hunger = max(0, current_hunger - 1)
		hunger_changed.emit(current_hunger, max_hunger)


func sate(amount: int) -> void:
	current_hunger = min(max_hunger, current_hunger + amount)
