extends Enemy

### Se herada desde Enemy, asi puedo poner funcionalidades compartidas entre todos los enemigos sin repetir y override lo que sea necesario
@onready var timers: Node = get_node("Timers")

### simple animations
const simple_attacks: Dictionary = {
	"slice": "2H_Melee_Attack_Slice",
	"spin": "2H_Melee_Attack_Spin",
	"range": "1H_Melee_Attack_Stab",
}

func _physics_process(delta: float) -> void:
	move_to_player(delta)
	pass


### attack player


func _on_attack_timer_timeout() -> void:
	if position.distance_to(player.position) < 5.0:
		melee_attack_animation()
	else:
		range_attack_animation()

	# 4 animaciones que controlar
	# 2 melee attacks
	# 2 range attacks



func range_attack_animation() -> void:
	stop_movement(1.5,1.5)

	attack_animation.animation = simple_attacks["range"]
	get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func melee_attack_animation() -> void:
	attack_animation.animation = simple_attacks["slice" if rng.randi() % 2 else "spin"]
	get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	pass