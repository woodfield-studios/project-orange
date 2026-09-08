extends MultiplayerSynchronizer

@export var direction: Vector2 = Vector2()
@export var is_jumping: bool = false
@export var is_using: bool = false


func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "forward", "backward").normalized()

	if Input.is_action_just_pressed("jump"):
		jump.rpc()

	if Input.is_action_just_pressed("use"):
		use.rpc()


@rpc("call_local")
func jump() -> void:
	is_jumping = true


@rpc("call_local")
func use() -> void:
	is_using = true
