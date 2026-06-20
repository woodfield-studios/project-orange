extends Node

@export_group("Dependencies")
@export var character_body: CharacterBody3D
@export var rotation_reference: Node3D

@export_group("Options")
@export var speed : float = 8.0
@export var sprint_multiplier : float = 1.8
@export var jump_velocity : float = 10.0
@export var gravity : float = -9.8

var velocity_gravity: Vector3
var velocity_input: Vector3
var velocity_input_jump: Vector3

func _physics_process(delta):
	# Calculate movement direction from an oriented rotation_reference
	var direction2: Vector2 = Input.get_vector("left", "right", "forward", "backward").normalized()
	var direction3: Vector3 = Vector3(direction2.x, 0, direction2.y)
	var camera_transform: Transform3D = rotation_reference.transform.orthonormalized()
	var move_direction: Vector3 = camera_transform * direction3
	
	# Apply sprint modifiers
	var modified_speed = speed if !Input.is_action_pressed("sprint") else (speed * sprint_multiplier)
	
	# Gravity velocity
	if not character_body.is_on_floor():
		velocity_gravity.y += gravity * delta 
	
	# Movement velocity
	velocity_input = move_direction * modified_speed

	# Jump velocity
	if Input.is_action_just_pressed("jump") and character_body.is_on_floor():
		velocity_input_jump.y += jump_velocity
	
	character_body.velocity = velocity_gravity + velocity_input + velocity_input_jump
	character_body.move_and_slide()
