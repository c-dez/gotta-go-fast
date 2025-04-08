extends Node3D

@export_category("Mouse Sensitivity")
@export var mouse_sensitivity := 0.25/3 # /3 para 60 fps 0.008333333333333333

var camera_input_direction := Vector2.ZERO

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
    var is_camera_motion := event is InputEventMouseMotion
    if is_camera_motion:
        camera_input_direction = event.screen_relative * mouse_sensitivity
        # camera_input_direction = event.screen_relative 
        


func _physics_process(_delta: float) -> void:
    rotation.x -= camera_input_direction.y *_delta 
    rotation.y -= camera_input_direction.x *_delta
    rotation.x = clamp(rotation.x, -PI / 6.0, PI / 3.0)
    camera_input_direction = Vector2.ZERO
