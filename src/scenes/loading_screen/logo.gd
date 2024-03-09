extends NinePatchRect

@export var default_rot_speed: float
var rot_speed := 0.
var time_passed := 0.

func _process(delta: float) -> void:
	time_passed += delta
	rotation += rot_speed
	
func stop() -> void:
	rot_speed = 0

func _on_loading_screen_spin_logo() -> void:
	rot_speed = default_rot_speed
