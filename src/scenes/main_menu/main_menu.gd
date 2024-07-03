extends Control

signal go_to_login
signal go_to_register

@onready var audio_player := $AudioStreamPlayer


func _on_login_button_pressed() -> void:
	audio_player.play()
	go_to_login.emit()


func _on_register_button_pressed() -> void:
	audio_player.play()
	go_to_register.emit()


func _on_language_select_go_to_main_menu() -> void:
	$NinePatchRect/VBoxContainer/Login/LoginButton.text = tr("LOGIN")
	$NinePatchRect/VBoxContainer/Register/RegisterButton.text = tr("REGISTER")
	visible = true
