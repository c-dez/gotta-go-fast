extends Node3D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/MoveStateMachine/playback")
@onready var attack_state_machine :AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/AttackStateMachine/playback")
@onready var second_attack_timer : Timer = get_node("SecondAttackTimer")
@onready var set_attacking_false :Timer = get_node("SetAttackingFalse")
var attacking: bool = false



func _physics_process(_delta: float) -> void:
    print(second_attack_timer.time_left)

    pass

func set_move_state(state_name: String) -> void:
    move_state_machine.travel(state_name)

func attack() -> void:
    

    if not attacking:
        get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
        set_attacking_false.start()
        # attack_state_machine.travel("Chop" )
        attack_state_machine.travel("Slice" if second_attack_timer.time_left else "Chop")
        
    if !set_attacking_false.time_left:
        ### por alguna razon en algunas ocasiones attacking falla en ser falso lo que no deja que animacion chop funcione correctamente, para forzar a que cambie a false, se usa un timer a 1 segundo (declarado en godot) cuando el timer llega a 0 attacking = false
        # attacking = false
        pass

func attacking_toggle(value:bool) -> void:
    # attacking = !attacking
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
