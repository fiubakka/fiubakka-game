extends LineEdit


func _on_text_changed(new_text: String) -> void:
	const invalid_characters: Array[String] = [" "]

	var invalid_char_indexes: Array[int] = []
	for i in range(new_text.length()):
		if new_text[i] in invalid_characters:
			invalid_char_indexes.append(i)
	for i in invalid_char_indexes:
		delete_text(i, i + 1)
