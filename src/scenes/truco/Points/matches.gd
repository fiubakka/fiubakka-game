extends Node2D

class_name Matches

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_points(0)


func set_points(n: int) -> void:
	if n <= 5:
		var children := get_children()
		for i in range(0, n):
			children[i].visible = true
		for j in range(n, 5):
			children[j].visible = false
