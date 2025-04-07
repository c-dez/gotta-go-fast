extends CharacterBody3D


@onready var player_inputs: Node = get_node("PlayerInputs")
const SPEED = 5.0
const JUMP_VELOCITY = 6


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	movement(_delta)
	dash()
	action2()

	pass
	

func movement(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	jump()

	var input_dir: Vector2 = player_inputs.input_dir()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# print(direction)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func dash() -> void:
	if player_inputs.mb1():
		print("dash")


func action2() -> void:
	if player_inputs.mb2():
		print("action 2")


func jump() -> void:
	if player_inputs.space_bar() and is_on_floor():
		velocity.y = JUMP_VELOCITY
												