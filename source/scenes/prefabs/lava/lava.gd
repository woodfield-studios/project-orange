extends StaticBody3D

@export var damage: int = 1


func interact(collider: PhysicsBody3D):
	var health_component = collider.get_node_or_null("HealthComponent")
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(damage, self)
