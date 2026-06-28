extends CharacterBody3D

func _physics_process(_delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.has_method("interact"):
			collider.interact(self)


func _on_hunger_component_tick_starve(starve_damage: int) -> void:
	var health_component: HealthComponent = get_node_or_null("HealthComponent")
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(starve_damage)


func _on_thirst_component_tick_parch(parch_damage: int) -> void:
	var health_component: HealthComponent = get_node_or_null("HealthComponent")
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(parch_damage)
