extends Control

signal go_to_login
signal go_to_register


func _ready() -> void:
	$NinePatchRect/VBoxContainer/Login/NinePatchRect/RichTextLabel.text = "[center]" + tr("LOGIN") + "[/center]"
	$NinePatchRect/VBoxContainer/Register/NinePatchRect/RichTextLabel.text = "[center]" + tr("REGISTER") + "[/center]"

func _on_login_button_pressed() -> void:
	go_to_login.emit()


func _on_register_button_pressed() -> void:
	go_to_register.emit()
