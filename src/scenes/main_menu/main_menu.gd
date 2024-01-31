extends Control

signal go_to_login
signal go_to_register


func _on_login_button_pressed() -> void:
	go_to_login.emit()


func _on_register_button_pressed() -> void:
	go_to_register.emit()
