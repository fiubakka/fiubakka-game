extends Control

signal go_to_login
signal go_to_register

@onready var audio_player := $AudioStreamPlayer

func _ready() -> void:
	$NinePatchRect/VBoxContainer/Login/NinePatchRect/RichTextLabel.text = Utils.center_text(
		tr("LOGIN")
	)
	$NinePatchRect/VBoxContainer/Register/NinePatchRect/RichTextLabel.text = Utils.center_text(
		tr("REGISTER")
	)


func _on_login_button_pressed() -> void:
	audio_player.play()
	go_to_login.emit()


func _on_register_button_pressed() -> void:
	audio_player.play()
	go_to_register.emit()


func _on_language_select_go_to_main_menu() -> void:
	$NinePatchRect/VBoxContainer/Login/NinePatchRect/RichTextLabel.text = Utils.center_text(
		tr("LOGIN")
	)
	$NinePatchRect/VBoxContainer/Register/NinePatchRect/RichTextLabel.text = Utils.center_text(
		tr("REGISTER")
	)
	visible = true
