## Clase/Blueprint para enemigos
class_name Enemy

extends CharacterBody3D

const simple_attacks: Dictionary = {
	"slice": "2H_Melee_Attack_Slice",
	"spin": "2H_Melee_Attack_Spin",
	"range": "1H_Melee_Attack_Stab",
	"spining": "2H_Melee_Attack_Spinning",
	"spellcast_shoot": "Spellcast_Shoot",
}

## Referencia a el primer nodo en grupo "Player"
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
## referencia a el nodo skin que contiene Mesh3d
@onready var skin: Node3D = get_node("Skin")
## Velocidad de movimiento normal
@export var walk_speed: float = 2.0
## Distancia desde self para detectar a jugador
@export var notice_radius: float = 30.0
## Distancia desde self para melee attack jugador
@export var attack_radius: float = 3.0
## Modificador de velocidad, modificado para controlar distintas velocidades segun contexto
var speed_modifier: float = 1.0

## state_machine dentro de AnimationTree
@onready var move_state_machine: AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/MoveStateMachine/playback")
## Animacion dentro de AnimationTree
@onready var attack_animation: AnimationNodeAnimation = get_node("AnimationTree").get_tree_root().get_node("AttackAnimation")
## Objeto para distintos RNG
var rng := RandomNumberGenerator.new()

## Camina hacia player cuando distancia es  mayor attack_radius y menor a notice_radius
func move_to_player(_delta: float) -> void:
	# position.distance_to() si la distancia es menor a notice_radius, entonces mueve hacia jugador
	if is_player_in_notice_radius():
		# rota hacia player #######################
		var target_direction: Vector3 = (player.position - position).normalized()
		var target_vec2 := Vector2(target_direction.x, target_direction.z)
		var target_angle: float = - target_vec2.angle() + PI / 2
		rotation.y = rotate_toward(rotation.y, target_angle, _delta * 6.0)
		##########################################

		if position.distance_to(player.position) > attack_radius:
		# si self esta a mas de attack_radius-> se mueve hacia player
			# Lo paso a velocity e invoco move_and_slide() para mover se hacia esa direccion y multiplico por speed
			velocity = Vector3(target_vec2.x, 0, target_vec2.y) * walk_speed * speed_modifier
			# animacion
			move_state_machine.travel("walk")
		else:
		# si no -> no se mueve
			velocity = Vector3.ZERO
			move_state_machine.travel("idle")
	else:
		move_state_machine.travel("idle")
		velocity = Vector3.ZERO

	move_and_slide()
	pass


func look_at_player(_delta) -> void:
	# sin usar
	var target_direction := Vector3(player.position - position).normalized()
	var target_vec2 := Vector2(target_direction.x, target_direction.z)
	var target_angle: float = - target_vec2.angle() + PI / 2
	rotation.y = rotate_toward(rotation.y, target_angle, _delta * 0.90)


	pass


## Funcion para detectar si Player esta dentro de notice_radius
func is_player_in_notice_radius() -> bool:
# funcion hecha por mi
	return true if position.distance_to(player.position) < notice_radius else false

	
## Detener el movimiento
func stop_movement(start_duration: float, end_duration: float) -> void:
	const speed_modifier_default := 1.0
	var tween := create_tween()
	
	tween.tween_property(self, "speed_modifier", 0.0, start_duration)
	tween.tween_property(self, "speed_modifier", speed_modifier_default, end_duration)
	pass

func spellcast_shoot_animation() -> void:
	stop_movement(1.5, 1.5)
	attack_animation.animation = simple_attacks["spellcast_shoot"]
	get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


	pass
