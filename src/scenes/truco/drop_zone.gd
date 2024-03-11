extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 75, Color.BLANCHED_ALMOND)


func select() -> void:
	for child: Node2D in get_tree().get_nodes_in_group("zone"):
		child.deselect()
	modulate = Color.WEB_MAROON


func deselect() -> void:
	modulate = Color.WHITE

