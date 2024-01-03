extends Node

signal send_message


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("open_chat") and !self.visible:
		self.visible = true
		self.focus_chat()
	if Input.is_action_pressed("close_chat") and self.visible:
		self.visible = false


func focus_chat() -> void:
	$LineEdit.grab_focus()


func _on_line_edit_send_message(message: String) -> void:
	send_message.emit(message)


func _on_tcp_peer_update_content(username: String, content: String) -> void:
	$RichTextLabel.add_new_message(username, content)
