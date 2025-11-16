extends CharacterBody3D


var speed: float = 5.0
var sprint_speed: float = 8.0
var is_sprinting: bool = false
const JUMP_VELOCITY = 4.5

var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
var is_jumping: bool = false

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = velocity.y > 0
	else:
		is_jumping = false

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	is_sprinting = Input.is_action_pressed("sprint") and input_dir != Vector2.ZERO
	
	var current_speed: float = sprint_speed if is_sprinting else speed
	
	# Apply movement
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)



	move_and_slide()
