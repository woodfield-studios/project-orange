extends StaticBody3D

@export var amount: int = 1


func interact(collider: PhysicsBody3D):
	var health_component = collider.get_node_or_null("HealthComponent")

	if health_component and health_component.has_method("heal"):
		health_component.heal(amount)
