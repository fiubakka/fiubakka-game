extends LineEdit

signal send_message

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event: InputEventKey):
	if event is InputEventKey and event.as_text_keycode() == "Enter" and event.pressed:
		send_message.emit(text)
		clear()


func _on_button_pressed():
	send_message.emit(text)
	clear()
