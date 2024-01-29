extends Control

signal save_character
signal return_to_menu

func _on_button_pressed() -> void:
	save_character.emit()


func _on_return_return_to_menu() -> void:
	return_to_menu.emit()
