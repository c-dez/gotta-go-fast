extends CharacterBody3D


@onready var player_inputs: Node = get_node("PlayerInputs")
const SPEED := 8.0
const JUMP_VELOCITY := 8
var defend_speed: float = 5.0

@onready var camera_control_node: Node3D = get_node("CameraControl")

### rotate mesh node
@onready var skin: Node3D = get_node("GodetteSkin")
var last_movement_direction := Vector3.BACK
var rotation_speed: float = 12
### Animation
var defend: bool = false:
	set(value):
		### invoca funcion defend de godette_skin dependiendo de los condicionales
		if not defend and value:
			skin.defend(true)
		if defend and not value:
			skin.defend(false)
		defend = value


func _physics_process(_delta: float) -> void:
	action1()
	action2()
	move_logic(_delta)
	gravity(_delta)
	jump_logic()
	pass


func move_logic(_delta) -> void:
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
	var _speed: float = defend_speed if defend else SPEED

	if move_direction:
		### movimiento con "peso"
		# velocity = velocity.move_toward(move_direction * SPEED, 20 * _delta)
		### Movimiento sin "peso"
		velocity.x = move_direction.x * _speed
		velocity.z = move_direction.z * _speed
		skin.set_move_state("Running")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		skin.set_move_state("Idle")

	move_and_slide()

	### mesh mira hacia last_movement_direction
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
	skin.global_rotation.y = lerp_angle(skin.global_rotation.y, target_angle, rotation_speed * _delta)


func action1() -> void:
	if player_inputs.mb1():
		skin.attack()


func action2() -> void:
	defend = Input.is_action_pressed("mb2")


func jump_logic() -> void:
	if player_inputs.space_bar() and is_on_floor():
		velocity.y = JUMP_VELOCITY


func gravity(_delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 1.2 * _delta
		skin.set_move_state("Jump")

	if velocity.y < 0:
		velocity += get_gravity() * 2 * _delta
