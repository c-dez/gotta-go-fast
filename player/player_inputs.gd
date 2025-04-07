extends Node



func _physics_process(_delta: float) -> void:
    # input_dir()
    pass

func input_dir() -> Vector2:
    var input_vector: Vector2 = Input.get_vector("left", "rigth", "forward", "backwards")
    return input_vector


func space_bar() -> bool:
    return true if Input.is_action_just_pressed("space") else false


func mb1() -> bool:
    return true if Input.is_action_just_pressed("mb1") else false


func mb2() -> bool:
    return true if Input.is_action_just_pressed("mb2") else false
