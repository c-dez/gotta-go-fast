extends Enemy


func _physics_process(delta: float) -> void:
    # heredado de Enemy
    move_to_player(delta)


    # no heredado


    pass


func _on_attack_timer_timeout() -> void:
    if is_player_in_notice_radius():
        if position.distance_to(player.position) <= attack_radius:
            spellcast_shoot_animation()