extends StaticBody3D

@export var amount: int = 1


func interact(collider: PhysicsBody3D) -> void:
	var health_component: HealthComponent = collider.get_node_or_null("HealthComponent")

	if health_component and health_component.has_method("heal"):
		health_component.heal(amount)
