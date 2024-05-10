extends LineEdit

signal username_submitted(new_text: String)

@onready var _enabled := true

func _on_text_changed(new_text: String) -> void:
	const invalid_characters: Array[String] = [" "]

	var invalid_char_indexes: Array[int] = []
	for i in range(new_text.length()):
		if new_text[i] in invalid_characters:
			invalid_char_indexes.append(i)
	for i in invalid_char_indexes:
		delete_text(i, i + 1)


func _on_return_to_menu() -> void:
	text = ""
	text_changed.emit(text)


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
		username_submitted.emit(new_text)

