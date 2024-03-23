extends Node2D

class_name DropZone

var has_card := false


func _draw() -> void:
	draw_circle(Vector2.ZERO, 75, Color.BLANCHED_ALMOND)


func select() -> void:
	has_card = true
	modulate = Color.WEB_MAROON


func deselect() -> void:
	has_card = false
	modulate = Color.WHITE
