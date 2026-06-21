extends Control

func _on_health_component_health_changed(new_health: int, max_health: int) -> void:
	$Health.text = str(new_health, "/", max_health)
