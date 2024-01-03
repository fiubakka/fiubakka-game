extends LineEdit

signal send_message


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_text_submitted(new_text: String) -> void:
	send_text_message(new_text)


func _on_button_pressed() -> void:
	send_text_message(text)


func send_text_message(new_text: String) -> void:
	if !new_text.replace(" ", "").is_empty():
		send_message.emit(new_text)
		clear()
