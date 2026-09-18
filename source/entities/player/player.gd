extends CharacterBody3D

@export_group("Dependencies")
@export var name_tag: Label3D
@export var viewmodel: Node3D
@export var mouse_camera: Node
@export var player_input: MultiplayerSynchronizer
@export var hud: Control
@export var current_equipment: Equipment

@export var player_id: int = 1:
	set(id):
		player_id = id
		name_tag.text = str(id)
		player_input.set_multiplayer_authority(id)
		mouse_camera.set_multiplayer_authority(id)

var is_own_client: bool:
	get ():
		return player_id == multiplayer.get_unique_id()


func _ready() -> void:
	if is_own_client:
		viewmodel.camera.current = true
		hud.visible = true

	viewmodel.equipped = current_equipment


func _physics_process(_delta: float) -> void:
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i)
		var collider: PhysicsBody3D = collision.get_collider()

		if collider.has_method("interact"):
			collider.interact(self)

	if player_input.is_using:
		viewmodel.use_equipped()
		player_input.is_using = false


func _on_health_component_depleted() -> void:
	if is_own_client:
		var death_screen: Control = preload("res://source/ui/hud/death_screen.tscn").instantiate()
		add_child(death_screen)
		player_input.set_process(false)
		$Groan.play()
	visible = false
	$CollisionShape3D.disabled = true
