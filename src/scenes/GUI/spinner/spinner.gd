extends TextureProgressBar


func _process(delta: float) -> void:
	radial_initial_angle += delta * 300

func _on_character_creation_user_logged_in(
	_username: String, _password: String, _equipment: Equipment
	) -> void:
	visible = true


func _on_character_creation_register_error(_errorCode: String) -> void:
	visible = false
