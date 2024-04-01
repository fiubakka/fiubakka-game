extends CenterContainer

@onready var elevator := $Elevator


func _ready() -> void:
	pass


func _on_timer_timeout() -> void:
	print("(UP) elevator change")
	elevator.position.y = -elevator.position.y
