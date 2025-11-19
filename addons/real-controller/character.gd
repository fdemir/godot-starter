## A first-person character controller with camera controls, movement, sprinting, and jumping.
## Requires a CameraPivot (Node3D) and Camera3D as children, and a character mesh as a child node.
extends CharacterBody3D

## Node References
## -----------------------------------------------------------------------------
## These nodes must exist in the scene tree for the controller to work properly.

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var character: Node3D = $character

## Movement Settings
## -----------------------------------------------------------------------------
## Configure the character's movement speed and jump behavior.

@export_group("Movement")
@export_range(0.1, 20.0, 0.1, "or_greater") var speed: float = 5.0
## Speed when walking. Should be lower than normal speed.
@export_range(0.1, 10.0, 0.1, "or_greater") var walk_speed: float = 2.5
## Speed multiplier when sprinting. Should be higher than normal speed.
@export_range(0.1, 30.0, 0.1, "or_greater") var sprint_speed: float = 8.0
## Vertical velocity applied when jumping.
@export_range(1.0, 20.0, 0.1) var jump_velocity: float = 4.5
@export var can_walk: bool = true

## Camera Settings
## -----------------------------------------------------------------------------
## Adjust camera sensitivity and rotation limits.

@export_group("Camera")
## Mouse sensitivity for camera rotation. Higher values = faster rotation.
@export_range(0.0, 1.0, 0.001) var mouse_sensitivity: float = 0.005
## Maximum vertical camera tilt angle in radians (prevents over-rotation).
@export_range(0.0, 1.57, 0.01) var tilt_limit: float = deg_to_rad(75)
## Speed at which the character mesh rotates to face movement direction.
@export_range(0.1, 50.0, 0.1) var rotation_speed: float = 10.0

var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
var is_sprinting: bool = false
var is_walking: bool = false
var is_jumping: bool = false

func _ready() -> void:
	## Captures the mouse cursor for first-person camera control.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	_handle_gravity_and_jump(delta)
	_handle_movement_input()
	_handle_character_rotation(delta)
	_apply_movement()
	move_and_slide()

## Handles gravity application and jump mechanics.
func _handle_gravity_and_jump(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = velocity.y > 0
	else:
		is_jumping = false

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		is_jumping = true

## Processes movement input and calculates movement direction relative to camera.
func _handle_movement_input() -> void:
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	var camera_basis = Transform3D(Basis(Vector3.UP, camera_pivot.rotation.y), Vector3.ZERO).basis
	direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

## Rotates the character mesh to face the movement direction smoothly.
func _handle_character_rotation(delta: float) -> void:
	character.rotation.y = lerp_angle(character.rotation.y, camera_pivot.rotation.y + PI, rotation_speed * delta)

## Applies horizontal movement velocity based on input and sprint/walk state.
func _apply_movement() -> void:
	var is_moving = input_dir != Vector2.ZERO and is_on_floor()
	is_sprinting = Input.is_action_pressed("sprint") and is_moving and not Input.is_action_pressed("walk")
	is_walking = Input.is_action_pressed("walk") and is_moving and not Input.is_action_pressed("sprint") and can_walk
	
	var current_speed: float
	if is_sprinting:
		current_speed = sprint_speed
	elif is_walking and can_walk:
		current_speed = walk_speed
	else:
		current_speed = speed
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

## Handles mouse input for camera rotation with tilt limits.
func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.physical_keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion:
		camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
