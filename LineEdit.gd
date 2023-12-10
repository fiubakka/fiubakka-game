extends LineEdit

signal send_message

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_text_submitted(new_text):
	send_text_message(new_text)

func _on_button_pressed():
	send_text_message(text)
	
func send_text_message(new_text: String):
	if (!new_text.is_empty() and !new_text.strip_edges(true, true).is_empty()):
		send_message.emit(new_text)
		clear()



