extends Node

signal send_message

var waiting_for_login: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO: How can we instantiate this scene AFTER login is succesful?
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func focus_chat() -> void:
	$LineEdit.grab_focus()


func _on_line_edit_send_message(message: String) -> void:
	send_message.emit(message)


func _on_server_consumer_update_content(entityId: String, content: String) -> void:
	$RichTextLabel.add_new_message(entityId, content)


func _on_main_login_ready() -> void:
	self.waiting_for_login = false


func _on_main_chat_opened() -> void:
	if !waiting_for_login:
		self.visible = true
		self.focus_chat()


func _on_main_chat_closed() -> void:
	if !waiting_for_login:
		self.visible = false


func _on_main_paused() -> void:
	if !waiting_for_login:
		self.visible = false
