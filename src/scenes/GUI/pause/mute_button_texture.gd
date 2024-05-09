extends NinePatchRect


func _on_mute_toggled() -> void:
	var is_muted: bool = SoundManager.is_muted()
	if is_muted:
		var new_region := Rect2(1968, 768, 48, 48)
		region_rect = new_region
	else:
		var new_region := Rect2(1920, 768, 48, 48)
		region_rect = new_region
