extends MultiplayerSynchronizer

@export var direction := Vector2()
@export var is_jumping := false
@export var is_sprinting := false


func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "forward", "backward").normalized()

	if Input.is_action_just_pressed("jump"):
		jump.rpc()

	if Input.is_action_just_pressed("sprint"):
		sprint.rpc()

	if Input.is_action_just_released("sprint"):
		unsprint.rpc()


@rpc("call_local")
func jump():
	is_jumping = true


@rpc("call_local")
func sprint():
	is_sprinting = true


@rpc("call_local")
func unsprint():
	is_sprinting = false
