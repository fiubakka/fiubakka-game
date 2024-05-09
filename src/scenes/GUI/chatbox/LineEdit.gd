extends LineEdit

signal send_message


func _on_text_submitted(new_text: String) -> void:
	send_text_message(new_text)


func _on_button_pressed() -> void:
	send_text_message(text)


func send_text_message(new_text: String) -> void:
	if !new_text.replace(" ", "").is_empty():
		send_message.emit(new_text)
		clear()
