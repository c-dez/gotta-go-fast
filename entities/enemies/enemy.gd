class_name Enemy
### Los enemigos heredan de esta escena/scrip
extends CharacterBody3D

### Referencia al Player usando grupos
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
### referencia a el mesh
@onready var skin: Node3D = get_node("Skin")

@export var walk_speed: float = 2.0
@export var notice_radius: float = 30.0
@export var attack_radius: float = 3.0

## Animaciones
@onready var move_state_machine: AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/MoveStateMachine/playback")


func move_to_player(_delta: float) -> void:
	### position.distance_to() si la distancia es menor a notice_radius, entonces mueve hacia jugador
	if position.distance_to(player.position) < notice_radius:
		### Toma ala direccion de jugador(target) y moverse hacia el
		var target_direction: Vector3 = (player.position - position).normalized()
		### Lo convierto a Vector2
		var target_vec2 := Vector2(target_direction.x, target_direction.z)
		if position.distance_to(player.position) > attack_radius:
		### si self esta a mas de attack_radius-> se mueve hacia player
			### Lo paso a velocity e invoco move_and_slide() para mover se hacia esa direccion y multiplico por speed
			velocity = Vector3(target_vec2.x, 0, target_vec2.y) * walk_speed
			### animacion
			move_state_machine.travel("walk")
		else:
		# si no -> no se mueve
			velocity = Vector3.ZERO
			move_state_machine.travel("idle")
		### Rotar a direccion de Player
		### con este codigo consigo que el angulosea correcto
		var target_angle: float = - target_vec2.angle() + PI / 2
		### rotate_toward(from, to, speed)
		rotation.y = rotate_toward(rotation.y, target_angle, _delta * 6.0)
	# elif position.distance_to(player.position)> notice_radius:
	# 	move_state_machine.travel("idle")
	# 	velocity = Vector3.ZERO
	else:
		move_state_machine.travel("idle")
		velocity = Vector3.ZERO

	move_and_slide()
	pass
