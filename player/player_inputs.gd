extends Node


var raw_input := Vector2.ZERO


func _physics_process(_delta: float) -> void:
    get_raw_input()
    pass

func get_raw_input() -> void:
    var vector := Input.get_vector("left", "rigth", "forward", "backwards")
    raw_input = vector


func space_bar() -> bool:
    return true if Input.is_action_just_pressed("space") else false


func mb1() -> bool:
    return true if Input.is_action_just_pressed("mb1") else false


func mb2() -> bool:
    return true if Input.is_action_just_pressed("mb2") else false
