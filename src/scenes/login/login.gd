extends Control

signal user_logged_in(username: String)


func _on_login_username_text_submitted(username: String) -> void:
	#TODO: Add logic to send the init every x seconds until we get a response in case the server loses the msg
	user_logged_in.emit(username)
