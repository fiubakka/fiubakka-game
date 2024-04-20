extends Node2D

class_name Matches

var neutral: Color = Color(1, 1, 1)
var golden: Color = Color(255, 215, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_points(0, false)


func set_points(n: int, is_golden: bool) -> void:
	if n <= 5:
		var children := get_children()
		if not is_golden:
			for i in range(0, n):
				children[i].visible = true
				children[i].self_modulate = neutral
			for j in range(n, 5):
				children[j].visible = false
		else:
			for i in range(0, n):
				children[i].visible = true
				children[i].self_modulate = golden
			for j in range(n, 5):
				children[j].visible = true
				children[j].self_modulate = neutral

