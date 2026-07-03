extends CharacterBody3D

@onready var camera: Camera3D = $Body/Head/Camera3D

@export var player_id: int = 1:
	set(id):
		player_id = id
		$Movement/PlayerInput.set_multiplayer_authority(id)


func _ready():
	if player_id == multiplayer.get_unique_id():
		camera.current = true


func _physics_process(_delta: float) -> void:
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i)
		var collider: StaticBody3D = collision.get_collider()

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
