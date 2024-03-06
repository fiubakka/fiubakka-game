extends Control

signal go_to_login
signal go_to_register


func _ready() -> void:
	$NinePatchRect/VBoxContainer/Login/NinePatchRect/RichTextLabel.text = Utils.center_text(
		tr("LOGIN")
	)
	$NinePatchRect/VBoxContainer/Register/NinePatchRect/RichTextLabel.text = Utils.center_text(
		tr("REGISTER")
	)


func _on_login_button_pressed() -> void:
	go_to_login.emit()


func _on_register_button_pressed() -> void:
	go_to_register.emit()
