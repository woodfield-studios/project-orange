class_name ThirstComponent
extends Node

signal thirst_changed(new_thirst: int, max_thirst: int)
signal tick_parch(parch_damage: int)

@export var max_thirst: int = 100
@export var thirst_rate: float = 0.2
@export var parch_damage: int = 1

var current_thirst: int = max_thirst
var time_elapsed: float = 0.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quench"):
		quench(10)

	time_elapsed += delta

	if time_elapsed >= 1.0 / thirst_rate:
		tick_thirst()
		time_elapsed = 0.0


func tick_thirst() -> void:
	if current_thirst <= 0:
		tick_parch.emit(parch_damage)
	else:
		current_thirst = max(0, current_thirst - 1)
		thirst_changed.emit(current_thirst, max_thirst)


func quench(amount: int) -> void:
	current_thirst = min(max_thirst, current_thirst + amount)
