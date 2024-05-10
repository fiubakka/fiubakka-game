extends LineEdit

signal password_submitted(new_text: String)

@onready var _enabled := true

func _on_user_logged_in(
	_username: String,
	_password: String,
	_equipment: Equipment
) -> void:
	_enabled = false

func _on_register_error() -> void:
	_enabled = true
	
func _on_text_submitted(new_text: String) -> void:
	if _enabled:
		password_submitted.emit(new_text)
