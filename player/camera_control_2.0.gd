extends Node3D

@export_category("Mouse Sensitivity")
@export var mouse_sensitivity := 0.25
var camera_input_direction := Vector2.ZERO

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
    var is_camera_motion := event is InputEventMouseMotion
    if is_camera_motion:
        camera_input_direction = event.screen_relative * mouse_sensitivity


func _physics_process(delta: float) -> void:
    rotation.x -= camera_input_direction.y * delta
    rotation.y -= camera_input_direction.x * delta
    rotation.x = clamp(rotation.x, -PI / 6.0, PI / 3.0)
    camera_input_direction = Vector2.ZERO
