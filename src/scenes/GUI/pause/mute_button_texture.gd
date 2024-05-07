extends NinePatchRect

var is_muted := false


func _on_button_pressed() -> void:
	is_muted = !is_muted
	if is_muted:
		var new_region := Rect2(1970, 774, 47, 42)
		region_rect = new_region
	else:
		var new_region := Rect2(1920, 774, 47, 42)
		region_rect = new_region
