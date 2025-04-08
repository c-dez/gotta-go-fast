extends Node

### state machine para
## idle
## running
## jumping

@onready var label := get_node("Label")
enum MOVEMENT_STATE {IDDLE, RUN, JUMP}
var state: int = 0

func _ready() -> void:
	state = MOVEMENT_STATE.IDDLE
	pass

func _process(_delta: float) -> void:
	match state:
		MOVEMENT_STATE.IDDLE:
			label.text = "iddle"
		MOVEMENT_STATE.RUN:
			label.text = "run"
		MOVEMENT_STATE.JUMP:
			label.text = "jump"
		_:
			label.text = "no state"	
