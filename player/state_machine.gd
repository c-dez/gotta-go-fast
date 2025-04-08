extends Node

### state machine para
## idle
## running
## jumping

@onready var label := get_node("Label")
enum MOVEMENT_STATE {IDLE, RUN, JUMP_START, ON_AIR, FALLING, LANDING}
var state: int = 0
var last_state: int = 0
### Animation Player
@onready var animation_player = get_node("../GodetteSkin/AnimationPlayer")
var transition_speed:float = 0.2


func _ready() -> void:
	state = MOVEMENT_STATE.IDLE
	pass

func _process(_delta: float) -> void:
	print("current :",state," last: ", last_state)

	match state:
		MOVEMENT_STATE.IDLE:
			label.text = "idle"

			animation_player.current_animation = "Idle"
			animation_player.speed_scale = 1.0
			animation_player.set_blend_time("Running_C","Idle", transition_speed)
			animation_player.set_blend_time("Jump_Start","Idle", transition_speed)




		MOVEMENT_STATE.RUN:
			label.text = "run"
			animation_player.current_animation = "Running_C"
			animation_player.speed_scale = 1.0
			animation_player.set_blend_time("Idle","Running_C", transition_speed)
			animation_player.set_blend_time("Jump_Start","Running_C", transition_speed)




		MOVEMENT_STATE.JUMP_START:
			label.text = "jump_start"
			animation_player.speed_scale = 2
			animation_player.current_animation = "Jump_Start"
			animation_player.set_blend_time("Idle","Jump_Start", 0.1)

		MOVEMENT_STATE.ON_AIR:
			label.text = "on_air"
			# animation_player.speed_scale = 1.0
			animation_player.current_animation = "Jump_Idle"
			animation_player.set_blend_time("Jump_Start","Jump_Idle", 1)
		
		MOVEMENT_STATE.FALLING:
			label.text ="falling"
			# animation_player.current_animation = "Jump_Idle"
			# animation_player.set_blend_time("Jump_Idle","Jump_Land", 1)

		MOVEMENT_STATE.LANDING:
			# animation_player.current_animation = "Jump_Land"
			label.text = "sdasd"

		_:
			label.text = "no state"	

