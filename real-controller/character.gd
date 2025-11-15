extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera_3d: Camera3D = %Camera3D
@onready var camera_pivot: Node3D = %CameraPivot

@export_range(0.0, 1.0) var mouse_sensitivity = 0.002
@export var tilt_limit = deg_to_rad(75)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var camera_basis := camera_pivot.global_transform.basis
	var cam_forward := camera_basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()
	var cam_right := camera_basis.x
	cam_right.y = 0
	cam_right = cam_right.normalized()
	var move_dir := (cam_right * input_dir.x + cam_forward * input_dir.y).normalized()

	if move_dir:
		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
