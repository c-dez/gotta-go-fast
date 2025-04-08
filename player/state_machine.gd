extends Node

### state machine para
## idle
## running
## jumping

enum MOVEMENT_STATE {IDDLE, RUN, JUMP}
var state: int = 0

func _ready() -> void:
    state = MOVEMENT_STATE.IDDLE
    pass

func _process(_delta: float) -> void:
    if state == MOVEMENT_STATE.IDDLE:
        print("State: iddle")
    
    elif state == MOVEMENT_STATE.RUN:
        print("state: run")

    elif state == MOVEMENT_STATE.JUMP:
        print("state: jump")