extends CharacterBody3D


@onready var player_inputs: Node = get_node("PlayerInputs")
const SPEED := 8.0
const JUMP_VELOCITY := 6.0

@onready var camera_control_node := get_node("CameraControl")

### rotate mesh node
@onready var mesh_node: MeshInstance3D = get_node("Mesh")
var last_movement_direction := Vector3.FORWARD
var rotation_speed: float = 10

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	dash()
	action2()
	movement_v2(_delta)

	gravity(_delta)
	jump()
	

	pass

func movement_v2(_delta) -> void:
### posible problema con el no usar delta para movimiento
	### esta version implementa parte de codigo de gdquest para mover en tercera persona entre el input de el player y la pocicion de la camara
	### Esta modificado para  tener un movimiento mas instantaneo
	###  raw_input: tomado desde PlayerInputs node
	var raw_input: Vector2 = player_inputs.raw_input

	### Estos dos valosres representan el global basis de CameraControl node
	var forward: Vector3 = camera_control_node.global_basis.z
	var right: Vector3 = camera_control_node.global_basis.x
	### Toma los valores : cameraControl basis y raw_input para crear un vector3
	var move_direction: Vector3 = forward * raw_input.y + right * raw_input.x
	# move_direction.y = 0.0
	move_direction = move_direction.normalized()

	if move_direction:
		### movimiento con "peso"
		# velocity = velocity.move_toward(move_direction * SPEED, 20 * _delta)
		### Movimiento sin "peso"
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

	### mesh mira hacia last_movement_direction
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	
	var target_angle := Vector3.FORWARD.signed_angle_to(last_movement_direction, Vector3.UP)
	# mesh_node.global_rotation.y = target_angle
	mesh_node.global_rotation.y = lerp_angle(mesh_node.global_rotation.y, target_angle, rotation_speed * _delta)


func movement_v1(_delta: float) -> void:
	#### OBSOLETA #####
	if not is_on_floor():
		velocity += get_gravity() * _delta

	jump()

	var input_dir: Vector2 = player_inputs.raw_input
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

func gravity(_delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * _delta
