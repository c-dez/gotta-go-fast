extends Enemy

### Se herada desde Enemy, asi puedo poner funcionalidades compartidas entre todos los enemigos sin repetir y override lo que sea necesario


func _physics_process(delta: float) -> void:
    move_to_player(delta)
