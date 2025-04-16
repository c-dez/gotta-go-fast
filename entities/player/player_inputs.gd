extends Node


var raw_input := Vector2.ZERO

@onready var skin = get_node("../GodetteSkin")

func _physics_process(_delta: float) -> void:
    get_raw_input()
    _exit_tree()
    pass

func get_raw_input() -> void:
    if skin.attacking == false:
        var vector := Input.get_vector("left", "rigth", "forward", "backwards")
        raw_input = vector
    else:
        raw_input = Vector2.ZERO


func space_bar() -> bool:
    return true if Input.is_action_just_pressed("space") else false


func mb1() -> bool:
    return true if Input.is_action_just_pressed("mb1") else false


func mb2() -> bool:
    return true if Input.is_action_just_pressed("mb2") else false

func _exit_tree() -> void:
    if Input.is_action_just_pressed("exit"):
        get_tree().quit()