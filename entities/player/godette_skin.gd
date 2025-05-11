extends Node3D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/MoveStateMachine/playback")
@onready var attack_state_machine: AnimationNodeStateMachinePlayback = get_node("AnimationTree").get("parameters/AttackStateMachine/playback")
@onready var second_attack_timer: Timer = get_node("SecondAttackTimer")
@onready var set_attacking_false: Timer = get_node("SetAttackingFalse")
@onready var extra_animation: AnimationNodeAnimation = get_node("AnimationTree").get_tree_root().get_node("ExtraAnimation")
@onready var face_material: StandardMaterial3D = get_node("Rig/Skeleton3D/Godette_Head").get_surface_override_material(0)
var rng := RandomNumberGenerator.new()


var attacking: bool = false
var squash_and_stretch: float = 1.0:
    set(value):
        squash_and_stretch = value
        var negative := 1.0 + (1.0 - squash_and_stretch)
        scale = Vector3(negative, squash_and_stretch, negative)
const faces = {
    "default": Vector3.ZERO,
    "blink": Vector3(0.0, 0.5, 0)
}


func _physics_process(_delta: float) -> void:
    pass

func set_move_state(state_name: String) -> void:
    move_state_machine.travel(state_name)


func attack() -> void:
    if not attacking:
        get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
        set_attacking_false.start()
        attack_state_machine.travel("Slice" if second_attack_timer.time_left else "Chop")
    if !set_attacking_false.time_left:
        ### por alguna razon en algunas ocasiones attacking falla en ser falso lo que no deja que animacion chop funcione correctamente, para forzar a que cambie a false, se usa un timer a 1 segundo (declarado en godot) cuando el timer llega a 0 attacking = false
        attacking = false
        pass
        

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


func switch_weapon(weapon_active: bool) -> void:
    var sword_1handed: Node3D = get_node("Rig/Skeleton3D/RightHandSlot/sword_1handed2")
    var wand: Node3D = get_node("Rig/Skeleton3D/RightHandSlot/wand2")
    if weapon_active:
        sword_1handed.show()
        wand.hide()
        do_squash_and_stretch(1.2, 0.15)
    else:
        sword_1handed.hide()
        wand.show()
        do_squash_and_stretch(1.2, 0.15)

    pass

func attacking_lock_rotation() -> void:
    # cuando attacking == true -> lock skin rotation to last rotation
    pass


func cast_spell() -> void:
### Spellcast_Shoot animation
    if not attacking:
        extra_animation.animation = "Spellcast_Shoot"
        get_node("AnimationTree").set("parameters/ExtraOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


    pass

func hit() -> void:
### Hit_B animation cuando recibe dano
    extra_animation.animation = "Hit_B"
    get_node("AnimationTree").set("parameters/ExtraOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    get_node("AnimationTree").set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
    attacking = false


func do_squash_and_stretch(value: float, duration: float = 0.1):
    var tween = create_tween()
    tween.tween_property(self, "squash_and_stretch", value, duration)
    tween.tween_property(self, "squash_and_stretch", 1.0, duration * 1.8).set_ease(Tween.EASE_IN_OUT)

func change_face(expression: String) -> void:
    face_material.uv1_offset = faces[expression]
    

func _on_blink_timer_timeout() -> void:
    change_face("blink")
    await get_tree().create_timer(0.2).timeout
    change_face("default")
    get_node("BlinkTimer").wait_time = rng.randf_range(1.5, 4.5)
