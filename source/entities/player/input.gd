extends BaseNetInput
class_name PlayerInput

@export var sensitivity: float = 1.0

var mouse_rotation: Vector2 = Vector2.ZERO
var look_angle: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var jump: bool = false
var use: bool = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return

	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion:
		_aim_look(event)

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _aim_look(event: InputEventMouseMotion) -> void:
	if not is_multiplayer_authority():
		return

	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.001

	motion *= sensitivity
	motion *= degrees_per_unit

	add_yaw(motion.x)
	add_pitch(motion.y)
	clamp_pitch()


func add_yaw(amount: float) -> void:
	if is_zero_approx(amount):
		return

	mouse_rotation.y -= deg_to_rad(amount)


func add_pitch(amount: float) -> void:
	if is_zero_approx(amount):
		return

	mouse_rotation.x -= deg_to_rad(amount)


func clamp_pitch() -> void:
	if mouse_rotation.x > deg_to_rad(min_pitch) and mouse_rotation.x < deg_to_rad(max_pitch):
		return

	viewmodel.rotation.x = clamp(viewmodel.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))


func _gather() -> void:
	direction = Input.get_vector("left", "right", "forward", "backward")

	jump = Input.is_action_pressed("jump")
	use = Input.is_action_pressed("use")

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_angle = Vector2(mouse_rotation.y, mouse_rotation.x)
		mouse_rotation = Vector2.ZERO
