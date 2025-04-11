extends Node3D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/MoveStateMachine/playback")
var attacking: bool = false

func set_move_state(state_name: String) -> void:
    move_state_machine.travel(state_name)
    # set("parameters/AttackOneShot/request",true)

func attack() -> void:
    if not attacking:
        get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func attacking_toggle(value: bool) -> void:
    attacking = value
    pass

func defend(forward: bool) -> void:
    ### tween (inbetween) es un valor que interpola entre un rango de valores
    var tween = create_tween()
    ### tween_method() invoca una funcion y le da de parametro un tween
    ### 
    tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0.25)
    
    pass

func _defend_change(value: float) -> void:
    ### value deseado es un tween
    get_node("AnimationTree").set("parameters/ShieldBlend/blend_amount", value)
    pass
