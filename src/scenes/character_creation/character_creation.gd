extends Control

signal save_character

func _on_button_pressed() -> void:
	save_character.emit()
