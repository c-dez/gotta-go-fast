extends Node3D


@export var x_sens: float = 11
@export var y_sens: float = 10
var look_up_deg: int = 60
var look_down_deg: int = -60
@onready var player: CharacterBody3D = get_node("..")
@onready var spring_arm: SpringArm3D = get_node("SpringArm3D")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.relative:
			var mouse_relative: Vector2 = event.relative
			var delta: float = get_process_delta_time()
			## rota Player(scene root node) en direccion de movimiento mouse multiplicado por delta, 
			player.rotate_y(deg_to_rad(-mouse_relative.x * x_sens) * delta)
			# rotate camera vertical / clamp
			var max_rad: float = deg_to_rad(look_up_deg)
			var min_rad: float = deg_to_rad(look_down_deg)
			rotate_x(deg_to_rad(-mouse_relative.y * y_sens) * delta)
			rotation.x = clamp(rotation.x, min_rad, max_rad)
			rotation.z = clamp(rotation.z, 0, 0)

		
	pass
