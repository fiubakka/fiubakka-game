extends NinePatchRect

var is_muted := false


func _on_button_pressed() -> void:
	is_muted = !is_muted
	if is_muted:
		var new_region := Rect2(1968, 768, 48, 48)
		region_rect = new_region
	else:
		var new_region := Rect2(1920, 768, 48, 48)
		region_rect = new_region
