extends BaseNetInput
class_name PlayerInput

var direction: Vector2 = Vector2.ZERO


func _gather() -> void:
	direction = Input.get_vector("left", "right", "forward", "backward")
