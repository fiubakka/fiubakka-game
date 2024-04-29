extends NinePatchRect

@export var default_rot_speed: float
@export var offset: int
var rot_speed := 0.
var time_passed := 0.


func _ready() -> void:
	pivot_offset.x = offset
	pivot_offset.y = offset


func _process(delta: float) -> void:
	time_passed += delta
	rotation += rot_speed


func stop() -> void:
	rot_speed = 0


func _on_loading_screen_spin_logo() -> void:
	rot_speed = default_rot_speed
