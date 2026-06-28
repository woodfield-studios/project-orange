extends Control

func _on_health_component_health_changed(new_health: int, max_health: int) -> void:
	get_node("Health").text = str(new_health, "/", max_health)


func _on_hunger_component_hunger_changed(new_hunger: int, max_hunger: int) -> void:
	get_node("Hunger").text = str(new_hunger, "/", max_hunger)


func _on_thirst_component_thirst_changed(new_thirst: int, max_thirst: int) -> void:
	get_node("Thirst").text = str(new_thirst, "/", max_thirst)
