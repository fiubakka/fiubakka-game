extends Control

signal user_logged_in(username: String)


func _on_login_username_text_submitted(username: String) -> void:
	user_logged_in.emit(username)
