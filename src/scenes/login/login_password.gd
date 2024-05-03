extends LineEdit


func _on_return_to_menu() -> void:
	text = ""
	text_changed.emit(text)
