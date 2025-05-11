extends Enemy

# Se herada desde Enemy, asi puedo poner funcionalidades compartidas entre todos los enemigos sin repetir y override lo que sea necesario
## Nodo que contiene vatios Timers
@onready var timers: Node = get_node("Timers")
## boleano para dar seguimiento a cuando animacion "spining" se esta reproduciendo
var is_spinning: bool = false

### Diccionario conteniendo referencias a animaciones


func _physics_process(delta: float) -> void:
	move_to_player(delta)
	pass


func _on_attack_timer_timeout() -> void:
	# controla cuando y que ataque se hace
	timers.get_node("AttackTimer").wait_time = rng.randf_range(4.0, 5.5)
	# cuando AttackTimer node llega a cero, se checa si jugador esta dentro de notice_radius
		# si lo esta y  es a menos de 5.0 melee_attack_animation()
	if is_player_in_notice_radius():
		if position.distance_to(player.position) < 7.0:
			melee_attack_animation()
		# si no esta , range_attack_animation()
		if position.distance_to(player.position) > 15.0:
			if rng.randi_range(1,10) > 4:
				range_attack_animation()
			else:
				spin_attack_animation()

	
func spin_attack_animation() -> void:
	# cuando animation.play spining incrementar velocidad de movimmiento (tween)
	## nuevo valor para Enemy.speed_modifier
	var speed_modifier_spin := 4.0
	var tween := create_tween()
	tween.tween_property(self, "speed_modifier", speed_modifier_spin, 0.5)

	tween.tween_method(_spin_transition, 0.0, 1.0, 0.3)
	# Detiene el timer que controla cuando se realiza un ataque
	timers.get_node("AttackTimer").stop()
	is_spinning = true
	
## Transision a "spinning" animation en nodo SpinBlend en AnimationTree
func _spin_transition(value: float) -> void:
	get_node("AnimationTree").set("parameters/SpinBlend/blend_amount", value)
	pass
	
func range_attack_animation() -> void:
	stop_movement(2.5, 2.5)

	attack_animation.animation = simple_attacks["range"]
	get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func melee_attack_animation() -> void:
	attack_animation.animation = simple_attacks["slice" if rng.randi() % 2 else "spin"]
	get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	pass

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if is_spinning:
		await get_tree().create_timer(rng.randf_range(0.5, 1.5)).timeout
		var tween := create_tween()
		## El mismo valor que default Enemy.speed_modifier
		const speed_modifier_default := 1.0
		# regresa speed_modifier a default = 1.0
		tween.tween_property(self, "speed_modifier", speed_modifier_default, 3.0)
		tween.tween_method(_spin_transition, 1.0, 0.0, 0.3)
		is_spinning = false
		# Reinicia timer que controla la cadencia en que ataques inician
		timers.get_node("AttackTimer").start()
