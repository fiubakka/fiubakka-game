extends Button


func _on_login_error(_error_code: String) -> void:
	disabled = false


func _on_user_logged_in(_username: String, _password: String, _equipment: Equipment) -> void:
	disabled = true


func _on_pressed() -> void:
	var audio_player := $AudioStreamPlayer
	audio_player.play()
