extends NinePatchRect

signal return_to_menu

func _on_button_pressed() -> void:
	return_to_menu.emit()
