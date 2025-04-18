extends Enemy


func _physics_process(delta: float) -> void:
	move_to_player(delta)


func _on_timer_timeout() -> void:
	if is_player_in_notice_radius():
		if position.distance_to(player.position) <= attack_radius:
			melee_attack_animation()
