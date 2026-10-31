extends CharacterBody3D

@export_group("Dependencies")
@export var name_tag: Label3D
@export var viewmodel: Node3D
@export var rollback_synchronizer: RollbackSynchronizer
@export var input: PlayerInput
@export var hud: Control
@export var current_equipment: Equipment
@export_group("Options")
@export var speed: float = 8.0
@export var jump_velocity: float = 8.0

@export var peer_id: int = 1:
	set(id):
		peer_id = id
		viewmodel.user_id = id
		name_tag.text = str(id)

var is_own_client: bool:
	get():
		return peer_id == multiplayer.get_unique_id()


func _ready() -> void:
	await get_tree().process_frame

	set_multiplayer_authority(1)
	input.set_multiplayer_authority(peer_id)
	rollback_synchronizer.process_settings()

	if is_own_client:
		viewmodel.camera.current = true
		hud.visible = true
	viewmodel.equipped = current_equipment


func _rollback_tick(delta: float, _tick: int, is_fresh: bool) -> void:
	_mouse_look()

	var direction3: Vector3 = basis * Vector3(input.direction.x, 0.0, input.direction.y)
	var horizontal_velocity: Vector3 = direction3.normalized() * speed
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	_force_update_is_on_floor()
	if is_on_floor():
		if input.jump and is_fresh:
			velocity.y = jump_velocity
	else:
		velocity += get_gravity() * delta

	if input.use and is_fresh:
		viewmodel.use_equipped()

	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor

	for i: int in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i)
		var collider: PhysicsBody3D = collision.get_collider()

		if collider.has_method("interact"):
			collider.interact(self)


func _force_update_is_on_floor() -> void:
	var old_velocity: Vector3 = velocity
	velocity = Vector3.ZERO
	move_and_slide()
	velocity = old_velocity


func _mouse_look() -> void:
	rotation.y = input.yaw
	viewmodel.rotation.x = input.pitch


func _on_health_component_depleted() -> void:
	_die()


func _die() -> void:
	if is_own_client:
		_show_death_screen()
	_play_death_sound()
	input.set_process(false)
	viewmodel.remove_all_equipped()
	$CollisionShape3D.disabled = true


func _show_death_screen() -> void:
	if is_own_client:
		var death_screen: Control = preload("res://source/ui/hud/death_screen.tscn").instantiate()
		get_parent_node_3d().add_child(death_screen)


func _play_death_sound() -> void:
	$Groan.play()


func _on_groan_finished() -> void:
	rollback_synchronizer.despawn()
