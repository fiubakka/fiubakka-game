extends Button


func _on_character_creation_register_error(_error_code: String) -> void:
	disabled = false


func _on_character_creation_user_logged_in(
	_username: String, _password: String, _equipment: Equipment
) -> void:
	disabled = true
