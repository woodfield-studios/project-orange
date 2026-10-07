extends BaseNetInput
class_name PlayerInput

const SENSITIVITY_COEFFICIENT: float = 0.001

@export var sensitivity: float = 1.0
@export var max_pitch: float = 89.0
@export var min_pitch: float = -89.0

var yaw: float = 0.0
var pitch: float = 0.0
var direction: Vector2 = Vector2.ZERO

var jump: bool = false
var _jump_buffer: bool = false

var use: bool = false


func _ready() -> void:
	super()
	NetworkTime.after_tick.connect(
		func(_dt: float, _t: float) -> void:
			_gather_always(),
	)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return

	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw = wrapf(yaw - event.relative.x * sensitivity * SENSITIVITY_COEFFICIENT, -PI, PI)
		pitch = clampf(
			pitch - event.relative.y * sensitivity * SENSITIVITY_COEFFICIENT,
			deg_to_rad(min_pitch),
			deg_to_rad(max_pitch),
		)

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event.is_action_pressed("jump"):
		_jump_buffer = true


func _gather() -> void:
	direction = Input.get_vector("left", "right", "forward", "backward")
	use = Input.is_action_pressed("use")


func _gather_always() -> void:
	jump = _jump_buffer
	_jump_buffer = false
