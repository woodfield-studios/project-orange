extends Node

@export_group("Dependencies")
@export var character_body: CharacterBody3D

@export_group("Options")
@export var speed : float = 25.0
@export var sprint_multiplier : float = 1.8
@export var jump_velocity : float = -500.0
@export var gravity : float = -9.8

func _physics_process(_delta):
	#character_body.velocity.y = move_toward(character_body.velocity.y, gravity, gravity)
	
	var direction2: Vector2 = Input.get_vector("left", "right", "forward", "backward").normalized()
	# Need to take into account camera direction to calculate proper forward direction
	var direction = Vector3(direction2.x, 0, direction2.y)
	var current_speed = speed if !Input.is_action_pressed("sprint") else (speed * sprint_multiplier)
	
	if direction != Vector3.ZERO:
		character_body.velocity = direction * current_speed
		character_body.move_and_slide()

	if Input.is_action_just_pressed("jump") and character_body.is_on_floor():
		character_body.velocity.y = jump_velocity
