extends NinePatchRect


func _on_mute_toggled() -> void:
	var is_muted: bool = SoundManager.is_muted()
	if is_muted:
		region_rect = Rect2(1968, 768, 48, 48)
	else:
		region_rect = Rect2(1920, 768, 48, 48)
