extends Node

@export_group("Dependencies")
@export var character_body: CharacterBody3D
@export var input: MultiplayerSynchronizer

@export_group("Options")
@export var speed: float = 8.0
@export var sprint_multiplier: float = 1.8
@export var jump_velocity: float = 10.0
@export var gravity: float = -9.8

var velocity_gravity: Vector3
var velocity_input: Vector3
var velocity_input_jump: Vector3


func _physics_process(delta):
	if not character_body.is_multiplayer_authority():
		return

	# Calculate movement direction from an oriented character_body
	var direction3: Vector3 = Vector3(input.direction.x, 0, input.direction.y)
	var move_direction: Vector3 = character_body.basis * direction3

	# Apply sprint modifiers
	var modified_speed = speed if not input.is_sprinting else (speed * sprint_multiplier)

	# Gravity velocity
	if not character_body.is_on_floor():
		velocity_gravity.y += gravity * delta

	# Movement velocity
	velocity_input = move_direction * modified_speed

	# Jump velocity
	if input.is_jumping and character_body.is_on_floor():
		velocity_input_jump.y += jump_velocity
		input.is_jumping = false

	character_body.velocity = velocity_gravity + velocity_input + velocity_input_jump
	character_body.move_and_slide()
